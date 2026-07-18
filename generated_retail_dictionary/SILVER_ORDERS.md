# Data Dictionary: `RETAIL_DB.SILVER.SILVER_ORDERS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned order header table with decoded statuses and calculated net order amount |
| Row Grain | One row per order |
| Primary or Natural Key | `ORDER_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze layer) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Cleaned and enriched order header table derived from the Bronze layer. Status codes are decoded into human-readable descriptions, a date-only field is extracted from the timestamp, NULLs in discount and tax are defaulted to 0 via COALESCE, a net order amount is calculated, and a boolean cancellation flag is added.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
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

- No row-level filters; all Bronze order records are included
- NULLs in DISC_AMT and TAX_AMT are defaulted to 0 via COALESCE
- NET_ORDER_AMOUNT = GROSS_AMT - DISCOUNT + TAX (tax is added to the net)
- IS_CANCELLED_FLAG is TRUE only when ORD_STS_CD = 'CAN'

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_ID` | Order Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for an order. Renamed from ORD_ID. E.g.: 5001, 5002, 5003, 5004, 5005 | `RENAMED` | HIGH |
| 2 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Foreign key to SILVER_CUSTOMERS.CUSTOMER_ID. Renamed from CUST_ID. E.g.: 101, 102, 103, 104 | `RENAMED` | HIGH |
| 3 | `ORDER_TIMESTAMP` | Order Timestamp | `TIMESTAMP_NTZ` | YES | Exact date and time the order was placed. Renamed from ORD_TS. E.g.: 2026-07-01 10:15:00, 2026-07-04 17:20:00 | `RENAMED` | HIGH |
| 4 | `ORDER_DATE` | Order Date | `DATE` | YES | Date-only value extracted from the order timestamp. Derived as `TO_DATE(ORD_TS)`. E.g.: 2026-07-01, 2026-07-02, 2026-07-05 | `DERIVED` | HIGH |
| 5 | `ORDER_STATUS_CODE` | Order Status Code | `VARCHAR` | YES | Short code for current order fulfillment status. Renamed from ORD_STS_CD. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) | `RENAMED` | HIGH |
| 6 | `ORDER_STATUS_DESCRIPTION` | Order Status Description | `VARCHAR(9)` | YES | Human-readable description decoded via CASE statement. Derived as `CASE ORD_STS_CD WHEN 'PND' THEN 'Pending' WHEN 'SHP' THEN 'Shipped' WHEN 'DLV' THEN 'Delivered' WHEN 'CAN' THEN 'Cancelled' ELSE 'Unknown' END`. Values: "Delivered", "Cancelled", "Shipped", "Pending" | `DERIVED` | HIGH |
| 7 | `PAYMENT_MODE_CODE` | Payment Mode Code | `VARCHAR` | YES | Code identifying the payment method. Renamed from PAY_MODE_CD. Values: "UPI", "CARD", "COD" | `RENAMED` | HIGH |
| 8 | `GROSS_ORDER_AMOUNT` | Gross Order Amount | `NUMBER(12,2)` | YES | Total order amount before discounts and taxes. Renamed from GROSS_AMT. Range: 450.00 to 2100.00 | `RENAMED` | HIGH |
| 9 | `DISCOUNT_AMOUNT` | Discount Amount | `NUMBER(12,2)` | YES | Discount applied to the order. NULLs defaulted to 0 via `COALESCE(DISC_AMT, 0)`. Range: 0.00 to 200.00 | `DERIVED` | HIGH |
| 10 | `TAX_AMOUNT` | Tax Amount | `NUMBER(12,2)` | YES | Tax charged on the order. NULLs defaulted to 0 via `COALESCE(TAX_AMT, 0)`. Range: 22.50 to 95.00 | `DERIVED` | HIGH |
| 11 | `NET_ORDER_AMOUNT` | Net Order Amount | `NUMBER(14,2)` | YES | Final order amount after discount and including tax. Derived as `GROSS_AMT - COALESCE(DISC_AMT, 0) + COALESCE(TAX_AMT, 0)`. Range: 472.50 to 1995.00. E.g.: 1155.00, 472.50, 1995.00 | `DERIVED` | HIGH |
| 12 | `IS_CANCELLED_FLAG` | Is Cancelled Flag | `BOOLEAN` | YES | Boolean flag indicating whether the order was cancelled. Derived as `IFF(ORD_STS_CD = 'CAN', TRUE, FALSE)`. Values: TRUE, FALSE | `DERIVED` | HIGH |
| 13 | `SOURCE_SYSTEM_CODE` | Source System Code | `VARCHAR` | YES | Code identifying the originating system. Renamed from SRC_SYS_CD. Values: "OMS", "WEB" | `RENAMED` | HIGH |
| 14 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Original ingestion timestamp from the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:55.716 | `RENAMED` | HIGH |

---
