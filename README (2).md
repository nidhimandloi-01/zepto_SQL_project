<div align="center">

<img src="https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white"/>
<img src="https://img.shields.io/badge/SQL-Analysis-F29111?style=for-the-badge&logo=databricks&logoColor=white"/>
<img src="https://img.shields.io/badge/Domain-Quick%20Commerce-E63946?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Status-Complete-2EC4B6?style=for-the-badge"/>

<br/><br/>

# Zepto Product Data Analysis

**End-to-end SQL data analysis on Zepto's product catalog — from raw dirty data to business insights.**

</div>

---

## 📌 Objective

Zepto is one of India's fastest-growing quick-commerce platforms. This project performs a full analytical lifecycle on Zepto's product SKU data using **only SQL** — covering schema design, data cleaning, exploratory analysis, and business intelligence queries.

The goal: extract **pricing strategies, inventory patterns, and revenue signals** from raw product data.

---

## 📂 Dataset Overview

| Column | Type | Description |
|---|---|---|
| `sku_id` | SERIAL PK | Unique product identifier |
| `category` | VARCHAR | Product category (e.g., Dairy, Snacks) |
| `name` | VARCHAR | Product name |
| `mrp` | NUMERIC | Maximum Retail Price |
| `discount_percentage` | NUMERIC | Discount offered (%) |
| `discount_selling_price` | NUMERIC | Final price after discount |
| `available_quantity` | INTEGER | Units currently in stock |
| `weight_in_gms` | INTEGER | Product weight |
| `out_of_stock` | BOOLEAN | Stock availability flag |
| `quantity` | INTEGER | Pack size |

---

## 🧹 Data Cleaning

Real-world data is messy. Before any analysis, three critical issues were resolved:

**Issue 1 — Zero-price records**
```sql
-- Identified and removed products with MRP = 0 (invalid entries)
DELETE FROM zepto WHERE mrp = 0;
```

**Issue 2 — Wrong currency unit (Paise stored instead of Rupees)**
```sql
-- Converted all price columns from paise → rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discount_selling_price = discount_selling_price / 100.0;
```

**Issue 3 — NULL audit**
```sql
-- Scanned all critical columns for missing values
SELECT * FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL
   OR discount_percentage IS NULL OR available_quantity IS NULL
   OR discount_selling_price IS NULL OR weight_in_gms IS NULL
   OR out_of_stock IS NULL OR quantity IS NULL;
```

---

## 🔍 Exploratory Data Analysis

| Question | Query Approach |
|---|---|
| How many products exist? | `COUNT(*)` on full table |
| What categories are available? | `SELECT DISTINCT category` |
| How many products are in/out of stock? | `GROUP BY out_of_stock` |
| Which products have multiple SKUs? | `HAVING COUNT(sku_id) > 1` |

---

## 📊 Business Analysis — 8 Key Questions

### Q1 · Top 10 Products by Discount Percentage
> Identifies the best deals available on Zepto for price-sensitive shoppers.

```sql
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
ORDER BY discount_percentage DESC
LIMIT 10;
```

---

### Q2 · High-MRP Products That Are Out of Stock
> Premium products (MRP > ₹300) currently unavailable — a direct signal of **revenue leakage**.

```sql
SELECT DISTINCT name, mrp
FROM zepto
WHERE out_of_stock = TRUE AND mrp > 300
ORDER BY mrp DESC;
```

---

### Q3 · Estimated Revenue by Category
> Calculates potential GMV per category using `selling_price × available_quantity`.

```sql
SELECT category,
       SUM(discount_selling_price * available_quantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;
```

---

### Q4 · Expensive Products With Low Discounts
> MRP > ₹500 but discount < 10% — candidates for **repricing or promotional push**.

```sql
SELECT DISTINCT name, mrp, discount_percentage
FROM zepto
WHERE mrp > 500 AND discount_percentage < 10
ORDER BY mrp DESC;
```

---

### Q5 · Top 5 Categories by Average Discount
> Reveals where Zepto is being most aggressive with pricing strategy.

```sql
SELECT category,
       ROUND(AVG(discount_percentage), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
```

---

### Q6 · Best Price-Per-Gram Value (Products ≥ 100g)
> Unit economics analysis — helps identify the best value for bulk buyers.

```sql
SELECT DISTINCT name, weight_in_gms, discount_selling_price,
       ROUND(discount_selling_price / weight_in_gms, 2) AS price_per_gm
FROM zepto
WHERE weight_in_gms >= 100
ORDER BY price_per_gm ASC;
```

---

### Q7 · Product Weight Segmentation
> Classifies products into `Low / Medium / Bulk` tiers using `CASE WHEN` logic.

```sql
SELECT DISTINCT name, weight_in_gms,
       CASE
           WHEN weight_in_gms < 1000 THEN 'Low'
           WHEN weight_in_gms < 5000 THEN 'Medium'
           ELSE 'Bulk'
       END AS weight_category
FROM zepto;
```

---

### Q8 · Total Inventory Weight per Category
> Operational insight — physical stock weight per category for logistics planning.

```sql
SELECT category,
       SUM(weight_in_gms * available_quantity) AS total_inventory_weight
FROM zepto
GROUP BY category
ORDER BY total_inventory_weight DESC;
```

---

## 💡 Key Insights

- 🔴 **Currency bug found** — prices were stored in paise; all values were 100× higher than actual
- 💸 **High-MRP out-of-stock items** represent direct lost revenue — these need restocking priority
- 📦 **Multiple SKUs per product** indicate variant products (different weights/sizes)
- 🏷️ Category-level average discounts reveal Zepto's **aggressive pricing** in certain verticals
- ⚖️ Price-per-gram analysis surfaces products with the **best unit value** — useful for consumer insights

---

## 🛠️ Tech Stack

| Tool | Role |
|---|---|
| PostgreSQL | Relational database engine |
| SQL (DDL, DML, DQL) | Schema design, cleaning, and analysis |
| pgAdmin / psql | Query execution |

---


## 🙋 About

This project is part of my **Data Analysis Portfolio**, demonstrating proficiency in SQL for real-world data work — including data cleaning, exploratory analysis, and translating business questions into structured queries.

> 📬 Connect on [LinkedIn](https://linkedin.com/in/YOUR_PROFILE) · ⭐ Star this repo if it helped you!

---

<div align="center">
<sub>Built with PostgreSQL · Zepto Product Dataset · SQL Only</sub>
</div>
