# E-Commerce Operations & Supply Chain Performance (SQL Analysis)

## 📌 Executive Summary
<!-- TODO: Add a 3-5 sentence high-level summary of the business problem, key findings, and final recommendation after completing the analysis -->

---

## 🏢 Business Context & Problem Statement
* **Stakeholder:** Vice President of Operations, Olist (Brazilian E-Commerce Marketplace)
* **Problem:** Declining customer satisfaction ratings and recurring delivery delay complaints.
* **Objective:** Conduct a comprehensive SQL-driven operational audit across 100,000+ orders to diagnose logistics bottlenecks, repeat customer dynamics, and product category performance.

---

## 🗄️ Relational Database Schema
<!-- TODO: Add description or ER diagram illustrating the relationships between orders, items, customers, sellers, payments, and reviews -->

---

## 🛠️ Tech Stack & Methodology
* **Database:** MySQL
* **Key SQL Techniques:**
  * Complex Multi-Table Joins & Foreign Key Audits
  * Common Table Expressions (CTEs)
  * Window Functions (`ROW_NUMBER()`, `DENSE_RANK()`, `LAG()`, `LEAD()`)
  * Date/Time Difference Aggregations

---

## 📊 Key Findings
<!-- TODO: As you complete Days 2-5, summarize your core findings with metric callouts -->
1. **Sales & Category Performance:** <!-- TODO -->
2. **Customer Retention & Repeat Orders:** <!-- TODO -->
3. **Logistics & Delivery SLA Breaches:** <!-- TODO -->

---

## 💡 Strategic Recommendations
<!-- TODO: Document 3 actionable business recommendations based on your analysis -->

---

## 🚀 How to Reproduce
1. Download the dataset from [Kaggle Olist Brazilian E-Commerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Follow the SQL setup scripts in `/sql` in sequence:
   * `01_data_integrity_checks.sql`
   * `02_sales_and_kpis.sql`
   * `03_customer_lifetime_sequencing.sql`
   * `04_mom_growth_and_trends.sql`
   * `05_delivery_sla_bottlenecks.sql`
