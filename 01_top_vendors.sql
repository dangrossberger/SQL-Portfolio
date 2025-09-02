WITH 
lt AS (
 SELECT
  request_id,
  COALESCE(line_total, qty*unit_price) AS line_tot
 FROM line_items
),
vt AS (
SELECT
 r.vendor_id,
 sum(lt.line_tot) AS total_spend
FROM lt
JOIN requests r
ON r.request_id = lt.request_id
GROUP BY r.vendor_id
)
SELECT
 vt.vendor_id,
 v.vendor_name,
 ROUND(vt.total_spend, 2) AS vend_spend,
CASE
 WHEN vt.total_spend >=50000 THEN 'VIP'
 WHEN vt.total_spend >=40000 THEN 'Gold'
 WHEN vt.total_spend >=25000 THEN 'Silver'
 ELSE 'Bronze'
END AS Spend_Tier,
CASE
 WHEN v.mbe_edge_flag = 1 THEN 'MBE/EDGE'
 ELSE 'Standard'
END AS Diversity_flag
FROM vt
JOIN vendors v
ON vt.vendor_id = v.vendor_id
ORDER BY vend_spend DESC
LIMIT 10;