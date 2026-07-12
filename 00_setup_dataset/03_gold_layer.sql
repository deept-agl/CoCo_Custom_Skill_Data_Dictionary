-- ============================================================
-- LOAD GOLD DATA
-- Business marts and analytics-ready aggregates
-- ============================================================

USE DATABASE RETAIL_DB;
USE SCHEMA RETAIL_DB.GOLD;
USE WAREHOUSE CORTEX_DEMO_WH;

CREATE OR REPLACE TABLE CUSTOMER_ORDER_SUMMARY
COMMENT = 'Customer-level order performance summary derived from Silver customer and order tables.'
AS
SELECT
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.CITY_NAME,
    C.STATE_CODE,
    C.SIGNUP_DATE,
    COUNT(O.ORDER_ID)                                                    AS TOTAL_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')                                AS DELIVERED_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')                                AS CANCELLED_ORDER_COUNT,
    COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0)
                                                                          AS TOTAL_REVENUE_AMOUNT,
    COALESCE(AVG(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, NULL)), 0)
                                                                          AS AVERAGE_ORDER_VALUE,
    MAX(O.ORDER_DATE)                                                    AS MOST_RECENT_ORDER_DATE,
    DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE())                    AS DAYS_SINCE_LAST_ORDER,
    IFF(
        COUNT(O.ORDER_ID) >= 2
        AND COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0) >= 1000,
        'HIGH_VALUE',
        'STANDARD'
    )                                                                    AS CUSTOMER_SEGMENT_CODE
FROM RETAIL_DB.SILVER.SILVER_CUSTOMERS C
LEFT JOIN RETAIL_DB.SILVER.SILVER_ORDERS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.CITY_NAME,
    C.STATE_CODE,
    C.SIGNUP_DATE;

CREATE OR REPLACE TABLE DAILY_SALES_SUMMARY
COMMENT = 'Daily sales summary excluding cancelled orders and aggregating revenue and order metrics.'
AS
SELECT
    ORDER_DATE,
    COUNT(DISTINCT ORDER_ID)                         AS TOTAL_ORDER_COUNT,
    COUNT(DISTINCT CUSTOMER_ID)                      AS UNIQUE_CUSTOMER_COUNT,
    SUM(GROSS_ORDER_AMOUNT)                          AS GROSS_SALES_AMOUNT,
    SUM(DISCOUNT_AMOUNT)                             AS TOTAL_DISCOUNT_AMOUNT,
    SUM(TAX_AMOUNT)                                  AS TOTAL_TAX_AMOUNT,
    SUM(NET_ORDER_AMOUNT)                            AS NET_SALES_AMOUNT,
    AVG(NET_ORDER_AMOUNT)                            AS AVERAGE_ORDER_VALUE
FROM RETAIL_DB.SILVER.SILVER_ORDERS
WHERE ORDER_STATUS_CODE <> 'CAN'
GROUP BY ORDER_DATE;

CREATE OR REPLACE VIEW PRODUCT_SALES_PERFORMANCE
COMMENT = 'Product-level sales view combining item-level sales with order status and order date.'
AS
SELECT
    I.PRODUCT_ID,
    I.PRODUCT_NAME,
    I.PRODUCT_CATEGORY_CODE,
    COUNT(DISTINCT I.ORDER_ID)                       AS ORDER_COUNT,
    SUM(I.ORDERED_QUANTITY)                          AS TOTAL_QUANTITY_SOLD,
    SUM(I.GROSS_ITEM_AMOUNT)                         AS GROSS_PRODUCT_SALES_AMOUNT,
    SUM(I.ITEM_DISCOUNT_AMOUNT)                      AS PRODUCT_DISCOUNT_AMOUNT,
    SUM(I.NET_ITEM_AMOUNT)                           AS NET_PRODUCT_SALES_AMOUNT,
    MAX(O.ORDER_DATE)                                AS MOST_RECENT_SALE_DATE
FROM RETAIL_DB.SILVER.SILVER_ORDER_ITEMS I
JOIN RETAIL_DB.SILVER.SILVER_ORDERS O
    ON I.ORDER_ID = O.ORDER_ID
WHERE O.ORDER_STATUS_CODE <> 'CAN'
GROUP BY
    I.PRODUCT_ID,
    I.PRODUCT_NAME,
    I.PRODUCT_CATEGORY_CODE;
