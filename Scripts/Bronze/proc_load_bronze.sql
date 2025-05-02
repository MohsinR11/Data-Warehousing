/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

-- ========================
-- Bronze Layer Load Script
-- ========================
DROP PROCEDURE IF EXISTS bronze.load_bronze;

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
    row_count INT;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
BEGIN
    batch_start_time := clock_timestamp();

    RAISE NOTICE '================================================';
    RAISE NOTICE '            Loading Bronze Layer                ';
    RAISE NOTICE '================================================';

    -- ---------- CRM Tables ----------
    RAISE NOTICE '--- CRM Tables ---';

    -- CRM Customer Info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_cust_info;

    COPY bronze.crm_cust_info
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.crm_cust_info;
    RAISE NOTICE 'Loaded % rows into bronze.crm_cust_info', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- CRM Product Info
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;

    COPY bronze.crm_prd_info
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.crm_prd_info;
    RAISE NOTICE 'Loaded % rows into bronze.crm_prd_info', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- CRM Sales Details
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;

    COPY bronze.crm_sales_details
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.crm_sales_details;
    RAISE NOTICE 'Loaded % rows into bronze.crm_sales_details', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- ---------- ERP Tables ----------
    RAISE NOTICE '--- ERP Tables ---';

    -- ERP Location
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;

    COPY bronze.erp_loc_a101
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.erp_loc_a101;
    RAISE NOTICE 'Loaded % rows into bronze.erp_loc_a101', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- ERP Customer AZ12
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;

    COPY bronze.erp_cust_az12
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.erp_cust_az12;
    RAISE NOTICE 'Loaded % rows into bronze.erp_cust_az12', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- ERP PX Cat G1V2
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;

    COPY bronze.erp_px_cat_g1v2
    FROM 'D:/Study/SQL Data Warehouse Project/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ',');

    SELECT COUNT(*) INTO row_count FROM bronze.erp_px_cat_g1v2;
    RAISE NOTICE 'Loaded % rows into bronze.erp_px_cat_g1v2', row_count;
    end_time := clock_timestamp();
    RAISE NOTICE 'Duration: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

    -- ---------- Completion ----------
    batch_end_time := clock_timestamp();
    RAISE NOTICE '================================================';
    RAISE NOTICE ' Bronze Layer Load Completed in % seconds', ROUND(EXTRACT(EPOCH FROM batch_end_time - batch_start_time), 2);
    RAISE NOTICE '================================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '================================================';
        RAISE NOTICE ' ERROR DURING BRONZE LOAD: %', SQLERRM;
        RAISE NOTICE ' SQLSTATE: %', SQLSTATE;
        RAISE NOTICE '================================================';
END;
$$;

-- Execute Procedure
CALL bronze.load_bronze();
