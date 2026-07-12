-- ============================================================
-- LOAD SILVER DATA
-- Cleaned and standardized business-ready tables
-- ============================================================
USE DATABASE RETAIL_DB;
USE SCHEMA RETAIL_DB.SILVER;
USE WAREHOUSE CORTEX_DEMO_WH;

CREATE OR REPLACE TABLE SILVER_CUSTOMERS
COMMENT = 'Cleaned customer master with standardized names and source-system attributes.'
AS
SELECT
    CUST_ID                                      AS CUSTOMER_ID,
    INITCAP(TRIM(CUST_NM))                       AS CUSTOMER_NAME,
    LOWER(TRIM(EMAIL_ADDR))                      AS EMAIL_ADDRESS,
    INITCAP(TRIM(CITY_NM))                       AS CITY_NAME,
    UPPER(TRIM(STATE_CD))                        AS STATE_CODE,
    SIGNUP_DT                                    AS SIGNUP_DATE,
    DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())   AS CUSTOMER_TENURE_DAYS,
    SRC_SYS_CD                                   AS SOURCE_SYSTEM_CODE,
    INGEST_TS                                    AS RECORD_INGESTED_TIMESTAMP
FROM RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW;

CREATE OR REPLACE TABLE SILVER_ORDERS
COMMENT = 'Cleaned order header table with decoded statuses and calculated net order amount.'
AS
SELECT
    ORD_ID                                       AS ORDER_ID,
    CUST_ID                                      AS CUSTOMER_ID,
    ORD_TS                                       AS ORDER_TIMESTAMP,
    TO_DATE(ORD_TS)                              AS ORDER_DATE,
    ORD_STS_CD                                   AS ORDER_STATUS_CODE,
    CASE ORD_STS_CD
        WHEN 'PND' THEN 'Pending'
        WHEN 'SHP' THEN 'Shipped'
        WHEN 'DLV' THEN 'Delivered'
        WHEN 'CAN' THEN 'Cancelled'
        ELSE 'Unknown'
    END                                          AS ORDER_STATUS_DESCRIPTION,
    PAY_MODE_CD                                  AS PAYMENT_MODE_CODE,
    GROSS_AMT                                    AS GROSS_ORDER_AMOUNT,
    COALESCE(DISC_AMT, 0)                        AS DISCOUNT_AMOUNT,
    COALESCE(TAX_AMT, 0)                         AS TAX_AMOUNT,
    GROSS_AMT - COALESCE(DISC_AMT, 0)
        + COALESCE(TAX_AMT, 0)                   AS NET_ORDER_AMOUNT,
    IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)         AS IS_CANCELLED_FLAG,
    SRC_SYS_CD                                   AS SOURCE_SYSTEM_CODE,
    INGEST_TS                                    AS RECORD_INGESTED_TIMESTAMP
FROM RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW;

CREATE OR REPLACE TABLE SILVER_ORDER_ITEMS
COMMENT = 'Cleaned order-item details with calculated gross and net item amounts.'
AS
SELECT
    ORD_ITEM_ID                                  AS ORDER_ITEM_ID,
    ORD_ID                                       AS ORDER_ID,
    PROD_ID                                      AS PRODUCT_ID,
    INITCAP(TRIM(PROD_NM))                       AS PRODUCT_NAME,
    UPPER(TRIM(PROD_CAT_CD))                     AS PRODUCT_CATEGORY_CODE,
    QTY                                          AS ORDERED_QUANTITY,
    UNIT_PRC                                     AS UNIT_PRICE,
    QTY * UNIT_PRC                               AS GROSS_ITEM_AMOUNT,
    COALESCE(ITEM_DISC_AMT, 0)                   AS ITEM_DISCOUNT_AMOUNT,
    (QTY * UNIT_PRC) - COALESCE(ITEM_DISC_AMT,0) AS NET_ITEM_AMOUNT,
    INGEST_TS                                    AS RECORD_INGESTED_TIMESTAMP
FROM RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW;
