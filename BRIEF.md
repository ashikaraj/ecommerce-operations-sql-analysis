# Project 1 Brief: E-Commerce Supply Chain & Sales SQL Analysis

## 1. Stakeholder Scenario
* **Stakeholder:** Vice President of Operations & Head of Logistics at Olist (Brazilian E-Commerce Marketplace).
* **The Situation:** 
  The marketplace connects thousands of small merchants across Brazil with online buyers. Over the past three quarters, customer review scores have dipped, shipping delays have sparked customer complaints, and executive leadership suspects that certain logistics routes and product categories are bleeding money.
* **Your Role:** Lead Operations Data Analyst.
* **The Mandate:** 
  Conduct a rigorous SQL-driven deep dive into 100,000+ orders to diagnose:
  1. High-level financial health: order volumes, revenue trends, and Average Order Value (AOV).
  2. Repeat purchase dynamics: first-order vs. subsequent order behaviors.
  3. Logistics bottlenecks: estimated vs. actual delivery lag, state-by-state delivery SLA breaches, and freight cost correlation with bad reviews.
  4. Strategic recommendations to improve fulfillment efficiency and customer satisfaction.

---

## 2. The Relational Data Schema
The database consists of 8 interconnected tables:
1. `olist_orders_dataset`: Core order table (`order_id`, `customer_id`, `order_status`, timestamps for purchase, approval, carrier delivery, customer delivery, estimated delivery).
2. `olist_order_items_dataset`: Line-item breakdown (`order_id`, `order_item_id`, `product_id`, `seller_id`, `shipping_limit_date`, `price`, `freight_value`).
3. `olist_order_payments_dataset`: Payment methods and installments (`order_id`, `payment_sequential`, `payment_type`, `payment_installments`, `payment_value`).
4. `olist_order_reviews_dataset`: Customer feedback (`review_id`, `order_id`, `review_score`, `review_creation_date`, `review_answer_timestamp`).
5. `olist_customers_dataset`: Customer details (`customer_id`, `customer_unique_id`, `customer_zip_code_prefix`, `customer_city`, `customer_state`).
   * *Note on Customer IDs:* `customer_id` is per-order token; `customer_unique_id` tracks the actual individual across multiple orders!
6. `olist_sellers_dataset`: Merchant locations (`seller_id`, `seller_zip_code_prefix`, `seller_city`, `seller_state`).
7. `olist_products_dataset`: Product metadata (`product_id`, `product_category_name`, dimensions, weight).
8. `product_category_name_translation`: English translation of Brazilian Portuguese product category names.

---

## 3. Data Source & Setup
* **Source:** [Kaggle Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
* **Target Database:** MySQL (`olist_ecommerce`)

---

## 4. Key Business Questions to Answer
1. **Data Integrity:** What are the exact table grains, and which foreign keys have missing relationships?
2. **Revenue & Category Performance:** Which product categories generate 80% of revenue, and what is the seasonal trend?
3. **Customer Retention:** What percentage of customers are repeat buyers (`customer_unique_id`), and what is their average lifetime spend?
4. **Logistics Performance:** Which states suffer the highest delivery SLA breach rates (> estimated date), and how does delivery delay impact review scores?
5. **Action Plan:** What operational rules or merchant SLA policies should management implement?
