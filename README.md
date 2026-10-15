# Ride Operations & Revenue Analytic

An end-to-end data analytics project using Python, PostgreSQL, and Power BI to analyze ride revenue, customer behavior, driver performance, and ride demand.

## Overview

This project analyzes ride-hailing data to understand business performance and identify opportunities to improve operations. It covers data cleaning, SQL-based analysis, and business insights.

## Dataset

The dataset contains three tables:

| Table | Records | Description |
|---|---:|---|
| Users | 10,000 | Customer information |
| Drivers | 300 | Driver details |
| Rides | 50,000 | Ride transactions |

**Source:** Kaggle

## Tools Used

- **Python:** Data cleaning and feature engineering
- **PostgreSQL:** SQL queries and business analysis
- **Power BI:** Data visualization and dashboard creation
- **DAX:** Measures and calculations

## Analysis

The project explores the following business questions:

- Which drivers generate the most revenue?
- Who are the highest-spending customers?
- Which locations have the highest ride demand?
- Which time slots generate the most revenue?
- How does ride behavior vary across age groups?
- Which trip categories contribute the most revenue?
- How does revenue change over time?

SQL analysis uses joins, aggregations, CTEs, and window functions to answer these questions.

## Key Insights

- Total revenue was approximately **$2.87 million** across nearly 50,000 rides.
- Morning and late-night slots generated the highest revenue.
- Long-distance trips contributed the largest share of revenue.
- Customers aged 41–60 completed the most rides.
- A small group of drivers generated a disproportionate share of revenue.
- Ride demand was concentrated in specific pickup locations.
- Monthly revenue remained relatively stable.

## Business Recommendations

- Increase driver availability during peak hours.
- Position drivers in high-demand locations.
- Reward high-performing drivers.
- Introduce loyalty programs for valuable customers.
- Use revenue trends to monitor business performance.
- Improve driver allocation based on demand patterns.

## Project Workflow

1. Clean and prepare the data using Python.
2. Load the processed data into PostgreSQL.
3. Run SQL queries to analyze business performance.
4. Visualize the findings using Power BI.

## Conclusion

This project demonstrates how Python, PostgreSQL, and Power BI can be used together to analyze business data, identify important trends, and support data-driven decisions.

---
**Author:** Rounit Kashyap
