-- Active: 1789505983775@@127.0.0.1@5432@retail_analytics@retailanalytics
SELECT * FROM customers LIMIT 5;

SELECT * FROM orders LIMIT 5;

-- GET the latest order date
SELECT MAX(order_date) FROM orders; -- -> 2026-09-30

-- Section A - SQL Fundamentals (Q1 - Q10)
-- 1. Retrieve all customer records.
SELECT * FROM customers;

-- 2. Display customer names, cities, and segments.
SELECT customer_name AS "Customer Name", city, customer_segment AS "Customer Segment" FROM customers;

-- 3. Find customers living in Nairobi.
SELECT customer_name AS  "Customer Name", city AS "City" FROM customers
WHERE city = 'Nairobi';

-- 4. Find customers registered after January 1, 2025.
SELECT customer_name AS "Customer Name", registration_date AS "Registration Date" FROM customers
WHERE registration_date > '2025-01-01';

-- 5. Display all unique customer cities.
SELECT DISTINCT(city) AS "Distinct Cities" FROM customers;

-- 6. Retrieve the 10 most recent orders.
SELECT order_id, customer_id, order_date, product_name, product_category, quantity, unit_price, cost_price,
discount, payment_method, order_status
FROM orders
LIMIT 10;

-- 7. Find orders with unit prices above KSh 10,000.
SELECT order_id, customer_id, order_date, product_name, product_category, quantity, unit_price, cost_price,
discount, payment_method, order_status
FROM orders
WHERE unit_price > 10000;

-- 8. Find customers whose names start with A.
SELECT customer_id, customer_name
FROM customers
WHERE customer_name LIKE 'A%';

-- 9. Retrieve orders with quantities between 2 and 5.
SELECT order_id, customer_id, order_date, product_name, product_category, quantity, unit_price, cost_price,
discount, payment_method, order_status
FROM orders
WHERE quantity IN(2,3,4,5);

-- 10. Find orders paid through M-Pesa.
SELECT order_id, customer_id, order_date, product_name, product_category, quantity, unit_price, cost_price,
discount, payment_method, order_status
FROM orders
WHERE payment_method = 'M-Pesa';

-- Section B — Aggregation and grouping (Q11–Q20)
-- 11. Count all customers.
SELECT COUNT(*) FROM customers;

-- 12. Count all orders.
SELECT COUNT(*) FROM orders;

-- 13. Calculate completed-order revenue.
SELECT ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS "Revenue"
FROM ORDERS
WHERE order_status = 'Completed';

-- 14. Calculate the average completed-order value.
SELECT ROUND(AVG(quantity * unit_price * (1 - discount / 100)),2) AS "Average Revenue"
FROM ORDERS
WHERE order_status = 'Completed';

-- 15. Find the highest and lowest product prices.
SELECT MAX(unit_price) AS "Most Expensive Product Price", MIN(unit_price) AS "Least Expensive Product Price"
FROM orders;

-- 16. Calculate revenue by product category.
SELECT product_category, ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2)
FROM orders
GROUP BY product_category;

-- 17. Count customers by city.
SELECT city, COUNT(*)
FROM customers
GROUP BY city;

-- 18. Calculate quantity sold by product.
SELECT product_name, COUNT(quantity) AS "Quantity Sold"
FROM orders
GROUP BY product_name;

-- 19. Find categories generating more than KSh 100,000 in revenue.
SELECT product_category, ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS "Generated Revenue"
FROM orders
GROUP BY product_category
HAVING ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) > 100000

-- 20. Calculate the percentage of cancelled orders.
SELECT ROUND(COUNT(*) FILTER(WHERE order_status = 'Cancelled') * 100.0 / COUNT(*),2) AS "Cancelled Orders" FROM orders;

-- Section C — Joins and customer analytics (Q21–Q28)
-- 21. Display orders with customer names and cities.
SELECT order_id, customer_name, city FROM ORDERS o
INNER JOIN customers c ON c.customer_id = o.customer_id;

-- 22. Calculate total spending by customer.
select customer_name, ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS "Customer Spending"
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY customer_name;

-- 23. Identify customers who have never ordered.
SELECT customer_name FROM customers c
LEFT JOIN orders o on c.customer_id = o.customer_id
WHERE order_id IS NULL;


-- 24. Find the 10 highest-spending customers.
select customer_name, ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS "Customer Spending"
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY customer_name
ORDER BY ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) DESC
LIMIT 10

-- 25. Calculate revenue by customer city.
select city, ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS "Customer Spending"
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY customer_name
ORDER BY ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) DESC
LIMIT 10

-- 26. Identify customers with more than five orders.
SELECT customer_name, COUNT(order_id) FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY customer_name
HAVING COUNT(order_id) > 5
ORDER BY COUNT(order_id) DESC

-- 27. Calculate average customer spending by segment.
SELECT customer_segment, ROUND(AVG(quantity * unit_price * (1 - discount / 100)),2) AS "Avg Spending by Segment"
FROM customers c
INNER JOIN orders o on o.customer_id = c.customer_id
GROUP BY customer_segment;

-- 28. Identify the most popular category among VIP customers.
SELECT product_name, SUM(quantity) AS "Quantity Sold"
FROM orders o
INNER JOIN customers c on c.customer_id = o.customer_id
WHERE customer_segment = 'VIP'
GROUP BY product_name
ORDER BY SUM(quantity) DESC
LIMIT 1

-- Section D — Subqueries and CTEs (Q29–Q34)
-- 29. Find customers spending above the average total spending per purchasing customer.
SELECT * FROM customers;
WITH bascic_CTE AS(
    SELECT customer_name, gender, city FROM customers
)
SELECT * FROM customers;

-- 30. Find products priced above the overall average unit price.
SELECT DISTINCT(product_name), unit_price FROM orders
WHERE unit_price > (SELECT AVG(unit_price) FROM orders)
ORDER BY unit_price DESC;  

-- 31. Use a CTE to identify the three highest-revenue months.
WITH monthly_revenue AS(
    SELECT
        DATE_TRUNC('month', order_date)::date AS revenue_month,
        ROUND(SUM(quantity * unit_price * (1 - discount / 100)),2) AS total_revenue
        FROM orders
        GROUP BY DATE_TRUNC('month', order_date)
)
SELECT revenue_month, total_revenue FROM monthly_revenue
ORDER BY total_revenue DESC
LIMIT 3;

-- 32. Find customers purchasing from at least three categories.
SELECT customer_name, COUNT(product_category) AS category_count FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY customer_name
HAVING COUNT(product_category) >= 3

-- 33. Use a CTE to calculate category revenue, cost, profit, and profit margin.
WITH CategoryMetrics AS (
    SELECT 
        product_category,
        SUM(quantity * unit_price * (1 - discount / 100)) AS total_revenue,
        SUM(quantity * cost_price) AS total_cost
    FROM orders
    WHERE order_status = 'Completed' 
    GROUP BY product_category
)
SELECT 
    product_category,
    ROUND(total_revenue, 2) AS revenue,
    ROUND(total_cost, 2) AS cost,
    ROUND(total_revenue - total_cost, 2) AS profit,
    ROUND(((total_revenue - total_cost) / total_revenue) * 100, 2) AS profit_margin_percentage
FROM CategoryMetrics
ORDER BY revenue DESC;

-- 34. Find customers whose latest completed order is more than 90 days before the latest order date in
    -- the dataset.
WITH LatestDatasetDate AS (
    SELECT MAX(order_date) AS max_dataset_date
    FROM orders
),
CustomerLatestCompleted AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_completed_order_date
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.last_completed_order_date,
    d.max_dataset_date,
    d.max_dataset_date - c.last_completed_order_date AS days_since_last_order
FROM CustomerLatestCompleted c
CROSS JOIN LatestDatasetDate d
WHERE d.max_dataset_date - c.last_completed_order_date > 90
ORDER BY days_since_last_order DESC;

-- 35. Rank customers by spending using `RANK()`.
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price * (1 - discount / 100)) AS total_spend
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    c.customer_name,
    ROUND(cs.total_spend, 2) AS total_spend,
    RANK() OVER (ORDER BY cs.total_spend DESC) AS spend_rank
FROM CustomerSpend cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY spend_rank;

-- 36. Number each customer's orders by recency using `ROW_NUMBER()`.
WITH RankedOrders AS (
    SELECT 
        order_id,
        customer_id,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS order_recency_num
    FROM orders
)
SELECT 
    customer_id,
    order_id,
    order_date
FROM RankedOrders
WHERE order_recency_num = 1;

-- 37. Rank products within categories using `DENSE_RANK()`.
WITH ProductRevenue AS (
    SELECT 
        product_category,
        product_name,
        SUM(quantity * unit_price * (1 - discount / 100)) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category, product_name
)
SELECT 
    product_category,
    product_name,
    ROUND(revenue, 2) AS revenue,
    DENSE_RANK() OVER (PARTITION BY product_category ORDER BY revenue DESC) AS rank_in_category
FROM ProductRevenue
ORDER BY product_category, rank_in_category;

-- 38. Calculate cumulative monthly revenue.
WITH MonthlyRevenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::date AS order_month,
        SUM(quantity * unit_price * (1 - discount / 100)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY 1
)
SELECT 
    order_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER (ORDER BY order_month), 2) AS cumulative_revenue
FROM MonthlyRevenue
ORDER BY order_month;

-- 39. Compare monthly revenue using `LAG()`.
WITH MonthlyRevenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::date AS order_month,
        SUM(quantity * unit_price * (1 - discount / 100)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY 1
)
SELECT 
    order_month,
    ROUND(monthly_revenue, 2) AS current_revenue,
    ROUND(LAG(monthly_revenue) OVER (ORDER BY order_month), 2) AS previous_month_revenue
FROM MonthlyRevenue
ORDER BY order_month;

-- 40. Calculate month-over-month revenue growth (%).
WITH MonthlyRevenue AS (
    SELECT 
        DATE_TRUNC('month', order_date)::date AS order_month,
        SUM(quantity * unit_price * (1 - discount / 100)) AS monthly_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY 1
),
RevenueWithLag AS (
    SELECT 
        order_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (ORDER BY order_month) AS prev_month_revenue
    FROM MonthlyRevenue
)
SELECT 
    order_month,
    ROUND(monthly_revenue, 2) AS current_revenue,
    ROUND(
        ((monthly_revenue - prev_month_revenue) / NULLIF(prev_month_revenue, 0)) * 100, 
        2
    ) AS mom_growth_percentage
FROM RevenueWithLag
ORDER BY order_month;

-- 41. Divide customers into four spending groups using `NTILE(4)`.
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price * (1 - discount / 100)) AS total_spend
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
)
SELECT 
    customer_id,
    ROUND(total_spend, 2) AS total_spend,
    NTILE(4) OVER (ORDER BY total_spend DESC) AS spend_quartile
FROM CustomerSpend
ORDER BY spend_quartile, total_spend DESC;

-- 42. Calculate each category's share of total revenue using window functions.
WITH CategoryRevenue AS (
    SELECT 
        product_category,
        SUM(quantity * unit_price * (1 - discount / 100)) AS category_revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT 
    product_category,
    ROUND(category_revenue, 2) AS category_revenue,
    ROUND(SUM(category_revenue) OVER (), 2) AS total_company_revenue,
    -- Calculate percentage share
    ROUND((category_revenue / SUM(category_revenue) OVER ()) * 100, 2) AS revenue_share_percentage
FROM CategoryRevenue
ORDER BY category_revenue DESC;

-- Section F - Advanced Business Intelligence
-- 43. Create a `monthly_sales_summary` view (month, orders, revenue, cost, profit). Then `SELECT` from it.
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT 
    DATE_TRUNC('month', order_date)::date AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100))::numeric, 2) AS revenue,
    ROUND(SUM(quantity * cost_price)::numeric, 2) AS cost,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100))::numeric 
          - SUM(quantity * cost_price)::numeric, 2) AS profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date);

-- Select from the new view
SELECT * FROM monthly_sales_summary
ORDER BY sales_month;

-- 44. Create a PostgreSQL function that returns completed-order revenue for a supplied customer ID. Show
--     it working for one customer **and** for an ID that does not exist (it should return 0, not NULL).
CREATE OR REPLACE FUNCTION get_customer_revenue(p_customer_id INT)
RETURNS NUMERIC AS $$
DECLARE
    v_revenue NUMERIC;
BEGIN
    SELECT COALESCE(SUM(quantity * unit_price * (1 - discount / 100)), 0)
    INTO v_revenue
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN ROUND(v_revenue, 2);
END;
$$ LANGUAGE plpgsql;

-- 45. Segment customers into High, Medium and Low Value. **Explain why you chose your thresholds** — for
--     example percentiles, or round KSh amounts based on what the data looks like.
WITH CustomerSpend AS (
    SELECT 
        customer_id,
        SUM(quantity * unit_price * (1 - discount / 100)) AS total_spend
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
Ranked AS (
    SELECT 
        customer_id,
        total_spend,
        -- PERCENT_RANK gives 0.0 (lowest spender) to 1.0 (highest)
        PERCENT_RANK() OVER (ORDER BY total_spend ASC) AS pct_rank
    FROM CustomerSpend
)
SELECT 
    customer_id,
    ROUND(total_spend, 2) AS total_spend,
    ROUND(pct_rank::numeric, 3) AS pct_rank,
    CASE 
        WHEN pct_rank >= 0.80 THEN 'High Value'   -- Top 20%
        WHEN pct_rank >= 0.50 THEN 'Medium Value' -- Next 30%
        ELSE 'Low Value'                          -- Bottom 50%
    END AS customer_segment
FROM Ranked
ORDER BY total_spend DESC;

-- 46. Produce a management report: the top five customers, top five products, the most profitable
--     category, and the lowest-revenue month.
-- Top 5 Customers by Revenue
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100))::numeric, 2) AS total_revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.customer_segment
ORDER BY total_revenue DESC
LIMIT 5;

-- Top 5 Products
SELECT 
    product_name,
    product_category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100))::numeric, 2) AS total_revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name, product_category
ORDER BY total_revenue DESC
LIMIT 5;

-- Most Profitable Category
SELECT 
    product_category,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100))::numeric, 2) AS revenue,
    ROUND(SUM(quantity * cost_price)::numeric, 2) AS cost,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100) 
              - quantity * cost_price)::numeric, 2) AS profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY profit DESC
LIMIT 1;

-- Lowest-Revenue Month
SELECT 
    DATE_TRUNC('month', order_date)::date AS sales_month,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(quantity * unit_price * (1 - discount / 100))::numeric, 2) AS revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY revenue ASC
LIMIT 1;