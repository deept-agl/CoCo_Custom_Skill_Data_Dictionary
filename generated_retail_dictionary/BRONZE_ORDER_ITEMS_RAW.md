# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw order-item records containing product, quantity, price, and discount details |
| Row Grain | One row per order line item |
| Primary or Natural Key | `ORD_ITEM_ID` |
| Refresh Method | `BATCH` (ingestion from external source systems) |
| Upstream Sources | External source systems (same as orders) |
| Sensitivity | `LOW` |
| Documentation Confidence | `HIGH` |
| Generated On | `2026-07-18` |
| Review Status | `Pending Review` |

---

## 2. Business Description

Raw order line-item data containing the product details, quantities, unit prices, and item-level discounts for each item within an order. This is the Bronze landing table for order items before derivation of gross and net item amounts in the Silver layer.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External Source Systems | `DIRECT` | Ingested from the same OMS/WEB systems as BRONZE_ORDERS_RAW |

### Population Logic

```sql
-- Direct ingestion from source systems; no transformation applied
```

### Known Filters and Business Rules

- No filters or transformations applied at this layer
- GROSS_ITEM_AMOUNT is not pre-calculated here; it is derived in the Silver layer as QTY * UNIT_PRC

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORD_ITEM_ID` | Order Item Identifier | `NUMBER(38,0)` | YES | Unique numeric identifier for the order line item. E.g.: 9001, 9002, 9003, 9004, 9005 | `SOURCE` | HIGH |
| 2 | `ORD_ID` | Order Identifier | `NUMBER(38,0)` | YES | Foreign key referencing the parent order. Joins to BRONZE_ORDERS_RAW.ORD_ID. E.g.: 5001, 5002, 5003, 5004 | `SOURCE` | HIGH |
| 3 | `PROD_ID` | Product Identifier | `NUMBER(38,0)` | YES | Numeric identifier for the product purchased. E.g.: 301, 302, 303, 304, 305 | `SOURCE` | HIGH |
| 4 | `PROD_NM` | Product Name | `VARCHAR` | YES | Name of the product as recorded in the source system. E.g.: "Wireless Mouse", "Mouse Pad", "Coffee Mug", "Notebook Set", "Bluetooth Speaker" | `SOURCE` | HIGH |
| 5 | `PROD_CAT_CD` | Product Category Code | `VARCHAR` | YES | Short code representing the product category. Values: "ELEC" (Electronics), "HOME" (Home & Kitchen), "STAT" (Stationery) | `SOURCE` | HIGH |
| 6 | `QTY` | Quantity | `NUMBER(38,0)` | YES | Number of units ordered for this line item. Range: 1 to 3. E.g.: 2, 1, 3 | `SOURCE` | HIGH |
| 7 | `UNIT_PRC` | Unit Price | `NUMBER(12,2)` | YES | Price per unit of the product. Range: 150.00 to 2100.00. E.g.: 500.00, 200.00, 425.00 | `SOURCE` | HIGH |
| 8 | `ITEM_DISC_AMT` | Item Discount Amount | `NUMBER(12,2)` | YES | Discount applied to this line item. Range: 0.00 to 200.00. E.g.: 50.00, 0.00, 200.00 | `SOURCE` | HIGH |
| 9 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was ingested into Snowflake. E.g.: 2026-07-18 01:49:58.541 | `AUDIT` | HIGH |

---
