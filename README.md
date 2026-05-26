# Customer Profiling Using RFM Analysis and K-Means Clustering

## 📋 Project Overview

This project performs **customer segmentation** using RFM (Recency, Frequency, Monetary) analysis combined with K-Means clustering on the UCI Online Retail II dataset. The goal is to identify distinct customer segments to enable targeted marketing strategies and improve customer lifetime value (CLV).

### Business Problem

The marketing team needs to move beyond one-size-fits-all campaigns. By understanding natural customer groupings based on purchasing behavior, we can:
- Allocate marketing budget more effectively
- Design segment-specific retention strategies
- Identify high-value customers for loyalty programs
- Detect at-risk customers before churn

### Key Results

- **4 distinct customer segments** identified
- **Top 19% of customers** (Champions) generate 60% of revenue
- **35% of customers** identified as at-risk requiring re-engagement


---

## 🗂️ Dataset

**Source:** (https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)

**Description:** Transaction data from a UK-based online retailer (2010-2011)

| Metric | Value |
|--------|-------|
| Total transactions | 1,067,371 |
| Unique customers | 3,920 (UK only) |
| Date range | Dec 2010 - Dec 2011 |
| Features | InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country |

---

## 📊 Results

### Segment Profiles

| Segment | Size | Recency (days) | Frequency | Monetary (£) | Marketing Priority |
|---------|------|----------------|-----------|--------------|-------------------|
| **Champions** | 19% | 25 | 19.8 | 10 322 | VIP treatment |
| **Loyal** | 25% | 216 | 5.5 | 2012 | Cross-sell |
| **At-Risk** | 21% | 28 | 3.1 | 843 | Re-engagement |
| **New/Occasional** | 35.1% | 394 | 1.4 | 329 | Onboarding |

### Visualizations

Elbow Method
- Optimal K selection using elbow method

Monetary Distribution by Segment
- Monetary value distribution across segments

---

## 💡 Recommendations

### Champions (19% of customers)
- **Action:** Exclusive loyalty program, early access to new products
- **Goal:** Increase retention and cross-sell premium items

### Loyal Customers (25% of customers)
- **Action:** Product recommendations based on history, referral bonuses
- **Goal:** Upgrade to Champion status

### At-Risk Customers (21% of customers)
- **Action:** "We miss you" email with 15-20% discount
- **Goal:** Win back before complete churn

### New/Occasional Customers (35.1% of customers)
- **Action:** Welcome series, educational content, second-purchase incentive
- **Goal:** Convert to regular buyers

