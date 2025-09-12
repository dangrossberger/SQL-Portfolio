-- Part A: Top Vendors by Spend (SQLite)
-- Author: Dan Grossberger
-- Purpose: Compute vendor spend, apply business labels, and export Top 10.
-- Grain: One row per vendor
-- Inputs: vendors(vendor_id, vendor_name, mbe_edge_flag), requests(request_id, vendor_id, ...), line_items(request_id, qty, unit_price, line_total)

-- 0) CLI export helpers (uncomment when exporting)
--.headers on
--.mode csv
--.once top_vendors.csv

-- QC notes:
-- - Parity: SUM(vendor_spend) ≈ SUM(COALESCE(line_total, qty*unit_price)) from line_items
-- - Join integrity: every vendor_id resolves to vendor_name


WITH
-- 1) Line totals: prefer provided line_total; fallback to qty * unit_price
lt AS (
SELECT
request_id,
COALESCE(line_total, qty * unit_price) AS line_tot
FROM line_items
),


-- 2) Vendor totals
vt AS (
SELECT
r.vendor_id,
SUM(lt.line_tot) AS vendor_spend
FROM lt
JOIN requests r
ON r.request_id = lt.request_id
GROUP BY r.vendor_id
)


-- 3) Final projection: labels + presentation
SELECT
vt.vendor_id,
v.vendor_name,
ROUND(vt.vendor_spend, 2) AS vendor_spend,
CASE
WHEN vt.vendor_spend >= 50000 THEN 'VIP'
WHEN vt.vendor_spend >= 40000 THEN 'Gold'
WHEN vt.vendor_spend >= 25000 THEN 'Silver'
ELSE 'Bronze'
END AS spend_tier,
CASE
WHEN v.mbe_edge_flag = 1 THEN 'MBE/EDGE'
ELSE 'Standard'
END AS diversity_flag
FROM vt
JOIN vendors v
ON v.vendor_id = vt.vendor_id
ORDER BY vendor_spend DESC
LIMIT 10;


-- QC: Parity vs line totals
-- WITH lt AS (...), vt AS (...)
-- SELECT (
-- SELECT SUM(vendor_spend) FROM vt
-- ) AS total_by_vendor,
-- (
-- SELECT SUM(COALESCE(line_total, qty * unit_price)) FROM line_items
-- ) AS total_by_lines,
-- (
-- SELECT SUM(vendor_spend) FROM vt
-- ) - (
-- ) AS diff;
