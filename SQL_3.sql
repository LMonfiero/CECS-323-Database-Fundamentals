--25
select sum(amount) from payments
group by CUSTOMERNUMBER;

--26
select  max(amount) from payments;

--27
select  avg(amount) from payments;

--28
select count(productline) from products
group by PRODUCTLINE;

--29
select count(status) from orders
group by status;

--30
select officecode, count(employeenumber) as "Total Employees" from employees
group by officecode;

--31
select count(productline) from products
group by PRODUCTLINE
having count(productline)>3;

--32
select ordernumber, sum(priceeach) as "Total less than $60,000.00" from orderdetails
group by ordernumber
having sum(priceeach) > 60000;

--33
select products.productname, sum((orderdetails.PRICEEACH - products.BUYPRICE)*orderdetails.QUANTITYORDERED) as Profit
from orderdetails
natural join products
group by products.productname
having sum((orderdetails.PRICEEACH - products.BUYPRICE)*orderdetails.QUANTITYORDERED) >60000
order by Profit desc;

--34
select productname, avg(od.QUANTITYORDERED * od.PRICEEACH) AS Average from products
natural join orderdetails as od
natural join orders
natural join customers
where customers.COUNTRY = 'Japan'
group by productname
order by Average DESC;

--35
select productname, sum(MSRP-buyprice) AS profit 
from products
group by productname
order by profit desc;

--36

select customers.CUSTOMERNAME, sum(orderdetails.QUANTITYORDERED * orderdetails.PRICEEACH) as "Total customer orders" from customers
natural join orders
natural join orderdetails
group by customers.CUSTOMERNAME
having  sum(orderdetails.QUANTITYORDERED * orderdetails.PRICEEACH)> 100000
order by sum(orderdetails.QUANTITYORDERED * orderdetails.PRICEEACH) DESC;