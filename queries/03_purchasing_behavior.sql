-- =============================================================
-- Query 03: Purchasing Behavior
-- RFM scoring, basket analysis, frequency distribution
-- =============================================================


-- -------------------------------------------------------------
-- 3.1  RFM Analysis — Recency, Frequency, Monetary
-- -------------------------------------------------------------
WITH rfm_raw AS (
    SELECT
        c.customer_id,
        c.full_name,
        DATE_PART('day', NOW() - MAX(o.order_date))     AS recency_days,
        COUNT(DISTINCT o.order_id)                      AS frequency,
        SUM(oi.quantity * oi.unit_price
            * (1 - o.discount_pct / 100.0))             AS monetary
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id AND o.status = 'completed'
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.full_name
),
rfm_scored AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY recency_days DESC)  AS r_score,  -- lower recency = better
        NTILE(5) OVER (ORDER BY frequency ASC)      AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC)       AS m_score
    FROM rfm_raw
)
SELECT
    customer_id,
    full_name,
    recency_days,
    frequency,
    ROUND(monetary, 2) AS monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score)   AS rfm_total,
    CASE
        WHEN (r_score + f_score + m_score) >= 13 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 7  THEN 'Potential Loyalists'
        WHEN r_score >= 4 AND (f_score + m_score) <= 4 THEN 'New Customers'
        ELSE                                           'At Risk'
    END AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;


-- -------------------------------------------------------------
-- 3.2  Average Basket Size (items per order)
-- -------------------------------------------------------------
SELECT
    ROUND(AVG(items_per_order), 2)      AS avg_basket_size,
    MIN(items_per_order)                AS min_basket,
    MAX(items_per_order)                AS max_basket
FROM (
    SELECT
        order_id,
        SUM(quantity) AS items_per_order
    FROM order_items
    GROUP BY order_id
) basket;


-- -------------------------------------------------------------
-- 3.3  Purchase Frequency Distribution
-- -------------------------------------------------------------
SELECT
    total_orders,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_customers
FROM (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders
    FROM orders
    WHERE status = 'completed'
    GROUP BY customer_id
) freq
GROUP BY total_orders
ORDER BY total_orders;


-- -------------------------------------------------------------
-- 3.4  Average Days Between Repeat Purchases
-- -------------------------------------------------------------
WITH ordered AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order
    FROM orders
    WHERE status = 'completed'
)
SELECT
    customer_id,
    ROUND(AVG(DATE_PART('day', order_date - prev_order)), 1) AS avg_days_between_orders
FROM ordered
WHERE prev_order IS NOT NULL
GROUP BY customer_id
ORDER BY avg_days_between_orders;


-- -------------------------------------------------------------
-- 3.5  Frequently Bought Together (product pairs)
-- -------------------------------------------------------------
SELECT
    a.product_id   AS product_a,
    b.product_id   AS product_b,
    pa.name        AS product_a_name,
    pb.name        AS product_b_name,
    COUNT(*)       AS co_purchase_count
FROM order_items a
JOIN order_items b  ON a.order_id = b.order_id AND a.product_id < b.product_id
JOIN products pa    ON a.product_id = pa.product_id
JOIN products pb    ON b.product_id = pb.product_id
GROUP BY a.product_id, b.product_id, pa.name, pb.name
HAVING COUNT(*) >= 1
ORDER BY co_purchase_count DESC
LIMIT 15;
