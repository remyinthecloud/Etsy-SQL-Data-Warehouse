/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
	Go through all tables of the bronze layer and clean up the data.

    This includes removing duplicates, nulls, and ensuring data integrity.
    The following SQL statements are examples of how to perform these operations.	
	
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL silver.load_silver();
===============================================================================
*/

-- Create Stored Procedure
CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
	load_start_time TIMESTAMP;
    full_load_time TIMESTAMP;

    start_time TIMESTAMP;
    end_time TIMESTAMP;

    err_message TEXT;
    err_detail TEXT;
    err_hint TEXT;
BEGIN
    load_start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Starting Data Load Process: %', load_start_time;

    RAISE NOTICE '=============================';
    RAISE NOTICE 'Loading Data into Silver Layer';
    RAISE NOTICE '=============================';

    RAISE NOTICE '------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    RAISE NOTICE '>> Inserting Data into Table: silver.crm_cust_info';
		-- Final Query to insert cleaned data into silver layer
		INSERT INTO silver.crm_cust_info(
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)
			
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			
			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'N/A'
			END cst_marital_status, -- Normalize marital status values to readable format
			
			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'N/A'
			END cst_gndr,  -- Normalize gender values to readable format
			cst_create_date
		FROM
			(SELECT 
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS last_flag
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL) sq
		WHERE last_flag = 1; -- Select the most recent record per customer

	end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';


	start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    RAISE NOTICE '>> Inserting Data into Table: silver.crm_prd_info';	
		-- Insert into silver.crm_prd_info
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)

		SELECT 
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
			SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, -- Extract product key
			prd_nm,
			COALESCE(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'N/A'
			END prd_line, -- Map product line codes to descriptive values
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE) AS prd_end_dt -- Calculate end date as on day before the next start date
		FROM bronze.crm_prd_info;

	end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

	start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    RAISE NOTICE '>> Inserting Data into Table: silver.crm_sales_details';	
		-- Insert into silver.crm_sales_details
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,  
			sls_sales,
			sls_quantity,
			sls_price)

		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				WHEN sls_order_dt <= 0 OR LENGTH(sls_order_dt::text) != 8 THEN NULL -- Set dates to NULL if invalid
				ELSE CAST(CAST(sls_order_dt AS TEXT) AS DATE) -- CAST the original data type to date from int
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt <= 0 OR LENGTH(sls_ship_dt::text) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS TEXT) AS DATE) 
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt <= 0 OR LENGTH(sls_due_dt::text) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS TEXT) AS DATE) 
			END AS sls_due_dt,    
			CASE
				WHEN sls_sales IS NULL or sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,  -- Recalculate sales if original value is missing or incorrect
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price 
			END AS sls_price -- Derive price if original value is invalid
		FROM bronze.crm_sales_details;

	end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    RAISE NOTICE '------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;

    RAISE NOTICE '>> Inserting Data into Table: silver.erp_cust_az12';	
		-- Insert into silver.erp_cust_az12
		INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)

		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) -- Remove 'NAS' prefix if present
				ELSE cid
			END AS cid,
			CASE
				WHEN bdate > CURRENT_TIMESTAMP THEN NULL -- Set future birthdates to NULL
				ELSE bdate
			END AS bdate,
			CASE
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				ELSE 'N/A'
			END AS gen -- Normalize gender values and handle unknown cases
		FROM bronze.erp_cust_az12;

	end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    RAISE NOTICE '>> Inserting Data into Table: silver.erp_loc_a101';	
		-- Insert into silver.erp_loc_a101
		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)

		SELECT DISTINCT
			REPLACE(cid, '-', '') AS cid, -- Replace '-' in cid to stay consistent with format of cst_key in the crm_cust_info table
			CASE
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'N/A'
				ELSE TRIM(cntry)
			END AS cntry -- Normalize and handle missing or blank country codes
		FROM bronze.erp_loc_a101;

	end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    RAISE NOTICE '>> Inserting Data into Table: silver.erp_px_cat_g1v2';	
		-- Insert into silver.erp_px_cat_g1v2
		INSERT INTO silver.erp_px_cat_g1v2(
			id,
			cat,
			subcat,
			maintenance
		)

		SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;

			end_time := CURRENT_TIMESTAMP;
			RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
			RAISE NOTICE '>> -------------------------------';
EXCEPTION
    WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS
            err_message = MESSAGE_TEXT,
            err_detail = PG_EXCEPTION_DETAIL,
            err_hint = PG_EXCEPTION_HINT;
        RAISE NOTICE '==============================';
        RAISE NOTICE 'Error loading data into silver layer: %', SQLERRM;
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE 'An error occurred: % - Detail: % - Hint: %', err_message, err_detail, err_hint; -- More Error Details like the line, etc.
        RAISE NOTICE '==============================';
END
$$;