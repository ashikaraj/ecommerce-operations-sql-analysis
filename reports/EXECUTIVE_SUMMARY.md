# Olist E-Commerce Operations & Growth Strategy
## Executive Summary

**Prepared by:** Ashika Raj | Data Analyst Portfolio Project  
**Audience:** COO, CFO, VP of Growth  
**Dataset:** Brazilian E-Commerce Public Dataset by Olist  
**Analysis period:** January 2017 – August 2018  
**Tools:** SQL, CTEs, window functions, data quality checks, business KPI analysis

---

## 1. Executive Overview

Olist's Brazilian marketplace generated approximately **R$13.22 million in delivered product revenue** across **96,478 delivered orders** during the analyzed period, based on the current SQL results. However, the analysis identifies three areas requiring management attention: limited repeat purchasing, slowing revenue momentum in mid-2018, and regional delivery delays associated with substantially lower customer review scores.

The findings suggest that sustainable growth requires more than acquiring new customers. Olist should improve the post-purchase customer experience, address regional delivery bottlenecks, and use historical delivery performance to make more competitive and reliable delivery promises.

*Financial values are presented in Brazilian reais (R$), the dataset's original currency. Reported metrics should be reconciled against the final SQL outputs before publication.*

## 2. Executive KPI Scorecard

| KPI | Reported result | Business implication |
|---|---:|---|
| Delivered product revenue (GMV proxy) | R$13.22M | Establishes the scale of marketplace product sales |
| Delivered orders | 96,478 | Measures fulfilled order volume |
| Average order value (AOV) | R$137.04 | Indicates average product revenue per delivered order |
| Average basket size | 1.14 items | Suggests an opportunity to investigate complementary-product sales |
| Orders attributed to returning buyers | 3.2% | Signals a potential customer-retention challenge; validate using unique customer identities |
| Early delivery rate | 91.89% | Suggests delivery estimates may be conservative on some routes |
| Late delivery / SLA breach rate | 6.77% | Identifies a service-reliability issue requiring targeted investigation |

*Definitions matter: product revenue is not the same as net revenue or profit. Confirm whether the reported GMV excludes freight, canceled orders, and other non-delivered transactions. The retention metric must also specify whether its denominator is orders or unique customers.*

## 3. Key Business Findings

### Finding 1 — Repeat purchasing is a growth opportunity

The current analysis attributes 93,358 delivered orders to first-time purchasing activity and 3,120 to returning buyers. This represents a reported split of approximately 96.8% versus 3.2% of delivered orders.

**Why it matters:** A marketplace that relies heavily on first-time transactions may need to continually acquire new buyers to maintain sales. Increasing repeat purchasing could improve customer lifetime value and reduce dependence on paid acquisition.

**Recommended response:** Measure the percentage of unique customers who place a second delivered order, identify categories with stronger repeat behavior, and test targeted post-purchase communication and complementary-product offers.

### Finding 2 — Revenue momentum weakened in mid-2018

Monthly revenue reportedly peaked at R$987,765 in November 2017, coinciding with the Black Friday period. Revenue then declined in December. After a recovery during early 2018, growth weakened, with reported month-over-month changes of -12.43% in June and -3.38% in August 2018.

The reported three-month rolling average also declined from R$968K in May to R$854K in August 2018.

**Why it matters:** Revenue deceleration may reflect seasonality, changing order volume, average order value, customer acquisition, or a combination of factors. The trend alone does not establish the cause.

**Recommended response:** Decompose monthly revenue into order volume and AOV, compare category and customer segments, and evaluate whether repeat purchasing contributed to the slowdown.

### Finding 3 — Late deliveries are associated with lower review scores

Average review scores reportedly differ by delivery performance:

- Early deliveries: **4.29 / 5**
- On-time deliveries: **4.03 / 5**
- Late deliveries: **2.27 / 5**

The late-delivery score is approximately 47.1% lower than the early-delivery score, based on the relative difference between the two averages.

Regional analysis identifies Alagoas (AL) at a reported 21.41% breach rate, Maranhão (MA) at 17.43%, and Sergipe (SE) at 15.22%. Rio de Janeiro (RJ) reportedly accounts for 1,495 late orders, with a 12.11% breach rate.

**Why it matters:** Delivery failures are associated with a weaker customer review experience. High breach rates and high breach volumes represent different problems: some states have a greater proportion of late orders, while others contribute more late orders in absolute terms.

**Recommended response:** Prioritize carrier and route-level investigation in Rio de Janeiro and the identified Northeastern states. Compare promised versus actual delivery dates, carrier performance, origin-destination routes, and review scores before selecting corrective actions.

## 4. Recommended Action Plan

### Phase 1 — Immediate: 0–30 days
**Improve delivery reliability**

- Audit carrier performance and late-delivery causes in RJ, AL, MA, and SE.
- Identify routes with the highest breach rates and highest late-order volumes.
- Establish carrier-level service targets and monitor performance weekly.

**Success measures:** Late-delivery rate, late-order volume, and average review score for delayed orders.

### Phase 2 — Near term: 30–90 days
**Build a measurable retention program**

- Calculate customer-level repeat purchase rates using `customer_unique_id`.
- Identify high-performing product categories and complementary purchase patterns.
- Test post-delivery email campaigns and second-order incentives against a control group.

**Success measures:** Second-purchase rate, time to second order, incremental revenue, and campaign profitability.

### Phase 3 — Longer term: 90–180 days
**Improve delivery estimates and commercial performance**

- Develop route-level delivery estimates using historical transit performance.
- Test shorter delivery promises on routes with consistently reliable performance.
- Monitor checkout conversion and late-delivery rates together to ensure faster promises do not reduce reliability.

**Success measures:** Delivery-date accuracy, checkout conversion, breach rate, and customer review scores.

## 5. Analytical Approach and Data Integrity

The analysis uses SQL to examine marketplace sales, customer purchasing behavior, revenue trends, and delivery performance.

- **Join integrity:** Pre-aggregate order-item and payment data before joining independent one-to-many tables to prevent join fan-out from inflating financial metrics.
- **Customer identity:** Use `customer_unique_id` for customer-level repeat-purchase and lifetime analyses rather than treating every `customer_id` as a distinct person.
- **Time-series consistency:** Exclude the September–December 2016 pilot period from the specified production growth baseline, and apply consistent monthly boundaries.
- **Delivery analysis:** Compare estimated and actual delivery timestamps, classify delivery performance consistently, and analyze review scores by delivery status.
- **Validation:** Reconcile order counts, financial totals, date filters, and metric denominators across SQL scripts and this report.

## 6. Business Conclusion

The analysis highlights three priorities for Olist: improve repeat purchasing, investigate the causes of revenue deceleration, and reduce regional delivery failures.

The recommended strategy is to address the most significant delivery bottlenecks first, establish a measurable customer-retention program, and then improve delivery promises using route-level evidence. Progress should be evaluated using controlled tests and clearly defined KPIs rather than assumed business impacts.

**Project deliverables:** SQL data-integrity checks, sales and KPI analysis, customer-lifetime analysis, monthly revenue-growth analysis, delivery-SLA analysis, and this executive summary.

*Scope note: The dataset covers historical marketplace activity from 2016–2018. Findings describe the analyzed period and should not be interpreted as a statement of Olist's current performance.*
