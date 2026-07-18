# Data Dictionary: `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY` |
| Object Type | `TABLE` |
| Business Purpose | Customer-level order performance summary derived from Silver customer and order tables |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUSTOMER_ID` |
| Refresh Method | `BATCH` (CTAS from Silver layer) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_CUSTOMERS`, `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Customer-level aggregated summary combining customer demographics with order performance metrics. Includes total, delivered, and cancelled order counts, revenue totals, average order value, recency metrics, and a computed customer segment code. Revenue calculations exclude cancelled orders. This is an analytics-ready Gold table for customer dashboards and segmentation analysis.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_CUSTOMERS` | `DIRECT` | Provides customer demographics (name, city, state, signup date) |
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `JOIN` | Provides order-level data for aggregation (counts, amounts, dates) |

### Population Logic

```sql
SELECT
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    C.CITY_NAME,
    C.STATE_CODE,
    C.SIGNUP_DATE,
    COUNT(O.ORDER_ID)                                            AS TOTAL_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')                        AS DELIVERED_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')                        AS CANCELLED_ORDER_COUNT,
    COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0)
                                                                  AS TOTAL_REVENUE_AMOUNT,
    COALESCE(AVG(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, NULL)), 0)
                                                                  AS AVERAGE_ORDER_VALUE,
    MAX(O.ORDER_DATE)                                            AS MOST_RECENT_ORDER_DATE,
    DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE())            AS DAYS_SINCE_LAST_ORDER,
    IFF(COUNT(O.ORDER_ID) >= 2
        AND COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0) >= 1000,
        'HIGH_VALUE', 'STANDARD')                                AS CUSTOMER_SEGMENT_CODE
FROM RETAIL_DB.SILVER.SILVER_CUSTOMERS C
LEFT JOIN RETAIL_DB.SILVER.SILVER_ORDERS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY_NAME, C.STATE_CODE, C.SIGNUP_DATE;
```

### Known Filters and Business Rules

- LEFT JOIN ensures all customers appear even if they have no orders
- Cancelled orders (ORDER_STATUS_CODE = 'CAN') are excluded from revenue and average order value calculations
- CUSTOMER_SEGMENT_CODE = 'HIGH_VALUE' when total orders >= 2 AND total non-cancelled revenue >= 1000
- DAYS_SINCE_LAST_ORDER is dynamic and recalculated on each refresh

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique identifier for the customer. Sourced from SILVER_CUSTOMERS.CUSTOMER_ID. E.g.: 101, 102, 103, 104, 105 | `SOURCE` | HIGH |
| 2 | `CUSTOMER_NAME` | Customer Name | `VARCHAR` | YES | Full name of the customer in title case. Sourced from SILVER_CUSTOMERS.CUSTOMER_NAME. E.g.: "Aarav Mehta", "Meera Shah", "Rohan Verma" | `SOURCE` | HIGH |
| 3 | `CITY_NAME` | City Name | `VARCHAR` | YES | Customer city of residence. Sourced from SILVER_CUSTOMERS.CITY_NAME. E.g.: "Gurugram", "Mumbai", "Delhi", "Bengaluru" | `SOURCE` | HIGH |
| 4 | `STATE_CODE` | State Code | `VARCHAR` | YES | Two-letter Indian state code. Sourced from SILVER_CUSTOMERS.STATE_CODE. Values: "HR", "MH", "DL", "KA", "RJ" | `SOURCE` | HIGH |
| 5 | `SIGNUP_DATE` | Signup Date | `DATE` | YES | Date the customer first registered. Sourced from SILVER_CUSTOMERS.SIGNUP_DATE. Range: 2025-01-15 to 2025-04-12 | `SOURCE` | HIGH |
| 6 | `TOTAL_ORDER_COUNT` | Total Order Count | `NUMBER(18,0)` | YES | Total number of orders placed by the customer (all statuses). Aggregated as `COUNT(O.ORDER_ID)`. Range: 1 to 2 | `AGGREGATED` | HIGH |
| 7 | `DELIVERED_ORDER_COUNT` | Delivered Order Count | `NUMBER(13,0)` | YES | Number of orders with status 'DLV' (Delivered). Aggregated as `COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')`. Range: 0 to 2 | `AGGREGATED` | HIGH |
| 8 | `CANCELLED_ORDER_COUNT` | Cancelled Order Count | `NUMBER(13,0)` | YES | Number of orders with status 'CAN' (Cancelled). Aggregated as `COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')`. Range: 0 to 1 | `AGGREGATED` | HIGH |
| 9 | `TOTAL_REVENUE_AMOUNT` | Total Revenue Amount | `NUMBER(26,2)` | YES | Sum of NET_ORDER_AMOUNT for non-cancelled orders. Derived as `COALESCE(SUM(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, 0)), 0)`. NULLs defaulted to 0. Range: 0.00 to 1995.00 | `AGGREGATED` | HIGH |
| 10 | `AVERAGE_ORDER_VALUE` | Average Order Value | `NUMBER(32,8)` | YES | Average NET_ORDER_AMOUNT across non-cancelled orders. Derived as `COALESCE(AVG(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, NULL)), 0)`. NULLs defaulted to 0. Range: 0.00 to 1995.00 | `AGGREGATED` | HIGH |
| 11 | `MOST_RECENT_ORDER_DATE` | Most Recent Order Date | `DATE` | YES | Date of the customer's most recent order (any status). Aggregated as `MAX(O.ORDER_DATE)`. Range: 2026-07-02 to 2026-07-06 | `AGGREGATED` | HIGH |
| 12 | `DAYS_SINCE_LAST_ORDER` | Days Since Last Order | `NUMBER(9,0)` | YES | Number of days between the most recent order and today. Derived as `DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE())`. Dynamic value recalculated on each refresh. Range: 12 to 16 | `DERIVED` | HIGH |
| 13 | `CUSTOMER_SEGMENT_CODE` | Customer Segment Code | `VARCHAR(10)` | YES | Segmentation label based on order count and revenue. Derived as `IFF(COUNT >= 2 AND revenue >= 1000, 'HIGH_VALUE', 'STANDARD')`. Values: "HIGH_VALUE", "STANDARD" | `DERIVED` | HIGH |

---
