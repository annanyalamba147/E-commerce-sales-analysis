# Sample Query Outputs

Illustrative results based on the seed dataset.

---

## Query 01 — Revenue by Month

| month   | total_orders | net_revenue | avg_order_value |
|---------|-------------|-------------|-----------------|
| 2023-01 | 2           | ₹7,193.55   | ₹2,397.85       |
| 2023-02 | 2           | ₹5,197.10   | ₹2,598.55       |
| 2023-03 | 2           | ₹4,556.10   | ₹2,278.05       |
| 2023-04 | 1           | ₹1,179.00   | ₹1,179.00       |
| 2023-05 | 2           | ₹5,773.65   | ₹2,886.83       |
| 2023-06 | 2           | ₹6,249.35   | ₹3,124.68       |
| 2023-07 | 2           | ₹3,595.00   | ₹1,797.50       |
| 2023-08 | 1           | ₹4,769.10   | ₹4,769.10       |

---

## Query 02 — CLV Segmentation

| clv_segment   | customer_count | segment_revenue | revenue_share_pct |
|---------------|---------------|-----------------|-------------------|
| High Value    | 3             | ₹14,120.35      | 49.2%             |
| Mid Value     | 4             | ₹8,633.75       | 30.1%             |
| Low Value     | 3             | ₹5,958.80       | 20.7%             |

---

## Query 03 — RFM Segments

| customer_segment    | count |
|---------------------|-------|
| Champions           | 2     |
| Loyal Customers     | 2     |
| Potential Loyalists | 3     |
| New Customers       | 2     |
| At Risk             | 1     |

---

## Query 04 — Top Products by Revenue

| rank | product               | category    | units_sold | gross_revenue | margin_pct |
|------|-----------------------|-------------|-----------|---------------|------------|
| 1    | Mechanical Keyboard   | Electronics | 3         | ₹11,997.00    | 55.0%      |
| 2    | Wireless Headphones   | Electronics | 3         | ₹7,497.00     | 52.0%      |
| 3    | Running Shoes         | Footwear    | 3         | ₹5,697.00     | 57.9%      |
| 4    | Laptop Stand          | Electronics | 3         | ₹3,897.00     | 61.5%      |
| 5    | LED Desk Lamp         | Home Decor  | 3         | ₹2,997.00     | 59.9%      |

---

## Query 05 — 30/60/90 Day Retention

| total_customers | retained_30d | retained_60d | retained_90d |
|-----------------|-------------|-------------|-------------|
| 10              | 3           | 5           | 7           |

*Retention improves as the cohort window widens — customers who stay through 90 days have significantly higher LTV.*
