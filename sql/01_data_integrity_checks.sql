-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 01_data_integrity_checks.sql
-- Objective: Audit schema, verify primary keys, confirm table grains, 
--            and validate relational integrity across tables.
-- ====================================================================

-- Step 0: Ensure you are in the correct database
-- CREATE DATABASE IF NOT EXISTS olist_ecommerce;
-- USE olist_ecommerce;

-- --------------------------------------------------------------------
-- Task 1: Record Counts Verification
-- Business Reason: Confirm all data was ingested without truncation or loss.
-- --------------------------------------------------------------------
-- TODO: Write queries to count the total rows in each of the core tables:
-- 1. olist_orders_dataset (Expected: ~99,441 rows)
-- 2. olist_order_items_dataset (Expected: ~112,650 rows)
-- 3. olist_customers_dataset (Expected: ~99,441 rows)
-- 4. olist_order_payments_dataset (Expected: ~103,886 rows)
-- 5. olist_order_reviews_dataset (Expected: ~99,224 rows)
-- 6. olist_products_dataset (Expected: ~32,951 rows)

-- YOUR QUERY HERE:



-- --------------------------------------------------------------------
-- Task 2: Primary Key & Uniqueness Audits
-- Business Reason: A corrupted primary key causes duplicated aggregations.
-- --------------------------------------------------------------------
-- TODO: Check whether `order_id` is 100% unique in `olist_orders_dataset`.
-- HINT: Compare COUNT(order_id) with COUNT(DISTINCT order_id), or find IDs with COUNT(*) > 1.

-- YOUR QUERY HERE:



-- TODO: Check the primary key / grain of `olist_order_items_dataset`.
-- Is `order_id` unique on its own? What combination of columns forms the true primary key?

-- YOUR QUERY HERE:



-- --------------------------------------------------------------------
-- Task 3: Customer ID Discrepancy & Grain Understanding
-- Business Reason: Olist has two customer IDs: `customer_id` and `customer_unique_id`.
-- --------------------------------------------------------------------
-- TODO: In `olist_customers_dataset`:
-- 1. How many total rows are there?
-- 2. How many DISTINCT `customer_id` values?
-- 3. How many DISTINCT `customer_unique_id` values?
-- 4. What does the difference between distinct `customer_id` and `customer_unique_id` tell you?

-- YOUR QUERY HERE:



-- --------------------------------------------------------------------
-- Task 4: Foreign Key Consistency / Orphan Record Checks
-- Business Reason: Orphan records (items without an order) break financial reporting.
-- --------------------------------------------------------------------
-- TODO: Check if there are any `order_id` values in `olist_order_items_dataset` 
-- that DO NOT exist in `olist_orders_dataset` (using a LEFT JOIN or NOT IN).

-- YOUR QUERY HERE:



-- --------------------------------------------------------------------
-- Task 5: Date Range & Order Status Audit
-- Business Reason: Clarify the timeframe of the dataset and non-delivered orders.
-- --------------------------------------------------------------------
-- TODO: In `olist_orders_dataset`:
-- 1. Find the earliest and latest `order_purchase_timestamp`.
-- 2. List the distinct `order_status` values and the count of orders in each status.

-- YOUR QUERY HERE:

