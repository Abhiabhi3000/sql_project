-- SQL Retail Sales Analysis - p1
CREATE DATABASE sql_project_p1;

-- Create Table
CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,	
	sale_time TIME,	
	customer_id	INT,
	gender VARCHAR(15),	
	age INT,	
	category VARCHAR(15),	
	quantiy INT,	
	price_per_unit FLOAT,	
	cogs FLOAT,	
	total_sale FLOAT
);

-- Data Cleaning
SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactionS_id IS NULL;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR 	
	cogs IS NULL
	OR 	
	total_sale IS NULL; 

--

DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR 
	gender IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR 	
	cogs IS NULL
	OR 	
	total_sale IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT(customer_id)) FROM retail_sales;
SELECT * FROM RETAIL_SALES;

SELECT DISTINCT category FROM retail_sales;

-- Data Analyis & Business Key Problems & Answers

-- Q1) Write sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q2) Write sql query to to retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales 
WHERE 
	category = 'Clothing' 
	and 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	and
	quantiy >= 4;

-- Q3) Write a sql query to calculate the total sales (total_sale) for each category
SELECT
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4) Write a sql query to find the average age of of customers who purchased items from the 'Beauty' category
SELECT
	ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5) Write a sql query to find all transactions where the total sale is greater than 1000
SELECT * FROM retail_sales WHERE total_sale > 1000;

-- Q6) Write a sql query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT
	category,
	gender,
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7) Write a sql query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
		(SELECT
			EXTRACT(YEAR FROM sale_date) AS year,
			EXTRACT(MONTH FROM sale_date) AS month,
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY 1,2) as t1
WHERE rank = 1;

-- Q8) Write sql query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9) Write sql query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT(customer_id)) unique_customers
FROM retail_sales
GROUP BY category;

-- Q10) Write sql to create each shift and number of orders (Example morning <=12, Afternoon between 12 and 17 , evening > 17)
WITH hourly_sales AS(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
)

SELECT shift, COUNT(*) AS total_orders FROM hourly_sales GROUP BY shift;

-- END OF PROJECT