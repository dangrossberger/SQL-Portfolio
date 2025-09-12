-- Part B.1: Top-3 Vendors per Department (SQLite)
-- Author: Dan Grossberger
-- Purpose: Rank vendors by spend within each department and keep top 3.
-- Grain: One row per (department, vendor) in the base rollup; final output = top 3 per department
-- Inputs: requests(request_id, department, vendor_id, ...),
--         line_items(request_id, qty, unit_price, line_total, ...),
--         vendors(vendor_id, vendor_name, mbe_edge_flag)

-- 0) CLI export helpers (uncomment when exporting)
-- .headers on
-- .mode csv
-- .once dept_top3.csv

WITH
-- 1) Line totals (reliable amount per line)
lt AS (
  SELECT
    request_id,
    COALESCE(line_total, qty * unit_price) AS line_tot
  FROM line_items
),

-- 2) Dept × Vendor rollup
dept_vendor AS (
  SELECT
    r.department,
    r.vendor_id,
    SUM(lt.line_tot) AS vendor_spend
  FROM lt
  JOIN requests r
    ON r.request_id = lt.request_id
  GROUP BY r.department, r.vendor_id
),

-- 3) Rank vendors within each department
ranked_vendor AS (
  SELECT
    department,
    vendor_id,
    vendor_spend,
    ROW_NUMBER() OVER (
      PARTITION BY department
      ORDER BY vendor_spend DESC
    ) AS dept_rank,
    vendor_spend * 1.0
      / NULLIF(SUM(vendor_spend) OVER (PARTITION BY department), 0) AS pct_of_dept
  FROM dept_vendor
)

-- 4) Final projection (Top 3 per dept)
SELECT
  rv.department,
  rv.vendor_id,
  v.vendor_name,
  ROUND(rv.vendor_spend, 2) AS vendor_spend,
  rv.dept_rank,
  ROUND(rv.pct_of_dept, 4) AS pct_of_dept
FROM ranked_vendor rv
LEFT JOIN vendors v
  ON v.vendor_id = rv.vendor_id
WHERE rv.dept_rank <= 3
ORDER BY rv.department, rv.dept_rank;
-- QC 1: each department has <= 3 rows
-- SELECT department, COUNT(*) AS cnt FROM (
--   SELECT department, ROW_NUMBER() OVER (PARTITION BY department ORDER BY vendor_spend DESC) AS r
--   FROM dept_vendor
-- ) t
-- WHERE r <= 3
-- GROUP BY department
-- ORDER BY department;

-- QC 2: sanity — Top-3 share ≤ 1 per dept
-- WITH top3 AS (
--   SELECT department, vendor_spend,
--          ROW_NUMBER() OVER (PARTITION BY department ORDER BY vendor_spend DESC) AS rnk
--   FROM dept_vendor
-- )
-- SELECT department,
--        SUM(vendor_spend) * 1.0
--        / NULLIF(SUM(vendor_spend) OVER (PARTITION BY department), 0) AS share_top3
-- FROM top3
-- WHERE rnk <= 3
-- GROUP BY department
-- ORDER BY department;
