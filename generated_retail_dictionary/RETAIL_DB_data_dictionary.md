# RETAIL_DB — Consolidated Data Dictionary

| Database | Schema | Table/View | Column | Data Type | Business Description |
|---|---|---|---|---|---|
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CUST_ID | NUMBER(38,0) | Unique numeric identifier assigned to a customer in the source system. Used as the natural key to join across order tables. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CUST_NM | VARCHAR | Full name of the customer as recorded in the source system. Not standardized at this layer. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | EMAIL_ADDR | VARCHAR | Customer email address from the source system. May contain NULLs for customers without registered emails. E.g.: "aarav.mehta@example.com", NULL |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CITY_NM | VARCHAR | City of residence as reported by the customer. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru", "Jaipur" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | STATE_CD | VARCHAR | Two-letter Indian state code. Values: "HR" (Haryana), "MH" (Maharashtra), "DL" (Delhi), "KA" (Karnataka), "RJ" (Rajasthan) |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | SIGNUP_DT | DATE | Date when the customer first registered in the system. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | SRC_SYS_CD | VARCHAR | Code identifying the originating source system. Values: "CRM" (Customer Relationship Management), "WEB" (Web application) |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:52.073 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ORD_ITEM_ID | NUMBER(38,0) | Unique numeric identifier for the order line item. E.g.: 9001, 9002, 9003, 9004, 9005 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ORD_ID | NUMBER(38,0) | Foreign key referencing the parent order. Joins to BRONZE_ORDERS_RAW.ORD_ID. E.g.: 5001, 5002, 5003 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_ID | NUMBER(38,0) | Numeric identifier for the product purchased. E.g.: 301, 302, 303, 304, 305 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_NM | VARCHAR | Name of the product as recorded in the source system. E.g.: "Wireless Mouse", "Coffee Mug", "Notebook Set", "Bluetooth Speaker" |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_CAT_CD | VARCHAR | Short code representing the product category. Values: "ELEC" (Electronics), "HOME" (Home & Kitchen), "STAT" (Stationery) |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | QTY | NUMBER(38,0) | Number of units ordered for this line item. Range: 1 to 3. E.g.: 2, 1, 3 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | UNIT_PRC | NUMBER(12,2) | Price per unit of the product. Range: 150.00 to 2100.00. E.g.: 500.00, 200.00, 425.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ITEM_DISC_AMT | NUMBER(12,2) | Discount applied to this line item. Range: 0.00 to 200.00. E.g.: 50.00, 0.00, 200.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:58.541 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_ID | NUMBER(38,0) | Unique numeric identifier for an order. E.g.: 5001, 5002, 5003, 5004, 5005 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | CUST_ID | NUMBER(38,0) | Foreign key referencing the customer who placed the order. E.g.: 101, 102, 103, 104 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_TS | TIMESTAMP_NTZ | Exact date and time when the order was placed. E.g.: 2026-07-01 10:15:00, 2026-07-02 12:45:00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_STS_CD | VARCHAR | Code indicating the current fulfillment status. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | PAY_MODE_CD | VARCHAR | Code identifying the payment method used. Values: "UPI" (Unified Payments Interface), "CARD" (Credit/Debit Card), "COD" (Cash on Delivery) |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | GROSS_AMT | NUMBER(12,2) | Total order amount before discounts and taxes. Range: 450.00 to 2100.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | DISC_AMT | NUMBER(12,2) | Total discount applied to the order. Range: 0.00 to 200.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | TAX_AMT | NUMBER(12,2) | Tax charged on the order. Range: 22.50 to 95.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | SRC_SYS_CD | VARCHAR | Code identifying the originating source system. Values: "OMS" (Order Management System), "WEB" (Web application) |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:55.716 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_ID | NUMBER(38,0) | Unique numeric identifier for a customer. Renamed from CUST_ID in Bronze. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_NAME | VARCHAR | Full name of the customer, standardized to title case. Derived as `INITCAP(TRIM(CUST_NM))`. E.g.: "Aarav Mehta", "Meera Shah" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | EMAIL_ADDRESS | VARCHAR | Customer email address, standardized to lowercase. Derived as `LOWER(TRIM(EMAIL_ADDR))`. May be NULL. E.g.: "aarav.mehta@example.com" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CITY_NAME | VARCHAR | Customer city of residence, standardized to title case. Derived as `INITCAP(TRIM(CITY_NM))`. E.g.: "Gurugram", "Mumbai", "Delhi" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | STATE_CODE | VARCHAR | Two-letter Indian state code, standardized to uppercase. Derived as `UPPER(TRIM(STATE_CD))`. Values: "HR", "MH", "DL", "KA", "RJ" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | SIGNUP_DATE | DATE | Date when the customer first registered. Renamed from SIGNUP_DT. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_TENURE_DAYS | NUMBER(9,0) | Number of days since signup. Derived as `DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())`. Dynamic value recalculated on each refresh. Range: 462 to 549 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | SOURCE_SYSTEM_CODE | VARCHAR | Code identifying the originating system. Renamed from SRC_SYS_CD. Values: "CRM", "WEB" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Original ingestion timestamp from the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:52.073 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDER_ITEM_ID | NUMBER(38,0) | Unique identifier for the order line item. Renamed from ORD_ITEM_ID. E.g.: 9001, 9002, 9003, 9004, 9005 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDER_ID | NUMBER(38,0) | Foreign key to SILVER_ORDERS.ORDER_ID. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_ID | NUMBER(38,0) | Numeric identifier for the product. Renamed from PROD_ID. E.g.: 301, 302, 303, 304, 305 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_NAME | VARCHAR | Product name standardized to title case. Derived as `INITCAP(TRIM(PROD_NM))`. E.g.: "Wireless Mouse", "Coffee Mug", "Bluetooth Speaker" |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_CATEGORY_CODE | VARCHAR | Product category code standardized to uppercase. Derived as `UPPER(TRIM(PROD_CAT_CD))`. Values: "ELEC", "HOME", "STAT" |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDERED_QUANTITY | NUMBER(38,0) | Number of units ordered for this line item. Renamed from QTY. Range: 1 to 3 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | UNIT_PRICE | NUMBER(12,2) | Price per unit of the product. Renamed from UNIT_PRC. Range: 150.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | GROSS_ITEM_AMOUNT | NUMBER(38,2) | Total line-item amount before discount. Derived as `QTY * UNIT_PRC`. Range: 200.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ITEM_DISCOUNT_AMOUNT | NUMBER(12,2) | Discount applied to this line item. NULLs defaulted to 0 via `COALESCE(ITEM_DISC_AMT, 0)`. Range: 0.00 to 200.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | NET_ITEM_AMOUNT | NUMBER(38,2) | Final line-item amount after discount. Derived as `(QTY * UNIT_PRC) - COALESCE(ITEM_DISC_AMT, 0)`. Range: 150.00 to 1900.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Original ingestion timestamp from the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:58.541 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_ID | NUMBER(38,0) | Unique numeric identifier for an order. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004, 5005 |
| RETAIL_DB | SILVER | SILVER_ORDERS | CUSTOMER_ID | NUMBER(38,0) | Foreign key to SILVER_CUSTOMERS.CUSTOMER_ID. Renamed from CUST_ID. E.g.: 101, 102, 103, 104 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_TIMESTAMP | TIMESTAMP_NTZ | Exact date and time the order was placed. Renamed from ORD_TS. E.g.: 2026-07-01 10:15:00, 2026-07-04 17:20:00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_DATE | DATE | Date-only value extracted from the order timestamp. Derived as `TO_DATE(ORD_TS)`. E.g.: 2026-07-01, 2026-07-02, 2026-07-05 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_STATUS_CODE | VARCHAR | Short code for current order fulfillment status. Renamed from ORD_STS_CD. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_STATUS_DESCRIPTION | VARCHAR(9) | Human-readable status decoded via CASE. Derived as `CASE ORD_STS_CD WHEN 'PND' THEN 'Pending' ... END`. Values: "Delivered", "Cancelled", "Shipped", "Pending" |
| RETAIL_DB | SILVER | SILVER_ORDERS | PAYMENT_MODE_CODE | VARCHAR | Code identifying the payment method. Renamed from PAY_MODE_CD. Values: "UPI", "CARD", "COD" |
| RETAIL_DB | SILVER | SILVER_ORDERS | GROSS_ORDER_AMOUNT | NUMBER(12,2) | Total order amount before discounts and taxes. Renamed from GROSS_AMT. Range: 450.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | DISCOUNT_AMOUNT | NUMBER(12,2) | Discount applied to the order. NULLs defaulted to 0 via `COALESCE(DISC_AMT, 0)`. Range: 0.00 to 200.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | TAX_AMOUNT | NUMBER(12,2) | Tax charged on the order. NULLs defaulted to 0 via `COALESCE(TAX_AMT, 0)`. Range: 22.50 to 95.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | NET_ORDER_AMOUNT | NUMBER(14,2) | Final order amount after discount and including tax. Derived as `GROSS_AMT - COALESCE(DISC_AMT, 0) + COALESCE(TAX_AMT, 0)`. Range: 472.50 to 1995.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | IS_CANCELLED_FLAG | BOOLEAN | Boolean flag indicating cancellation. Derived as `IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)`. Values: TRUE, FALSE |
| RETAIL_DB | SILVER | SILVER_ORDERS | SOURCE_SYSTEM_CODE | VARCHAR | Code identifying the originating system. Renamed from SRC_SYS_CD. Values: "OMS", "WEB" |
| RETAIL_DB | SILVER | SILVER_ORDERS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Original ingestion timestamp from the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:55.716 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_ID | NUMBER(38,0) | Unique identifier for the customer. Sourced from SILVER_CUSTOMERS. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_NAME | VARCHAR | Full name of the customer in title case. Sourced from SILVER_CUSTOMERS. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CITY_NAME | VARCHAR | Customer city of residence. Sourced from SILVER_CUSTOMERS. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | STATE_CODE | VARCHAR | Two-letter Indian state code. Sourced from SILVER_CUSTOMERS. Values: "HR", "MH", "DL", "KA", "RJ" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | SIGNUP_DATE | DATE | Date the customer first registered. Sourced from SILVER_CUSTOMERS. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | TOTAL_ORDER_COUNT | NUMBER(18,0) | Total number of orders placed by the customer (all statuses). Aggregated as `COUNT(O.ORDER_ID)`. Range: 1 to 2 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | DELIVERED_ORDER_COUNT | NUMBER(13,0) | Number of delivered orders. Aggregated as `COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')`. Range: 0 to 2 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CANCELLED_ORDER_COUNT | NUMBER(13,0) | Number of cancelled orders. Aggregated as `COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')`. Range: 0 to 1 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | TOTAL_REVENUE_AMOUNT | NUMBER(26,2) | Sum of NET_ORDER_AMOUNT for non-cancelled orders. Derived as `COALESCE(SUM(IFF(STATUS <> 'CAN', NET_ORDER_AMOUNT, 0)), 0)`. Range: 0.00 to 1995.00 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | AVERAGE_ORDER_VALUE | NUMBER(32,8) | Average NET_ORDER_AMOUNT across non-cancelled orders. Derived as `COALESCE(AVG(IFF(STATUS <> 'CAN', NET_ORDER_AMOUNT, NULL)), 0)`. Range: 0.00 to 1995.00 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | MOST_RECENT_ORDER_DATE | DATE | Date of the customer's most recent order. Aggregated as `MAX(O.ORDER_DATE)`. Range: 2026-07-02 to 2026-07-06 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | DAYS_SINCE_LAST_ORDER | NUMBER(9,0) | Days between most recent order and today. Derived as `DATEDIFF('DAY', MAX(ORDER_DATE), CURRENT_DATE())`. Dynamic value recalculated on each refresh. Range: 12 to 16 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_SEGMENT_CODE | VARCHAR(10) | Segmentation label. Derived as `IFF(COUNT >= 2 AND revenue >= 1000, 'HIGH_VALUE', 'STANDARD')`. Values: "HIGH_VALUE", "STANDARD" |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | ORDER_DATE | DATE | Calendar date of the orders. Natural key for this daily summary. Excludes dates with only cancelled orders. E.g.: 2026-07-01, 2026-07-03, 2026-07-05 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_ORDER_COUNT | NUMBER(18,0) | Count of distinct non-cancelled orders on this date. Aggregated as `COUNT(DISTINCT ORDER_ID)`. Range: 1 to 1 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | UNIQUE_CUSTOMER_COUNT | NUMBER(18,0) | Count of distinct customers with non-cancelled orders on this date. Aggregated as `COUNT(DISTINCT CUSTOMER_ID)`. Range: 1 to 1 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | GROSS_SALES_AMOUNT | NUMBER(24,2) | Sum of gross order amounts for the day. Aggregated as `SUM(GROSS_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 450.00 to 2100.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_DISCOUNT_AMOUNT | NUMBER(24,2) | Sum of discount amounts for the day. Aggregated as `SUM(DISCOUNT_AMOUNT)`. Excludes cancelled orders. Range: 0.00 to 200.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_TAX_AMOUNT | NUMBER(24,2) | Sum of tax amounts for the day. Aggregated as `SUM(TAX_AMOUNT)`. Excludes cancelled orders. Range: 22.50 to 95.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | NET_SALES_AMOUNT | NUMBER(26,2) | Sum of net order amounts for the day. Aggregated as `SUM(NET_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 472.50 to 1995.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | AVERAGE_ORDER_VALUE | NUMBER(32,8) | Average net order amount per order for the day. Aggregated as `AVG(NET_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 472.50 to 1995.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_ID | NUMBER(38,0) | Unique numeric identifier for a product. Sourced from SILVER_ORDER_ITEMS.PRODUCT_ID. E.g.: 301, 302, 305, 306, 307 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_NAME | TEXT | Descriptive name of the product. Sourced from SILVER_ORDER_ITEMS.PRODUCT_NAME. E.g.: "Wireless Mouse", "Bluetooth Speaker", "Desk Lamp" |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_CATEGORY_CODE | TEXT | Product category code. Sourced from SILVER_ORDER_ITEMS.PRODUCT_CATEGORY_CODE. Values: "ELEC", "HOME", "STAT" |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | ORDER_COUNT | NUMBER(18,0) | Count of distinct non-cancelled orders containing this product. Aggregated as `COUNT(DISTINCT I.ORDER_ID)`. Excludes cancelled orders. Range: 1 to 1 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | TOTAL_QUANTITY_SOLD | NUMBER(38,0) | Sum of ordered quantities across non-cancelled orders. Aggregated as `SUM(I.ORDERED_QUANTITY)`. Range: 1 to 3 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | GROSS_PRODUCT_SALES_AMOUNT | NUMBER(38,2) | Total gross sales before discounts. Aggregated as `SUM(I.GROSS_ITEM_AMOUNT)`. Excludes cancelled orders. Range: 200.00 to 2100.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_DISCOUNT_AMOUNT | NUMBER(24,2) | Total discount for this product. Aggregated as `SUM(I.ITEM_DISCOUNT_AMOUNT)`. Excludes cancelled orders. Range: 0.00 to 200.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | NET_PRODUCT_SALES_AMOUNT | NUMBER(38,2) | Total net sales after discounts. Aggregated as `SUM(I.NET_ITEM_AMOUNT)`. Excludes cancelled orders. Range: 150.00 to 1900.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | MOST_RECENT_SALE_DATE | DATE | Date of the most recent non-cancelled order for this product. Aggregated as `MAX(O.ORDER_DATE)`. Range: 2026-07-01 to 2026-07-06 |
