# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw customer records ingested from source systems without business transformations |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUST_ID` |
| Refresh Method | `BATCH` (ingestion from external source systems) |
| Upstream Sources | External CRM and WEB source systems |
| Sensitivity | `MEDIUM` (contains email addresses) |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Raw customer master data ingested directly from operational source systems (CRM and WEB) without any business transformations. This is the landing table for customer records in the medallion architecture's Bronze layer. Column names use abbreviated conventions from the source systems.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External CRM System | `DIRECT` | Source of customer records with SRC_SYS_CD = 'CRM' |
| External WEB System | `DIRECT` | Source of customer records with SRC_SYS_CD = 'WEB' |

### Population Logic

```sql
-- Direct ingestion from source systems; no transformation applied
```

### Known Filters and Business Rules

- No filters or transformations applied at this layer
- Data is ingested as-is from source systems

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUST_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier assigned to a customer in the source system. Used as the natural key to join across order tables. E.g.: 101, 102, 103, 104, 105 | `SOURCE` | HIGH |
| 2 | `CUST_NM` | Customer Name | `VARCHAR` | YES | Full name of the customer as recorded in the source system. Not standardized at this layer. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" | `SOURCE` | HIGH |
| 3 | `EMAIL_ADDR` | Email Address | `VARCHAR` | YES | Customer email address from the source system. May contain NULLs for customers without registered emails. E.g.: "aarav.mehta@example.com", NULL | `SOURCE` | HIGH |
| 4 | `CITY_NM` | City Name | `VARCHAR` | YES | City of residence as reported by the customer. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru", "Jaipur" | `SOURCE` | HIGH |
| 5 | `STATE_CD` | State Code | `VARCHAR` | YES | Two-letter Indian state code. Values: "HR" (Haryana), "MH" (Maharashtra), "DL" (Delhi), "KA" (Karnataka), "RJ" (Rajasthan) | `SOURCE` | HIGH |
| 6 | `SIGNUP_DT` | Signup Date | `DATE` | YES | Date when the customer first registered in the system. Range: 2025-01-15 to 2025-04-12 | `SOURCE` | HIGH |
| 7 | `SRC_SYS_CD` | Source System Code | `VARCHAR` | YES | Code identifying the originating source system. Values: "CRM" (Customer Relationship Management), "WEB" (Web application) | `SOURCE` | HIGH |
| 8 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:52.073 | `AUDIT` | HIGH |

---
