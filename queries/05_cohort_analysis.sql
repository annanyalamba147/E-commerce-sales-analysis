-- =============================================================
-- Query 05: Cohort Analysis
-- Monthly retention matrix and churn identification
-- =============================================================


-- -------------------------------------------------------------
-- 5.1  Define Customer Cohorts (first purchase month)
-- -------------------------------------------------------------
WITH first_order AS (
    SELECT
        customer_id,
        MIN(order_date)                             AS first_order_date,
        TO_CHAR(MIN(order_date), 'YYYY-MM')         AS cohort_month
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
),
order_activity AS (
    SELECT
        o.customer_id,
        TO_CHAR(o.order_date, 'YYYY-MM')            AS activity_month,
        fo.cohort_month
    FROM orders o
    JOIN first_order fo ON o.customer_id = fo.customer_id
    WHERE o.status = 'completed'
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_customers
    FROM first_order
    GROUP BY cohort_month
)
-- Cohort retention matrix
SELECT
    oa.cohort_month,
    cs.cohort_customers,
    oa.activity_month,
    COUNT(DISTINCT oa.customer_id)                              AS active_customers,
    ROUND(
        COUNT(DISTINCT oa.customer_id) * 100.0 / cs.cohort_customers,
    2)                                                         AS retention_rate_pct
FROM order_activity oa
JOIN cohort_size cs ON oa.cohort_month = cs.cohort_month
GROUP BY oa.cohort_month, cs.cohort_customers, oa.activity_month
ORDER BY oa.cohort_month, oa.activity_month;


-- -------------------------------------------------------------
-- 5.2  Customers Who Churned (no purchase in last 90 days)
-- -------------------------------------------------------------
SELECT
    c.customer_id,
    c.full_name,
    c.email,
    MAX(o.order_date)::DATE     AS last_order_date,
    DATE_PART('day', NOW() - MAX(o.order_date))::INT AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'completed'
GROUP BY c.customer_id, c.full_name, c.email
HAVING DATE_PART('day', NOW() - MAX(o.order_date)) > 90
ORDER BY days_since_last_order DESC;


-- -------------------------------------------------------------
-- 5.3  New vs. Returning Customer Revenue Split
-- -------------------------------------------------------------
WITH first_order AS (
    SELECT customer_id, MIN(order_id) AS first_order_id
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN fo.first_order_id = o.order_id THEN 'New Customer'
        ELSE 'Returning Customer'
    END                                    AS customer_type,
    COUNT(DISTINCT o.order_id)             AS orders,
    ROUND(SUM(oi.quantity * oi.unit_price
              * (1 - o.discount_pct / 100.0)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN first_order fo ON o.customer_id = fo.customer_id
WHERE o.status = 'completed'
GROUP BY customer_type
ORDER BY revenue DESC;


-- -------------------------------------------------------------
-- 5.4  30 / 60 / 90 Day Retention Rates
-- -------------------------------------------------------------
WITH first_order AS (
    SELECT customer_id, MIN(order_date) AS first_purchase
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
)
SELECT
    COUNT(DISTINCT fo.customer_id)              AS total_customers,
    COUNT(DISTINCT CASE
        WHEN EXISTS (
            SELECT 1 FROM orders o2
            WHERE o2.customer_id = fo.customer_id
              AND o2.status = 'completed'
              AND o2.order_date > fo.first_purchase
              AND o2.order_date <= fo.first_purchase + INTERVAL '30 days'
        ) THEN fo.customer_id END)              AS retained_30d,
    COUNT(DISTINCT CASE
        WHEN EXISTS (
            SELECT 1 FROM orders o2
            WHERE o2.customer_id = fo.customer_id
              AND o2.status = 'completed'
              AND o2.order_date > fo.first_purchase
              AND o2.order_date <= fo.first_purchase + INTERVAL '60 days'
        ) THEN fo.customer_id END)              AS retained_60d,
    COUNT(DISTINCT CASE
        WHEN EXISTS (
            SELECT 1 FROM orders o2
            WHERE o2.customer_id = fo.customer_id
              AND o2.status = 'completed'
              AND o2.order_date > fo.first_purchase
              AND o2.order_date <= fo.first_purchase + INTERVAL '90 days'
        ) THEN fo.customer_id END)              AS retained_90d
FROM first_order fo;
