# Data Dictionary: `RETAIL_DB.GOLD.DAILY_SALES_SUMMARY`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.DAILY_SALES_SUMMARY` |
| Object Type | `TABLE` |
| Business Purpose | Daily sales summary excluding cancelled orders and aggregating revenue and order metrics. |
| Row Grain | One row per order date |
| Primary or Natural Key | `ORDER_DATE` |
| Refresh Method | `BATCH` (CTAS from Silver) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Downstream Objects | Analytics dashboards and reporting consumers |
| Sensitivity | Low (aggregated metrics only) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This Gold-layer table provides a daily aggregate of sales metrics. Cancelled orders are excluded via a WHERE filter. It summarizes order count, unique customers, gross sales, discounts, taxes, net sales, and average order value per day. Useful for daily KPI dashboards and trend analysis.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `DIRECT / AGGREGATION` | All metrics aggregated from this table |

### Population Logic

```sql
CREATE OR REPLACE TABLE DAILY_SALES_SUMMARY AS
SELECT
    ORDER_DATE,
    COUNT(DISTINCT ORDER_ID)    AS TOTAL_ORDER_COUNT,
    COUNT(DISTINCT CUSTOMER_ID) AS UNIQUE_CUSTOMER_COUNT,
    SUM(GROSS_ORDER_AMOUNT)     AS GROSS_SALES_AMOUNT,
    SUM(DISCOUNT_AMOUNT)        AS TOTAL_DISCOUNT_AMOUNT,
    SUM(TAX_AMOUNT)             AS TOTAL_TAX_AMOUNT,
    SUM(NET_ORDER_AMOUNT)       AS NET_SALES_AMOUNT,
    AVG(NET_ORDER_AMOUNT)       AS AVERAGE_ORDER_VALUE
FROM RETAIL_DB.SILVER.SILVER_ORDERS
WHERE ORDER_STATUS_CODE <> 'CAN'
GROUP BY ORDER_DATE;
```

### Known Filters and Business Rules

- Cancelled orders (ORDER_STATUS_CODE = 'CAN') are excluded
- Only dates with at least one non-cancelled order appear
- COUNT(DISTINCT ORDER_ID) avoids double-counting

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORDER_DATE` | Order Date | `DATE` | YES | Calendar date on which orders were placed (excludes cancelled). E.g.: 2026-07-01, 2026-07-03, 2026-07-05 | Source | HIGH |
| 2 | `TOTAL_ORDER_COUNT` | Total Order Count | `NUMBER(18,0)` | YES | Number of distinct non-cancelled orders on that date. Calculated as `COUNT(DISTINCT ORDER_ID)`. E.g.: 1 | Aggregated | HIGH |
| 3 | `UNIQUE_CUSTOMER_COUNT` | Unique Customer Count | `NUMBER(18,0)` | YES | Number of distinct customers who placed non-cancelled orders on that date. Calculated as `COUNT(DISTINCT CUSTOMER_ID)`. E.g.: 1 | Aggregated | HIGH |
| 4 | `GROSS_SALES_AMOUNT` | Gross Sales Amount | `NUMBER(24,2)` | YES | Sum of gross order amounts for the date. Calculated as `SUM(GROSS_ORDER_AMOUNT)`. Range: 450.00 to 2100.00 | Aggregated | HIGH |
| 5 | `TOTAL_DISCOUNT_AMOUNT` | Total Discount Amount | `NUMBER(24,2)` | YES | Sum of discount amounts for the date. Calculated as `SUM(DISCOUNT_AMOUNT)`. Range: 0.00 to 200.00 | Aggregated | HIGH |
| 6 | `TOTAL_TAX_AMOUNT` | Total Tax Amount | `NUMBER(24,2)` | YES | Sum of tax amounts for the date. Calculated as `SUM(TAX_AMOUNT)`. Range: 22.50 to 95.00 | Aggregated | HIGH |
| 7 | `NET_SALES_AMOUNT` | Net Sales Amount | `NUMBER(26,2)` | YES | Sum of net order amounts for the date. Calculated as `SUM(NET_ORDER_AMOUNT)`. Range: 472.50 to 1995.00 | Aggregated | HIGH |
| 8 | `AVERAGE_ORDER_VALUE` | Average Order Value | `NUMBER(32,8)` | YES | Average net order amount for the date. Calculated as `AVG(NET_ORDER_AMOUNT)`. E.g.: 472.50, 1155.00, 1522.50 | Aggregated | HIGH |
