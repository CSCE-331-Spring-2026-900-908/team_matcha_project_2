-- 1. Total revenue and total number of orders for each weekday
SELECT
    TO_CHAR(orderdatetime, 'Day') AS weekday,
    SUM(costtotal) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_revenue DESC;

-- 2. Average order cost overall
SELECT AVG(costtotal) AS avg_order_cost
FROM orders;

-- 3. Average order cost taken by each employee, ordered by highest average cost
SELECT 
    employeeid,
    AVG(costtotal) AS avg_order_cost
FROM orders
GROUP BY employeeid
ORDER BY avg_order_cost DESC;

-- 4. Total quantity of each menu item ordered, ordered by most popular 
SELECT 
    m.name AS menu_item,
    SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN menu m ON oi.menuID = m.menuID
GROUP BY m.name
ORDER BY total_quantity DESC;

-- 5. Top 10 customers by total spending
SELECT customername, SUM(costtotal) AS total_spent
FROM orders
GROUP BY customername
ORDER BY total_spent DESC
LIMIT 10;

-- 6. Total revenue and total number of orders for weekends vs weekdays
SELECT CASE WHEN EXTRACT(DOW FROM orderdatetime) IN (0,6) THEN 'Weekend' ELSE 'Weekday' END AS day_type,
       SUM(costtotal) AS total_revenue, COUNT(*) AS total_orders
FROM orders
GROUP BY day_type;
