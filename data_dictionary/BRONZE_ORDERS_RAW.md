# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_ORDERS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw order header records ingested from operational source systems. |
| Row Grain | One row per order |
| Primary or Natural Key | `ORD_ID` |
| Refresh Method | `BATCH` (INSERT from source) |
| Upstream Sources | External OMS (Order Management System) and WEB systems |
| Downstream Objects | `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Sensitivity | Low (no direct PII) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table stores raw order header records as received from the Order Management System (OMS) and WEB channel. Each record represents a single customer order with financial amounts (gross, discount, tax) and status codes. No business transformations, status decoding, or net amount calculations are applied at this layer.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External OMS System | `DIRECT` | Primary order source |
| External WEB System | `DIRECT` | Web-channel order source |

### Population Logic

```sql
INSERT INTO BRONZE_ORDERS_RAW
(ORD_ID, CUST_ID, ORD_TS, ORD_STS_CD, PAY_MODE_CD, GROSS_AMT, DISC_AMT, TAX_AMT, SRC_SYS_CD, INGEST_TS)
VALUES (...);
```

### Known Filters and Business Rules

- No status code validation at this layer
- DISC_AMT may be 0.00 (no discount applied)
- INGEST_TS is set to CURRENT_TIMESTAMP() at load time

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORD_ID` | Order Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for the order. E.g.: 5001, 5002, 5003 | Source | HIGH |
| 2 | `CUST_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Foreign key to BRONZE_CUSTOMERS_RAW. Links order to customer. E.g.: 101, 102, 103 | Source | HIGH |
| 3 | `ORD_TS` | Order Timestamp | `TIMESTAMP_NTZ` | YES | Date and time the order was placed. Range: 2026-07-01 to 2026-07-06 | Source | HIGH |
| 4 | `ORD_STS_CD` | Order Status Code | `VARCHAR` | YES | Short code indicating order lifecycle status. Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped), "PND" (Pending) | Source | HIGH |
| 5 | `PAY_MODE_CD` | Payment Mode Code | `VARCHAR` | YES | Payment method used for the order. Values: "UPI", "CARD", "COD" | Source | HIGH |
| 6 | `GROSS_AMT` | Gross Amount | `NUMBER(12,2)` | YES | Total order amount before discounts and taxes. Range: 450.00 to 2100.00 | Source | HIGH |
| 7 | `DISC_AMT` | Discount Amount | `NUMBER(12,2)` | YES | Discount amount applied to the order. Range: 0.00 to 200.00 | Source | HIGH |
| 8 | `TAX_AMT` | Tax Amount | `NUMBER(12,2)` | YES | Tax amount charged on the order. Range: 22.50 to 95.00 | Source | HIGH |
| 9 | `SRC_SYS_CD` | Source System Code | `VARCHAR` | YES | Identifier for the originating system. Values: "OMS", "WEB" | Source | HIGH |
| 10 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was loaded into the Bronze layer. E.g.: 2026-07-12 10:35:17 | Audit | HIGH |
