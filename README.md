E-Commerce Sales Analysis – SQL Project

Project Overview

This project analyzes a retail e-commerce dataset stored in a star-schema data warehouse to generate actionable business insights. Using SQL only, insights on revenue trends, product & category performance, customer behavior, and sales efficiency were extracted.

The analysis uses joins, aggregations, CTEs, and window functions to provide a comprehensive view of business performance.

Problem Statement

A retail e-commerce company wants to analyze historical sales data to answer key business questions:

What are the revenue trends over time?

Which products and categories perform best?

How do customers behave, including repeat vs one-time buyers?

Which areas or product lines are most profitable?

Are there any shipment or operational inefficiencies?

Key Metrics
| Metric               | Value      |
|---------------------|-----------|
| Total Revenue        | 29356250  |
| Total Quantity Sold  | 60423     |
| Unique Customers     | 18484     |
| Active Products      | 226       |
| Repeat Customer Rate | 37%       |

Top Products
By Quantity

| Product Name          | Quantity Sold |
|----------------------|---------------|
| Water Bottle 30 oz    | 4249         |
| Patch Kit (8 Patches) | 3191         |
| Mountain Tire Tube    | 3096         |
| Road Tire Tube        | 2376         |

By Revenue

| Product Name           | Revenue     |
|-----------------------|------------|
| Mountain-200 Black-46  | 1373454    |
| Mountain-200 Black-42  | 1363128    |
| Mountain-200 Silver-38 | 1339394    |
| Mountain-200 Silver-46 | 1301029    |

By Category

| Category    | Revenue    |
|------------|-----------|
| Bikes       | 28316272 |
| Accessories | 700262   |
| Clothing    | 339716   |


By Product Line

| Product Line | Revenue   |
|-------------|-----------|
| Road        | 14622850 |
| Mountain    | 10250982 |
| Touring     | 3879135  |
| Other Sales | 603283   |

Customer Insights

| Metric                 | Value / Details               |
|------------------------|-------------------------------|
| Top Customer           | Jordan Turner – 15998        |
| Top Revenue Countries  | US, Australia, UK            |
| Gender                 | Female slightly outspends Male |
| Marital Status         | Married contributes slightly more revenue |
| Repeat Customer Rate   | 37%                          |


Time-Based Analysis

Analyzed daily, monthly, and yearly revenue trends

Calculated Month-over-Month growth to identify seasonal peaks

SQL Skills Demonstrated

Joins (INNER, LEFT)

Aggregations (SUM, COUNT, AVG)

CTEs (Common Table Expressions)

Window Functions (DENSE_RANK, ROW_NUMBER, LAG, SUM OVER)

Trend analysis and customer segmentation

Impact / Business Value

Identified top-performing products & categories

Understood repeat customer behavior

Highlighted key revenue markets

Provided a SQL-based foundation for reporting or dashboarding
