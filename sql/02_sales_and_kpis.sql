-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 02_sales_and_kpis.sql
-- Objective: Calculate core business KPIs (Revenue, AOV, Basket Size),
--            monthly sales trends, top categories, and avoid join fan-outs.
-- ====================================================================

-- --------------------------------------------------------------------
-- Macro Business Scorecard (Delivered Orders Only)
SELECT 
    COUNT(DISTINCT o.order_id) AS total_delivered_orders,
    COUNT(oi.order_item_id) AS total_items_sold,
    SUM(oi.price) AS total_merchandise_revenue,
    SUM(oi.freight_value) AS total_freight_value,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value,
    ROUND(COUNT(oi.order_item_id) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS avg_items_per_order
FROM olist_order_items_dataset AS oi
INNER JOIN olist_orders_dataset AS o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';



-- --------------------------------------------------------------------
-- Task 2: Monthly Revenue & Order Volume Trends

SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT o.order_id) AS monthly_orders,
    SUM(oi.price) AS monthly_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS monthly_aov
FROM olist_order_items_dataset AS oi
INNER JOIN olist_orders_dataset AS o
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 
    YEAR(o.order_purchase_timestamp), 
    MONTH(o.order_purchase_timestamp)
ORDER BY 
    YEAR(o.order_purchase_timestamp), 
    MONTH(o.order_purchase_timestamp);

-- --------------------------------------------------------------------
-- Task 3: Top 10 Revenue-Generating Product Categories
SELECT TOP 10 
    p.product_category_name, 
    COUNT(oi.order_item_id) AS total_items_sold, 
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM olist_order_items_dataset AS oi
INNER JOIN olist_orders_dataset AS o
    ON o.order_id = oi.order_id
INNER JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;



-- --------------------------------------------------------------------
-- Task 4: The Join Fan-Out Trap (Data Validation Check)
-
WITH item_totals AS (
    SELECT 
        order_id,
        SUM(price) AS total_price
    FROM olist_order_items_dataset
    GROUP BY order_id
),
payment_totals AS (
    SELECT 
        order_id,
        SUM(payment_value) AS total_payment
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT 
    ROUND(SUM(it.total_price), 2) AS clean_merchandise_revenue,
    ROUND(SUM(pt.total_payment), 2) AS clean_payment_revenue
FROM olist_orders_dataset AS o
LEFT JOIN item_totals AS it 
    ON o.order_id = it.order_id
LEFT JOIN payment_totals AS pt 
    ON o.order_id = pt.order_id
WHERE o.order_status = 'delivered';
