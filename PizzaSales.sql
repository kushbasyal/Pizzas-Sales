CREATE DATABASE Pizza_sales;

SELECT * FROM order_details
limit 10;
SELECT * FROM orders
limit 10;
SELECT * FROM pizza_types
limit 10;
SELECT * FROM pizzas
limit 10;
-- Q.1 Retrieve the total number of orders placed
SELECT 
    COUNT(order_id) AS Total_orders
FROM
    orders;


-- Q.2 Calculate the total revenue generated from pizza sales

SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS Total_revenue
FROM
    order_details AS od
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;
    
-- Q.3 Identify the highest- priced pizza
SELECT 
    pt.name, p.price AS Highest_Price
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Q.4 Identify the most common pizza size ordered

SELECT 
    p.size, COUNT(order_details) AS Total_order
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id
GROUP BY size
ORDER BY total_order DESC;

-- Q.5 List the top 5 most  ordered pizza types along with their quantities

SELECT 
    pt.name, SUM(od.quantity) AS Total_order
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_order DESC
LIMIT 5;

-- Q.6 Join the necessary tables to find the total_quantity of each pizza category ordered

SELECT 
    pt.category, SUM(od.quantity) AS Total_quantity
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q.7 Determine the distribution of orders by hour of the day

SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS Total_order
FROM
    orders
GROUP BY HOUR(order_time);

-- Q.8 Join the relevant tables to find the category_wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

-- Q.9 Group the orders by date and calculate the average the number of pizzas ordered per day
WITH Quantity_Orders AS (
    SELECT 
        o.order_date, 
        SUM(od.quantity) AS total_quantity
    FROM 
        orders AS o 
    JOIN 
        order_details AS od ON o.order_id = od.order_id
    GROUP BY 
        o.order_date
)
SELECT 
    round(AVG(total_quantity),0) AS avg_quantity_per_day
FROM 
    Quantity_Orders;

-- Q.10 Determine the top 3 most ordered pizza types based on revenue

SELECT 
    pt.name, SUM(od.quantity * p.price) AS Total_revenue
FROM
    pizza_types AS pt
        JOIN
    pizzas AS p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

-- Q.11 Calculate the percentage contribution of each pizza category to total_reevenue

WITH CategoryRevenue AS (
    SELECT 
        pt.category,
        round(SUM(od.quantity * p.price),2) AS total_revenue
    FROM 
        pizza_types AS pt
    JOIN 
        pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
    JOIN 
        order_details AS od ON p.pizza_id = od.pizza_id
    GROUP BY 
        pt.category
)
SELECT 
    category,
    total_revenue,
    round((total_revenue / SUM(total_revenue) OVER ()) * 100,2) AS revenue_percentage
FROM 
    CategoryRevenue
ORDER BY 
    total_revenue DESC;
    
-- Q.12 Analyze the cumulative revenue generated over time

WITH DailyRevenue AS (
    SELECT 
        o.order_date,
        round(SUM(od.quantity * p.price),2) AS daily_revenue
    FROM 
        orders AS o
    JOIN 
        order_details AS od ON o.order_id = od.order_id
    JOIN 
        pizzas AS p ON od.pizza_id = p.pizza_id
    GROUP BY 
        o.order_date
)

SELECT 
    order_date,
    daily_revenue,
    round(SUM(daily_revenue) OVER (ORDER BY order_date),2) AS cumulative_revenue
FROM 
    DailyRevenue
ORDER BY 
    order_date;

-- Q.13 Determine the top most ordered pizza types based on revenue for each pizza category

WITH PizzaRevenue AS (
    SELECT 
        pt.category,
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM 
        pizza_types AS pt
    JOIN 
        pizzas AS p ON pt.pizza_type_id = p.pizza_type_id
    JOIN 
        order_details AS od ON od.pizza_id = p.pizza_id
    GROUP BY 
        pt.category, pt.name
),
RankedPizzaRevenue AS (
    SELECT 
        category,
        name,
        revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM 
        PizzaRevenue
)
SELECT 
    category,
    name,
    revenue
FROM 
    RankedPizzaRevenue
WHERE 
    rn <= 3
ORDER BY 
    category, rn;

-- END OF PROJECT--




