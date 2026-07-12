/*=============================================================================
 Retail Orders — SETUP SCRIPT
 Creates database, schema, warehouse and resource monitor.
=============================================================================*/
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS RETAIL_DB;

CREATE SCHEMA IF NOT EXISTS RETAIL_DB.BRONZE;
CREATE SCHEMA IF NOT EXISTS RETAIL_DB.SILVER;
CREATE SCHEMA IF NOT EXISTS RETAIL_DB.GOLD;

-- Optional metadata schema for future dictionary outputs
CREATE SCHEMA IF NOT EXISTS RETAIL_DB.METADATA;

--warehouse to execute all workloads
CREATE OR REPLACE WAREHOUSE CORTEX_DEMO_WH WITH
WAREHOUSE_SIZE= 'X-SMALL'
AUTO_SUSPEND=120
AUTO_RESUME= TRUE
INITIALLY_SUSPENDED=TRUE;