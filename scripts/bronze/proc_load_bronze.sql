/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `COPY` command to load data from csv Files to bronze tables.
This is what we call full load.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
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
    RAISE NOTICE 'Loading Data into Bronze Layer';
    RAISE NOTICE '=============================';

    RAISE NOTICE '------------------------------';
    RAISE NOTICE 'Loading CRM Tables';
    RAISE NOTICE '------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;

    RAISE NOTICE '>> Truncating Table: bronze.crm_cust_info';
    TRUNCATE TABLE bronze.crm_cust_info;

    RAISE NOTICE '>> Loading Data into Table: bronze.crm_cust_info';
    COPY bronze.crm_cust_info
        FROM '/mnt/datasets/source_crm/cust_info.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );

    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;
    RAISE NOTICE '>> Truncating Table: bronze.crm_prd_info';
    TRUNCATE TABLE bronze.crm_prd_info;

    RAISE NOTICE '>> Loading Data into Table: bronze.crm_prd_info';
    COPY bronze.crm_prd_info
        FROM '/mnt/datasets/source_crm/prd_info.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
    
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;
    RAISE NOTICE '>> Truncating Table: bronze.crm_sales_details';
    TRUNCATE TABLE bronze.crm_sales_details;

    RAISE NOTICE '>> Loading Data into Table: bronze.crm_sales_details';
    COPY bronze.crm_sales_details
        FROM '/mnt/datasets/source_crm/sales_details.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );

    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';


    RAISE NOTICE '------------------------------';
    RAISE NOTICE 'Loading ERP Tables';
    RAISE NOTICE '------------------------------';


    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;
    RAISE NOTICE '>> Truncating Table: bronze.erp_cust_az12';
    TRUNCATE TABLE bronze.erp_cust_az12;

    RAISE NOTICE '>> Loading Data into Table: bronze.erp_cust_az12';
    COPY bronze.erp_cust_az12
        FROM '/mnt/datasets/source_erp/CUST_AZ12.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
    
    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;
    RAISE NOTICE '>> Truncating Table: bronze.erp_loc_a101';
    TRUNCATE TABLE bronze.erp_loc_a101;

    RAISE NOTICE '>> Loading Data into Table: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101
        FROM '/mnt/datasets/source_erp/LOC_A101.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );

    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);
    RAISE NOTICE '>> -------------------------------';

    start_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Current Time: %', start_time;
    RAISE NOTICE '>> Truncating Table: bronze.erp_px_cat_g1v2';
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    RAISE NOTICE '>> Loading Data into Table: bronze.erp_px_cat_g1v2';
    COPY bronze.erp_px_cat_g1v2
        FROM '/mnt/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );

    end_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM end_time - start_time) AS INTEGER);

    RAISE NOTICE '>> -------------------------------';
    RAISE NOTICE '>> Data Load Process Completed';
    full_load_time := CURRENT_TIMESTAMP;
    RAISE NOTICE '>> Full Load Duration: % seconds', CAST(EXTRACT(EPOCH FROM full_load_time - load_start_time) AS INTEGER);

EXCEPTION
    WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS
            err_message = MESSAGE_TEXT,
            err_detail = PG_EXCEPTION_DETAIL,
            err_hint = PG_EXCEPTION_HINT;
        RAISE NOTICE '==============================';
        RAISE NOTICE 'Error loading data into bronze layer: %', SQLERRM;
        RAISE NOTICE 'SQLSTATE: %', SQLSTATE;
        RAISE NOTICE 'An error occurred: % - Detail: % - Hint: %', err_message, err_detail, err_hint; -- More Error Details like the line, etc.
        RAISE NOTICE '==============================';
END
$$;