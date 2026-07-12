# Data Dictionary: `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.CUSTOMER_ORDER_SUMMARY` |
| Object Type | `TABLE` |
| Business Purpose | Customer-level order performance summary derived from Silver customer and order tables. |
| Row Grain | One row per customer |
| Primary or Natural Key | `CUSTOMER_ID` |
| Refresh Method | `BATCH` (CTAS from Silver) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_CUSTOMERS`, `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Downstream Objects | Analytics and reporting consumers |
| Sensitivity | Low (aggregated metrics, no PII beyond name/city) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This Gold-layer table provides a customer-level performance summary combining customer attributes with aggregated order metrics. It includes order counts by status, total revenue (excluding cancelled orders), average order value, recency metrics, and a customer segmentation code based on order count and revenue thresholds.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_CUSTOMERS` | `JOIN` | Customer attributes (name, city, state, signup date) |
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `LEFT JOIN / AGGREGATION` | Order metrics aggregated per customer |

### Population Logic

```sql
CREATE OR REPLACE TABLE CUSTOMER_ORDER_SUMMARY AS
SELECT
    C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY_NAME, C.STATE_CODE, C.SIGNUP_DATE,
    COUNT(O.ORDER_ID) AS TOTAL_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'DLV') AS DELIVERED_ORDER_COUNT,
    COUNT_IF(O.ORDER_STATUS_CODE = 'CAN') AS CANCELLED_ORDER_COUNT,
    COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0) AS TOTAL_REVENUE_AMOUNT,
    COALESCE(AVG(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, NULL)), 0) AS AVERAGE_ORDER_VALUE,
    MAX(O.ORDER_DATE) AS MOST_RECENT_ORDER_DATE,
    DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE()) AS DAYS_SINCE_LAST_ORDER,
    IFF(COUNT(O.ORDER_ID) >= 2 AND COALESCE(SUM(IFF(O.ORDER_STATUS_CODE <> 'CAN', O.NET_ORDER_AMOUNT, 0)), 0) >= 1000, 'HIGH_VALUE', 'STANDARD') AS CUSTOMER_SEGMENT_CODE
FROM RETAIL_DB.SILVER.SILVER_CUSTOMERS C
LEFT JOIN RETAIL_DB.SILVER.SILVER_ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.CUSTOMER_NAME, C.CITY_NAME, C.STATE_CODE, C.SIGNUP_DATE;
```

### Known Filters and Business Rules

- Cancelled orders (CAN) are excluded from revenue and average calculations
- LEFT JOIN ensures customers with no orders still appear (counts = 0)
- HIGH_VALUE segment: >= 2 orders AND >= 1000 total revenue
- DAYS_SINCE_LAST_ORDER recalculated on each refresh (dynamic based on CURRENT_DATE)

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `CUSTOMER_ID` | Customer Identifier | `NUMBER(38,0)` | YES | Unique customer identifier from Silver customers. E.g.: 101, 102, 103 | Source | HIGH |
| 2 | `CUSTOMER_NAME` | Customer Name | `VARCHAR` | YES | Full customer name from Silver customers. E.g.: "Aarav Mehta", "Meera Shah" | Source | HIGH |
| 3 | `CITY_NAME` | City Name | `VARCHAR` | YES | Customer city from Silver customers. E.g.: "Gurugram", "Mumbai", "Delhi" | Source | HIGH |
| 4 | `STATE_CODE` | State Code | `VARCHAR` | YES | Two-letter state code from Silver customers. E.g.: "HR", "MH", "DL" | Source | HIGH |
| 5 | `SIGNUP_DATE` | Signup Date | `DATE` | YES | Customer registration date. E.g.: 2025-01-15, 2025-02-10 | Source | HIGH |
| 6 | `TOTAL_ORDER_COUNT` | Total Order Count | `NUMBER(18,0)` | YES | Total number of orders placed by the customer (all statuses). Calculated as `COUNT(O.ORDER_ID)`. E.g.: 1, 2 | Aggregated | HIGH |
| 7 | `DELIVERED_ORDER_COUNT` | Delivered Order Count | `NUMBER(13,0)` | YES | Count of orders with status 'DLV'. Calculated as `COUNT_IF(O.ORDER_STATUS_CODE = 'DLV')`. E.g.: 0, 1, 2 | Aggregated | HIGH |
| 8 | `CANCELLED_ORDER_COUNT` | Cancelled Order Count | `NUMBER(13,0)` | YES | Count of orders with status 'CAN'. Calculated as `COUNT_IF(O.ORDER_STATUS_CODE = 'CAN')`. E.g.: 0, 1 | Aggregated | HIGH |
| 9 | `TOTAL_REVENUE_AMOUNT` | Total Revenue Amount | `NUMBER(26,2)` | YES | Sum of NET_ORDER_AMOUNT excluding cancelled orders. Calculated as `COALESCE(SUM(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, 0)), 0)`. Range: 0.00 to 1995.00 | Aggregated | HIGH |
| 10 | `AVERAGE_ORDER_VALUE` | Average Order Value | `NUMBER(32,8)` | YES | Average NET_ORDER_AMOUNT for non-cancelled orders. Calculated as `COALESCE(AVG(IFF(ORDER_STATUS_CODE <> 'CAN', NET_ORDER_AMOUNT, NULL)), 0)`. E.g.: 714.00, 813.75, 1522.50 | Aggregated | HIGH |
| 11 | `MOST_RECENT_ORDER_DATE` | Most Recent Order Date | `DATE` | YES | Date of the customer's latest order. Calculated as `MAX(O.ORDER_DATE)`. E.g.: 2026-07-03, 2026-07-06 | Aggregated | HIGH |
| 12 | `DAYS_SINCE_LAST_ORDER` | Days Since Last Order | `NUMBER(9,0)` | YES | Days between last order and current date. Calculated as `DATEDIFF('DAY', MAX(O.ORDER_DATE), CURRENT_DATE())`. Dynamic value. E.g.: 6, 7, 8 | Derived | HIGH |
| 13 | `CUSTOMER_SEGMENT_CODE` | Customer Segment Code | `VARCHAR(10)` | YES | Segmentation based on order count and revenue. HIGH_VALUE if >= 2 orders AND >= 1000 revenue; otherwise STANDARD. Values: "HIGH_VALUE", "STANDARD" | Derived | HIGH |
