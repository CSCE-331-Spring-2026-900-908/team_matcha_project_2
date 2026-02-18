-- SPECIAL QUERIES:

-- 1. Weekly Sales History
SELECT
  date_trunc('week', orderdatetime)::date AS week_start,
  COUNT(*) AS orders_count
FROM orders
GROUP BY date_trunc('week', orderdatetime)::date
ORDER BY week_start;

-- 2. Realistic Sales History
SELECT
  EXTRACT(HOUR FROM orderdatetime)::int AS hour_of_day,
  COUNT(*) AS orders_count,
  SUM(costTotal) AS total_sales
FROM orders
GROUP BY EXTRACT(HOUR FROM orderdatetime)::int
ORDER BY hour_of_day;

-- 3. Peak Sales Day
SELECT
  date_trunc('day', orderdatetime)::date AS day,
  SUM(costTotal) AS total_sales
FROM orders
GROUP BY date_trunc('day', orderdatetime)::date
ORDER BY total_sales DESC
LIMIT 10;

-- 4. Menu Item Inventory
SELECT
  m.menuid,
  m.name,
  COUNT(DISTINCT mi.inventoryid) AS ingredients_used
FROM menu m
JOIN menu_items mi
  ON mi.menuid = m.menuid
GROUP BY m.menuid, m.name
ORDER BY m.menuid;

-- 5. Best of the Worst
WITH daily_sales AS (
  SELECT
    date_trunc('week', o.orderdatetime)::date AS week_start,
    o.orderdatetime::date AS day,
    SUM(o.costtotal) AS day_sales
  FROM orders o
  GROUP BY date_trunc('week', o.orderdatetime)::date, o.orderdatetime::date
),
worst_day AS (
  SELECT
    ds.week_start,
    ds.day,
    ds.day_sales
  FROM daily_sales ds
  JOIN (
    SELECT week_start, MIN(day_sales) AS min_sales
    FROM daily_sales
    GROUP BY week_start
  ) mins
    ON mins.week_start = ds.week_start
   AND mins.min_sales  = ds.day_sales
),
top_item AS (
  SELECT
    wd.week_start,
    wd.day,
    wd.day_sales,
    oi.menuid,
    SUM(oi.quantity) AS units_sold
  FROM worst_day wd
  JOIN orders o
    ON o.orderdatetime::date = wd.day
  JOIN order_items oi
    ON oi.orderid = o.orderid
  GROUP BY wd.week_start, wd.day, wd.day_sales, oi.menuid
),
ranked AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (PARTITION BY t.week_start ORDER BY t.units_sold DESC, t.menuid) AS rn
  FROM top_item t
)
SELECT
  r.week_start,
  r.day AS worst_day,
  r.day_sales AS worst_day_sales,
  m.name AS top_seller,
  r.units_sold
FROM ranked r
JOIN menu m
  ON m.menuid = r.menuid
WHERE r.rn = 1
ORDER BY r.week_start;


-- REGULAR QUERIES:

-- 6. Lowest 10 Inventory Levels
SELECT inventoryid, name, inventorynum
FROM inventory
ORDER BY inventorynum ASC
LIMIT 10;

-- 7. Total Orders Processed per Employee
SELECT
  e.employeeid,
  e.name,
  COUNT(o.orderid) AS orders_processed
FROM employees e
LEFT JOIN orders o
  ON o.employeeid = e.employeeid
GROUP BY e.employeeid, e.name
ORDER BY orders_processed DESC;

-- 8. Average Items per Order
SELECT
  AVG(items_in_order) AS avg_menu_items_per_order
FROM (
  SELECT
    oi.orderid,
    SUM(oi.quantity) AS items_in_order
  FROM order_items oi
  GROUP BY oi.orderid
) t;

-- 9. Total Orders and Revenue per Month
SELECT
  date_trunc('month', orderdatetime)::date AS month_start,
  COUNT(*) AS monthly_orders,
  SUM(costtotal) AS monthly_revenue
FROM orders
GROUP BY date_trunc('month', orderdatetime)::date
ORDER BY month_start;