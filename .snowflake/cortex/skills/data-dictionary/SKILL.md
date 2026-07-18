---
name: data-dictionary
description: Generate a detailed, evidence-based data dictionary for Snowflake tables and views using metadata, SQL logic, sample values, and Snowflake AI functions.
---

# Snowflake AI Data Dictionary Generator

## Purpose

Use this skill to create a detailed data dictionary for one or more Snowflake tables or views.

The generated dictionary must explain both the business meaning and technical implementation of every column. It must interpret abbreviations, identify derivation logic, include safe sample values, and clearly separate confirmed information from AI inference.

---

## When to Use This Skill

Use this skill when the user asks to:

- Create a data dictionary
- Document Snowflake tables or views
- Explain column names or abbreviations
- Understand how derived columns are calculated
- Add sample values to column documentation
- Generate column comments
- Document a schema or data model
- Review undocumented database objects
- Standardize metadata documentation across a project

Do not use this skill merely to list column names and data types. The output must include contextual explanations.

---

## Required Inputs

Collect or determine the following:

- Database name
- Schema name
- Table or view name
- Whether to process one object, selected objects, or an entire schema
- Whether sample values are allowed
- Whether sensitive values must be masked
- Whether repository SQL files are available
- Desired output location
- Whether generated Snowflake comments are required

When some inputs are unavailable, continue with the accessible evidence and identify limitations in the output.

---

## Tools and Data Sources

Use available Snowflake SQL and local repository tools to inspect:

1. Information Schema metadata
2. Existing table and column comments
3. Table or view DDL
4. View, dynamic-table, task, procedure, dbt, ETL, and transformation SQL
5. Constraints and relationships
6. Safe sample values
7. Existing project documentation
8. Upstream and downstream object references

Prefer direct Snowflake metadata and source SQL over assumptions.

---

## Execution Workflow
Output format should be as per @Data_Dictionary_Output_Template.md file.
Sample data should be present in all column descriptions.

### Step 1: Confirm Scope

Identify the requested:

- Database
- Schema
- Objects

Do not scan unrelated databases or schemas.

### Step 2: Inspect Object Metadata

For every object, collect:

- Object type
- Table comment
- Column name
- Data type
- Length, precision, and scale
- Nullability
- Default value
- Existing column comment

### Step 3: Inspect Object Definition

Retrieve and inspect the DDL.

For views, dynamic tables, and transformed objects, analyze the defining query.

For physical tables, search project SQL, stored procedures, tasks, pipelines, dbt models, or ETL scripts that populate the table.

### Step 4: Identify Object Grain

Determine what one row represents.

Examples:

- One row per customer
- One row per order
- One row per order item
- One row per account per business date
- One row per incident status change

State the grain near the beginning of the table documentation.

### Step 5: Interpret Column Abbreviations

Expand abbreviations using all available context.

Common examples include:

| Abbreviation | Possible Meaning |
|---|---|
| ID | Identifier |
| CD | Code |
| DESC | Description |
| DT | Date |
| TS | Timestamp |
| AMT | Amount |
| QTY | Quantity |
| CNT | Count |
| NUM or NO | Number |
| FLG | Flag |
| IND | Indicator |
| PCT | Percentage |
| AVG | Average |
| MIN | Minimum or minute, depending on context |
| MAX | Maximum |
| SRC | Source |
| TGT | Target |
| SYS | System |
| EFF | Effective |
| EXP | Expiry or expense, depending on context |
| ACTV | Active |
| CUST | Customer |
| ACCT | Account |
| PROD | Product |
| ORD | Order |
| TXN | Transaction |
| BAL | Balance |
| REV | Revenue |
| CURR | Currency or current, depending on context |

Never expand an abbreviation solely from this list when table context suggests another meaning.

For ambiguous abbreviations:

- Review neighboring columns.
- Review the table name.
- Review sample values.
- Review SQL expressions.
- Review upstream column names.
- Mark confidence as low or medium when unresolved.

### Step 6: Collect Safe Sample Values

Use a small, controlled number of representative values.

Recommended maximum:

- 3 distinct values for low-cardinality columns
- Three masked examples for identifiers
- Minimum, maximum, and 2 examples for dates or timestamps
- Minimum, maximum, average, and 2 examples for numeric measures
- Distinct values for boolean or flag columns

Never expose:

- Passwords
- Access tokens
- Authentication secrets
- Private keys
- Full payment-card details
- Unmasked government identifiers
- Restricted health information
- Other highly sensitive values

Replace sensitive samples with masked patterns such as:

- `CUST_****91`
- `****@example.com`
- `XXXX-XXXX-XXXX-1234`

### Step 7: Determine Derivation Logic

Classify each column as one of:

- Source
- Renamed
- Derived
- Aggregated
- Window-derived
- Defaulted
- System-generated
- Audit
- Unknown

Extract the exact SQL expression when available.

Examples:

```text
Source:
Directly populated from RAW_ORDERS.ORDER_ID.

Renamed:
Renamed from RAW_CUSTOMER.CUST_NBR to CUSTOMER_NUMBER.

Derived:
Calculated as GROSS_AMOUNT - DISCOUNT_AMOUNT.

Aggregated:
Calculated as SUM(ORDER_AMOUNT) at customer-month grain.

Window-derived:
Calculated using ROW_NUMBER over CUSTOMER_ID ordered by EFFECTIVE_TIMESTAMP descending.

Audit:
Populated with the pipeline execution timestamp.

Unknown:
The creation logic was not found in the available SQL or metadata.
```

Do not invent a formula based only on the column name.

### Step 8: Generate AI-Assisted Descriptions

Use Snowflake `AI_COMPLETE` when execution access is available.

The prompt supplied to the AI should include:

- Database, schema, and object
- Table grain
- Column name
- Data type
- Existing comments
- Table description
- Neighboring columns
- Source columns
- SQL expression
- Sample-value summary
- Known business context

Request structured output with these fields:

```json
{
  "expanded_name": "",
  "business_description": "",
  "technical_description": "",
  "derivation_type": "",
  "derivation_logic": "",
  "sample_value_interpretation": "",
  "data_quality_notes": [],
  "sensitivity": "",
  "confidence": "",
  "reasoning_evidence": []
}
```

The final documentation must not expose internal model chain-of-thought. The `reasoning_evidence` field should contain only concise, verifiable evidence such as SQL expressions, comments, data types, and sample patterns.

### Step 9: Validate the AI Output

Validate every response against the collected evidence.

Reject or revise output when it:

- Invents an upstream source
- Invents a business rule
- Contradicts the SQL expression
- Misinterprets a sample value
- Confuses a code with a description
- Labels a derived field as directly sourced
- Exposes sensitive values
- Claims high confidence without adequate evidence

### Step 10: Assign Confidence

Use:

**High**

- Confirmed by existing comment, DDL, and source SQL
- Exact derivation expression is available
- Sample values support the interpretation

**Medium**

- Strongly supported by naming, data type, neighboring columns, and samples
- Complete source logic is not available

**Low**

- Primarily inferred from the column name
- Abbreviation is ambiguous
- Sample data or SQL logic is unavailable
- Conflicting evidence exists

### Step 11: Generate the Data Dictionary

Follow the standard template in:

```text
templates/DATA_DICTIONARY_OUTPUT_TEMPLATE.md
```

Create a separate file as <table_name> and decide file format as per the output. Better to have an excel output per table and saved under current git workspace.

Create one row per column in the summary table and a detailed subsection for each column when required.

### Step 12. Consolidated Data Dictionary (Single-File Output)

After generating individual per-table data dictionary files, also generate ONE consolidated file named `<database_name>_data_dictionary.md` that contains a single markdown table with ALL columns from ALL tables/views in the database.

### Output Format-Consolidated Data Dictionary

The file should have:
- A heading: `# <DATABASE_NAME> — Consolidated Data Dictionary`
- A single markdown table with these columns:

| Database | Schema | Table/View | Column | Data Type | Business Description |

### Ordering Rules-Consolidated Data Dictionary

- Rows should be ordered by: Schema (BRONZE → SILVER → GOLD), then Table name (alphabetical), then column ordinal position.
- This reflects the data flow through the medallion architecture.

### Data Gathering Steps

To populate the Business Description accurately:
1. Query `INFORMATION_SCHEMA.COLUMNS` for column metadata (data types, nullability, ordinal position)
2. Read any SQL files in the workspace that contain the CREATE TABLE / CREATE VIEW / INSERT logic
3. Query `GET_DDL()` for each object to capture the exact DDL
4. Run `SELECT * FROM <table> LIMIT 5` for each table to capture real sample values
5. Cross-reference column names between layers to identify renames and derivations

### Business Description Column Rules-For all files

The `Business Description` column in the consolidated file must be **rich and detailed**, following these rules:

1. **Start with a clear one-sentence explanation** of what the column represents in business terms.
2. **Include derivation logic** for any calculated/derived columns — show the SQL expression (e.g., "Calculated as `SUM(GROSS_ORDER_AMOUNT)`" or "Derived as `INITCAP(TRIM(CUST_NM))`").
3. **Include sample values** using one of these formats depending on column type:
   - For categorical/code columns: list all known values with meanings. E.g.: Values: "DLV" (Delivered), "CAN" (Cancelled), "SHP" (Shipped)
   - For numeric columns: show the range. E.g.: Range: 450.00 to 2100.00
   - For identifier/name/date columns: list representative examples. E.g.: E.g.: "Aarav Mehta", "Meera Shah"
4. **Note renamed columns** when the Silver/Gold name differs from the Bronze source. E.g.: "Renamed from ORD_ID"
5. **Note NULL handling** where COALESCE or similar logic is applied. E.g.: "NULLs defaulted to 0 via COALESCE"
6. **Note business filters** that affect this column's population. E.g.: "Excludes orders WHERE ORDER_STATUS_CODE <> 'CAN'"
7. **Note if dynamic** — if the value changes on each refresh without underlying data changing. E.g.: "Dynamic value recalculated on each refresh"
Bad description:

> Stores customer data.

Good description:

> Unique identifier assigned to a customer and used to join the order record to the customer dimension. Eg: cust***34, cust***14

Bad derivation:

> Calculated by the system.

Good derivation:

> Calculated as `GROSS_ORDER_AMOUNT - DISCOUNT_AMOUNT - REFUND_AMOUNT` in the order transformation model.

---

## Table-Level Output Requirements

For each object, include:

- Fully qualified object name
- Object type
- Business purpose
- Row grain
- Primary or natural key
- Refresh or population method, when known
- Upstream sources
- Important downstream uses, when known
- Overall documentation confidence

---

## Column-Level Output Requirements

For each column, include:

- Physical name
- Expanded name
- Data type
- Nullable status
- Business description
- Technical description
- Derivation type
- Derivation logic
- Source columns
- Sample values or masked patterns
- Confidence
---
