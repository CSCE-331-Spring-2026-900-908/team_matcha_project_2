SELECT
    TO_CHAR(orderdatetime, 'Day') AS weekday,
    SUM(costtotal) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_revenue DESC;

SELECT AVG(costtotal) AS avg_order_cost
FROM orders;

SELECT 
    employeeid,
    AVG(costtotal) AS avg_order_cost
FROM orders
GROUP BY employeeid
ORDER BY avg_order_cost DESC;
