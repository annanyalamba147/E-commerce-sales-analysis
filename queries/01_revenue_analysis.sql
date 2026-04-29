-- =============================================================
-- Query 01: Revenue Analysis
-- Monthly trends, YoY growth, category breakdown
-- =============================================================


-- -------------------------------------------------------------
-- 1.1  Total Revenue by Month (completed orders only)
-- -------------------------------------------------------------
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM')          AS month,
    COUNT(DISTINCT o.order_id)                AS total_orders,
    SUM(oi.quantity * oi.unit_price
        * (1 - o.discount_pct / 100.0))       AS net_revenue,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY month;


-- -------------------------------------------------------------
-- 1.2  Month-over-Month Revenue Growth (window function)
-- -------------------------------------------------------------
WITH monthly_rev AS (
    SELECT
        TO_CHAR(o.order_date, 'YYYY-MM')       AS month,
        SUM(oi.quantity * oi.unit_price
            * (1 - o.discount_pct / 100.0))    AS net_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
)
SELECT
    month,
    net_revenue,
    LAG(net_revenue) OVER (ORDER BY month)     AS prev_month_revenue,
    ROUND(
        (net_revenue - LAG(net_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(net_revenue) OVER (ORDER BY month), 0) * 100,
    2)                                         AS mom_growth_pct
FROM monthly_rev
ORDER BY month;


-- -------------------------------------------------------------
-- 1.3  Revenue by Product Category
-- -------------------------------------------------------------
SELECT
    p.category,
    COUNT(DISTINCT o.order_id)                AS orders,
    SUM(oi.quantity)                          AS units_sold,
    SUM(oi.quantity * oi.unit_price)          AS gross_revenue,
    SUM(oi.quantity * (oi.unit_price - p.cost_price)) AS gross_profit,
    ROUND(
        SUM(oi.quantity * (oi.unit_price - p.cost_price))
        / NULLIF(SUM(oi.quantity * oi.unit_price), 0) * 100,
    2)                                        AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p    ON oi.product_id = p.product_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY gross_revenue DESC;


-- -------------------------------------------------------------
-- 1.4  Revenue Contribution % per Category (subquery)
-- -------------------------------------------------------------
SELECT
    category,
    gross_revenue,
    ROUND(gross_revenue / SUM(gross_revenue) OVER () * 100, 2) AS revenue_share_pct
FROM (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS gross_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    WHERE o.status = 'completed'
    GROUP BY p.category
) cat_revenue
ORDER BY gross_revenue DESC;


-- -------------------------------------------------------------
-- 1.5  Revenue by Payment Method
-- -------------------------------------------------------------
SELECT
    py.method,
    COUNT(*)                    AS transactions,
    SUM(py.amount)              AS total_collected,
    ROUND(AVG(py.amount), 2)    AS avg_transaction_value
FROM payments py
JOIN orders o ON py.order_id = o.order_id
WHERE py.status = 'success'
GROUP BY py.method
ORDER BY total_collected DESC;
