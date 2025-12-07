select * from gold.dim_customers
select * from gold.dim_products
select * from gold.fact_sales

--Problem Statement 

--A retail e-commerce company wants to analyze its sales performance using historical data stored in a star-schema data warehouse.
--The leadership team wants insights on:

--Revenue trends
--Product & category performance
--Customer buying behavior
--Profitability & quantity trends
--Shipment efficiency

--BUSINESS QUESTIONS 


--A. BASIC SALES ANALYSIS

--1 What is the total revenue? (SUM of sales_amount)
select sum(sales_amount) as Total_Revenue from gold.fact_sales
--2️ What is the total quantity sold?
select sum(quantity) as Quantity_Sold from gold.fact_sales
--3️ How many unique customers made purchases?
select count(distinct customer_key) as unique_customer from gold.fact_sales
--4️ How many products are active?
select count(*) as active_products from gold.dim_products
where lower(maintenance)='yes'

--B.PRODUCT PERFORMANCE ANALYSIS

--5 Top 10 best-selling products (quantity)
with Ten_best_selling_products as (
	select 
		p.product_key,
		p.product_name,
		sum(quantity) as Total_quantity,
		dense_rank() over(order by sum(quantity)  desc) as rk 
	from gold.dim_products as p
	join gold.fact_sales as s
	on p.product_key=s.product_key
	group by p.product_key,
		p.product_name
)
select product_key,product_name,Total_quantity from Ten_best_selling_products
where rk<=10;

--6️ Top 10 highest revenue-generating products
with Ten_best_selling_products as (
	select 
		p.product_key,
		p.product_name,
		sum(sales_amount) as Revenue,
		dense_rank() over(order by sum(sales_amount)  desc) as rk 
	from gold.dim_products as p
	join gold.fact_sales as s
	on p.product_key=s.product_key
	group by p.product_key,
		p.product_name
)
select product_key,product_name,Revenue from Ten_best_selling_products
where rk<=10;
--7 Category-wise revenue
select 
	category ,
	sum(sales_amount) as Revenue
from gold.dim_products as p
join gold.fact_sales as s 
on p.product_key=s.product_key
group by category
order by Revenue desc
--8 Sub-category wise revenue
select 
	subcategory ,
	sum(sales_amount) as Revenue
from gold.dim_products as p
join gold.fact_sales as s 
on p.product_key=s.product_key
group by subcategory
order by Revenue desc
--9 Category-wise profit = sales_amount – (cost * quantity)
SELECT 
    p.category,
    SUM(s.sales_amount) AS total_revenue,
    SUM(p.cost * s.quantity) AS total_cost,
    SUM(s.sales_amount - (p.cost * s.quantity)) AS total_profit
FROM gold.dim_products p
JOIN gold.fact_sales s 
    ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_profit DESC;

--10 Which product_line performs best?
select 
	product_line,
	sum(sales_amount) as Total_Revnue 
from gold.dim_products as p
join gold.fact_sales as s
on p.product_key=s.product_key
group by product_line
order by Total_Revnue desc

--C. CUSTOMER ANALYSIS

--11 Top customers by total spending
with top_spending_customers as (
	select 
		CONCAT(first_name,' ',last_name) as Full_Name ,
		sum(sales_amount) as Total_Revenue,
		DENSE_RANK() over(order by sum(sales_amount) desc ) as rk	
	from gold.dim_customers as c
	join  gold.fact_sales as g
	on c.customer_key=g.customer_key
	group by CONCAT(first_name,' ',last_name)
)
select Full_Name,Total_Revenue from top_spending_customers
where rk=1
--12 Customers who purchased only once
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM gold.dim_customers c
JOIN gold.fact_sales s
    ON c.customer_key = s.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
HAVING COUNT(DISTINCT s.order_number) = 1
ORDER BY full_name;

--13 Repeat customer rate
WITH customer_orders AS (
    SELECT 
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders
    FROM gold.fact_sales
    GROUP BY customer_key
)
SELECT
    ROUND(100.0 * SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_customer_rate_percent,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM customer_orders;

--14 Country-wise revenue
select 
	country,
	sum(sales_amount) as Total_Revenue
from gold.dim_customers as c
join gold.fact_sales as s
on c.customer_key=s.customer_key
group by country
order by Total_Revenue desc
--15 Gender-wise spending
select 
	gender,
	sum(sales_amount) as Total_Revenue
from gold.dim_customers as c
join gold.fact_sales as s
on c.customer_key=s.customer_key
group by gender
order by Total_Revenue desc
--16 Which marital_status group spends more?
select 
	marital_status,
	sum(sales_amount) as Total_Revenue
from gold.dim_customers as c
join gold.fact_sales as s
on c.customer_key=s.customer_key
group by marital_status
order by Total_Revenue desc

--D. TIME-BASED ANALYSIS

--17 Daily revenue trend

select 
	DATEPART(DAY,order_date) as Day ,
	sum(sales_amount) as Revenue
from gold.fact_sales
where DATEPART(DAY,order_date) is not null
group by DATEPART(DAY,order_date)
order by DATEPART(DAY,order_date)

--18 Monthly revenue trend
select 
	MONTH(order_date) as month ,
	sum(sales_amount) as Revenue
from gold.fact_sales
where MONTH(order_date) is not null
group by MONTH(order_date)
order by MONTH(order_date)
--19 Yearly revenue trend
select 
	Year(order_date) as year ,
	sum(sales_amount) as Revenue
from gold.fact_sales
where Year(order_date) is not null
group by Year(order_date)
order by Year(order_date)
--20 Running total revenue (Window Function)
select 
	order_date, 
	sum(sales_amount) as revenue,
	sum(sum(sales_amount)) over(order by order_date) Running_Total
from  gold.fact_sales 
where order_date is not null
group by order_date

--21 Average shipping time = shipping_date – order_date
select avg(DATEDIFF(DAY,order_date,shipping_date)) as avg_shipping_days  from gold.fact_sales

--E. PROFITABILITY & COST ANALYSIS

--22 Profit per product → sales_amount – (cost * quantity)
select 
	product_name,
	 SUM(s.sales_amount - (p.cost * s.quantity)) AS total_profit	
from gold.dim_products as p
join gold.fact_sales as s
on p.product_key=s.product_key
group by product_name
order by total_profit desc
--23 Most profitable product categories
select 
	category,
	 SUM(s.sales_amount - (p.cost * s.quantity)) AS total_profit	
from gold.dim_products as p
join gold.fact_sales as s
on p.product_key=s.product_key
group by category
order by total_profit desc
--24 Products with negative profit (selling below cost)
select 
	product_name,
	 SUM(s.sales_amount - (p.cost * s.quantity)) AS total_profit	
from gold.dim_products as p
join gold.fact_sales as s
on p.product_key=s.product_key
group by product_name
having SUM(s.sales_amount - (p.cost * s.quantity))<0
order by total_profit desc
--25 Profit margin % by product_line
SELECT 
    p.product_line,
    SUM(s.sales_amount - (p.cost * s.quantity)) AS total_profit,
    SUM(s.sales_amount) AS total_revenue,
    ROUND(SUM(s.sales_amount - (p.cost * s.quantity)) * 100.0 / SUM(s.sales_amount), 2) AS profit_margin_percent
FROM gold.dim_products p
JOIN gold.fact_sales s
    ON p.product_key = s.product_key
GROUP BY p.product_line
ORDER BY profit_margin_percent DESC;

--F. SHIPPING & OPERATIONS

--26 Late deliveries → shipping_date > due_date
SELECT 
    order_number,
    customer_key,
    order_date,
    shipping_date,
    due_date,
    DATEDIFF(day, due_date, shipping_date) AS days_late
FROM gold.fact_sales
WHERE shipping_date > due_date
ORDER BY days_late DESC;

--27 Average shipping delay
SELECT 
    ROUND(AVG(DATEDIFF(day, due_date, shipping_date)), 2) AS avg_shipping_delay_days
FROM gold.fact_sales
WHERE shipping_date > due_date;

--28 Fast vs slow shipping regions (based on customer country)
SELECT 
    c.country,
    ROUND(AVG(DATEDIFF(day, due_date, s.shipping_date)), 2) AS avg_shipping_delay_days,
    COUNT(*) AS total_orders
FROM gold.fact_sales s
JOIN gold.dim_customers c
    ON s.customer_key = c.customer_key
WHERE s.shipping_date > s.due_date   
GROUP BY c.country
ORDER BY avg_shipping_delay_days ASC;

--G. ADVANCED / INTERVIEW-LEVEL

--29 RFM metrics (using customer_key + order_date + sales_amount)
WITH last_order AS (
    SELECT 
        customer_key,
        MAX(order_date) AS last_order_date,
        COUNT(*) AS frequency,
        SUM(sales_amount) AS monetary
    FROM gold.fact_sales
    GROUP BY customer_key
)
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    DATEDIFF(day, last_order.last_order_date, GETDATE()) AS recency_days,
    last_order.frequency,
    last_order.monetary
FROM last_order
JOIN gold.dim_customers c
    ON last_order.customer_key = c.customer_key
ORDER BY monetary DESC;

--30 Cohort analysis by customer create_date
SELECT
    DATETRUNC(MONTH, c.create_date) AS cohort_month,
    DATETRUNC(MONTH, s.order_date) AS order_month,
    COUNT(DISTINCT s.customer_key) AS active_customers
FROM gold.dim_customers c
JOIN gold.fact_sales s
    ON c.customer_key = s.customer_key
GROUP BY DATETRUNC(MONTH, c.create_date) , DATETRUNC(MONTH, s.order_date)
ORDER BY cohort_month, order_month;

select * from gold.dim_customers

--31 Month-over-month growth for revenue
WITH monthly_revenue AS (
    SELECT 
        DATETRUNC(MONTH, order_date) AS month,
        SUM(sales_amount) AS revenue
    FROM gold.fact_sales
    GROUP BY DATETRUNC(MONTH, order_date) 
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) * 100.0 / LAG(revenue) OVER (ORDER BY month)), 2) AS mom_growth_percent
FROM monthly_revenue
ORDER BY month;


--32 Product demand forecasting base table (moving averages)
SELECT 
    s.product_key,
    p.product_name,
    DATETRUNC(MONTH, s.order_date) AS month,
    SUM(s.quantity) AS total_quantity,
    ROUND(AVG(SUM(s.quantity)) OVER (PARTITION BY s.product_key ORDER BY DATETRUNC(month, s.order_date) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_3_months
FROM gold.fact_sales s
JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY s.product_key, p.product_name,DATETRUNC(MONTH, s.order_date)
ORDER BY s.product_key, month;

