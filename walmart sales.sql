CREATE DATABASE IF NOT EXISTS walmart;
USE walmart;
CREATE TABLE sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT(20) NOT NULL,
vat FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4),
rating FLOAT(2, 1)
);
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

SELECT time,
(CASE 
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;
UPDATE sales
SET time_of_day = (
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);

SELECT date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

SELECT date,
MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

SELECT DISTINCT city FROM sales; 
SELECT DISTINCT branch, city FROM sales; 
SELECT COUNT(DISTINCT product_line) FROM sales;

SELECT payment, COUNT(payment) AS common_payment_method 
FROM sales GROUP BY payment ORDER BY common_payment_method DESC LIMIT 1;

SELECT product_line, count(product_Line) AS most_selling_product
FROM sales GROUP BY product_line ORDER BY most_selling_product DESC LIMIT 1;

SELECT month_name, SUM(total) AS total_revenue
FROM SALES GROUP BY month_name ORDER BY total_revenue DESC;

SELECT month_name, SUM(cogs) AS total_cogs
FROM sales GROUP BY month_name ORDER BY total_cogs DESC;

SELECT product_line, SUM(total) AS total_revenue
FROM sales GROUP BY product_line ORDER BY total_revenue DESC LIMIT 1;

SELECT city, SUM(total) AS total_revenue
FROM sales GROUP BY city ORDER BY total_revenue DESC LIMIT 1;

SELECT product_line, SUM(vat) as VAT 
FROM sales GROUP BY product_line ORDER BY VAT DESC LIMIT 1;

ALTER TABLE sales ADD COLUMN product_category VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;
UPDATE sales
SET product_category = 
  CASE 
    WHEN total >= (SELECT AVG(total) FROM (SELECT * FROM sales) AS temp) THEN 'Good'
    ELSE 'Bad'
  END;

SELECT branch, SUM(quantity) AS quantity
FROM sales GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC LIMIT 1;

SELECT gender, product_line, COUNT(gender) total_count
FROM sales GROUP BY gender, product_line ORDER BY total_count DESC;

SELECT product_line, ROUND(AVG(rating),2) average_rating
FROM sales GROUP BY product_line ORDER BY average_rating DESC;

SELECT day_name, time_of_day, COUNT(invoice_id) AS total_sales
FROM sales GROUP BY day_name, time_of_day HAVING day_name NOT IN ('Sunday','Saturday');

SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM sales WHERE day_name NOT IN ('Saturday','Sunday') GROUP BY day_name, time_of_day;

SELECT customer_type, SUM(total) AS total_sales
FROM sales GROUP BY customer_type ORDER BY total_sales DESC LIMIT 1;

SELECT city, SUM(VAT) AS total_VAT
FROM sales GROUP BY city ORDER BY total_VAT DESC LIMIT 1;

SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales GROUP BY customer_type ORDER BY total_VAT DESC LIMIT 1;

SELECT COUNT(DISTINCT customer_type) FROM sales;
SELECT COUNT(DISTINCT payment) FROM sales;
SELECT customer_type, COUNT(customer_type) AS common_customer
FROM sales GROUP BY customer_type ORDER BY common_customer DESC LIMIT 1;

SELECT customer_type, SUM(total) as total_sales
FROM sales GROUP BY customer_type ORDER BY total_sales LIMIT 1;

SELECT customer_type, COUNT(*) AS most_buyer
FROM sales GROUP BY customer_type ORDER BY most_buyer DESC LIMIT 1;

SELECT gender, COUNT(*) AS all_genders 
FROM sales GROUP BY gender ORDER BY all_genders DESC LIMIT 1;

SELECT branch, gender, COUNT(gender) AS gender_distribution
FROM sales GROUP BY branch, gender ORDER BY branch;

SELECT time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY time_of_day ORDER BY average_rating DESC LIMIT 1;

SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY branch, time_of_day ORDER BY average_rating DESC;

SELECT branch, time_of_day,
AVG(rating) OVER (PARTITION BY branch) AS ratings
FROM sales;

SELECT day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name ORDER BY average_rating DESC LIMIT 1;

SELECT  branch, day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name, branch ORDER BY average_rating DESC;

SELECT branch, day_name,
AVG(rating) OVER (PARTITION BY branch) AS rating
FROM sales
ORDER BY rating DESC;


