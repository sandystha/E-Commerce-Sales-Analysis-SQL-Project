# E-Commerce-Sales-Analysis-SQL-Project

Project Overview

This project analyzes a retail e-commerce dataset stored in a star-schema data warehouse to generate actionable business insights. Using SQL only, I extracted insights on revenue trends, product and category performance, customer behavior, and sales efficiency.

The analysis uses joins, aggregations, CTEs, and window functions to provide a comprehensive view of business performance.

Problem Statement

A retail e-commerce company wants to analyze historical sales data to answer key business questions:

What are the revenue trends over time?

Which products and categories perform best?

How do customers behave, including repeat vs one-time buyers?

Which areas or product lines are most profitable?

Are there any shipment or operational inefficiencies?

Key Metrics
Metric	Value
Total Revenue	29,356,250
Total Quantity Sold	60,423
Unique Customers	18,484
Active Products	226
Repeat Customer Rate	37%

All metrics calculated using SQL aggregations, CTEs, and window functions.

Top Products
By Quantity
Product Name	Quantity Sold
Water Bottle – 30 oz.	4,249
Patch Kit (8 Patches)	3,191
Mountain Tire Tube	3,096
Road Tire Tube	2,376
By Revenue
Product Name	Revenue
Mountain-200 Black-46	1,373,454
Mountain-200 Black-42	1,363,128
Mountain-200 Silver-38	1,339,394
Mountain-200 Silver-46	1,301,029
Category / Product Line Revenue
Category	Revenue
Bikes	28,316,272
Accessories	700,262
Clothing	339,716
Product Line	Revenue
Road	14,622,850
Mountain	10,250,982
Touring	3,879,135
Other Sales	603,283
Customer Insights
Metric	Value / Details
Top Customer	Jordan Turner – 15,998
Top Revenue Countries	US, Australia, UK
Gender	Female slightly outspends Male
Marital Status	Married contributes slightly more revenue
Repeat Customer Rate	37%
Time-Based Analysis

Analyzed daily, monthly, and yearly revenue trends

Calculated Month-over-Month growth to identify seasonal peaks and performance changes

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
