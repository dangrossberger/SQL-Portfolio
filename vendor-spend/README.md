# Part A — Vendor Spend (SQLite)

**Author:** Dan Grossberger  
**Dataset:** Self-created procurement tables (`vendors`, `requests`, `line_items`)  
**Context:** Weekend SQL mini-project A (procurement reporting)

---

## Goal
Produce a clean SQL pipeline to calculate vendor spend, label vendor tiers, and export top vendors.  
This shows core analyst skills: grouping, CASE labels, COALESCE, QC checks, and export from the SQLite shell.

## Grain
One row per vendor.

## Inputs
- `line_items(request_id, qty, unit_price, line_total, …)`
- `requests(request_id, …)`
- `vendors(vendor_id, vendor_name, mbe_edge_flag, …)`

## Method (CTE pipeline)
- **lt (line_totals)**  
  Pick reliable line amounts with `COALESCE(line_total, qty*unit_price)`.  
  *Why:* `line_total` may include overrides/discounts; fallback ensures completeness.

- **vt (vendor_totals)**  
  Aggregate spend per vendor via `SUM(line_tot)` grouped by `vendor_id`.  
  *Why:* collapses line-level noise to vendor-level spend.

- **Final SELECT**  
  Join to vendors table, then add labels:  
  - CASE for spend tier (VIP / Gold / Silver / Bronze).  
  - CASE for diversity flag (MBE/EDGE vs Standard).  
  Round `vendor_spend` to 2 decimals for presentation.

## Final Columns
- `vendor_id`  
- `vendor_name`  
- `vendor_spend` (rounded, 2 decimals)  
- `spend_tier`  
- `diversity_flag`

## Query Techniques Used
- WITH (CTEs) for clarity  
- SELECT + JOIN + GROUP BY for aggregation  
- CASE for business labels  
- COALESCE for missing data (ensures fallback values)  
- ROUND for presentation formatting

## Quality Checks
- **Parity:** `SUM(vendor_spend)` ≈ total line item spend.  
- **Join integrity:** every `vendor_id` resolves to a `vendor_name`.

## Files
- `part_a_vendor_spend.sql` — SQL script  
- `top_vendors.csv` — exported results  
- `README.md` — this explainer

## How to Run (sqlite3)
```sql
.headers on
.mode csv
.once top_vendors.csv
.read part_a_vendor_spend.sql
