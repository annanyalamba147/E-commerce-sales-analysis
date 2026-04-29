-- =============================================================
-- E-Commerce Sales Analysis — Seed Data
-- Sample dataset for local development and testing
-- =============================================================

-- CUSTOMERS
INSERT INTO customers (full_name, email, phone, city, country, registered_at) VALUES
('Arjun Sharma',    'arjun.sharma@email.com',    '9876543201', 'Delhi',     'India', '2022-01-15 10:30:00'),
('Priya Mehta',     'priya.mehta@email.com',     '9876543202', 'Mumbai',    'India', '2022-02-20 11:45:00'),
('Rahul Gupta',     'rahul.gupta@email.com',     '9876543203', 'Bangalore', 'India', '2022-03-10 09:00:00'),
('Sneha Kapoor',    'sneha.kapoor@email.com',    '9876543204', 'Pune',      'India', '2022-04-05 14:20:00'),
('Vikram Singh',    'vikram.singh@email.com',    '9876543205', 'Hyderabad', 'India', '2022-05-18 16:00:00'),
('Ananya Iyer',     'ananya.iyer@email.com',     '9876543206', 'Chennai',   'India', '2022-06-22 08:30:00'),
('Rohan Verma',     'rohan.verma@email.com',     '9876543207', 'Kolkata',   'India', '2022-07-11 13:15:00'),
('Neha Joshi',      'neha.joshi@email.com',      '9876543208', 'Jaipur',    'India', '2022-08-09 10:00:00'),
('Amit Patel',      'amit.patel@email.com',      '9876543209', 'Ahmedabad', 'India', '2022-09-30 15:45:00'),
('Kavita Nair',     'kavita.nair@email.com',     '9876543210', 'Kochi',     'India', '2022-10-14 12:00:00');

-- PRODUCTS
INSERT INTO products (name, category, subcategory, unit_price, cost_price, stock_qty) VALUES
('Wireless Bluetooth Headphones', 'Electronics',  'Audio',        2499.00, 1200.00, 150),
('Mechanical Keyboard',           'Electronics',  'Peripherals',  3999.00, 1800.00, 80),
('Running Shoes - Men',           'Footwear',     'Sports',       1899.00,  800.00, 200),
('Yoga Mat Premium',              'Sports',       'Fitness',       899.00,  300.00, 300),
('Cotton Formal Shirt',           'Clothing',     'Men',           699.00,  250.00, 400),
('Stainless Steel Water Bottle',  'Kitchen',      'Drinkware',     499.00,  150.00, 500),
('Novel: The Alchemist',          'Books',        'Fiction',       299.00,   80.00, 1000),
('Face Moisturizer SPF 50',       'Beauty',       'Skincare',      799.00,  300.00, 250),
('Laptop Stand Adjustable',       'Electronics',  'Accessories',  1299.00,  500.00, 120),
('LED Desk Lamp',                 'Home Decor',   'Lighting',      999.00,  400.00, 180);

-- ORDERS
INSERT INTO orders (customer_id, order_date, status, shipping_city, discount_pct) VALUES
(1, '2023-01-10 10:00:00', 'completed',  'Delhi',     5),
(2, '2023-01-15 11:30:00', 'completed',  'Mumbai',    0),
(3, '2023-02-02 09:15:00', 'completed',  'Bangalore', 10),
(4, '2023-02-20 14:00:00', 'returned',   'Pune',      0),
(5, '2023-03-05 16:30:00', 'completed',  'Hyderabad', 0),
(1, '2023-03-18 10:00:00', 'completed',  'Delhi',     5),
(6, '2023-04-07 08:45:00', 'completed',  'Chennai',   0),
(7, '2023-04-22 13:00:00', 'cancelled',  'Kolkata',   0),
(2, '2023-05-03 11:00:00', 'completed',  'Mumbai',    15),
(8, '2023-05-19 15:30:00', 'completed',  'Jaipur',    0),
(3, '2023-06-01 09:00:00', 'completed',  'Bangalore', 0),
(9, '2023-06-14 14:45:00', 'completed',  'Ahmedabad', 5),
(1, '2023-07-08 10:30:00', 'completed',  'Delhi',     0),
(10,'2023-07-25 12:00:00', 'completed',  'Kochi',     0),
(5, '2023-08-12 16:00:00', 'completed',  'Hyderabad', 10);

-- ORDER ITEMS
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1, 2499.00), (1,  9, 1, 1299.00),
(2,  3, 1, 1899.00), (2,  4, 2,  899.00),
(3,  2, 1, 3999.00),
(4,  8, 2,  799.00),
(5,  5, 3,  699.00), (5,  6, 2,  499.00),
(6,  7, 2,  299.00), (6, 10, 1,  999.00),
(7,  1, 1, 2499.00), (7,  4, 1,  899.00),
(8,  9, 1, 1299.00), (8,  3, 1, 1899.00),
(9,  2, 1, 3999.00), (9,  5, 2,  699.00),
(10, 6, 3,  499.00), (10, 8, 1,  799.00),
(11, 7, 5,  299.00),
(12, 1, 1, 2499.00), (12,10, 2,  999.00),
(13, 4, 1,  899.00), (13, 6, 2,  499.00),
(14, 3, 1, 1899.00), (14, 5, 1,  699.00),
(15, 2, 1, 3999.00), (15, 9, 1, 1299.00);

-- PAYMENTS
INSERT INTO payments (order_id, method, amount, paid_at, status) VALUES
(1,  'upi',          3623.55, '2023-01-10 10:05:00', 'success'),
(2,  'credit_card',  3697.00, '2023-01-15 11:32:00', 'success'),
(3,  'net_banking',  3599.10, '2023-02-02 09:18:00', 'success'),
(4,  'debit_card',   1598.00, '2023-02-20 14:02:00', 'refunded'),
(5,  'upi',          3095.00, '2023-03-05 16:32:00', 'success'),
(6,  'wallet',       1520.10, '2023-03-18 10:03:00', 'success'),
(7,  'upi',           899.00, '2023-04-07 08:47:00', 'success'),
(8,  'cod',          3398.00, '2023-04-22 13:02:00', 'pending'),
(9,  'credit_card',  4574.65, '2023-05-03 11:04:00', 'success'),
(10, 'upi',          1296.00, '2023-05-19 15:32:00', 'success'),
(11, 'net_banking',  1495.00, '2023-06-01 09:03:00', 'success'),
(12, 'upi',          4259.35, '2023-06-14 14:48:00', 'success'),
(13, 'debit_card',    997.00, '2023-07-08 10:33:00', 'success'),
(14, 'credit_card',  2598.00, '2023-07-25 12:02:00', 'success'),
(15, 'upi',          4769.10, '2023-08-12 16:02:00', 'success');
