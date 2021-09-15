-- Superstore has around 1800+ customers across North-America, they have 4 division orders,
--  shipping, products, research. They have 17 products and 3 product categories furniture,
--  office supplies, technology and 17 sub categories. Furniture has 4 sub categories, 
--  they are Bookcases, Chairs & Chair mats, Office furnishing, and Tables. 
--  Office supplies has the most sub categories under it. 
--  There are about 9 sub categories, they are appliances, binder and binder accessories,
--  envelopes, labels, paper, pens and art supplies, rubber bands, scissors, rulers 
--  and trimmers, storage and organization. Finally, technology category has
--  computer peripherals, copiers and fax, office machines, telephones and communication. 
--  Currently there are around 1137 High priority orders, 1124 Low priority orders, 
--  1080 Not specified, 1075 Medium and 1090 critical cases. There are 13 provinces 
--  and 8 regions with over 1832 customers. The average profit is around $181.18 
--  and average order quantity is 26 items. There are about 5496 items shipped by truck or air.
-- the nulls have been replaced by median values

-- The primary keys are cust_id in cust_dimen, ord_id in orders_dimen, 
-- prod_id in prod_dimen, and ship_id and order_id in shipping_dimen.
--  Foreign keys are cust_id, ord_id, prod_id, ship_id in market fact column, 
--  and order_id is foreign key in shipping_dimen column.

create schema superstore;
use superstore;
-- 1 Find the total and the average sales (display total_sales and avg_sales) 
select sum(sales) as total_sales, avg(sales) as avg_sales from market_fact; #total_sales 14915600.82400002, 1775.8781788308156

-- 2 Display the number of customers in each region in decreasing order of 
-- no_of_customers. The result should contain columns Region, no_of_customers
select Region,count(cust_id) as total_customers from cust_dimen group by Region order by 2; 

--  3 Find the region having maximum customers (display the region name and max(no_of_customers)

select region, max(no_of_customer) as no_of_customer from 
(select region, count(Cust_id) as no_of_customer from cust_dimen
group by Region) as T1 group by region order by 2 desc limit 1; 

--  4 Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
select prod_dimen.Prod_id as "product id" ,count(sales) as no_of_products from market_fact
join prod_dimen on market_fact.Prod_id = prod_dimen.Prod_id
group by prod_dimen.Prod_id
order by 2 desc;

-- 5 Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased) 
select Customer_Name,count(Sales) as no_of_tabels from cust_dimen
join market_fact on cust_dimen.Cust_id = market_fact.Cust_id
join prod_dimen on market_fact.Prod_id = prod_dimen.Prod_id
where (region like "At%" and prod_dimen.product_sub_category = "Tables")
group by cust_dimen.Cust_id
order by count(sales) desc;

-- 6 Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
select prod_dimen.Product_Category as product_category, sum(market_fact.Profit) as "Profit"
from market_fact 
join prod_dimen on market_fact.Prod_id = prod_dimen.Prod_id
group by Product_Category
order by Profit desc;

-- 7 Display the product category, product sub-category and the profit within each sub-category in three columns. 

select prod_dimen.Product_Category,prod_dimen.Product_Sub_Category, market_fact.Profit 
from market_fact
join prod_dimen on market_fact.Prod_id = prod_dimen.Prod_id
group by Product_Category,Product_Sub_Category
order by Product_Category,Profit desc;

-- 8 Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)
select sum(market_fact.profit) as profit_per_region,
count(market_fact.ship_id)as total_shipments,cust_dimen.region
from market_fact 
join prod_dimen on market_fact.Prod_id = prod_dimen.Prod_id
join cust_dimen on market_fact.Cust_id = cust_dimen.Cust_id
group by region
order by 1,2, Product_Sub_Category desc;
