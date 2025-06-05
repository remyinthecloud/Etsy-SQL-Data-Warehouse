-- Foreign Key Integrity (Dimnesions)

SELECT * FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
ON f.product_key= p.product_key
WHERE p.product_key IS NULL