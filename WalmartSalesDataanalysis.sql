CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoices_id varchar (30) not null primary key,
branch varchar( 5) not null,
city varchar (30) not null,
customer_type varchar (30) not null,
gender varchar (10) not null,
product_line varchar (30) not null,
unit_price decimal(10, 2) not null,
quantity int not null,
VAT Float (6, 4) not null,
total Decimal (12.4) not null,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method varchar(15) not null,
cogs decimal (10, 2) not null,
gross_margin_pct Float(11, 9),
gross_income Decimal (12, 4) not null,
rating float (2, 1)
);


---- -------------------------------------------------------------------------------------------
---- ----------------------- Feature Engineering -----------------------------------------------

-- time_of_day

select
 time,
  (case 
     when 'time' between "00:00:00" and "12:00:00" then "Morning"
     when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
     else "Evening"
end
     ) As time_of_day
From sales;

alter table sales add column time_of_day varchar(20);

update sales 
set time_of_day =  
 (case 
     when 'time' between "00:00:00" and "12:00:00" then "Morning"
     when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
     else "Evening"
end);


--  day_name
select 
date,
 dayname(date) as day_name
from sales;

alter table sales add column day_name varchar (10);

update sales 
set day_name = dayname(date);

-- month_name

select
date,
monthname(date)
from sales;

alter table sales add column month_name varchar (10);

update sales 
set month_name = monthname(date);
-- ----------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------
-- ----------------------------Generic ----------------------------------------------------

-- How many unique Cities does the data have?

select 
distinct
 city
from sales;
-- In which city is each branch?

select 
distinct
 branch
from sales;

select 
distinct
 city, branch
from sales;

-- -------------------------------------------------------------------------------------------
-- --------------------------------- Product -----------------------------------------------

-- How many unique product lines does my data have ?
select 
count(distinct product_line)
from sales;

-- What is the most common payment method?

select  
payment_method,
count(payment_method) as total_payment_method
from sales
group by payment_method
order by total_payment_method desc;

-- What is the most selling product line?

select 
* 
from sales ;

select  
product_line,
count(product_line) as total_selling_pdct
from sales
group by product_line
order by total_selling_pdct desc;

-- What is the total revenue by month ?
select 
month_name as month ,
sum(total) as total_monthly_revenue
from sales
group by month_name
order by   total_monthly_revenue desc;

-- what month had the largest COGS
select 
month_name as month ,
sum(cogs) as total_cogs
from sales
group by month_name
order by total_cogs desc;

-- What product line had the largest revenue

select 
product_line ,
sum(total) as total_rev_product_line
from sales
group by product_line
order by total_rev_product_line  desc;

-- What is the city/branch with the largest revenue?
select 
city, branch,
sum(total) as total_revenue
from sales 
group by city, branch
order by total_revenue desc;

-- What product line had the largest VAT?

select 
product_line ,
avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;


-- Which branch sold more products than average product sold ?

select  
branch, sum(quantity) as qty
from sales 
group by branch 
having sum(quantity ) > (select avg(quantity) from sales);

-- What is the most common product line by gender?

select
gender, 
product_line ,
count(gender) as product_by_gender
from sales
group by gender, product_line
order by  product_by_gender desc;

-- What is the Average rating of each product line ?

select 
product_line, 
round(avg(rating), 2) as avg_rating_pdct
 from sales 
 group by product_line
 order by avg_rating_pdct desc;

-- -------------------------------------------------------------------------------------------
-- ------------------------- Sales -----------------------------------------------------------

-- Number of sales made in each time of the day  per week day

select 
time_of_day,
count(*) as total_sales
from sales
where day_name = "sunday"
group by time_of_day
order by total_sales;
 
 -- Which of the customer type brings the most revenue?
  select 
  customer_type,
  sum(total) as total_rev
  from sales
  group by customer_type
  order by total_rev desc;
  
  -- Which city haS the largest VAT?
  select 
  city,
  avg(VAT) as AVG_VAT_CITY
  from sales 
  group by city 
  order by AVG_VAT_CITY DESC;
 
 --  Which customer type pays the most in VAT?
 select 
  customer_type,
  avg(VAT) as AVG_VAT_CITY
  from sales 
  group by customer_type
  order by AVG_VAT_CITY DESC;
 
 -- ------------------------------------------------------------------------------------------
 -- ---------------------------- Customers  --------------------------------------------------
  --  How many unique customer types does the data have ?
 
 select 
  distinct customer_type,
  count(invoices_id) as count_customers
  from sales
  group by customer_type
  order by count_customers desc;
  
  -- How many unique payment methods does thew data have?
  select
  distinct payment_method
  from sales;
 
  -- What is the most common customer type?
  select  
  distinct customer_type 
  from sales;
 
 -- which customer type buys the most ?
 select 
 customer_type,
 count(quantity ) as total_purchase
 from sales 
 group by customer_type
 order by total_purchase desc;

--- option 2
 select 
 customer_type,
 count(*) as total_purchase
 from sales 
 group by customer_type
 order by total_purchase desc;
 
-- what is the gender of most of the customer?

select
gender,
count(*) as gender_count
from sales
group by gender 
order by gender_count desc;

-- -- what is the gender of most of the customer per branch?

select
gender, branch,
count(*) as gender_count
from sales
where branch = 'C'
group by gender ,branch
order by gender_count desc;

-- Which time of the day do customers give most ratings?

 select 
 time_of_day,
 avg(rating) as avg_rating
 from sales
 group by time_of_day
 order by avg_rating desc ;
 
 -- Which time of the day do customer give more rating per branch
 
  select 
 time_of_day, branch,
 avg(rating) as avg_rating
 from sales
 group by time_of_day, branch
 order by avg_rating desc ;
 
 -- option 2 
 select 
 time_of_day, 
 avg(rating) as avg_rating
 from sales
 where branch = 'C'
 group by time_of_day, branch
 order by avg_rating desc ;

 -- Which day of the week has the most ratings?
 select 
 day_name, 
 avg(rating) as avg_rating
 from sales
 group by day_name
 order by avg_rating desc ;
 
 -- Which day of the week has the best average rating per branch?
 select 
 day_name, branch,
 avg(rating) as avg_rating
 from sales
 -- or use this instead of add the branch as aggregate function where branch = 'B'
 group by day_name, branch
 order by avg_rating desc ;
 
 -- ------------------------------------------------------------------------------------------
 ----------------------- Revenue And Profit Calcculations ------------------------------------
 
 -- $ COGS = Units price * Quantity $
 
 select
 product_line,
 unit_price, 
 (unit_price* quantity) as cal_COGS
 from sales;
  
 -- $VAT = 5%*COGS $
 
 SELECT
 product_line,
cogs  , (cogs* 0.05) as cal_VAT
 FROM sales;
 
 -- $ Total (gross_sales) = VAT + COGS $
  select
  product_line,
  VAT,
  cogs,
  (VAT + cogs) as gross_sales
  FROM sales;
  
  -- $ gross profit (gross income) = total(gross_sales)-COGS$
  SELECT 
  product_line,
  total,
  cogs,
  (total-cogs) as gross_income 
  from sales ;
  
  -- $ gross margin ( gross profit) = gross income / revenue$
  
  select 
  product_line,
  gross_income,
  (gross_income/ total)*100 as gross_margin 
  from sales ;
  
  
 
 -- 
 
 
 
update sales 
set day_name = dayname(date);
 
-- Fetch each column line and add a column to those product line showing "good", "bad". Good if its greater than
-- average sales

 