drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category varchar(120),
name varchar (150) not null,
mrp numeric (8,2),
discount_percentage numeric(5,2),
available_quantity integer,
discount_selling_price numeric(8,2),
weight_in_gms integer,
out_of_stock boolean,
quantity integer
);

--data exploration 

--coun of rows
select count(*) from zepto;

--null values
select * from zepto
limit 10;

--null values
select * from zepto
where name is null 
or
category is null 
or
mrp is null 
or
discount_percentage is null 
or
available_quantity is null 
or
discount_selling_price is null 
or
weight_in_gms is null 
or
out_of_stock is null 
or
quantity is null;

--different product categories
select distinct category from zepto
order by category;

--products in stocks and products out of stocks
select out_of_stock, count(sku_id)
from zepto
group by out_of_stock;

--product names present multiple times 
select name, count(sku_id) as "no. of skus"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;


--data cleaning

--products with price = 0
select * from zepto
where mrp = 0 or discount_selling_price = 0;

delete from zepto
where mrp = 0;

--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discount_selling_price = discount_selling_price/100.0;

select mrp, discount_selling_price from zepto;

--Q1.Find the top 10 best-value product on the discount percentage.
 select distinct name, mrp, discount_percentage 
 from zepto
 order by discount_percentage desc
 limit 10;

--Q2.What are the products with high MRP but out of stock
select distinct name, mrp
from zepto
where out_of_stock = true and mrp > 300
order by mrp desc;

--Q3.Calculate estimated revenue for each category
select category,
sum(discount_selling_price * available_quantity) as total_revenue
from zepto
group by category
order by total_revenue;

--Q4.Find all products where MRP is greater then ₹500 and discount is less than 10%.
select distinct name, mrp, discount_percentage
from zepto
where mrp>500 and discount_percentage <10
order by mrp desc, discount_percentage desc;

--Q5.Identify the top 5 categories offering the highest average discount percentage.
select category,
round(avg(discount_percentage),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6.Find the price per gram for product above 100g and sort by best value.
select distinct name, weight_in_gms, discount_selling_price,
round(discount_selling_price/weight_in_gms,2) as price_per_gms
from zepto
where weight_in_gms >=100
order by price_per_gms;

--Q7.Group the product into categories like low, medium, bulk.
 select distinct name, weight_in_gms,
 case when weight_in_gms < 1000 then 'Low'
 when weight_in_gms < 5000 then 'Medium'
 else 'Bulk'
 end as weight_category
 from zepto;

 --Q8.What is the total inventory weight per category.
 select category,
 sum(weight_in_gms * available_quantity) as total_weight
 from zepto
 group by category
 order by total_weight;
