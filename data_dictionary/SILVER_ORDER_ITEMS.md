# Data Dictionary: `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned order-item details with calculated gross and net item amounts. |
| Row Grain | One row per order line item |
| Primary or Natural Key | `ORDER_ITEM_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` |
| Downstream Objects | `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE` |
| Sensitivity | Low |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table is the cleaned and enriched order line-item detail in the Silver layer. It renames abbreviated columns, standardizes product names (INITCAP) and category codes (UPPER), and calculates the GROSS_ITEM_AMOUNT (QTY * UNIT_PRC) and NET_ITEM_AMOUNT (gross minus discount).

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
CREATE OR REPLACE TABLE SILVER_ORDER_ITEMS AS
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
```

### Known Filters and Business Rules

- GROSS_ITEM_AMOUNT = QTY * UNIT_PRC
- NET_ITEM_AMOUNT = GROSS_ITEM_AMOUNT - ITEM_DISCOUNT_AMOUNT
- COALESCE ensures NULL discounts default to 0
- Product names formatted with INITCAP(TRIM())
- Category codes standardized with UPPER(TRIM())

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_ITEM_ID` | Order Item Identifier | `NUMBER(38,0)` | YES | Unique line-item identifier. Renamed from ORD_ITEM_ID. E.g.: 9001, 9002, 9003 | Renamed | HIGH |
| 2 | `ORDER_ID` | Order Identifier | `NUMBER(38,0)` | YES | Foreign key to SILVER_ORDERS. Renamed from ORD_ID. E.g.: 5001, 5002, 5003 | Renamed | HIGH |
| 3 | `PRODUCT_ID` | Product Identifier | `NUMBER(38,0)` | YES | Unique product identifier. Renamed from PROD_ID. E.g.: 301, 302, 303 | Renamed | HIGH |
| 4 | `PRODUCT_NAME` | Product Name | `VARCHAR` | YES | Product name standardized to Initial Caps. Derived as `INITCAP(TRIM(PROD_NM))`. E.g.: "Wireless Mouse", "Coffee Mug", "Bluetooth Speaker" | Derived | HIGH |
| 5 | `PRODUCT_CATEGORY_CODE` | Product Category Code | `VARCHAR` | YES | Category code uppercased and trimmed. Derived as `UPPER(TRIM(PROD_CAT_CD))`. Values: "ELEC", "HOME", "STAT" | Derived | HIGH |
| 6 | `ORDERED_QUANTITY` | Ordered Quantity | `NUMBER(38,0)` | YES | Number of units ordered. Renamed from QTY. Range: 1 to 3 | Renamed | HIGH |
| 7 | `UNIT_PRICE` | Unit Price | `NUMBER(12,2)` | YES | Price per unit. Renamed from UNIT_PRC. Range: 150.00 to 2100.00 | Renamed | HIGH |
| 8 | `GROSS_ITEM_AMOUNT` | Gross Item Amount | `NUMBER(38,2)` | YES | Total item amount before discount. Calculated as `QTY * UNIT_PRC`. Range: 150.00 to 2100.00 | Derived | HIGH |
| 9 | `ITEM_DISCOUNT_AMOUNT` | Item Discount Amount | `NUMBER(12,2)` | YES | Discount at item level, NULL defaulted to 0. Derived as `COALESCE(ITEM_DISC_AMT, 0)`. Range: 0.00 to 200.00 | Derived | HIGH |
| 10 | `NET_ITEM_AMOUNT` | Net Item Amount | `NUMBER(38,2)` | YES | Final item amount after discount. Calculated as `(QTY * UNIT_PRC) - COALESCE(ITEM_DISC_AMT, 0)`. Range: 150.00 to 1900.00 | Derived | HIGH |
| 11 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the source record was loaded into Bronze. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:18 | Renamed | HIGH |
