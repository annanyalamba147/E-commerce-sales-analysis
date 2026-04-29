# 🛒 E-Commerce Sales Analysis

> Relational database design and end-to-end sales analytics using SQL — uncovering revenue trends, customer lifetime value, and purchasing behavior.

---

## 📌 Project Overview

This project builds a normalized relational database from raw e-commerce transaction data and applies advanced SQL analytics to generate business insights. The analysis covers:

- **Revenue performance** across time periods, categories, and regions
- **Customer Lifetime Value (CLV)** segmentation
- **Purchasing behavior** patterns and cohort analysis
- **Product performance** rankings and return rates

---

## 🗂️ Repository Structure

```
ecommerce-sales-analysis/
│
├── data/
│   ├── schema.sql              # DDL — table definitions, constraints, indexes
│   └── seed_data.sql           # Sample dataset for local testing
│
├── queries/
│   ├── 01_revenue_analysis.sql       # Revenue trends, MoM/YoY growth
│   ├── 02_customer_lifetime_value.sql # CLV calculation & segmentation
│   ├── 03_purchasing_behavior.sql    # Basket size, frequency, recency
│   ├── 04_product_performance.sql    # Top/bottom products, category breakdown
│   └── 05_cohort_analysis.sql        # Customer cohort retention
│
├── analysis/
│   └── insights_summary.md     # Key findings and business recommendations
│
├── reports/
│   └── sample_outputs.md       # Sample query results and interpretation
│
├── docs/
│   └── erd_diagram.md          # Entity-Relationship Diagram (text-based)
│
└── README.md
```

---

## 🧱 Database Schema

The schema is fully normalized (3NF) across **5 core tables**:

| Table | Description |
|---|---|
| `customers` | Customer demographics and registration date |
| `products` | Product catalog with category and pricing |
| `orders` | Order header — customer, date, status |
| `order_items` | Line items — order ↔ product with quantity/price |
| `payments` | Payment method and transaction details |

See [`data/schema.sql`](data/schema.sql) for full DDL.

---

## 🔍 Key Analyses

### 1. Revenue Analysis
- Monthly and yearly revenue trends
- Revenue by product category and region
- MoM growth rate using window functions (`LAG`)

### 2. Customer Lifetime Value (CLV)
- Average revenue per customer over their lifetime
- CLV segmentation: High / Mid / Low value tiers
- Identifying top 10% customers driving 60%+ revenue

### 3. Purchasing Behavior
- Average order value (AOV) and basket size
- Purchase frequency distribution
- RFM scoring (Recency, Frequency, Monetary)

### 4. Product Performance
- Top-selling products by revenue and units
- Category-level contribution analysis
- Products with high return/cancellation rates

### 5. Cohort Retention
- Monthly cohort matrix showing customer retention
- Churn identification at 30 / 60 / 90 days

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **PostgreSQL 15** | Primary database engine |
| **SQL** | Querying — JOINs, subqueries, CTEs, window functions |
| **DB Diagram / ERD** | Schema visualization |

> Queries are ANSI SQL compatible and can be run on MySQL, SQLite, or PostgreSQL with minor adjustments.

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-sales-analysis.git
cd ecommerce-sales-analysis
```

### 2. Set up the database (PostgreSQL)
```bash
psql -U postgres -c "CREATE DATABASE ecommerce_db;"
psql -U postgres -d ecommerce_db -f data/schema.sql
psql -U postgres -d ecommerce_db -f data/seed_data.sql
```

### 3. Run a query
```bash
psql -U postgres -d ecommerce_db -f queries/01_revenue_analysis.sql
```

---

## 📊 Sample Insight

> **Top 10% of customers by CLV generate 63% of total revenue.**  
> High-value customers have an average order frequency of 7.2x/year vs 1.4x for low-value segments — a 5× gap that highlights retention as the #1 growth lever.

---

## 📄 License

MIT License — free to use and adapt.
