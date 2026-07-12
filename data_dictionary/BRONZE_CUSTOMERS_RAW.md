# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw customer records ingested from source systems without business transformations. |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUST_ID` |
| Refresh Method | `BATCH` (INSERT from source) |
| Upstream Sources | External CRM and WEB source systems |
| Downstream Objects | `RETAIL_DB.SILVER.SILVER_CUSTOMERS` |
| Sensitivity | Contains PII (email, name) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table stores raw customer master records as ingested from operational source systems (CRM and WEB). No cleansing, standardization, or transformation is applied. It serves as the immutable landing zone for customer data in the Bronze layer of the medallion architecture. Downstream Silver layer transformations clean and standardize this data.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External CRM System | `DIRECT` | Primary customer source for CRM-originated records |
| External WEB System | `DIRECT` | Customer records from web registration |

### Population Logic

```sql
INSERT INTO BRONZE_CUSTOMERS_RAW
(CUST_ID, CUST_NM, EMAIL_ADDR, CITY_NM, STATE_CD, SIGNUP_DT, SRC_SYS_CD, INGEST_TS)
VALUES (...);
```

### Known Filters and Business Rules

- No deduplication applied at this layer
- NULL values allowed in EMAIL_ADDR (e.g., customer 105 has no email)
- INGEST_TS is set to CURRENT_TIMESTAMP() at load time

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUST_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for a customer, used to join to orders. E.g.: 101, 102, 103 | Source | HIGH |
| 2 | `CUST_NM` | Customer Name | `VARCHAR` | YES | Full name of the customer as captured in the source system. E.g.: "Aarav Mehta", "Meera Shah", "Kabir Singh" | Source | HIGH |
| 3 | `EMAIL_ADDR` | Email Address | `VARCHAR` | YES | Customer email address. May be NULL if not collected. E.g.: "****@example.com", NULL | Source | HIGH |
| 4 | `CITY_NM` | City Name | `VARCHAR` | YES | City of residence as recorded in the source system. E.g.: "Gurugram", "Mumbai", "Delhi" | Source | HIGH |
| 5 | `STATE_CD` | State Code | `VARCHAR` | YES | Two-letter state code of the customer's location. E.g.: "HR", "MH", "DL", "KA", "RJ" | Source | HIGH |
| 6 | `SIGNUP_DT` | Signup Date | `DATE` | YES | Date the customer first registered in the source system. Range: 2025-01-15 to 2025-04-12 | Source | HIGH |
| 7 | `SRC_SYS_CD` | Source System Code | `VARCHAR` | YES | Identifier for the originating system. Values: "CRM", "WEB" | Source | HIGH |
| 8 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was loaded into the Bronze layer. E.g.: 2026-07-12 10:35:15 | Audit | HIGH |
