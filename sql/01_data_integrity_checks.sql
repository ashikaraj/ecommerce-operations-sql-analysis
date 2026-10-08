-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 01_data_integrity_checks.sql
-- ====================================================================

-- 1. Table Record Counts
SELECT COUNT(*) AS total_orders FROM olist_orders_dataset;
SELECT COUNT(*) AS total_items FROM olist_order_items_dataset;

-- 2. Primary Key Uniqueness Audit
SELECT 
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders
FROM olist_orders_dataset;

-- 3. Customer Identity Discrepancy
SELECT 
    COUNT(customer_id) AS total_customer_sessions,
    COUNT(DISTINCT customer_unique_id) AS unique_human_customers
FROM olist_customers_dataset;

/*
Finding:
customer_id is per order, while customer_unique_id identifies the individual person.
The 3,345 difference represents repeat purchases from returning customers.
*/

-- 4. Orphan Record Check (Order Items vs Orders)
SELECT ot.order_id 
FROM olist_order_items_dataset AS ot
LEFT JOIN olist_orders_dataset AS o
    ON ot.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 5. Operational Date Range & Order Status Breakdown
SELECT 
    MIN(order_purchase_timestamp) AS earliest_purchase, 
    MAX(order_purchase_timestamp) AS latest_purchase
FROM olist_orders_dataset;

SELECT 
    order_status, 
    COUNT(*) AS order_count
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;