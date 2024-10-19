Create Database WALMART;
USE WALMART;
CREATE TABLE SALES( 
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30) not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date datetime not null,
time time not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9),
gross_income decimal(12,4) not null,
rating float(2,1)
);



-- ------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------FEATURE ENGINEERING---------------------------------------------------------------
-- 1. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon, Evening. This will help the answer the question
--    on which part of the day most sales are made.

-- TIME_OF_DAY

SELECT 
     TIME,
         (CASE
            WHEN `TIME` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
			WHEN `TIME` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
            ELSE "EVENING"
            
		END) AS TIME_OF_DATE
FROM SALES;
        
ALTER TABLE SALES ADD COLUMN TIME_OF_DAY VARChar(20);

update sales
set time_of_day = (CASE
            WHEN `TIME` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
			WHEN `TIME` BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
            ELSE "EVENING"
            
		END);


-- 2. Add a new column named day_name that contains the extracted day of the week on which the given transcation took place. This will help
--    answer the question on which week of the day each branch is busiest.

-- Day_name

SELECT 
	DATE,
        DAYNAME(DATE)
FROM SALES;

ALTER TABLE SALES ADD COLUMN day_name varchar(10);

UPDATE SALES
SET day_name = DAYNAME(DATE);

-- 3. Add a new named month_name that contains the extracted months of the year on which the given transcation took place. Help determine
--    which month of the year has the most sales and profit.

-- Month_name

SELECT
     DATE,
     MONTHNAME(date)
FROM SALES;

ALTER TABLE SALES ADD COLUMN Month_name varchar(10);

UPDATE SALES
SET Month_name = MONTHNAME(DATE);

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------GENRIC------------------------------------------------------------------------

-- 1. How many unique cities doe sthe data have ?

select distinct city
from sales;

-- 2. In which city is each branch ?

Select distinct city, branch
from sales;
-- ------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------PRODUCT-------------------------------------------------------------------

-- 1. How many unique product lines does thwe data have ?

SELECT COUNT(DISTINCT PRODUCT_LINE)
FROM SALES;

-- 2. What is the most common payment method ?

SELECT PAYMENT_METHOD, COUNT(PAYMENT_METHOD)
FROM SALES
group by PAYMENT_METHOD
ORDER BY COUNT(PAYMENT_METHOD)
DESC;

-- 3. What is the most selling product line ?

SELECT PRODUCT_LINE, COUNT(PRODUCT_LINE) AS MOST
FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY MOST 
DESC LIMIT 1;

-- 4. What is the total revenue by month ?

SELECT MONTH_NAME, SUM(TOTAL)
FROM SALES
GROUP BY MONTH_NAME
ORDER BY SUM(TOTAL);

-- 5. What month had the largest Cogs ?

SELECT MONTH_NAME AS MONTH, SUM(COGS) AS COGS
FROM SALES 
GROUP BY MONTH_NAME
ORDER BY SUM(COGS)
DESC LIMIT 1;

-- 6. What product line had the largest revenue ?

SELECT PRODUCT_LINE, SUM(TOTAL) AS REVENUE
FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY SUM(TOTAL)
DESC LIMIT 1;

-- 7. WHAT IS THE CITY WITH THE LARGEST REVENUE ?

SELECT CITY, SUM(TOTAL) AS REVENUE
FROM SALES
GROUP BY CITY
ORDER BY SUM(TOTAL)
DESC LIMIT 1;

-- 8. What product line had the largest VAT ?

SELECT PRODUCT_LINE, AVG(VAT)
FROM SALES
GROUP BY PRODUCT_LINE
ORDER BY AVG(VAT)
DESC LIMIT 1;

-- 9. Which branch sold more products than average product sold ?

SELECT BRANCH, SUM(QUANTITY) AS QTY
FROM SALES 
GROUP BY BRANCH
HAVING SUM(QUANTITY)>(SELECT AVG(QUANTITY)
					  FROM SALES);

-- 10. What is the most common product line by gender ?

SELECT GENDER, PRODUCT_LINE, COUNT(GENDER)
FROM SALES
GROUP BY GENDER, PRODUCT_LINE
ORDER BY COUNT(GENDER)
DESC;

-- 11. What is the average rating of each product line ?

SELECT PRODUCT_LINE, AVG(RATING)
FROM SALES
GROUP BY PRODUCT_LINE;


-- ------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------SALES---------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday ? 
 
SELECT TIME_OF_DAY, DAY_NAME, COUNT(*) AS TOTAL_SALES
FROM SALES
WHERE DAY_NAME="MONDAY"
GROUP BY TIME_OF_DAY
ORDER BY TOTAL_SALES;

-- 2. Which of the customer types brings the most revenue ?

SELECT CUSTOMER_TYPE, SUM(TOTAL) AS REVENUE
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY REVENUE DESC;

-- 3. Which City has the largest tax percent/VAT(VALUE ADDED TAX) ?

SELECT CITY, AVG(VAT) AS VAT
FROM SALES
GROUP BY CITY
ORDER BY VAT
DESC;

-- 4. Which customer type pays the most in VAT ?

SELECT CUSTOMER_TYPE, AVG(VAT) AS VAT
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY VAT
DESC;

-- ------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------CUSTOMER--------------------------------------------------------------------

-- 1. How many unique customer types does the data have ?

SELECT DISTINCT CUSTOMER_TYPE
FROM SALES;

-- 2. How many unique payment method does the data have ?

SELECT DISTINCT PAYMENT_METHOD
FROM SALES;

-- 3. What is the most common customer type ?

SELECT DISTINCT CUSTOMER_TYPE, COUNT(CUSTOMER_TYPE) AS COM
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY COM DESC
LIMIT 1;

-- 4. What customer type buys the most ?

SELECT CUSTOMER_TYPE, COUNT(*) AS MOS
FROM SALES
GROUP BY CUSTOMER_TYPE
ORDER BY MOS DESC;

-- 5. What is the gender of most of the customer ?

SELECT GENDER, COUNT(*) AS MOS
FROM SALES
GROUP BY GENDER
ORDER BY MOS DESC;

-- 6. What is the gender distribution per branch ?

SELECT GENDER, COUNT(*) AS G_D
FROM SALES
WHERE BRANCH = "A"
GROUP BY GENDER;

-- 7. Which time of the day do customer give most rating ?

SELECT TIME_OF_DAY, AVG(RATING) AS AVG_RATING 
FROM SALES
GROUP BY TIME_OF_DAY
ORDER BY AVG_RATING
DESC;

-- 8. Which time of the day do customers give most rating per branch ?

SELECT TIME_OF_DAY, AVG(RATING) AS AVG_RATING 
FROM SALES
WHERE BRANCH = "A"
GROUP BY TIME_OF_DAY
ORDER BY AVG_RATING
DESC;

-- 9. Which day for the week has the best avg ratings ?

SELECT DAY_NAME, AVG(RATING) AS AVG_RATING
FROM SALES
GROUP BY DAY_NAME
ORDER BY AVG_RATING;

-- 10. Which day of the week has the best average rating per branch ?

SELECT DAY_NAME, AVG(RATING) AS AVG_RATING
FROM SALES
WHERE BRANCH = "A"
GROUP BY DAY_NAME
ORDER BY AVG_RATING
DESC;