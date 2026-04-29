-- =============================================================
-- Query 04: Product Performance
-- Top sellers, margin analysis, return rates
-- =============================================================


-- -------------------------------------------------------------
-- 4.1  Top 10 Products by Revenue
-- -------------------------------------------------------------
SELECT
    p.product_id,
    p.name,
    p.category,
    SUM(oi.quantity)                          AS units_sold,
    SUM(oi.quantity * oi.unit_price)          AS gross_revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.cost_price))
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0) * 100,
    2)                                        AS margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.name, p.category
ORDER BY gross_revenue DESC
LIMIT 10;


-- -------------------------------------------------------------
-- 4.2  Products with Highest Return / Cancellation Rate
-- -------------------------------------------------------------
SELECT
    p.product_id,
    p.name,
    p.category,
    COUNT(CASE WHEN o.status = 'completed' THEN 1 END)  AS completed_orders,
    COUNT(CASE WHEN o.status = 'returned'  THEN 1 END)  AS returns,
    COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END)  AS cancellations,
    ROUND(
        COUNT(CASE WHEN o.status IN ('returned','cancelled') THEN 1 END)
        * 100.0 / NULLIF(COUNT(*), 0),
    2)                                                  AS return_cancel_rate_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id = o.order_id
GROUP BY p.product_id, p.name, p.category
HAVING COUNT(*) > 1
ORDER BY return_cancel_rate_pct DESC;


-- -------------------------------------------------------------
-- 4.3  Category-Level Performance Summary
-- -------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT p.product_id)                  AS products_in_category,
    SUM(oi.quantity)                              AS total_units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2)   AS total_revenue,
    ROUND(AVG(oi.unit_price), 2)                 AS avg_selling_price,
    ROUND(AVG(p.unit_price - p.cost_price), 2)   AS avg_unit_margin
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY total_revenue DESC;


-- -------------------------------------------------------------
-- 4.4  Products with Zero Sales (never purchased)
-- -------------------------------------------------------------
SELECT
    p.product_id,
    p.name,
    p.category,
    p.stock_qty,
    p.unit_price
FROM products p
WHERE p.product_id NOT IN (
    SELECT DISTINCT oi.product_id
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status = 'completed'
)
AND p.is_active = TRUE;


-- -------------------------------------------------------------
-- 4.5  Revenue Rank Within Category (window function)
-- -------------------------------------------------------------
SELECT
    p.category,
    p.name,
    SUM(oi.quantity * oi.unit_price)             AS product_revenue,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    )                                            AS rank_in_category
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o   ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.category, p.name
ORDER BY p.category, rank_in_category;
