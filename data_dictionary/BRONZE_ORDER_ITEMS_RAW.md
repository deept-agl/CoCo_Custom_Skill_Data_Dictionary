# Data Dictionary: `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `RETAIL_DB.BRONZE.BRONZE_ORDER_ITEMS_RAW` |
| Object Type | `TABLE` |
| Business Purpose | Raw order-item records containing product, quantity, price, and discount details. |
| Row Grain | One row per order line item |
| Primary or Natural Key | `ORD_ITEM_ID` |
| Refresh Method | `BATCH` (INSERT from source) |
| Upstream Sources | External source systems (OMS/WEB) |
| Downstream Objects | `RETAIL_DB.SILVER.SILVER_ORDER_ITEMS` |
| Sensitivity | Low |
| Documentation Confidence | `HIGH` |
| Generated On | 2026-07-12 |
| Review Status | Pending Review |

---

## 2. Business Description

This table stores raw order line-item detail records. Each row represents a single product within a customer order, including the product identity, quantity ordered, unit price, and any item-level discount. No calculations (gross amount, net amount) are performed at this layer.

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| External OMS/WEB Systems | `DIRECT` | Source of order item detail |

### Population Logic

```sql
INSERT INTO BRONZE_ORDER_ITEMS_RAW
(ORD_ITEM_ID, ORD_ID, PROD_ID, PROD_NM, PROD_CAT_CD, QTY, UNIT_PRC, ITEM_DISC_AMT, INGEST_TS)
VALUES (...);
```

### Known Filters and Business Rules

- ITEM_DISC_AMT may be 0.00 (no discount on item)
- PROD_CAT_CD uses short codes: ELEC, HOME, STAT
- INGEST_TS is set to CURRENT_TIMESTAMP() at load time

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `ORD_ITEM_ID` | Order Item Identifier | `NUMBER(38,0)` | YES | Unique identifier for each line item within an order. E.g.: 9001, 9002, 9003 | Source | HIGH |
| 2 | `ORD_ID` | Order Identifier | `NUMBER(38,0)` | YES | Foreign key linking to BRONZE_ORDERS_RAW. E.g.: 5001, 5002, 5003 | Source | HIGH |
| 3 | `PROD_ID` | Product Identifier | `NUMBER(38,0)` | YES | Unique identifier for the product. E.g.: 301, 302, 303 | Source | HIGH |
| 4 | `PROD_NM` | Product Name | `VARCHAR` | YES | Descriptive name of the product. E.g.: "Wireless Mouse", "Mouse Pad", "Coffee Mug" | Source | HIGH |
| 5 | `PROD_CAT_CD` | Product Category Code | `VARCHAR` | YES | Short code representing the product category. Values: "ELEC" (Electronics), "HOME" (Home), "STAT" (Stationery) | Source | HIGH |
| 6 | `QTY` | Quantity | `NUMBER(38,0)` | YES | Number of units of the product ordered. Range: 1 to 3 | Source | HIGH |
| 7 | `UNIT_PRC` | Unit Price | `NUMBER(12,2)` | YES | Price per unit of the product. Range: 150.00 to 2100.00 | Source | HIGH |
| 8 | `ITEM_DISC_AMT` | Item Discount Amount | `NUMBER(12,2)` | YES | Discount applied at the item level. Range: 0.00 to 200.00 | Source | HIGH |
| 9 | `INGEST_TS` | Ingestion Timestamp | `TIMESTAMP_NTZ` | YES | Timestamp when the record was loaded into the Bronze layer. E.g.: 2026-07-12 10:35:18 | Audit | HIGH |
