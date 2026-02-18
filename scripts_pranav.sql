-- 1. Total revenue and total number of orders for each weekday
SELECT
    EXTRACT(DOW FROM orderdatetime) AS weekday_num,
    TO_CHAR(orderdatetime, 'Day') AS weekday_name,
    SUM(costtotal) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday_num, weekday_name
ORDER BY weekday_num;

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

--  7. Total quantity of each ingredient used in the 'Taro Milk Tea' menu item
SELECT 
    m.name AS drink, 
    i.name AS ingredient, 
    mi."itemquantity" AS amount
FROM menu m
JOIN menu_items mi ON m."menuid" = mi."menuid"
JOIN inventory i ON mi."inventoryid" = i."inventoryid"
WHERE m.name = 'Taro Milk Tea'; 
