SELECT
    TO_CHAR(orderdatetime, 'Day') AS weekday,
    SUM(costtotal) AS total_revenue,
    COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_revenue DESC;