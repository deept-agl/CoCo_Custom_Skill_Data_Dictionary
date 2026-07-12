# Data Dictionary: `RETAIL_DB.SILVER.SILVER_ORDERS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned order header table with decoded statuses and calculated net order amount. |
| Row Grain | One row per order |
| Primary or Natural Key | `ORDER_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` |
| Downstream Objects | `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY`, `RETAIL_DB.GOLD.DAILY_SALES_SUMMARY`, `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE` |
| Sensitivity | Low |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table is the cleaned and enriched order header in the Silver layer. It renames abbreviated columns to full business-friendly names, decodes status codes into human-readable descriptions, derives the ORDER_DATE from the timestamp, calculates the NET_ORDER_AMOUNT (gross - discount + tax), and adds a boolean IS_CANCELLED_FLAG for filtering convenience.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
CREATE OR REPLACE TABLE SILVER_ORDERS AS
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
    GROSS_AMT - COALESCE(DISC_AMT, 0) + COALESCE(TAX_AMT, 0) AS NET_ORDER_AMOUNT,
    IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)         AS IS_CANCELLED_FLAG,
    SRC_SYS_CD                                   AS SOURCE_SYSTEM_CODE,
    INGEST_TS                                    AS RECORD_INGESTED_TIMESTAMP
FROM RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW;
```

### Known Filters and Business Rules

- NET_ORDER_AMOUNT = GROSS - DISCOUNT + TAX (tax is additive)
- IS_CANCELLED_FLAG = TRUE only when status code is 'CAN'
- COALESCE ensures NULLs in DISC_AMT/TAX_AMT default to 0
- ORDER_DATE derived from ORDER_TIMESTAMP via TO_DATE()

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_ID` | Order Identifier | `NUMBER(38,0)` | YES | Unique identifier for the order. Renamed from ORD_ID. E.g.: 5001, 5002, 5003 | Renamed | HIGH |
| 2 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Foreign key to SILVER_CUSTOMERS. Renamed from CUST_ID. E.g.: 101, 102, 103 | Renamed | HIGH |
| 3 | `ORDER_TIMESTAMP` | Order Timestamp | `TIMESTAMP_NTZ` | YES | Exact date and time the order was placed. Renamed from ORD_TS. E.g.: 2026-07-01 10:15:00 | Renamed | HIGH |
| 4 | `ORDER_DATE` | Order Date | `DATE` | YES | Date portion of the order timestamp. Derived as `TO_DATE(ORD_TS)`. E.g.: 2026-07-01, 2026-07-03 | Derived | HIGH |
| 5 | `ORDER_STATUS_CODE` | Order Status Code | `VARCHAR` | YES | Short code for order lifecycle status. Renamed from ORD_STS_CD. Values: "DLV", "CAN", "SHP", "PND" | Renamed | HIGH |
| 6 | `ORDER_STATUS_DESCRIPTION` | Order Status Description | `VARCHAR(9)` | YES | Human-readable status decoded from status code via CASE expression. Values: "Delivered", "Cancelled", "Shipped", "Pending", "Unknown" | Derived | HIGH |
| 7 | `PAYMENT_MODE_CODE` | Payment Mode Code | `VARCHAR` | YES | Payment method used. Renamed from PAY_MODE_CD. Values: "UPI", "CARD", "COD" | Renamed | HIGH |
| 8 | `GROSS_ORDER_AMOUNT` | Gross Order Amount | `NUMBER(12,2)` | YES | Total order amount before discounts and taxes. Renamed from GROSS_AMT. Range: 450.00 to 2100.00 | Renamed | HIGH |
| 9 | `DISCOUNT_AMOUNT` | Discount Amount | `NUMBER(12,2)` | YES | Discount applied to the order, defaulting NULL to 0. Derived as `COALESCE(DISC_AMT, 0)`. Range: 0.00 to 200.00 | Derived | HIGH |
| 10 | `TAX_AMOUNT` | Tax Amount | `NUMBER(12,2)` | YES | Tax charged on the order, defaulting NULL to 0. Derived as `COALESCE(TAX_AMT, 0)`. Range: 22.50 to 95.00 | Derived | HIGH |
| 11 | `NET_ORDER_AMOUNT` | Net Order Amount | `NUMBER(14,2)` | YES | Final order amount after discount and including tax. Calculated as `GROSS_AMT - COALESCE(DISC_AMT, 0) + COALESCE(TAX_AMT, 0)`. Range: 472.50 to 1995.00 | Derived | HIGH |
| 12 | `IS_CANCELLED_FLAG` | Is Cancelled Flag | `BOOLEAN` | YES | Boolean flag indicating whether the order was cancelled. Derived as `IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)`. Values: TRUE, FALSE | Derived | HIGH |
| 13 | `SOURCE_SYSTEM_CODE` | Source System Code | `VARCHAR` | YES | Originating system identifier. Renamed from SRC_SYS_CD. Values: "OMS", "WEB" | Renamed | HIGH |
| 14 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the source record was loaded into the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:17 | Renamed | HIGH |
