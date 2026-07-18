# Data Dictionary: `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE` |
| Object Type | `VIEW` |
| Business Purpose | Product-level sales performance metrics excluding cancelled orders |
| Row Grain | One row per product (PRODUCT_ID + PRODUCT_NAME + PRODUCT_CATEGORY_CODE) |
| Primary or Natural Key | `PRODUCT_ID` |
| Refresh Method | `DYNAMIC` (view, recomputed on each query) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS`, `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Product-level aggregated sales metrics combining order item financial data with order header status and date information. Provides total orders, quantities, gross sales, discounts, net sales, and last sale date per product. Only non-cancelled orders are included. This view is intended for product performance reporting and category analysis dashboards.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS` | `DIRECT` | Provides product details and line-item financial amounts (gross, discount, net) and quantities |
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `JOIN` | Provides order status for filtering and order date for recency calculation |

### Population Logic

```sql
SELECT
    I.PRODUCT_ID,
    I.PRODUCT_NAME,
    I.PRODUCT_CATEGORY_CODE,
    COUNT(DISTINCT I.ORDER_ID)        AS ORDER_COUNT,
    SUM(I.ORDERED_QUANTITY)           AS TOTAL_QUANTITY_SOLD,
    SUM(I.GROSS_ITEM_AMOUNT)          AS GROSS_PRODUCT_SALES_AMOUNT,
    SUM(I.ITEM_DISCOUNT_AMOUNT)       AS PRODUCT_DISCOUNT_AMOUNT,
    SUM(I.NET_ITEM_AMOUNT)            AS NET_PRODUCT_SALES_AMOUNT,
    MAX(O.ORDER_DATE)                 AS MOST_RECENT_SALE_DATE
FROM RETAIL_DB.SILVER.SILVER_ORDER_ITEMS I
JOIN RETAIL_DB.SILVER.SILVER_ORDERS O
    ON I.ORDER_ID = O.ORDER_ID
WHERE O.ORDER_STATUS_CODE <> 'CAN'
GROUP BY I.PRODUCT_ID, I.PRODUCT_NAME, I.PRODUCT_CATEGORY_CODE;
```

### Known Filters and Business Rules

- Cancelled orders (ORDER_STATUS_CODE = 'CAN') are excluded via INNER JOIN with WHERE filter
- Grouping is by PRODUCT_ID, PRODUCT_NAME, and PRODUCT_CATEGORY_CODE
- Products that only appear on cancelled orders will not appear in this view

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `PRODUCT_ID` | Product Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for a product. Sourced from SILVER_ORDER_ITEMS.PRODUCT_ID. E.g.: 301, 302, 304, 305, 306, 307 | `SOURCE` | HIGH |
| 2 | `PRODUCT_NAME` | Product Name | `TEXT` | YES | Descriptive name of the product. Sourced from SILVER_ORDER_ITEMS.PRODUCT_NAME. E.g.: "Wireless Mouse", "Mouse Pad", "Bluetooth Speaker", "Desk Lamp", "Water Bottle" | `SOURCE` | HIGH |
| 3 | `PRODUCT_CATEGORY_CODE` | Product Category Code | `TEXT` | YES | Short code representing the product category. Sourced from SILVER_ORDER_ITEMS.PRODUCT_CATEGORY_CODE. Values: "ELEC" (Electronics), "HOME" (Home & Kitchen), "STAT" (Stationery) | `SOURCE` | HIGH |
| 4 | `ORDER_COUNT` | Order Count | `NUMBER(18,0)` | YES | Count of distinct non-cancelled orders containing this product. Aggregated as `COUNT(DISTINCT I.ORDER_ID)`. Excludes orders WHERE ORDER_STATUS_CODE = 'CAN'. Range: 1 to 1 | `AGGREGATED` | HIGH |
| 5 | `TOTAL_QUANTITY_SOLD` | Total Quantity Sold | `NUMBER(38,0)` | YES | Sum of ordered quantities across all non-cancelled orders. Aggregated as `SUM(I.ORDERED_QUANTITY)`. Range: 1 to 3 | `AGGREGATED` | HIGH |
| 6 | `GROSS_PRODUCT_SALES_AMOUNT` | Gross Product Sales Amount | `NUMBER(38,2)` | YES | Total gross sales amount before discounts. Aggregated as `SUM(I.GROSS_ITEM_AMOUNT)`. Excludes cancelled orders. Range: 200.00 to 2100.00 | `AGGREGATED` | HIGH |
| 7 | `PRODUCT_DISCOUNT_AMOUNT` | Product Discount Amount | `NUMBER(24,2)` | YES | Total discount amount applied to this product. Aggregated as `SUM(I.ITEM_DISCOUNT_AMOUNT)`. Excludes cancelled orders. Range: 0.00 to 200.00 | `AGGREGATED` | HIGH |
| 8 | `NET_PRODUCT_SALES_AMOUNT` | Net Product Sales Amount | `NUMBER(38,2)` | YES | Total net sales after discounts. Aggregated as `SUM(I.NET_ITEM_AMOUNT)`. Excludes cancelled orders. Range: 150.00 to 1900.00 | `AGGREGATED` | HIGH |
| 9 | `MOST_RECENT_SALE_DATE` | Most Recent Sale Date | `DATE` | YES | Date of the most recent non-cancelled order containing this product. Aggregated as `MAX(O.ORDER_DATE)`. Range: 2026-07-01 to 2026-07-06 | `AGGREGATED` | HIGH |

---
