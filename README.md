# Data Quality & BA Portfolio (SQL, ERDs, Requirements)

A collection of small, production-style mini-projects that show how I translate **business-style requirements → ERDs → SQL pipelines → testable deliverables**.  

Each project is built in the `sqlite3` shell and includes clear CTE pipelines, QC/test steps, and tidy artifacts (`.sql`, `.csv`, `README.md`).

---

## Projects

- **vendor-spend/** — *Part A: Top Vendors*  
  Calculate vendor spend on a procurement-style dataset (`vendors`, `requests`, `line_items`) using `JOIN` + `GROUP BY`, CTEs, and CASE tiering (Bronze → VIP).  
  Includes CSV output and SQL script.

- **dept-top3/** — *Part B.1: Top-3 Vendors per Department*  
  Identify the Top 3 vendors per department using window functions. Demonstrates `ROW_NUMBER` for strict top-3 logic.  
  Includes CSV output and SQL script.

- **dept-mom/** — *Part B: Department Month-over-Month Spend*  
  Track MoM department spend using `LAG` + `NULLIF`. Shows absolute and % deltas with QC checks for data quality.  
  Includes CSV output and SQL script.

- **ERD/** — Entity Relationship Diagrams of the schema (`vendors`, `requests`, `line_items`) created in diagrams.net.  
  Useful for understanding table design, keys, and relationships before diving into SQL.

- **requirements/** — Requirements documents for each project.  
  Show how business-style needs were translated into SQL deliverables and QC checks.

---

## How to Run (sqlite3)

**Part A: Vendor Spend**
```sql
.headers on
.mode csv
.once top_vendors.csv
.read part_a_vendor_spend.sql
