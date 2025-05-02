-- 1. Preview data
SELECT * FROM retail_sales LIMIT 10;

-- 2. Count total rows (sales)
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- 3. Get unique product categories
SELECT DISTINCT category FROM retail_sales;

-- 4. Find the earliest and latest sale date
SELECT MIN(sale_date) AS start_date, MAX(sale_date) AS end_date FROM retail_sales;

-- 5. List number of transactions per category
SELECT category, COUNT(*) AS num_transactions FROM retail_sales GROUP BY category;

-- 6. Total sales amount per category
SELECT category, SUM(total_sale) AS total_revenue FROM retail_sales GROUP BY category;

-- 7. Monthly total revenue
SELECT 
    YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    SUM(total_sale) AS monthly_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

-- 8. Top 5 highest value transactions
SELECT * FROM retail_sales
ORDER BY total_sale DESC
LIMIT 5;

-- 9. Average order value by gender
SELECT gender, ROUND(AVG(total_sale), 2) AS avg_order_value
FROM retail_sales
GROUP BY gender;

-- 10. How many unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 11. Rank top 5 customers by total spending
SELECT customer_id, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 12. Find the best-selling category in each year
SELECT year, category, total_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        category,
        SUM(total_sale) AS total_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY SUM(total_sale) DESC) AS rnk
    FROM retail_sales
    GROUP BY year, category
) ranked
WHERE rnk = 1;

-- 13. Segment sales by time of day (shift)
SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift;

-- 14. Calculate average basket size (units sold per transaction)
SELECT ROUND(AVG(quantity), 2) AS avg_units_per_sale
FROM retail_sales;

-- 15. Year-over-year sales growth
SELECT 
    year,
    total_revenue,
    ROUND(((total_revenue - LAG(total_revenue) OVER (ORDER BY year)) / LAG(total_revenue) OVER (ORDER BY year)) * 100, 2) AS yoy_growth
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        SUM(total_sale) AS total_revenue
    FROM retail_sales
    GROUP BY year
) yearly;
