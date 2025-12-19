




use classicmodels;
#Dataset Overview
select * from customers;#customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit, customerLocation
select * from employees;#employeeNumber, lastName, firstName, extension, email, reportsTo, jobTitle, officeCode
select * from offices;#officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory, officeLocation
select * from orderdetails;#orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber
select * from orders;#orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber
select * from payments;#checkNumber, paymentDate, amount, customerNumber
select * from productlines; #productLine, textDescription, htmlDescription, image
select * from products;#productCode, productName, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP, productLine


#Find total sales by year.
select year(orderDate),sum(quantityOrdered * priceEach) as total_sales from orders o join orderdetails od on od.orderNumber=o.orderNumber group by year(orderDate);

#Find top 10 customers by total purchase amount.
select customerName,round(sum(quantityOrdered * priceEach),2) as purchase_amount from orderdetails od join orders o on o.orderNumber=od.orderNumber join customers c on c.customerNumber=o.customerNumber group by customerName limit 10;

#Find customer count by country.
select country,count(customerNumber) as customer_count from customers group by country;

#Find customers with highest credit limit.
select customerName,creditlimit from customers order by creditlimit desc;

#Calculate the percentage of total revenue contributed by each productLine.
select productLine,round((sum(quantityOrdered * priceEach)/count(*))*100,2) as total_revenue_contributed from orders o join orderdetails od on od.orderNumber=o.orderNumber join products p on p.productCode=od.productCode group by productLine;

#Find products with low stock (quantityInStock < 1000).
select productName,quantityInStock from products where quantityInStock <1000;

#Calculate the year-over-year growth rate of total sales
select Years,lag(total_sales) over(order by Years)as Privious_year_sales,round((total_sales-lag(total_sales) over(order by Years))/lag(total_sales) over(order by Years)*100,2) as Y_over_Y_growth 
from (select year(orderDate) as Years,sum(quantityOrdered * priceEach) as total_sales from orders o join orderdetails od on od.orderNumber=o.orderNumber group by year(orderDate))t order by Years;

#Find payment trend by month.select * from payments;#checkNumber, paymentDate, amount, customerNumber
select monthname(paymentDate) as months,round(sum(amount),2)as total_amount from payments group by monthname(paymentDate);

#Find average payment amount per customer.
select customerName,round(avg(amount))as payment_avg from customers c left join payments p on p.customerNumber=c.customerNumber group by customerName;

#Identify the top 3 customers who spent the most money in each year.
select distinct customerName,year(orderDate) as Years,round(sum(quantityOrdered * priceEach),2) as total_sales from orderdetails od join orders o on o.orderNumber=od.orderNumber join customers c on c.customerNumber=o.customerNumber group by year(orderDate),customerName order by total_sales desc limit 3;
