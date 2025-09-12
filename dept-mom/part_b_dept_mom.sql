-- Part B: Department Month-over-Month Spend (SQLite)
-- Author: Dan Grossberger
-- Purpose: Build a dept × month spend table with MoM metrics (prev, diff, pct_change).
-- Grain: One row per (department, month)
-- Inputs: requests(request_id, department, request_date), line_items(request_id, qty, unit_price, line_total)

-- 0) CLI export helpers (uncomment when exporting)
-- .headers on
-- .mode csv
-- .once dept_mom.csv

-- QC notes:
-- - Parity: SUM(dept_spend) ≈ SUM(COALESCE(line_total, qty*unit_price)) from line_items
-- - Anomalies: prev_spend only NULL for first month per department; flag negatives

WITH
-- 1) Line totals (handles missing line_total using qty * unit_price)
lt AS (
SELECT
request_id,
COALESCE(line_total, qty * unit_price) AS line_tot
FROM line_items
),


-- 2) Dept × month rollup
dept_month AS (
SELECT
r.department,
strftime('%Y-%m', r.request_date) AS month, -- YYYY-MM bucket
SUM(lt.line_tot) AS dept_spend
FROM lt
JOIN requests r
ON r.request_id = lt.request_id
GROUP BY r.department, month
),


-- 3) Add previous month spend via window
dept_mom AS (
SELECT
department,
month,
dept_spend,
LAG(dept_spend) OVER (
PARTITION BY department
ORDER BY month
) AS prev_spend
FROM dept_month
)


-- 4) Final projection
SELECT
department,
month,
dept_spend,
prev_spend,
(dept_spend - prev_spend) AS spend_diff,
(dept_spend - prev_spend) * 1.0 / NULLIF(prev_spend, 0) AS pct_change
FROM dept_mom
ORDER BY department, month;


-- QC 1: Parity (monthly sum ≈ grand total)
-- WITH lt AS (...), dept_month AS (...)
-- SELECT SUM(dept_spend) AS total_from_months FROM dept_month;
-- SELECT SUM(COALESCE(line_total, qty * unit_price)) AS total_from_lines FROM line_items;


-- QC 2: Anomaly screen (unexpected NULL prev beyond first month, negatives)
-- WITH lt AS (...), dept_month AS (...),
-- ranked AS (
-- SELECT department, month, dept_spend,
-- ROW_NUMBER() OVER (PARTITION BY department ORDER BY month) AS rn
-- FROM dept_month
-- ),
-- mom AS (
-- SELECT department, month, dept_spend, rn,
-- LAG(dept_spend) OVER (PARTITION BY department ORDER BY month) AS prev_spend
-- FROM ranked
-- )
-- SELECT * FROM mom
-- WHERE dept_spend < 0 OR (rn > 1 AND prev_spend IS NULL);
