-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 04_mom_growth_and_trends.sql
-- Objective: Use LAG() and CTEs to calculate Month-over-Month
--            revenue growth rates and 3-month rolling averages.
-- ====================================================================

WITH  monthly_revenue AS (
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
),
mom_calc AS (
    SELECT 
        order_year,
        order_month,
        monthly_orders,
        monthly_revenue,
        LAG(monthly_revenue, 1) OVER (
            ORDER BY order_year, order_month
        ) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT order_year, order_month, monthly_revenue, prev_month_revenue,
ROUND(
    (monthly_revenue - prev_month_revenue) * 100.0 
    / prev_month_revenue
, 2) AS mom_growth_pct,
ROUND(AVG(monthly_revenue) OVER (
    ORDER BY order_year, order_month
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
), 2) AS rolling_3m_avg
FROM mom_calc
WHERE order_year >= 2017;

/*
1. November 2017 had the highest MoM growth at +52.37%, caused by Black Friday promotional demand.
2. After the Nov 2017 spike, the rolling average revealed the underlying trend was ~$787K-$879K,
   significantly lower than the raw $987K peak — signaling the spike was not sustainable.
3. A negative MoM growth % tells leadership that revenue is contracting vs the prior month,
   which requires investigation into churn, seasonality, or market saturation.
*/
