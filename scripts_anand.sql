-- SPECIAL QUERIES:

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


-- REGULAR QUERIES:

-- Lowest 10 Inventory Levels
SELECT inventoryid, name, inventorynum
FROM inventory
ORDER BY inventorynum ASC
LIMIT 10;

-- Total Orders Processed per Employee
SELECT
  e.employeeid,
  e.name,
  COUNT(o.orderid) AS orders_processed
FROM employees e
LEFT JOIN orders o
  ON o.employeeid = e.employeeid
GROUP BY e.employeeid, e.name
ORDER BY orders_processed DESC;

-- Average Items per Order
SELECT
  AVG(items_in_order) AS avg_menu_items_per_order
FROM (
  SELECT
    oi.orderid,
    SUM(oi.quantity) AS items_in_order
  FROM order_items oi
  GROUP BY oi.orderid
) t;

-- Total Orders and Revenue per Month
SELECT
  date_trunc('month', orderdatetime)::date AS month_start,
  COUNT(*) AS monthly_orders,
  SUM(costtotal) AS monthly_revenue
FROM orders
GROUP BY date_trunc('month', orderdatetime)::date
ORDER BY month_start;