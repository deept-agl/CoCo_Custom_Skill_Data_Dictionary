# Data Dictionary: `RETAIL_DB.SILVER.SILVER_CUSTOMERS`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.SILVER.SILVER_CUSTOMERS` |
| Object Type | `TABLE` |
| Business Purpose | Cleaned customer master with standardized names and source-system attributes. |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUSTOMER_ID` |
| Refresh Method | `BATCH` (CTAS from Bronze) |
| Upstream Sources | `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` |
| Downstream Objects | `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY` |
| Sensitivity | Contains PII (email, name) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table is the cleaned and standardized customer dimension in the Silver layer. It applies formatting transformations (INITCAP on names, LOWER on emails, UPPER on state codes, TRIM on all text) and derives the customer tenure in days. Column names are expanded from Bronze abbreviations to full business-friendly names.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.BRONZE.BRONZE_CUSTOMERS_RAW` | `DIRECT` | All columns sourced and transformed from this table |

### Population Logic

```sql
CREATE OR REPLACE TABLE SILVER_CUSTOMERS AS
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

- Names standardized to Initial Caps via INITCAP(TRIM())
- Email addresses lowercased via LOWER(TRIM())
- State codes uppercased via UPPER(TRIM())
- CUSTOMER_TENURE_DAYS recalculated on every refresh (dynamic based on CURRENT_DATE)

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for the customer. Renamed from CUST_ID. E.g.: 101, 102, 103 | Renamed | HIGH |
| 2 | `CUSTOMER_NAME` | Customer Name | `VARCHAR` | YES | Full name of the customer, formatted as Initial Caps with trimmed whitespace. Derived as `INITCAP(TRIM(CUST_NM))`. E.g.: "Aarav Mehta", "Meera Shah" | Derived | HIGH |
| 3 | `EMAIL_ADDRESS` | Email Address | `VARCHAR` | YES | Customer email, lowercased and trimmed. May be NULL. Derived as `LOWER(TRIM(EMAIL_ADDR))`. E.g.: "****@example.com", NULL | Derived | HIGH |
| 4 | `CITY_NAME` | City Name | `VARCHAR` | YES | Customer city of residence, formatted as Initial Caps. Derived as `INITCAP(TRIM(CITY_NM))`. E.g.: "Gurugram", "Mumbai", "Delhi" | Derived | HIGH |
| 5 | `STATE_CODE` | State Code | `VARCHAR` | YES | Two-letter state code, uppercased and trimmed. Derived as `UPPER(TRIM(STATE_CD))`. E.g.: "HR", "MH", "DL" | Derived | HIGH |
| 6 | `SIGNUP_DATE` | Signup Date | `DATE` | YES | Date the customer first registered. Renamed from SIGNUP_DT. Range: 2025-01-15 to 2025-04-12 | Renamed | HIGH |
| 7 | `CUSTOMER_TENURE_DAYS` | Customer Tenure Days | `NUMBER(9,0)` | YES | Number of days since signup. Calculated as `DATEDIFF('DAY', SIGNUP_DT, CURRENT_DATE())`. Dynamic value recalculated on each refresh. E.g.: 543, 518, 494 | Derived | HIGH |
| 8 | `SOURCE_SYSTEM_CODE` | Source System Code | `VARCHAR` | YES | Originating system identifier. Renamed from SRC_SYS_CD. Values: "CRM", "WEB" | Renamed | HIGH |
| 9 | `RECORD_INGESTED_TIMESTAMP` | Record Ingested Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the source record was loaded into the Bronze layer. Renamed from INGEST_TS. E.g.: 2026-07-12 10:35:15 | Renamed | HIGH |
