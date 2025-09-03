# Vendor Spend - SQL Mini-Project (SQLite)

Dataset: vendors, requests, line_items
Goal: Demonstrate a clean SQL pipeline for vendor-level spend on a realistic procurement shape.

## What I built
- Reliable line amounts via COALESCE(line_total, qty*unit_price)
- Roll-up with CTEs: line_totals -> vendor_totals
- Business labeling with CASE tiers: VIP (>= 50k) / Gold (>= 40k) / Silver (>= 25k) / Bronze
- Diversity flag from vendors.mbe_edge_flag -> 'MBE/EDGE' vs 'Standard'
- CSV export directly from the sqlite shell using .once

## Query techniques
SELECT, WHERE, JOIN, GROUP BY, ORDER BY, WITH (CTEs), CASE, COALESCE; safe rounding at presentation only.

## Quality checks
- Totals parity: sum of vendor totals approx equals grand total of line items
- Join integrity: every vendor_id in totals maps to a vendor_name

## Files in this folder
- 01_top_vendors.sql (exact query)
- top_vendors.csv (Top-10 vendors with tiers and diversity flag)
- README.md (this explainer)

## How to run (sqlite3)

```sql
.headers on
.mode csv
.once top_vendors.csv
.read 01_top_vendors.sql
```

## Next steps (tracked in repo root)
- dept-top3/: Top-3 vendors per department with ROW_NUMBER, RANK, DENSE_RANK
- dept-mom/: MoM department spend with LAG/LEAD, diff, percent change
