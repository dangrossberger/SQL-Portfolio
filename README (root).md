# SQL Portfolio (SQLite)

Small, production-style SQL mini-projects built in the sqlite3 shell. Clear pipelines, testable steps, and tidy artifacts (CSV + SQL).

## Projects

- **[vendor-spend/](vendor-spend/)** — Top Vendors on a procurement-style dataset (`vendors`, `requests`, `line_items`) using JOIN + GROUP BY, CTEs, and CASE tiering (Bronze -> VIP). Includes CSV output and the exact SQL.
- **dept-top3/** *(coming soon)* — Top-3 vendors per department using window functions (ROW_NUMBER, then RANK/DENSE_RANK to show tie behavior).
- **dept-mom/** *(coming soon)* — Month-over-month department spend with LAG/LEAD, absolute and % deltas, and a "big move" flag (safe division with NULLIF).

## How to run the vendor-spend example (sqlite3)

```sql
.headers on
.mode csv
.once top_vendors.csv
.read 01_top_vendors.sql
```

## Notes
- I layer logic with CTEs so each step is testable (counts, sums, min/max).
- I round only in the final SELECT (avoid double-rounding).
- COALESCE for fallbacks; NULLIF for division safety (used in upcoming windows work).

## License
This repository is open-source under the MIT License. See **LICENSE** for details.
