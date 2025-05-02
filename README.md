Retail Sales Analysis Project – MySQL

This project focuses on analyzing a retail sales dataset using MySQL. The dataset includes transaction-level details like sale date, customer demographics, product categories, quantity, and monetary values. The goal is to generate business insights through structured SQL queries.

Dataset Overview

Table Name: retail_sales

Columns: transaction_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sale

Objectives

Understand dataset structure

Analyze sales performance by category and time

Identify high-value customers and transactions

Segment and group data for business insight

Perform time-based comparisons (monthly and yearly)

SQL Queries Breakdown

Preview data

SELECT * FROM retail_sales LIMIT 10;

Total sales count

SELECT COUNT(*) AS total_sales FROM retail_sales;

Unique product categories

SELECT DISTINCT category FROM retail_sales;

Earliest and latest sale dates

SELECT MIN(sale_date) AS start_date, MAX(sale_date) AS end_date FROM retail_sales;

Number of transactions per category

SELECT category, COUNT(*) AS num_transactions FROM retail_sales GROUP BY category;

Total sales amount per category

SELECT category, SUM(total_sale) AS total_revenue FROM retail_sales GROUP BY category;

Monthly total revenue

SELECT 
    YEAR(sale_date) AS year, 
    MONTH(sale_date) AS month, 
    SUM(total_sale) AS monthly_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

Top 5 highest value transactions

SELECT * FROM retail_sales ORDER BY total_sale DESC LIMIT 5;

Average order value by gender

SELECT gender, ROUND(AVG(total_sale), 2) AS avg_order_value FROM retail_sales GROUP BY gender;

Unique customers per category

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales GROUP BY category;

Top 5 customers by total spending

SELECT customer_id, SUM(total_sale) AS total_spent FROM retail_sales GROUP BY customer_id ORDER BY total_spent DESC LIMIT 5;

Best-selling category per year

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

Sales by time of day (shift analysis)

SELECT 
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift;

Average basket size (units per transaction)

SELECT ROUND(AVG(quantity), 2) AS avg_units_per_sale FROM retail_sales;

Year-over-Year (YoY) sales growth

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

📈 Insights Gained

The dataset can be used to assess sales performance, customer behavior, seasonal trends, and segmentation.

Time-based analysis (monthly, yearly, hourly) gives actionable insights for demand planning and marketing.

Ranking functions help identify top-performing categories and customers.

🧩 Tools Used

MySQL (SQL queries)

Dataset: Custom CSV with sales data
