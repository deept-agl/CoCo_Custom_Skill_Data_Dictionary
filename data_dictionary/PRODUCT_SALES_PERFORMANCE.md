# Data Dictionary: `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.GOLD.PRODUCT_SALES_PERFORMANCE` |
| Object Type | `VIEW` |
| Business Purpose | Product-level sales view combining item-level sales with order status and order date. |
| Row Grain | One row per product |
| Primary or Natural Key | `PRODUCT_ID` |
| Refresh Method | `DYNAMIC` (View - computed on query) |
| Upstream Sources | `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS`, `RETAIL_DB.SILVER.SILVER_ORDERS` |
| Downstream Objects | Analytics and reporting consumers |
| Sensitivity | Low (aggregated metrics only) |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This Gold-layer view provides product-level sales performance metrics. It joins order items with order headers to filter out cancelled orders and aggregates quantity sold, gross/net sales, discount amounts, and order counts per product. As a view, it always reflects the current state of the underlying Silver tables.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS` | `JOIN / AGGREGATION` | Product attributes and item-level amounts |
| `RETAIL_DB.SILVER.SILVER_ORDERS` | `JOIN` | Order status filtering and ORDER_DATE for recency |

### Population Logic

```sql
CREATE OR REPLACE VIEW PRODUCT_SALES_PERFORMANCE AS
SELECT
    I.PRODUCT_ID,
    I.PRODUCT_NAME,
    I.PRODUCT_CATEGORY_CODE,
    COUNT(DISTINCT I.ORDER_ID)       AS ORDER_COUNT,
    SUM(I.ORDERED_QUANTITY)          AS TOTAL_QUANTITY_SOLD,
    SUM(I.GROSS_ITEM_AMOUNT)         AS GROSS_PRODUCT_SALES_AMOUNT,
    SUM(I.ITEM_DISCOUNT_AMOUNT)      AS PRODUCT_DISCOUNT_AMOUNT,
    SUM(I.NET_ITEM_AMOUNT)           AS NET_PRODUCT_SALES_AMOUNT,
    MAX(O.ORDER_DATE)                AS MOST_RECENT_SALE_DATE
FROM RETAIL_DB.SILVER.SILVER_ORDER_ITEMS I
JOIN RETAIL_DB.SILVER.SILVER_ORDERS O ON I.ORDER_ID = O.ORDER_ID
WHERE O.ORDER_STATUS_CODE <> 'CAN'
GROUP BY I.PRODUCT_ID, I.PRODUCT_NAME, I.PRODUCT_CATEGORY_CODE;
```

### Known Filters and Business Rules

- Cancelled orders (ORDER_STATUS_CODE = 'CAN') are excluded via JOIN + WHERE
- Products only appear if they have at least one non-cancelled order
- INNER JOIN means items without a matching order are excluded

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `PRODUCT_ID` | Product Identifier | `NUMBER(38,0)` | YES | Unique product identifier from Silver order items. E.g.: 301, 304, 305 | Source | HIGH |
| 2 | `PRODUCT_NAME` | Product Name | `VARCHAR` | YES | Cleaned product name from Silver order items. E.g.: "Wireless Mouse", "Bluetooth Speaker", "Desk Lamp" | Source | HIGH |
| 3 | `PRODUCT_CATEGORY_CODE` | Product Category Code | `VARCHAR` | YES | Product category. Values: "ELEC" (Electronics), "HOME" (Home), "STAT" (Stationery) | Source | HIGH |
| 4 | `ORDER_COUNT` | Order Count | `NUMBER(18,0)` | YES | Number of distinct non-cancelled orders containing this product. Calculated as `COUNT(DISTINCT I.ORDER_ID)`. E.g.: 1, 2 | Aggregated | HIGH |
| 5 | `TOTAL_QUANTITY_SOLD` | Total Quantity Sold | `NUMBER(38,0)` | YES | Total units of this product sold across non-cancelled orders. Calculated as `SUM(I.ORDERED_QUANTITY)`. E.g.: 1, 2, 3 | Aggregated | HIGH |
| 6 | `GROSS_PRODUCT_SALES_AMOUNT` | Gross Product Sales Amount | `NUMBER(38,2)` | YES | Total gross item amount for this product. Calculated as `SUM(I.GROSS_ITEM_AMOUNT)`. E.g.: 450.00, 1000.00, 2100.00 | Aggregated | HIGH |
| 7 | `PRODUCT_DISCOUNT_AMOUNT` | Product Discount Amount | `NUMBER(24,2)` | YES | Total item-level discounts for this product. Calculated as `SUM(I.ITEM_DISCOUNT_AMOUNT)`. E.g.: 0.00, 50.00, 200.00 | Aggregated | HIGH |
| 8 | `NET_PRODUCT_SALES_AMOUNT` | Net Product Sales Amount | `NUMBER(38,2)` | YES | Total net item amount for this product after discounts. Calculated as `SUM(I.NET_ITEM_AMOUNT)`. E.g.: 450.00, 950.00, 1900.00 | Aggregated | HIGH |
| 9 | `MOST_RECENT_SALE_DATE` | Most Recent Sale Date | `DATE` | YES | Date of the most recent non-cancelled order containing this product. Calculated as `MAX(O.ORDER_DATE)`. E.g.: 2026-07-01, 2026-07-04, 2026-07-05 | Aggregated | HIGH |
