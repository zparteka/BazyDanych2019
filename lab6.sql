/* 1. Reassign all the orders supervised by employee 1 to employee 4*/

select *
from orders where employeeid=1;
--123
select * from orders where employeeid=4;
--156

update orders set employeeid=4 where employeeid=1;

select * from orders where employeeid=4;
--279

/* 2. A reduction of quantity has to be made for all the orders made after 15/05/1997 for product Ikura.
2.   The quantity should be reduced by 20% and rounded to the nearest integer number.*/

select p.productname, de.orderid, de.quantity from [order details] de join orders o on o.orderid=de.orderid  join products p on p.productid=de.productid
  where convert(date, o.orderdate) > convert(datetime, '1997-05-15') and p.productname like 'Ikura' order by o.orderid

select o.orderid, de.quantity, convert(int, round(quantity*0.8, 0)) as reduced   from [order details] de join orders o on o.orderid=de.orderid  join products p on p.productid=de.productid
  where convert(date, o.orderdate) > convert(datetime, '1997-05-15') and p.productname like 'Ikura'


update [order details] set quantity=convert(int, round(quantity*0.8, 0))  from [order details] de join orders o on o.orderid=de.orderid  join products p on p.productid=de.productid
  where convert(date, o.orderdate) > convert(datetime, '1997-05-15') and p.productname like 'Ikura'


/*3. Find the identifier of the most recent order made by customer ALFKI and not including Chocolade2.
 Find the identifier of Chocolade
 3.   Add Chocolade to a list of products ordered within this order, with quantity=1*/


   select orderid from orders where orderdate in (select max(o.orderdate) from orders o join customers c on o.customerid=c.customerid
     join [order details] de on de.orderid=o.orderid join products p on p.productid=de.productid
where c.customerid='ALFKI' and o.orderid not in (select de.orderid from [order details] de join products p on p.productid=de.productid
                                                                                                                and p.productname='Chocolade')) and customerid='ALFKI'

select * from products where productname='Chocolade'

insert into [order details] values (11011, 48, 12.700, 1, 0 )

select * from [order details] where orderid=11011


/* 4. Add Chocolade to all orders made by customer ALFKI, not including it yet*/

select distinct  o.orderid from orders o join customers c on o.customerid=c.customerid
     join [order details] de on de.orderid=o.orderid join products p on p.productid=de.productid
where c.customerid='ALFKI' and o.orderid not in (select de.orderid from [order details] de join products p on p.productid=de.productid
                                                                                                                and p.productname='Chocolade')

insert into [order details] select distinct de.orderid, (select productid from products where productname='Chocolade'), 12.700, 1, 0 from orders o join customers c on o.customerid=c.customerid
     join [order details] de on de.orderid=o.orderid join products p on p.productid=de.productid
where c.customerid='ALFKI' and o.orderid not in (select de.orderid from [order details] de join products p on p.productid=de.productid
                                                                                                                and p.productname='Chocolade')

/* 5. Remove all the customers that have never made any orders*/

select * from customers c where c.customerid not in (select customerid from orders)

delete from customers where customerid not in (select customerid from orders)


/*scenariusz 1*/

select * into archivedOrders from orders where OrderID=-1
alter table archivedOrders drop column OrderID
alter table archivedOrders add  OrderID int not null

ALTER TABLE archivedOrders
ADD CONSTRAINT archiveorders_pk PRIMARY KEY (orderid);

ALTER TABLE archivedOrders
ADD CONSTRAINT customerid_fk
FOREIGN KEY (customerid) REFERENCES customers(customerid);

ALTER TABLE archivedOrders
ADD CONSTRAINT employeeid_fk
FOREIGN KEY (employeeid) REFERENCES employees(employeeid);


select * from archivedOrders

alter table archivedOrders add archiveDate date

select * into archivedOrderDetails from [order details] where OrderID=-1


ALTER TABLE archivedOrderDetails
ADD CONSTRAINT orderid_fk
FOREIGN KEY (orderid) REFERENCES archivedOrders(orderid);

select year(OrderDate) from Orders
select * from orders where year(OrderDate)=1996


begin transaction
insert into archivedOrders(OrderID, CustomerID, EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia,Freight,ShipName,
                                   ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry) select OrderID, CustomerID, EmployeeID,OrderDate,RequiredDate,ShippedDate,ShipVia,Freight,ShipName,
                                   ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry from orders where year(OrderDate)=1996
update archivedOrders set archiveDate=convert(date,getdate())
insert into archivedOrderDetails select de.* from [Order Details] de join orders o on o.orderid=de.OrderID  where year(o.OrderDate)='1996'
delete de from [Order Details] de join Orders O on de.OrderID = O.OrderID where year(O.OrderDate)='1996'
delete from orders where year(OrderDate)='1996'
commit
rollback

/*normalnie taki kod wykonuje aplikacja, wtedy wykonuje commit
jezeli ktores polecenie skutkowalo bledem to wykonuje rollback, czyli wycofuje cala transakcje

poziomy izolacji transakcji odpowiedzialne za dwie transakcje jednoczesnie*/

/*scenariusz2*/
alter table Orders add IsCancelled int

begin transaction
update Orders set Orders.IsCancelled = 0 where CustomerID!='ALFKI'
update Orders set Orders.IsCancelled = 1 where CustomerID = 'ALFKI'
update [Order Details] set Quantity=0 where OrderID in (select orderid from orders where CustomerID='ALFKI')
commit
rollback

/*scenariusz 4*/
drop index Customers.CompanyName
ALTER TABLE  Customers alter column CompanyName varchar(100);
alter table Customers add TotalOrderCount int


begin transaction
update Customers set TotalOrderCount=c.Total from (select CustomerID, count(CustomerID) as Total from orders group by CustomerID)
  c where c.CustomerID=Customers.CustomerID
commit

alter table Products add LatestOrderDate datetime

begin transaction
  update Products set LatestOrderDate=d.latest from (select de.ProductID, max(o.orderdate)as latest
  from orders o join [Order Details] de on o.OrderID = de.OrderID group by de.ProductID) d where d.ProductID=Products.ProductID
COMMIT

  alter table Products add IsCancelled int

  begin transaction
  update Products set Products.IsCancelled=1 from (select de.ProductID
  from orders o join [Order Details] de on o.OrderID = de.OrderID group by de.ProductID having  max(OrderDate)<convert(datetime, '01/01/1998') )
    d where d.ProductID=Products.ProductID
COMMIT
select * from Products
  SELECT * from Products
  select * from Customers