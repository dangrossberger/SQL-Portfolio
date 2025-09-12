# Department Month-over-Month Spend (SQLite)

**Author:** Dan Grossberger  
**Dataset:** `requests`, `line_items`  
**Context:** SQL mini-project (Part B) — demonstrate window functions and safe math.

---

## Goal
Create a department × month spend table and compute month-over-month metrics to support trend tracking and budgeting.

## Grain
One row per (department, month).

## Inputs
- `requests(request_id, department, request_date, …)`
- `line_items(request_id, qty, unit_price, line_total, …)`

## Method (CTE pipeline)
- **lt (line_totals)**  
  Compute reliable line amounts with `COALESCE(line_total, qty*unit_price)`.  
  *Why:* fallback ensures completeness when `line_total` is missing.

- **dept_month**  
  Aggregate spend per (department, YYYY-MM) using `strftime('%Y-%m', request_date)` and `SUM(line_tot)`.  
  *Why:* buckets into reporting periods.

- **dept_mom**  
  Add `prev_spend` with  
  `LAG(dept_spend) OVER (PARTITION BY department ORDER BY month)`.  
  *Why:* compare each month to the prior month in the same department.

- **Final SELECT**  
  Compute deltas:  
  - `spend_diff = dept_spend - prev_spend`  
  - `pct_change = (dept_spend - prev_spend) * 1.0 / NULLIF(prev_spend, 0)`  
  *Why:* `NULLIF` prevents divide-by-zero.

## Final Columns
- `department`  
- `month` (YYYY-MM)  
- `dept_spend`  
- `prev_spend`  
- `spend_diff`  
- `pct_change`

## Query Techniques
- CTE pipeline (`WITH`)  
- Aggregation with `SUM + GROUP BY`  
- Date bucketing with `strftime('%Y-%m')`  
- Window functions: `LAG()`  
- Safe math with `NULLIF`

## Quality Checks
- **Parity check:** `SUM(dept_spend)` ≈ total line item spend.  
  *Why:* validates aggregation.  
- **Null/negative screen:** `prev_spend` should only be NULL on the first month per department; flag negative spends.  
  *Why:* ensures data integrity.

## Files
- `part_b_dept_mom.sql` — query script  
- `dept_mom.csv` — exported results  
- `README.md` — this explainer

## How to Run (sqlite3)
```sql
.headers on
.mode csv
.once dept_mom.csv
.read part_b_dept_mom.sql
