-- ====================================================================
-- Project: Olist E-Commerce Operations Analysis
-- Script: 05_delivery_sla_bottlenecks.sql
-- Objective: Quantify delivery SLA breaches, identify geographic 
--            bottlenecks, and correlate delivery delays with 
--            customer review scores.
-- ====================================================================
-- --------------------------------------------------------------------
-- Task 1: Classify Every Delivered Order as Early, On-Time, or Late
-- Business Question: What percentage of delivered orders breached 
--                    the estimated delivery SLA?
-- --------------------------------------------------------------------
WITH
    row_calculations AS (
        SELECT
            DATEDIFF (
                day,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) AS days_diff,
            CASE
                WHEN DATEDIFF (
                    day,
                    order_estimated_delivery_date,
                    order_delivered_customer_date
                ) < 0 THEN 'Early'
                WHEN DATEDIFF (
                    day,
                    order_estimated_delivery_date,
                    order_delivered_customer_date
                ) = 0 THEN 'On-Time'
                ELSE 'Late'
            END AS delivery_status
        FROM
            olist_orders_dataset
        WHERE
            order_status = 'delivered'
            AND order_estimated_delivery_date IS NOT NULL
            AND order_delivered_customer_date IS NOT NULL
    ),
    aggregated_status AS (
        SELECT
            delivery_status,
            COUNT(*) AS total_orders
        FROM
            row_calculations
        GROUP BY
            delivery_status
    )
SELECT
    delivery_status,
    total_orders,
    ROUND(
        total_orders * 100.0 / SUM(total_orders) OVER (),
        2
    ) AS percentage_of_total
FROM
    aggregated_status;

-- --------------------------------------------------------------------
-- Task 2: SLA Breach Rate by State
-- Business Question: Which Brazilian states suffer the highest 
--                    percentage of late deliveries?
-- --------------------------------------------------------------------
SELECT
    TOP 10 c.customer_state,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN DATEDIFF (
                day,
                o.order_estimated_delivery_date,
                o.order_delivered_customer_date
            ) > 0 THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN DATEDIFF (
                    day,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                ) > 0 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_rate_pct
FROM
    olist_orders_dataset AS o
    INNER JOIN olist_customers_dataset AS c ON c.customer_id = o.customer_id
WHERE
    order_status = 'delivered'
GROUP BY
    c.customer_state
ORDER BY
    late_rate_pct DESC;

-- --------------------------------------------------------------------
-- Task 3: Delivery Delay vs. Customer Review Score
-- Business Question: Does being late actually hurt review scores?
--                    Quantify the impact.
-- --------------------------------------------------------------------
SELECT
    CASE
        WHEN DATEDIFF (
            day,
            o.order_estimated_delivery_date,
            o.order_delivered_customer_date
        ) < 0 THEN 'Early'
        WHEN DATEDIFF (
            day,
            o.order_estimated_delivery_date,
            o.order_delivered_customer_date
        ) = 0 THEN 'On-Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) AS avg_review_score,
    ROUND(
        AVG(
            CAST(
                DATEDIFF (
                    day,
                    o.order_estimated_delivery_date,
                    o.order_delivered_customer_date
                ) AS FLOAT
            )
        ),
        1
    ) AS avg_days_diff
FROM
    olist_orders_dataset AS o
    INNER JOIN olist_order_reviews_dataset AS r ON r.order_id = o.order_id
WHERE
    o.order_status = 'delivered'
    AND o.order_estimated_delivery_date IS NOT NULL
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
    CASE
        WHEN DATEDIFF (
            day,
            o.order_estimated_delivery_date,
            o.order_delivered_customer_date
        ) < 0 THEN 'Early'
        WHEN DATEDIFF (
            day,
            o.order_estimated_delivery_date,
            o.order_delivered_customer_date
        ) = 0 THEN 'On-Time'
        ELSE 'Late'
    END;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------
-- Task 4: Business Findings & Recommendations
-- --------------------------------------------------------------------
/*
KEY FINDINGS

1. Overall SLA Breach Rate:
6.77% of delivered orders (6,534 orders) were delivered
after the estimated delivery date.

2. Geographic Bottlenecks:
AL (Alagoas) had the highest late-delivery rate among the
reported states: 21.41% (85 late orders out of 397).
RJ (Rio de Janeiro) had the largest late-order volume:
1,495 late orders out of 12,350, with a 12.11% late rate.
RR had a 12.20% late rate but only 41 orders, so its rate
should be interpreted cautiously.

3. Review Score Impact:
Early deliveries averaged 4.29, while late deliveries
averaged 2.27. This represents approximately a 47.1%
lower average review score for late deliveries.
On-time deliveries averaged 4.03.

RECOMMENDATIONS

1. Improve Regional Logistics:
Investigate carrier performance, transit times, and
last-mile delivery bottlenecks in northeastern states
such as AL, MA, and SE. Consider adjusting carrier
allocation and adding regional delivery capacity.

2. Improve Delivery-Date Estimates:
Review estimated delivery dates because early orders
arrive an average of 13.7 days before the promised date.
Use actual historical transit times and regional carrier
performance to provide more accurate customer estimates.
Also investigate why late orders average 10.5 days past
the promised date and address the underlying delays.

3. Prioritize High-Impact States:
Prioritize RJ because its high order volume produces
1,495 late orders. Work with carriers to identify the
main delay causes and monitor late-order volume and
late-delivery rate after corrective actions.
 */