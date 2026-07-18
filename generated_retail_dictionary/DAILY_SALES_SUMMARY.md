# Data Dictionary: `RETAIL_DB.GOLD.DAILY_SALES_SUMMARY`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.DAILY_SALES_SUMMARY` |
| Object Type | `TABLE` |
| Business Purpose | Daily sales summary excluding cancelled orders and aggregating revenue and order metrics |
| Row Grain | One row per order date |
| Primary or Natural Key | `ORDER_DATE` |
| Refresh Method | `BATCH` (CTAS from Silver layer) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Daily-level aggregated sales metrics derived from the Silver orders table. Provides daily order counts, unique customer counts, and financial summaries (gross, discount, tax, net, average). Only non-cancelled orders are included — this is the go-to table for daily revenue reporting dashboards.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `DIRECT` | All metrics aggregated from this table after filtering out cancelled orders |

### Population Logic

```sql
SELECT
    ORDER_DATE,
    COUNT(DISTINCT ORDER_ID)     AS TOTAL_ORDER_COUNT,
    COUNT(DISTINCT CUSTOMER_ID)  AS UNIQUE_CUSTOMER_COUNT,
    SUM(GROSS_ORDER_AMOUNT)      AS GROSS_SALES_AMOUNT,
    SUM(DISCOUNT_AMOUNT)         AS TOTAL_DISCOUNT_AMOUNT,
    SUM(TAX_AMOUNT)              AS TOTAL_TAX_AMOUNT,
    SUM(NET_ORDER_AMOUNT)        AS NET_SALES_AMOUNT,
    AVG(NET_ORDER_AMOUNT)        AS AVERAGE_ORDER_VALUE
FROM RETAIL_DB.SILVER.SILVER_ORDERS
WHERE ORDER_STATUS_CODE <> 'CAN'
GROUP BY ORDER_DATE;
```

### Known Filters and Business Rules

- Cancelled orders (ORDER_STATUS_CODE = 'CAN') are excluded from all aggregations
- One row per calendar date that has at least one non-cancelled order

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_DATE` | Order Date | `DATE` | YES | Calendar date of the orders. Natural key for this daily summary. Excludes dates with only cancelled orders. E.g.: 2026-07-01, 2026-07-03, 2026-07-04, 2026-07-05, 2026-07-06 | `SOURCE` | HIGH |
| 2 | `TOTAL_ORDER_COUNT` | Total Order Count | `NUMBER(18,0)` | YES | Count of distinct non-cancelled orders on this date. Aggregated as `COUNT(DISTINCT ORDER_ID)`. Excludes orders WHERE ORDER_STATUS_CODE = 'CAN'. Range: 1 to 1 | `AGGREGATED` | HIGH |
| 3 | `UNIQUE_CUSTOMER_COUNT` | Unique Customer Count | `NUMBER(18,0)` | YES | Count of distinct customers who placed non-cancelled orders on this date. Aggregated as `COUNT(DISTINCT CUSTOMER_ID)`. Range: 1 to 1 | `AGGREGATED` | HIGH |
| 4 | `GROSS_SALES_AMOUNT` | Gross Sales Amount | `NUMBER(24,2)` | YES | Sum of gross order amounts for the day. Aggregated as `SUM(GROSS_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 450.00 to 2100.00 | `AGGREGATED` | HIGH |
| 5 | `TOTAL_DISCOUNT_AMOUNT` | Total Discount Amount | `NUMBER(24,2)` | YES | Sum of discount amounts for the day. Aggregated as `SUM(DISCOUNT_AMOUNT)`. Excludes cancelled orders. Range: 0.00 to 200.00 | `AGGREGATED` | HIGH |
| 6 | `TOTAL_TAX_AMOUNT` | Total Tax Amount | `NUMBER(24,2)` | YES | Sum of tax amounts for the day. Aggregated as `SUM(TAX_AMOUNT)`. Excludes cancelled orders. Range: 22.50 to 95.00 | `AGGREGATED` | HIGH |
| 7 | `NET_SALES_AMOUNT` | Net Sales Amount | `NUMBER(26,2)` | YES | Sum of net order amounts for the day. Aggregated as `SUM(NET_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 472.50 to 1995.00 | `AGGREGATED` | HIGH |
| 8 | `AVERAGE_ORDER_VALUE` | Average Order Value | `NUMBER(32,8)` | YES | Average net order amount per order for the day. Aggregated as `AVG(NET_ORDER_AMOUNT)`. Excludes cancelled orders. Range: 472.50 to 1995.00 | `AGGREGATED` | HIGH |

---
