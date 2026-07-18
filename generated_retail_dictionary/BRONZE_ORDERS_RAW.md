# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw order header records ingested from operational source systems |
| Row Grain | One row per order |
| Primary or Natural Key | `ORD_ID` |
| Refresh Method | `BATCH` (ingestion from external source systems) |
| Upstream Sources | External OMS and WEB systems |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Raw order header data ingested from the Order Management System (OMS) and Web systems. Contains order-level financial details (gross amount, discount, tax) and status codes. This is the Bronze landing table for orders before cleaning and enrichment in the Silver layer.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External OMS System | `DIRECT` | Primary source of order records |
| External WEB System | `DIRECT` | Secondary source of order records |

### Population Logic

```sql
-- Direct ingestion from source systems; no transformation applied
```

### Known Filters and Business Rules

- No filters or transformations applied at this layer
- Data includes all order statuses including cancelled orders

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORD_ID` | Order Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for an order. Used as the natural key for the order header. E.g.: 5001, 5002, 5003, 5004, 5005 | `SOURCE` | HIGH |
| 2 | `CUST_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Foreign key referencing the customer who placed the order. Joins to BRONZE_CUSTOMERS_RAW.CUST_ID. E.g.: 101, 102, 103, 104 | `SOURCE` | HIGH |
| 3 | `ORD_TS` | Order Timestamp | `TIMESTAMP_NTZ` | YES | Exact date and time when the order was placed. E.g.: 2026-07-01 10:15:00, 2026-07-02 12:45:00 | `SOURCE` | HIGH |
| 4 | `ORD_STS_CD` | Order Status Code | `VARCHAR` | YES | Code indicating the current fulfillment status of the order. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) | `SOURCE` | HIGH |
| 5 | `PAY_MODE_CD` | Payment Mode Code | `VARCHAR` | YES | Code identifying the payment method used. Values: "UPI" (Unified Payments Interface), "CARD" (Credit/Debit Card), "COD" (Cash on Delivery) | `SOURCE` | HIGH |
| 6 | `GROSS_AMT` | Gross Amount | `NUMBER(12,2)` | YES | Total order amount before discounts and taxes. Range: 450.00 to 2100.00. E.g.: 1200.00, 850.00 | `SOURCE` | HIGH |
| 7 | `DISC_AMT` | Discount Amount | `NUMBER(12,2)` | YES | Total discount applied to the order. Range: 0.00 to 200.00. E.g.: 100.00, 50.00, 0.00 | `SOURCE` | HIGH |
| 8 | `TAX_AMT` | Tax Amount | `NUMBER(12,2)` | YES | Tax charged on the order. Range: 22.50 to 95.00. E.g.: 55.00, 40.00 | `SOURCE` | HIGH |
| 9 | `SRC_SYS_CD` | Source System Code | `VARCHAR` | YES | Code identifying the originating source system. Values: "OMS" (Order Management System), "WEB" (Web application) | `SOURCE` | HIGH |
| 10 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:55.716 | `AUDIT` | HIGH |

---
