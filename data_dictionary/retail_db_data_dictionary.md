# RETAIL_DB — Consolidated Data Dictionary

| Database | Schema | Table/View | Column | Data Type | Business Description |
|---|---|---|---|---|---|
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CUST_ID | NUMBER(38,0) | Unique numeric identifier for a customer, used to join to orders. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CUST_NM | VARCHAR | Full name of the customer as captured in the source system. E.g.: "Aarav Mehta", "Meera Shah", "Kabir Singh" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | EMAIL_ADDR | VARCHAR | Customer email address. May be NULL if not collected. E.g.: "aarav.mehta@example.com", NULL |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | CITY_NM | VARCHAR | City of residence as recorded in the source system. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru", "Jaipur" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | STATE_CD | VARCHAR | Two-letter state code of the customer's location. E.g.: "HR", "MH", "DL", "KA", "RJ" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | SIGNUP_DT | DATE | Date the customer first registered in the source system. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | SRC_SYS_CD | VARCHAR | Identifier for the originating system. Values: "CRM", "WEB" |
| RETAIL_DB | BRONZE | BRONZE_CUSTOMERS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was loaded into the Bronze layer. Set to CURRENT_TIMESTAMP() at load time. E.g.: 2026-07-12 10:35:15 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_ID | NUMBER(38,0) | Unique numeric identifier for the order. E.g.: 5001, 5002, 5003, 5004, 5005, 5006 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | CUST_ID | NUMBER(38,0) | Foreign key linking to BRONZE_CUSTOMERS_RAW. Links order to customer. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_TS | TIMESTAMP_NTZ | Date and time the order was placed. Range: 2026-07-01 10:15:00 to 2026-07-06 11:10:00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | ORD_STS_CD | VARCHAR | Short code indicating order lifecycle status. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | PAY_MODE_CD | VARCHAR | Payment method used for the order. Values: "UPI", "CARD", "COD" |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | GROSS_AMT | NUMBER(12,2) | Total order amount before discounts and taxes. Range: 450.00 to 2100.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | DISC_AMT | NUMBER(12,2) | Discount amount applied to the order. May be 0.00 when no discount. Range: 0.00 to 200.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | TAX_AMT | NUMBER(12,2) | Tax amount charged on the order. Range: 22.50 to 95.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | SRC_SYS_CD | VARCHAR | Identifier for the originating system. Values: "OMS", "WEB" |
| RETAIL_DB | BRONZE | BRONZE_ORDERS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was loaded into the Bronze layer. Set to CURRENT_TIMESTAMP() at load time. E.g.: 2026-07-12 10:35:17 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ORD_ITEM_ID | NUMBER(38,0) | Unique identifier for each line item within an order. E.g.: 9001, 9002, 9003, 9004, 9005 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ORD_ID | NUMBER(38,0) | Foreign key linking to BRONZE_ORDERS_RAW. E.g.: 5001, 5002, 5003, 5004, 5005, 5006 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_ID | NUMBER(38,0) | Unique identifier for the product. E.g.: 301, 302, 303, 304, 305, 306, 307 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_NM | VARCHAR | Descriptive name of the product. E.g.: "Wireless Mouse", "Mouse Pad", "Coffee Mug", "Notebook Set", "Bluetooth Speaker" |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | PROD_CAT_CD | VARCHAR | Short code representing the product category. Values: "ELEC" (Electronics), "HOME" (Home), "STAT" (Stationery) |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | QTY | NUMBER(38,0) | Number of units of the product ordered. Range: 1 to 3 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | UNIT_PRC | NUMBER(12,2) | Price per unit of the product. Range: 150.00 to 2100.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | ITEM_DISC_AMT | NUMBER(12,2) | Discount applied at the item level. May be 0.00 when no discount. Range: 0.00 to 200.00 |
| RETAIL_DB | BRONZE | BRONZE_ORDER_ITEMS_RAW | INGEST_TS | TIMESTAMP_NTZ | Timestamp when the record was loaded into the Bronze layer. Set to CURRENT_TIMESTAMP() at load time. E.g.: 2026-07-12 10:35:18 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_ID | NUMBER(38,0) | Unique customer identifier. Renamed from CUST_ID. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_NAME | VARCHAR | Full customer name formatted as Initial Caps. Derived as `INITCAP(TRIM(CUST_NM))`. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | EMAIL_ADDRESS | VARCHAR | Customer email lowercased and trimmed; may be NULL. Derived as `LOWER(TRIM(EMAIL_ADDR))`. E.g.: "aarav.mehta@example.com", NULL |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CITY_NAME | VARCHAR | Customer city formatted as Initial Caps. Derived as `INITCAP(TRIM(CITY_NM))`. E.g.: "Gurugram", "Mumbai", "Delhi" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | STATE_CODE | VARCHAR | Two-letter state code uppercased and trimmed. Derived as `UPPER(TRIM(STATE_CD))`. E.g.: "HR", "MH", "DL", "KA", "RJ" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | SIGNUP_DATE | DATE | Date the customer first registered. Renamed from SIGNUP_DT. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | CUSTOMER_TENURE_DAYS | NUMBER(9,0) | Days since signup. Calculated as `DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())`. Dynamic value recalculated on each refresh. E.g.: 543, 518, 494 |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | SOURCE_SYSTEM_CODE | VARCHAR | Originating system identifier. Renamed from SRC_SYS_CD. Values: "CRM", "WEB" |
| RETAIL_DB | SILVER | SILVER_CUSTOMERS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Timestamp when the source record was loaded into Bronze. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:15 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_ID | NUMBER(38,0) | Unique order identifier. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004, 5005, 5006 |
| RETAIL_DB | SILVER | SILVER_ORDERS | CUSTOMER_ID | NUMBER(38,0) | Foreign key to SILVER_CUSTOMERS. Renamed from CUST_ID. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_TIMESTAMP | TIMESTAMP_NTZ | Exact date and time the order was placed. Renamed from ORD_TS. E.g.: 2026-07-01 10:15:00, 2026-07-02 12:45:00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_DATE | DATE | Date portion of order timestamp. Derived as `TO_DATE(ORD_TS)`. E.g.: 2026-07-01, 2026-07-02, 2026-07-03 |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_STATUS_CODE | VARCHAR | Short code for order status. Renamed from ORD_STS_CD. Values: "DLV", "CAN", "SHP", "PND" |
| RETAIL_DB | SILVER | SILVER_ORDERS | ORDER_STATUS_DESCRIPTION | VARCHAR(9) | Human-readable status decoded from ORD_STS_CD via CASE expression. Values: "Delivered", "Cancelled", "Shipped", "Pending", "Unknown" |
| RETAIL_DB | SILVER | SILVER_ORDERS | PAYMENT_MODE_CODE | VARCHAR | Payment method. Renamed from PAY_MODE_CD. Values: "UPI", "CARD", "COD" |
| RETAIL_DB | SILVER | SILVER_ORDERS | GROSS_ORDER_AMOUNT | NUMBER(12,2) | Total order amount before discounts and taxes. Renamed from GROSS_AMT. Range: 450.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | DISCOUNT_AMOUNT | NUMBER(12,2) | Discount applied, NULLs defaulted to 0. Derived as `COALESCE(DISC_AMT, 0)`. Range: 0.00 to 200.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | TAX_AMOUNT | NUMBER(12,2) | Tax charged, NULLs defaulted to 0. Derived as `COALESCE(TAX_AMT, 0)`. Range: 22.50 to 95.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | NET_ORDER_AMOUNT | NUMBER(14,2) | Final order amount after discount and including tax. Calculated as `GROSS_AMT - COALESCE(DISC_AMT, 0) + COALESCE(TAX_AMT, 0)`. Range: 472.50 to 1995.00 |
| RETAIL_DB | SILVER | SILVER_ORDERS | IS_CANCELLED_FLAG | BOOLEAN | Boolean flag indicating cancelled order. Derived as `IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)`. Values: TRUE, FALSE |
| RETAIL_DB | SILVER | SILVER_ORDERS | SOURCE_SYSTEM_CODE | VARCHAR | Originating system identifier. Renamed from SRC_SYS_CD. Values: "OMS", "WEB" |
| RETAIL_DB | SILVER | SILVER_ORDERS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Timestamp when the source record was loaded into Bronze. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:17 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDER_ITEM_ID | NUMBER(38,0) | Unique line-item identifier. Renamed from ORD_ITEM_ID. E.g.: 9001, 9002, 9003, 9004, 9005 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDER_ID | NUMBER(38,0) | Foreign key to SILVER_ORDERS. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004, 5005, 5006 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_ID | NUMBER(38,0) | Unique product identifier. Renamed from PROD_ID. E.g.: 301, 302, 303, 304, 305, 306, 307 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_NAME | VARCHAR | Product name standardized to Initial Caps. Derived as `INITCAP(TRIM(PROD_NM))`. E.g.: "Wireless Mouse", "Coffee Mug", "Bluetooth Speaker" |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | PRODUCT_CATEGORY_CODE | VARCHAR | Category code uppercased and trimmed. Derived as `UPPER(TRIM(PROD_CAT_CD))`. Values: "ELEC", "HOME", "STAT" |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ORDERED_QUANTITY | NUMBER(38,0) | Number of units ordered. Renamed from QTY. Range: 1 to 3 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | UNIT_PRICE | NUMBER(12,2) | Price per unit. Renamed from UNIT_PRC. Range: 150.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | GROSS_ITEM_AMOUNT | NUMBER(38,2) | Total item amount before discount. Calculated as `QTY * UNIT_PRC`. Range: 150.00 to 2100.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | ITEM_DISCOUNT_AMOUNT | NUMBER(12,2) | Item-level discount, NULLs defaulted to 0. Derived as `COALESCE(ITEM_DISC_AMT, 0)`. Range: 0.00 to 200.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | NET_ITEM_AMOUNT | NUMBER(38,2) | Final item amount after discount. Calculated as `(QTY * UNIT_PRC) - COALESCE(ITEM_DISC_AMT, 0)`. Range: 150.00 to 1900.00 |
| RETAIL_DB | SILVER | SILVER_ORDER_ITEMS | RECORD_INGESTED_TIMESTAMP | TIMESTAMP_NTZ | Timestamp when the source record was loaded into Bronze. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:18 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_ID | NUMBER(38,0) | Unique customer identifier from SILVER_CUSTOMERS. E.g.: 101, 102, 103, 104, 105 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_NAME | VARCHAR | Full customer name from SILVER_CUSTOMERS. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CITY_NAME | VARCHAR | Customer city from SILVER_CUSTOMERS. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru", "Jaipur" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | STATE_CODE | VARCHAR | Two-letter state code from SILVER_CUSTOMERS. E.g.: "HR", "MH", "DL", "KA", "RJ" |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | SIGNUP_DATE | DATE | Customer registration date from SILVER_CUSTOMERS. Range: 2025-01-15 to 2025-04-12 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | TOTAL_ORDER_COUNT | NUMBER(18,0) | Total number of orders placed by the customer (all statuses). Calculated as `COUNT(O.ORDER_ID)`. E.g.: 1, 2 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | DELIVERED_ORDER_COUNT | NUMBER(13,0) | Count of orders with status 'DLV'. Calculated as `COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')`. E.g.: 0, 1, 2 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CANCELLED_ORDER_COUNT | NUMBER(13,0) | Count of orders with status 'CAN'. Calculated as `COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')`. E.g.: 0, 1 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | TOTAL_REVENUE_AMOUNT | NUMBER(26,2) | Sum of NET_ORDER_AMOUNT excluding cancelled orders. Calculated as `COALESCE(SUM(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, 0)), 0)`. Range: 0.00 to 1995.00 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | AVERAGE_ORDER_VALUE | NUMBER(32,8) | Average NET_ORDER_AMOUNT for non-cancelled orders. Calculated as `COALESCE(AVG(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, NULL)), 0)`. E.g.: 0.00, 714.00, 813.75, 1522.50, 1995.00 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | MOST_RECENT_ORDER_DATE | DATE | Date of the customer's latest order. Calculated as `MAX(O.ORDER_DATE)`. E.g.: 2026-07-02, 2026-07-03, 2026-07-06 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | DAYS_SINCE_LAST_ORDER | NUMBER(9,0) | Days between last order and current date. Calculated as `DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE())`. Dynamic value recalculated on each refresh. E.g.: 6, 7, 8, 9, 10 |
| RETAIL_DB | GOLD | CUSTOMER_ORDER_SUMMARY | CUSTOMER_SEGMENT_CODE | VARCHAR(10) | Segmentation based on thresholds: HIGH_VALUE if >= 2 orders AND >= 1000 total revenue; otherwise STANDARD. Derived via `IFF(COUNT >= 2 AND SUM >= 1000, 'HIGH_VALUE', 'STANDARD')`. Values: "HIGH_VALUE", "STANDARD" |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | ORDER_DATE | DATE | Calendar date on which non-cancelled orders were placed. Filter: `WHERE ORDER_STATUS_CODE <> 'CAN'`. E.g.: 2026-07-01, 2026-07-03, 2026-07-04, 2026-07-05, 2026-07-06 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_ORDER_COUNT | NUMBER(18,0) | Number of distinct non-cancelled orders on that date. Calculated as `COUNT(DISTINCT ORDER_ID)`. E.g.: 1 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | UNIQUE_CUSTOMER_COUNT | NUMBER(18,0) | Number of distinct customers with non-cancelled orders on that date. Calculated as `COUNT(DISTINCT CUSTOMER_ID)`. E.g.: 1 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | GROSS_SALES_AMOUNT | NUMBER(24,2) | Sum of gross order amounts for the date. Calculated as `SUM(GROSS_ORDER_AMOUNT)`. Range: 450.00 to 2100.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_DISCOUNT_AMOUNT | NUMBER(24,2) | Sum of discount amounts for the date. Calculated as `SUM(DISCOUNT_AMOUNT)`. Range: 0.00 to 200.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | TOTAL_TAX_AMOUNT | NUMBER(24,2) | Sum of tax amounts for the date. Calculated as `SUM(TAX_AMOUNT)`. Range: 22.50 to 95.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | NET_SALES_AMOUNT | NUMBER(26,2) | Sum of net order amounts for the date. Calculated as `SUM(NET_ORDER_AMOUNT)`. Range: 472.50 to 1995.00 |
| RETAIL_DB | GOLD | DAILY_SALES_SUMMARY | AVERAGE_ORDER_VALUE | NUMBER(32,8) | Average net order amount for the date. Calculated as `AVG(NET_ORDER_AMOUNT)`. E.g.: 472.50, 1155.00, 1522.50, 1995.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_ID | NUMBER(38,0) | Unique product identifier from SILVER_ORDER_ITEMS. E.g.: 301, 304, 305, 306, 307 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_NAME | VARCHAR | Cleaned product name from SILVER_ORDER_ITEMS. E.g.: "Wireless Mouse", "Notebook Set", "Bluetooth Speaker", "Desk Lamp" |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_CATEGORY_CODE | VARCHAR | Product category from SILVER_ORDER_ITEMS. Values: "ELEC" (Electronics), "HOME" (Home), "STAT" (Stationery) |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | ORDER_COUNT | NUMBER(18,0) | Number of distinct non-cancelled orders containing this product. Calculated as `COUNT(DISTINCT I.ORDER_ID)`. Excludes orders WHERE O.ORDER_STATUS_CODE <> 'CAN'. E.g.: 1, 2 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | TOTAL_QUANTITY_SOLD | NUMBER(38,0) | Total units of this product sold across non-cancelled orders. Calculated as `SUM(I.ORDERED_QUANTITY)`. E.g.: 1, 2, 3 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | GROSS_PRODUCT_SALES_AMOUNT | NUMBER(38,2) | Total gross item amount for this product. Calculated as `SUM(I.GROSS_ITEM_AMOUNT)`. E.g.: 450.00, 1000.00, 1600.00, 2100.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | PRODUCT_DISCOUNT_AMOUNT | NUMBER(24,2) | Total item-level discounts for this product. Calculated as `SUM(I.ITEM_DISCOUNT_AMOUNT)`. E.g.: 0.00, 50.00, 150.00, 200.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | NET_PRODUCT_SALES_AMOUNT | NUMBER(38,2) | Total net item amount for this product after discounts. Calculated as `SUM(I.NET_ITEM_AMOUNT)`. E.g.: 450.00, 950.00, 1450.00, 1900.00 |
| RETAIL_DB | GOLD | PRODUCT_SALES_PERFORMANCE | MOST_RECENT_SALE_DATE | DATE | Date of the most recent non-cancelled order containing this product. Calculated as `MAX(O.ORDER_DATE)`. E.g.: 2026-07-01, 2026-07-03, 2026-07-04, 2026-07-05, 2026-07-06 |
