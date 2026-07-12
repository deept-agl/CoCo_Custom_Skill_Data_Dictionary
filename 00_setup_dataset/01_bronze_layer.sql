-- ============================================================
--LOAD BRONZE DATA
-- Raw source-aligned tables
-- ============================================================

USE DATABASE RETAIL_DB;
USE SCHEMA RETAIL_DB.BRONZE;
USE WAREHOUSE CORTEX_DEMO_WH;

CREATE OR REPLACE TABLE BRONZE_CUSTOMERS_RAW (
    CUST_ID             NUMBER,
    CUST_NM             VARCHAR,
    EMAIL_ADDR          VARCHAR,
    CITY_NM             VARCHAR,
    STATE_CD            VARCHAR,
    SIGNUP_DT           DATE,
    SRC_SYS_CD          VARCHAR,
    INGEST_TS           TIMESTAMP_NTZ
)
COMMENT = 'Raw customer records ingested from source systems without business transformations.';

CREATE OR REPLACE TABLE BRONZE_ORDERS_RAW (
    ORD_ID              NUMBER,
    CUST_ID             NUMBER,
    ORD_TS              TIMESTAMP_NTZ,
    ORD_STS_CD          VARCHAR,
    PAY_MODE_CD         VARCHAR,
    GROSS_AMT           NUMBER(12,2),
    DISC_AMT            NUMBER(12,2),
    TAX_AMT             NUMBER(12,2),
    SRC_SYS_CD          VARCHAR,
    INGEST_TS           TIMESTAMP_NTZ
)
COMMENT = 'Raw order header records ingested from operational source systems.';

CREATE OR REPLACE TABLE BRONZE_ORDER_ITEMS_RAW (
    ORD_ITEM_ID         NUMBER,
    ORD_ID              NUMBER,
    PROD_ID             NUMBER,
    PROD_NM             VARCHAR,
    PROD_CAT_CD         VARCHAR,
    QTY                 NUMBER,
    UNIT_PRC            NUMBER(12,2),
    ITEM_DISC_AMT       NUMBER(12,2),
    INGEST_TS           TIMESTAMP_NTZ
)
COMMENT = 'Raw order-item records containing product, quantity, price, and discount details.';

INSERT INTO BRONZE_CUSTOMERS_RAW
(CUST_ID, CUST_NM, EMAIL_ADDR, CITY_NM, STATE_CD, SIGNUP_DT, SRC_SYS_CD, INGEST_TS)
VALUES
(101, 'Aarav Mehta', 'aarav.mehta@example.com', 'Gurugram', 'HR', '2025-01-15', 'CRM', CURRENT_TIMESTAMP()),
(102, 'Meera Shah', 'meera.shah@example.com', 'Mumbai', 'MH', '2025-02-10', 'CRM', CURRENT_TIMESTAMP()),
(103, 'Rohan Verma', 'rohan.verma@example.com', 'Delhi', 'DL', '2025-03-05', 'WEB', CURRENT_TIMESTAMP()),
(104, 'Isha Nair', 'isha.nair@example.com', 'Bengaluru', 'KA', '2025-03-25', 'WEB', CURRENT_TIMESTAMP()),
(105, 'Kabir Singh', NULL, 'Jaipur', 'RJ', '2025-04-12', 'CRM', CURRENT_TIMESTAMP());

INSERT INTO BRONZE_ORDERS_RAW
(ORD_ID, CUST_ID, ORD_TS, ORD_STS_CD, PAY_MODE_CD, GROSS_AMT, DISC_AMT, TAX_AMT, SRC_SYS_CD, INGEST_TS)
VALUES
(5001, 101, '2026-07-01 10:15:00', 'DLV', 'UPI', 1200.00, 100.00, 55.00, 'OMS', CURRENT_TIMESTAMP()),
(5002, 102, '2026-07-02 12:45:00', 'CAN', 'CARD', 850.00, 50.00, 40.00, 'OMS', CURRENT_TIMESTAMP()),
(5003, 101, '2026-07-03 09:30:00', 'DLV', 'COD', 450.00, 0.00, 22.50, 'OMS', CURRENT_TIMESTAMP()),
(5004, 103, '2026-07-04 17:20:00', 'SHP', 'UPI', 2100.00, 200.00, 95.00, 'OMS', CURRENT_TIMESTAMP()),
(5005, 104, '2026-07-05 20:05:00', 'DLV', 'CARD', 1600.00, 150.00, 72.50, 'WEB', CURRENT_TIMESTAMP()),
(5006, 105, '2026-07-06 11:10:00', 'PND', 'UPI', 700.00, 20.00, 34.00, 'WEB', CURRENT_TIMESTAMP());

INSERT INTO BRONZE_ORDER_ITEMS_RAW
(ORD_ITEM_ID, ORD_ID, PROD_ID, PROD_NM, PROD_CAT_CD, QTY, UNIT_PRC, ITEM_DISC_AMT, INGEST_TS)
VALUES
(9001, 5001, 301, 'Wireless Mouse', 'ELEC', 2, 500.00, 50.00, CURRENT_TIMESTAMP()),
(9002, 5001, 302, 'Mouse Pad', 'ELEC', 1, 200.00, 50.00, CURRENT_TIMESTAMP()),
(9003, 5002, 303, 'Coffee Mug', 'HOME', 2, 425.00, 50.00, CURRENT_TIMESTAMP()),
(9004, 5003, 304, 'Notebook Set', 'STAT', 3, 150.00, 0.00, CURRENT_TIMESTAMP()),
(9005, 5004, 305, 'Bluetooth Speaker', 'ELEC', 1, 2100.00, 200.00, CURRENT_TIMESTAMP()),
(9006, 5005, 306, 'Desk Lamp', 'HOME', 2, 800.00, 150.00, CURRENT_TIMESTAMP()),
(9007, 5006, 307, 'Water Bottle', 'HOME', 2, 350.00, 20.00, CURRENT_TIMESTAMP());
