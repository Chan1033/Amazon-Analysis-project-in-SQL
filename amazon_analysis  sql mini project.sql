create database amazon_analysis;
use amazon_analysis;

select*from customers;
select*from products;
select*from order_details;
select*from orders;
select*from suppliers;
select*from reviews;

-- changing data type --
alter table customers modify customerID varchar(50);
alter table order_details modify orderID varchar(50),modify productID varchar (50);
alter table orders modify orderID varchar(50),modify customerID varchar(50);
alter table products modify productID varchar(50),modify supplierID varchar(50);
alter table reviews modify reviewID varchar(50),modify productID varchar(50),modify customerID varchar(50);
alter table suppliers modify supplierID varchar(50);

-- primary key --
alter table customers add constraint updated_customer primary key(customerID);
alter table orders add constraint up_oders primary key(orderID);
alter table reviews add constraint up_reviews primary key(reviewID);
alter table suppliers add constraint up_suppliers primary key(supplierID);
alter table products add constraint up_product primary key(productID);

-- foregin key --
alter table order_details add constraint fk_order_details foreign key (orderID)references orders (orderID);
alter table order_details add constraint fk_order_detail foreign key (productID)references products (productID);
alter table orders add constraint fk_order foreign key(customerID) references customers(customerID);
 
alter table products add constraint fk_product foreign key (supplierID) references suppliers(supplierID);
insert into suppliers (supplierID) select distinct supplierID from products where supplierID not in (
select supplierID  from suppliers);

alter table reviews add constraint fk_review foreign key (productID) references products(productID);
alter table reviews add constraint fk_reviews foreign key(customerID) references customers(customerID);

select* from customers where city ="Port Calebstad";
select *from products where category = "fruits";

create table customers (
customerID varchar(50) primary key,
age int not null  check(age>18),
name varchar(50) unique
);

-- Insert 3 new rows into the Products table using INSERT statements.
insert into products(productID,productName,category,subcategory,priceperunit,stockQuantity,supplierID)
values
('P108','berry','fruits','fresh fruits',150,20,'ba8f689a-c553-44f2-a2b3-93c8d435eecd'),
('P109','jackfruit','fruits','fresh fruits',200,10,'2a9672b2-72da-4b3b-81a3-0d4be445b42a'),
('P107','carrot', 'vegetables','root vegetables',120,5,'6341baf6-d590-400d-bed9-f684c1ef513d');

select* from products;

--  Update the stock quantity of a product where ProductID matches a specific ID
update products set stockquantity=30 where productID='P108';

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific 
delete from suppliers where city="Schneidermouth";

-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5. 
alter table reviews add constraint chk_review check (rating between 1 and 5);

-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
alter table customers modify PrimeMember varchar(50)  default 'no';
alter table customers modify PrimeMember varchar(50);

-- WHERE clause to find orders placed after 2024-01-01. 
select orderdate,orderID,customerID from orders  where orderdate  >2024-01-01;

-- HAVING clause to list products with average ratings greater than 4.
select productID, avg(rating)as avg_rating from reviews group by productID having avg_rating>4;

-- ○ GROUP BY and ORDER BY clauses to rank products by total sales. 
select productID ,sum(priceperunit*stockQuantity)as total_sales from products group by productID 
order by total_sales desc;

-- 1. Calculate each customer's total spending. 
select customerID,sum(orderamount)as total_spending from orders group by customerID ;

-- Rank customers based on their spending.
 select customerID,sum(orderamount)as total_spending from orders group by customerID order by total_spending desc;
 
 -- 3. Identify customers who have spent more than ₹5,000. 
 select customerID,sum(orderamount)as total_spending from orders group by customerID having total_spending>5000;
 
 -- Join the Orders and OrderDetails tables to calculate total revenue per order. 
 SELECT o.orderid,SUM(od.quantity * o.orderamount) AS total_revenue FROM orders o JOIN order_details od 
ON od.orderid = o.orderid GROUP BY od.orderid;

-- Identify customers who placed the most orders in a specific time period. 
SELECT c.customerID, COUNT(o.orderid) AS total_orders FROM customers c  JOIN orders o 
ON c.customerID = o.customerID where o.orderdate between "2024-01-01" and "2025-01-01"  GROUP BY c.customerID;

-- Find the supplier with the most products in stock. 
SELECT s.supplierID, SUM(o.stockquantity) AS total_stock FROM suppliers s  JOIN products o 
ON s.supplierID = o.supplierID GROUP BY s.supplierID;

--  Separate product categories and subcategories into a new table. 
create table category(
Category varchar(50),
subCategory varchar(50)
);

-- Create foreign keys to maintain relationships. 
alter table category add column productID varchar(50);
alter table category add constraint up_category foreign key (productID) references products (productID);

-- identify the top 3 products based on sales revenue. 
select productID ,orderID,sum(Quantity*Unitprice) as sales_revenue from order_details  group by productID ,orderID
order by sales_revenue desc limit 3;

-- Find customers who haven’t placed any orders yet.
ALTER TABLE customers RENAME COLUMN name TO customername;
select customerID , customername  from customers where customerID not in 
(select distinct customerID from orders);

select*from customers;
 -- Which cities have the highest concentration of Prime members? 
 select City , count(PrimeMember) as primecount from customers where PrimeMember="yes" 
 group by city order by primecount DESC;
 
-- What are the top 3 most frequently ordered categories? 
select p.category, sum(od.Quantity) as total_order from order_details as od join products as p 
on od.productID=p.ProductID group by od.orderID,p.Category order by total_order desc limit 3;















