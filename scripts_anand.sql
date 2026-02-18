-- Weekly Sales History
SELECT
  date_trunc('week', orderdatetime)::date AS week_start,
  COUNT(*) AS orders_count
FROM orders
GROUP BY date_trunc('week', orderdatetime)::date
ORDER BY week_start;

-- Realistic Sales History
SELECT
  EXTRACT(HOUR FROM orderdatetime)::int AS hour_of_day,
  COUNT(*) AS orders_count,
  SUM(costTotal) AS total_sales
FROM orders
GROUP BY EXTRACT(HOUR FROM orderdatetime)::int
ORDER BY hour_of_day;

-- Peak Sales Day
SELECT
  date_trunc('day', orderdatetime)::date AS day,
  SUM(costTotal) AS total_sales
FROM orders
GROUP BY date_trunc('day', orderdatetime)::date
ORDER BY total_sales DESC
LIMIT 10;

-- Menu Item Inventory
SELECT
  m.menuid,
  m.name,
  COUNT(DISTINCT mi.inventoryid) AS ingredients_used
FROM menu m
JOIN menu_items mi
  ON mi.menuid = m.menuid
GROUP BY m.menuid, m.name
ORDER BY m.menuid;
