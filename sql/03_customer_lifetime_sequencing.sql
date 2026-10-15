-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 03_customer_lifetime_sequencing.sql
-- Objective: Master SQL Window Functions (ROW_NUMBER, DENSE_RANK, 
--            PARTITION BY) to analyze repeat purchases and VIP customers.
-- ====================================================================

-- --------------------------------------------------------------------
-- Task 1: Customer Order Sequencing (1st Order vs. Repeat Orders)
WITH customer_order_sequence AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp ASC
        ) AS order_sequence
    FROM olist_orders_dataset AS o
    INNER JOIN olist_customers_dataset AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT
    CASE
        WHEN order_sequence = 1 THEN 'First Order'
        ELSE 'Repeat Order'
    END AS order_type,
    COUNT(*) AS total_orders
FROM customer_order_sequence
GROUP BY
    CASE
        WHEN order_sequence = 1 THEN 'First Order'
        ELSE 'Repeat Order'
    END;

-- Finding: Only 3.2% of delivered orders (3,120 out of 96,478) 
-- are repeat purchases. Olist has a severe retention problem.
-- Recommendation: Invest in post-purchase email flows and loyalty rewards.

----------------------------------------------------------------------
-- Task 2: Top 3 VIP Spenders Per State (DENSE_RANK)
WITH customer_spend AS (
SELECT c.customer_unique_id,c.customer_state,SUM(oi.price) AS total_spend
FROM olist_orders_dataset AS o
INNER JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
    INNER JOIN olist_customers_dataset AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id,c.customer_state
    ),
customer_ranked AS (
    SELECT customer_unique_id,customer_state,total_spend,
DENSE_RANK() OVER (
    PARTITION BY customer_state 
    ORDER BY total_spend DESC
   ) AS state_spend_rank
   FROM customer_spend 
 )
 SELECT *
FROM customer_ranked
WHERE state_spend_rank <= 3
ORDER BY customer_state, state_spend_rank;

-- Task 3: Window Ranking Concepts
/*
- ROW_NUMBER(): Always assigns unique numbers even for ties (1,2,3,4)
- RANK(): Assigns same rank for ties but skips next number (1,2,2,4)
- DENSE_RANK(): Assigns same rank for ties without skipping (1,2,2,3)

Use DENSE_RANK() when ranking within groups (e.g., Top 3 per state)
to avoid accidentally excluding tied records.
*/

