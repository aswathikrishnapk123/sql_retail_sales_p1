--sql retail sales analysis project -p1


--create table
create table retail_sales
	(transactions_id INT primary key,
	sale_date Date,
	sale_time Time,
	customer_id INT,
	gender varchar(15),
	age INT,
	category varchar(15),
	quantiy INT,
	price_per_unit float,
	cogs float,
	total_sale float
);
select * from retail_sales
limit 10;
select count(*) from retail_sales;

--data cleaniing
select * from retail_sales 
where  transactions_id is null

select * from retail_sales 
where  sale_date is null

select * from retail_sales 
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or 
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

delete  from retail_sales 
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or 
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;

--data exploration
--how many sales we have?
select count(*) as total_sales from retail_sales;
	
--how many unique customers we have?
select count(DISTINCT customer_id) as total_sales from retail_sales;
select  distinct category from retail_sales;

--data analysis and business key problems and answers
--my analysis and findings
-- 1. write a sqsl query to retrieve all columns foe sales on "2022-11-05"
select * from retail_sales 
where sale_date = '2022-11-05' ;


-- 2. write a sql query to retrieve all transactions where the category is "clothing" an the quantity sold is more than 4 in the month of nov-2022
select *
from retail_sales 
where 
	category='Clothing'
	and 
	TO_CHAR(sale_date,'yyyy-MM')='2022-11'
	AND
	quantiy>=4;


--3. write a sql query to calculate the total sales (total_sale) for each category
select 
	category,
	sum(total_sale) as net_sale 
from retail_sales
group by 1


--4. write a sql query to find the average age of customers who purchased items from the beauty category.
select
	round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'


--5. write a sql query to find all transaction where the total sale is greater than 1000
select * from retail_sales 
where total_sale >1000



--6.write a sql query to find the total number of transaction(transactions_id ) made by each gender in each category.
select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group
	by
	 category,
	 gender
order by 1


--7. write a sql query to calculate the average sales for each another . find out best selling month in each year.
select
	year,
	month,
	avg_sale
from
(
select
	extract(year from sale_date) as year,
	extract (month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc ) as rank
	from retail_sales
	group by 1,2
	) as t1
	where rank=1
--order by 1,3 desc


--8. write a sql query to find out the top 5 customers based on the highest total sales
select 
	customer_id,
	sum(total_Sale) as total_sales
from retail_sales 
group by 1
order by 2 desc
limit 5


--9. write a sql query to find the number of unique customers who purchased item from each category.
select 
	category,
	count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category

--10. write a sql query to create shift and number of order (example  morning<=12, afternoon between 12&17, evening >17)
with hourly_sale
as 
(
select *,
	case
		when extract (hour from sale_time) <12 then 'morning'
		when extract (hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select 	
	shift,
	count(*) as total_orders
from hourly_sale 
group by shift


--end of project










