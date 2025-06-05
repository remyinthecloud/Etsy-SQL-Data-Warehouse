/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr = 'N/A' THEN COALESCE(ca.gen, 'N/A') -- Only use ERP gender when the Master i.e CRM is N/A 
		ELSE ci.cst_gndr
	END gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================

CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key, -- Surrogate Key
	pi.prd_id AS product_id,
	pi.prd_key AS product_number,
	pi.prd_nm AS product_name,
	pi.cat_id AS category_id,
	ep.cat AS category,
	ep.subcat AS subcategory,
	ep.maintenance,
	pi.prd_cost AS cost,
	pi.prd_line AS product_line,
	pi.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pi
LEFT JOIN silver.erp_px_cat_g1v2 AS ep
ON pi.cat_id = ep.id
WHERE prd_end_dt IS NULL; -- Filter out historical data

-- =============================================================================
-- Create Dimension: gold.fact_sales
-- =============================================================================

CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
	cs.sls_ord_num AS order_number,
	dp.product_key,
	dc.customer_key,
	cs.sls_order_dt AS order_date,
	cs.sls_ship_dt AS ship_date,
	cs.sls_due_dt AS due_date,
	cs.sls_sales AS sales,
	cs.sls_quantity AS quantity,
	cs.sls_price AS price
FROM silver.crm_sales_details cs
LEFT JOIN gold.dim_products AS dp
ON cs.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
ON cs.sls_cust_id = dc.customer_id