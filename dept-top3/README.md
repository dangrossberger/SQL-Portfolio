# Part B.1 — Top-3 Vendors per Department (SQLite)

**Author:** Dan Grossberger  
**Dataset:** Self-created procurement tables (`vendors`, `requests`, `line_items`)  
**Context:** SQL mini-project continuation — demonstrating ranking with window functions.

---

## Goal
Identify the top 3 vendors by spend within each department. This highlights ranking, partitioning, and relative contribution of vendors.

## Grain
One row per (department, vendor) in the base rollup; final result keeps the top 3 vendors per department.

## Inputs
- `line_items(request_id, qty, unit_price, line_total, …)`
- `requests(request_id, department, vendor_id, …)`
- `vendors(vendor_id, vendor_name, mbe_edge_flag, …)`

## Method (CTE pipeline)
- **lt (line_totals)** — Use `COALESCE(line_total, qty*unit_price)` for reliable line amounts.  
  *Why:* ensures fallback if `line_total` is missing.

- **dept_vendor** — Aggregate spend by (department, vendor_id).  
  *Why:* collapses line-level detail into department–vendor totals.

- **ranked_vendor** — Add `ROW_NUMBER() OVER (PARTITION BY department ORDER BY vendor_spend DESC)` and compute `pct_of_dept`.  
  *Why:* rank vendors by spend within each department and capture their share of total department spend.  
  *Note:* `ROW_NUMBER()` means ties are broken arbitrarily — only 3 vendors max are kept per department.

- **Final SELECT** — Keep rows where `dept_rank <= 3`.  
  *Why:* only top 3 per department are included.

## Final Columns
- `department`
- `vendor_id`
- `vendor_name`
- `vendor_spend`
- `dept_rank`
- `pct_of_dept` (fraction 0–1, rounded to 4 decimals)

## Query Techniques Used
- WITH (CTEs) for pipeline clarity  
- SUM + GROUP BY for aggregation  
- ROW_NUMBER() for ranking  
- Window SUM() for calcula

## How to Run (sqlite3)
```sql
.headers on
.mode csv
.once dept_top3.csv
.read part_b1_dept_top3.sql

