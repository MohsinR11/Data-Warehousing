/*
===============================================================================
Quality Checks - PostgreSQL Version (Gold Layer)
===============================================================================
Script Purpose:
    Validate the integrity, consistency, and accuracy of the Gold Layer:
    - Surrogate key uniqueness in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Logical relationship validation in the star schema.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Ensure uniqueness of surrogate key: customer_key
-- Expectation: No results
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Ensure uniqueness of surrogate key: product_key
-- Expectation: No results
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Verify referential integrity between fact and dimension tables
-- Expectation: No rows with NULL dimension references
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
WHERE c.customer_key IS NULL OR p.product_key IS NULL;

