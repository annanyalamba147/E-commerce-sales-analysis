-- =============================================================
-- Query 02: Customer Lifetime Value (CLV)
-- CLV calculation, segmentation, and top-customer analysis
-- =============================================================


-- -------------------------------------------------------------
-- 2.1  CLV per Customer (total spend, order count, tenure)
-- -------------------------------------------------------------
SELECT
    c.customer_id,
    c.full_name,
    c.city,
    c.registered_at::DATE                          AS joined_date,
    COUNT(DISTINCT o.order_id)                     AS total_orders,
    SUM(oi.quantity * oi.unit_price
        * (1 - o.discount_pct / 100.0))            AS lifetime_value,
    ROUND(AVG(oi.quantity * oi.unit_price), 2)     AS avg_order_value,
    DATE_PART('day', NOW() - c.registered_at)      AS tenure_days
FROM customers c
LEFT JOIN orders o      ON c.customer_id = o.customer_id AND o.status = 'completed'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.full_name, c.city, c.registered_at
ORDER BY lifetime_value DESC NULLS LAST;


-- -------------------------------------------------------------
-- 2.2  CLV Segmentation: High / Mid / Low Value Tiers
-- -------------------------------------------------------------
WITH clv AS (
    SELECT
        c.customer_id,
        c.full_name,
        SUM(oi.quantity * oi.unit_price
            * (1 - o.discount_pct / 100.0)) AS lifetime_value
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id AND o.status = 'completed'
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.full_name
),
percentiles AS (
    SELECT
        PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY lifetime_value) AS p33,
        PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY lifetime_value) AS p66
    FROM clv
)
SELECT
    clv.customer_id,
    clv.full_name,
    ROUND(clv.lifetime_value, 2) AS lifetime_value,
    CASE
        WHEN clv.lifetime_value >= p.p66 THEN 'High Value'
        WHEN clv.lifetime_value >= p.p33 THEN 'Mid Value'
        ELSE                                   'Low Value'
    END AS clv_segment
FROM clv, percentiles p
ORDER BY lifetime_value DESC;


-- -------------------------------------------------------------
-- 2.3  Revenue share by CLV Segment
-- -------------------------------------------------------------
WITH clv AS (
    SELECT
        c.customer_id,
        SUM(oi.quantity * oi.unit_price
            * (1 - o.discount_pct / 100.0)) AS lifetime_value
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id AND o.status = 'completed'
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
percentiles AS (
    SELECT
        PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY lifetime_value) AS p33,
        PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY lifetime_value) AS p66
    FROM clv
),
segmented AS (
    SELECT
        CASE
            WHEN clv.lifetime_value >= p.p66 THEN 'High Value'
            WHEN clv.lifetime_value >= p.p33 THEN 'Mid Value'
            ELSE                                   'Low Value'
        END AS clv_segment,
        clv.lifetime_value
    FROM clv, percentiles p
)
SELECT
    clv_segment,
    COUNT(*)                                       AS customer_count,
    ROUND(SUM(lifetime_value), 2)                  AS segment_revenue,
    ROUND(SUM(lifetime_value)
        / SUM(SUM(lifetime_value)) OVER () * 100, 2) AS revenue_share_pct
FROM segmented
GROUP BY clv_segment
ORDER BY segment_revenue DESC;


-- -------------------------------------------------------------
-- 2.4  Top 10 Customers by Lifetime Value
-- -------------------------------------------------------------
SELECT
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price
                              * (1 - o.discount_pct / 100.0)) DESC) AS rank,
    c.customer_id,
    c.full_name,
    c.city,
    COUNT(DISTINCT o.order_id)                      AS orders,
    ROUND(SUM(oi.quantity * oi.unit_price
              * (1 - o.discount_pct / 100.0)), 2)   AS lifetime_value
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id AND o.status = 'completed'
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY lifetime_value DESC
LIMIT 10;
