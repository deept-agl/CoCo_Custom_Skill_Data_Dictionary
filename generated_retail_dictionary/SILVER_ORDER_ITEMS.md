# Data Dictionary: `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned order-item details with calculated gross and net item amounts |
| Row Grain | One row per order line item |
| Primary or Natural Key | `ORDER_ITEM_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze layer) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Cleaned and enriched order line-item table derived from the Bronze layer. Product names are title-cased, category codes uppercased, and two calculated financial fields are added: GROSS_ITEM_AMOUNT (QTY × UNIT_PRC) and NET_ITEM_AMOUNT (gross minus discount). Column names are expanded to full business-readable names.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
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

- No row-level filters; all Bronze order item records are included
- Product names are standardized using INITCAP(TRIM(...))
- Category codes are uppercased using UPPER(TRIM(...))
- GROSS_ITEM_AMOUNT = QTY × UNIT_PRC
- NULLs in ITEM_DISC_AMT are defaulted to 0 via COALESCE
- NET_ITEM_AMOUNT = (QTY × UNIT_PRC) - COALESCE(ITEM_DISC_AMT, 0)

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_ITEM_ID` | Order Item Identifier | `NUMBER(38,0)` | YES | Unique identifier for the order line item. Renamed from ORD_ITEM_ID. E.g.: 9001, 9002, 9003, 9004, 9005 | `RENAMED` | HIGH |
| 2 | `ORDER_ID` | Order Identifier | `NUMBER(38,0)` | YES | Foreign key to SILVER_ORDERS.ORDER_ID. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004 | `RENAMED` | HIGH |
| 3 | `PRODUCT_ID` | Product Identifier | `NUMBER(38,0)` | YES | Numeric identifier for the product. Renamed from PROD_ID. E.g.: 301, 302, 303, 304, 305 | `RENAMED` | HIGH |
| 4 | `PRODUCT_NAME` | Product Name | `VARCHAR` | YES | Product name standardized to title case. Derived as `INITCAP(TRIM(PROD_NM))`. E.g.: "Wireless Mouse", "Mouse Pad", "Coffee Mug", "Bluetooth Speaker" | `DERIVED` | HIGH |
| 5 | `PRODUCT_CATEGORY_CODE` | Product Category Code | `VARCHAR` | YES | Product category code standardized to uppercase. Derived as `UPPER(TRIM(PROD_CAT_CD))`. Values: "ELEC" (Electronics), "HOME" (Home & Kitchen), "STAT" (Stationery) | `DERIVED` | HIGH |
| 6 | `ORDERED_QUANTITY` | Ordered Quantity | `NUMBER(38,0)` | YES | Number of units ordered for this line item. Renamed from QTY. Range: 1 to 3 | `RENAMED` | HIGH |
| 7 | `UNIT_PRICE` | Unit Price | `NUMBER(12,2)` | YES | Price per unit of the product. Renamed from UNIT_PRC. Range: 150.00 to 2100.00. E.g.: 500.00, 200.00, 425.00 | `RENAMED` | HIGH |
| 8 | `GROSS_ITEM_AMOUNT` | Gross Item Amount | `NUMBER(38,2)` | YES | Total line-item amount before discount. Derived as `QTY * UNIT_PRC`. Range: 200.00 to 2100.00. E.g.: 1000.00, 850.00, 450.00 | `DERIVED` | HIGH |
| 9 | `ITEM_DISCOUNT_AMOUNT` | Item Discount Amount | `NUMBER(12,2)` | YES | Discount applied to this line item. NULLs defaulted to 0 via `COALESCE(ITEM_DISC_AMT, 0)`. Range: 0.00 to 200.00 | `DERIVED` | HIGH |
| 10 | `NET_ITEM_AMOUNT` | Net Item Amount | `NUMBER(38,2)` | YES | Final line-item amount after discount. Derived as `(QTY * UNIT_PRC) - COALESCE(ITEM_DISC_AMT, 0)`. Range: 150.00 to 1900.00. E.g.: 950.00, 150.00, 800.00 | `DERIVED` | HIGH |
| 11 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Original ingestion timestamp from the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:58.541 | `RENAMED` | HIGH |

---
