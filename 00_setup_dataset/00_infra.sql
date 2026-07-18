/*=============================================================================
 Retail Orders — SETUP SCRIPT
 Creates database, schema, warehouse and resource monitor.
=============================================================================*/
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE DATABASE RETAIL_DB;

CREATE OR REPLACE SCHEMA RETAIL_DB.BRONZE;
CREATE OR REPLACE SCHEMA RETAIL_DB.SILVER;
CREATE OR REPLACE SCHEMA RETAIL_DB.GOLD;


--warehouse to execute all workloads
CREATE OR REPLACE WAREHOUSE CORTEX_DEMO_WH WITH
WAREHOUSE_SIZE= 'X-SMALL'
AUTO_SUSPEND=120
AUTO_RESUME= TRUE
INITIALLY_SUSPENDED=TRUE;