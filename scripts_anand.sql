SELECT 
    date_trunc('week', orderDateTime)::date 
    AS week_start, 
    COUNT(*) AS orders_count 
FROM orders 
GROUP BY date_trunc('week', orderDateTime)::date 
ORDER BY week_start;