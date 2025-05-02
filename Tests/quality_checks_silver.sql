/*
===============================================================================
Quality Checks - PostgreSQL Version
===============================================================================
Script Purpose:
    Perform quality checks on the Silver Layer for:
    - Null or duplicate primary keys.
    - Unwanted spaces.
    - Data standardization and consistency.
    - Invalid date ranges and logic.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================
-- Nulls or Duplicates in Primary Key
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Unwanted Spaces
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key IS NOT NULL AND cst_key IS DISTINCT FROM TRIM(cst_key);

-- Marital Status Values
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================
-- Nulls or Duplicates in Primary Key
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Unwanted Spaces
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm IS NOT NULL AND prd_nm IS DISTINCT FROM TRIM(prd_nm);

-- Negative or NULL Costs
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Product Line Values
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Start Date > End Date
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================
-- Invalid Dates (bronze format is assumed to be integer-like YYYYMMDD)
SELECT 
    sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LENGTH(sls_due_dt::TEXT) != 8 
   OR sls_due_dt::INTEGER > 20500101 
   OR sls_due_dt::INTEGER < 19000101;

-- Invalid Order Logic
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Sales ≠ Quantity * Price or Nulls/Negatives
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL 
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0 
   OR sls_sales != sls_quantity * sls_price
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================
-- Out-of-Range Birthdates
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < DATE '1924-01-01' 
   OR bdate > CURRENT_DATE;

-- Gender Values
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================
-- Country Standardization
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Unwanted Spaces
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat IS NOT NULL AND cat IS DISTINCT FROM TRIM(cat)
   OR subcat IS NOT NULL AND subcat IS DISTINCT FROM TRIM(subcat)
   OR maintenance IS NOT NULL AND maintenance IS DISTINCT FROM TRIM(maintenance);

-- Maintenance Values
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;

