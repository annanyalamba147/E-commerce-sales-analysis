# Entity-Relationship Diagram

## Schema Overview

```
┌──────────────────────────┐
│         CUSTOMERS         │
├──────────────────────────┤
│ PK  customer_id  SERIAL   │
│     full_name    VARCHAR  │
│     email        VARCHAR  │
│     phone        VARCHAR  │
│     city         VARCHAR  │
│     country      VARCHAR  │
│     registered_at TIMESTAMP│
│     is_active    BOOLEAN  │
└────────────┬─────────────┘
             │ 1
             │
             │ N
┌────────────▼─────────────┐
│          ORDERS           │
├──────────────────────────┤
│ PK  order_id     SERIAL  │
│ FK  customer_id  INT      │
│     order_date   TIMESTAMP│
│     status       VARCHAR  │
│     shipping_city VARCHAR │
│     discount_pct NUMERIC  │
└──────┬──────────┬─────────┘
       │ 1        │ 1
       │          │
       │ N        │ 1
┌──────▼───────┐ ┌▼──────────────────┐
│  ORDER_ITEMS │ │     PAYMENTS       │
├──────────────┤ ├───────────────────┤
│ PK item_id   │ │ PK payment_id      │
│ FK order_id  │ │ FK order_id (UNIQ) │
│ FK product_id│ │    method VARCHAR  │
│    quantity  │ │    amount NUMERIC  │
│    unit_price│ │    paid_at TIMESTAMP│
└──────┬───────┘ │    status VARCHAR  │
       │ N       └───────────────────┘
       │
       │ 1
┌──────▼───────────────────┐
│         PRODUCTS          │
├──────────────────────────┤
│ PK  product_id   SERIAL  │
│     name         VARCHAR  │
│     category     VARCHAR  │
│     subcategory  VARCHAR  │
│     unit_price   NUMERIC  │
│     cost_price   NUMERIC  │
│     stock_qty    INT      │
│     is_active    BOOLEAN  │
└──────────────────────────┘
```

## Relationships

| From | To | Cardinality | Description |
|---|---|---|---|
| `customers` | `orders` | 1 → N | A customer can place many orders |
| `orders` | `order_items` | 1 → N | An order contains one or more items |
| `products` | `order_items` | 1 → N | A product can appear in many order lines |
| `orders` | `payments` | 1 → 1 | Each order has exactly one payment record |

## Key Design Decisions

- **Normalized to 3NF**: No transitive dependencies. Product price at time of sale is captured in `order_items.unit_price` to handle price changes.
- **Soft deletes**: `is_active` flag on `customers` and `products` preserves history.
- **Status enums**: Constrained via `CHECK` for data integrity without needing lookup tables.
- **Indexes**: Added on all foreign keys and high-cardinality filter columns (`order_date`, `status`, `category`).
