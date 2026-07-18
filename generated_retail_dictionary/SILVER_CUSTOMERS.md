# Data Dictionary: `RETAIL_DB.SILVER.SILVER_CUSTOMERS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_CUSTOMERS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned customer master with standardized names and source-system attributes |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUSTOMER_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze layer) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` |
| Sensitivity | `MEDIUM` (contains email addresses) |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Cleaned and standardized customer master table derived from the Bronze layer. Names are title-cased, emails lowercased, state codes uppercased, and a calculated tenure field is added. Column names are expanded from abbreviated Bronze conventions to full business-readable names.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
SELECT
    CUST_ID                                      AS CUSTOMER_ID,
    INITCAP(TRIM(CUST_NM))                       AS CUSTOMER_NAME,
    LOWER(TRIM(EMAIL_ADDR))                      AS EMAIL_ADDRESS,
    INITCAP(TRIM(CITY_NM))                       AS CITY_NAME,
    UPPER(TRIM(STATE_CD))                        AS STATE_CODE,
    SIGNUP_DT                                    AS SIGNUP_DATE,
    DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())   AS CUSTOMER_TENURE_DAYS,
    SRC_SYS_CD                                   AS SOURCE_SYSTEM_CODE,
    INGEST_TS                                    AS RECORD_INGESTED_TIMESTAMP
FROM RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW;
```

### Known Filters and Business Rules

- No row-level filters; all Bronze records are included
- Names are standardized using INITCAP(TRIM(...))
- Email is lowercased using LOWER(TRIM(...))
- State code is uppercased using UPPER(TRIM(...))

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for a customer. Renamed from CUST_ID in Bronze. E.g.: 101, 102, 103, 104, 105 | `RENAMED` | HIGH |
| 2 | `CUSTOMER_NAME` | Customer Name | `VARCHAR` | YES | Full name of the customer, standardized to title case. Derived as `INITCAP(TRIM(CUST_NM))`. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" | `DERIVED` | HIGH |
| 3 | `EMAIL_ADDRESS` | Email Address | `VARCHAR` | YES | Customer email address, standardized to lowercase. Derived as `LOWER(TRIM(EMAIL_ADDR))`. May be NULL. E.g.: "aarav.mehta@example.com", NULL | `DERIVED` | HIGH |
| 4 | `CITY_NAME` | City Name | `VARCHAR` | YES | Customer city of residence, standardized to title case. Derived as `INITCAP(TRIM(CITY_NM))`. E.g.: "Gurugram", "Mumbai", "Delhi" | `DERIVED` | HIGH |
| 5 | `STATE_CODE` | State Code | `VARCHAR` | YES | Two-letter Indian state code, standardized to uppercase. Derived as `UPPER(TRIM(STATE_CD))`. Values: "HR", "MH", "DL", "KA", "RJ" | `DERIVED` | HIGH |
| 6 | `SIGNUP_DATE` | Signup Date | `DATE` | YES | Date when the customer first registered. Renamed from SIGNUP_DT. Range: 2025-01-15 to 2025-04-12 | `RENAMED` | HIGH |
| 7 | `CUSTOMER_TENURE_DAYS` | Customer Tenure Days | `NUMBER(9,0)` | YES | Number of days since the customer signed up, calculated dynamically. Derived as `DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())`. Dynamic value recalculated on each refresh. Range: 462 to 549 | `DERIVED` | HIGH |
| 8 | `SOURCE_SYSTEM_CODE` | Source System Code | `VARCHAR` | YES | Code identifying the originating system. Renamed from SRC_SYS_CD. Values: "CRM", "WEB" | `RENAMED` | HIGH |
| 9 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was originally ingested into the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-18 01:49:52.073 | `RENAMED` | HIGH |

---
