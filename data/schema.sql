-- =============================================================
-- E-Commerce Sales Analysis — Database Schema
-- DDL: Table definitions, constraints, and indexes
-- =============================================================

-- Drop tables if they exist (for clean re-runs)
DROP TABLE IF EXISTS payments     CASCADE;
DROP TABLE IF EXISTS order_items  CASCADE;
DROP TABLE IF EXISTS orders       CASCADE;
DROP TABLE IF EXISTS products     CASCADE;
DROP TABLE IF EXISTS customers    CASCADE;

-- =============================================================
-- 1. CUSTOMERS
-- =============================================================
CREATE TABLE customers (
    customer_id     SERIAL          PRIMARY KEY,
    full_name       VARCHAR(120)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    phone           VARCHAR(20),
    city            VARCHAR(100),
    country         VARCHAR(100)    NOT NULL DEFAULT 'India',
    registered_at   TIMESTAMP       NOT NULL DEFAULT NOW(),
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE
);

CREATE INDEX idx_customers_country ON customers(country);
CREATE INDEX idx_customers_registered ON customers(registered_at);

-- =============================================================
-- 2. PRODUCTS
-- =============================================================
CREATE TABLE products (
    product_id      SERIAL          PRIMARY KEY,
    name            VARCHAR(255)    NOT NULL,
    category        VARCHAR(100)    NOT NULL,
    subcategory     VARCHAR(100),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price > 0),
    cost_price      NUMERIC(10, 2)  NOT NULL CHECK (cost_price > 0),
    stock_qty       INT             NOT NULL DEFAULT 0,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP       NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products(category);

-- =============================================================
-- 3. ORDERS
-- =============================================================
CREATE TABLE orders (
    order_id        SERIAL          PRIMARY KEY,
    customer_id     INT             NOT NULL REFERENCES customers(customer_id),
    order_date      TIMESTAMP       NOT NULL DEFAULT NOW(),
    status          VARCHAR(30)     NOT NULL DEFAULT 'completed'
                                    CHECK (status IN ('pending','processing','completed','cancelled','returned')),
    shipping_city   VARCHAR(100),
    shipping_country VARCHAR(100)   DEFAULT 'India',
    discount_pct    NUMERIC(5, 2)   DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100)
);

CREATE INDEX idx_orders_customer  ON orders(customer_id);
CREATE INDEX idx_orders_date      ON orders(order_date);
CREATE INDEX idx_orders_status    ON orders(status);

-- =============================================================
-- 4. ORDER ITEMS
-- =============================================================
CREATE TABLE order_items (
    item_id         SERIAL          PRIMARY KEY,
    order_id        INT             NOT NULL REFERENCES orders(order_id),
    product_id      INT             NOT NULL REFERENCES products(product_id),
    quantity        INT             NOT NULL CHECK (quantity > 0),
    unit_price      NUMERIC(10, 2)  NOT NULL CHECK (unit_price > 0)  -- price at time of order
);

CREATE INDEX idx_items_order   ON order_items(order_id);
CREATE INDEX idx_items_product ON order_items(product_id);

-- =============================================================
-- 5. PAYMENTS
-- =============================================================
CREATE TABLE payments (
    payment_id      SERIAL          PRIMARY KEY,
    order_id        INT             NOT NULL REFERENCES orders(order_id) UNIQUE,
    method          VARCHAR(50)     NOT NULL
                                    CHECK (method IN ('credit_card','debit_card','upi','net_banking','wallet','cod')),
    amount          NUMERIC(10, 2)  NOT NULL CHECK (amount > 0),
    paid_at         TIMESTAMP       NOT NULL DEFAULT NOW(),
    status          VARCHAR(20)     NOT NULL DEFAULT 'success'
                                    CHECK (status IN ('success','failed','refunded','pending'))
);

CREATE INDEX idx_payments_method ON payments(method);
CREATE INDEX idx_payments_status ON payments(status);
