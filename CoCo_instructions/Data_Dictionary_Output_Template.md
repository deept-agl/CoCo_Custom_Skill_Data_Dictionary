# Data Dictionary: `<DATABASE>.<SCHEMA>.<OBJECT>`

## 1. Object Overview

| Attribute | Value |
|---|---|
| Fully Qualified Name | `<DATABASE>.<SCHEMA>.<OBJECT>` |
| Object Type | `<TABLE / VIEW / DYNAMIC TABLE>` |
| Business Purpose | `<PURPOSE>` |
| Row Grain | `<WHAT ONE ROW REPRESENTS>` |
| Primary or Natural Key | `<KEY_COLUMNS>` |
| Refresh Method | `<BATCH / CDC / DYNAMIC / MANUAL / UNKNOWN>` |
| Upstream Sources | `<SOURCE_OBJECTS>` |
| Sensitivity | `<CLASSIFICATION>` |
| Documentation Confidence | `<HIGH / MEDIUM / LOW>` |
| Generated On | `<TIMESTAMP>` |
| Review Status | `Pending Review` |

---

## 2. Business Description

`<DETAILED_TABLE_DESCRIPTION>`

---

## 3. Data Lineage and Population Logic

### Upstream Objects

| Source Object | Relationship | Usage |
|---|---|---|
| `<SOURCE_OBJECT>` | `<DIRECT / JOIN / LOOKUP / AGGREGATION>` | `<HOW_USED>` |

### Population Logic

```sql
<RELEVANT_SQL_OR_SUMMARIZED_TRANSFORMATION_LOGIC>
```

### Known Filters and Business Rules

- `<RULE_1>`
- `<RULE_2>`

---

## 4. Column Summary

| # | Column | Expanded Name | Data Type | Nullable | Business Description | Derivation Type | Confidence |
|---|---|---|---|---|---|---|---|
| 1 | `<COLUMN_NAME>` | `<EXPANDED_NAME>` | `<DATA_TYPE>` | `<YES/NO>` | `<DESCRIPTION along with SAMPLE_VALUES>' | `<TYPE>` | `<HIGH/MEDIUM/LOW>` |

Repeat this for all columns
---


