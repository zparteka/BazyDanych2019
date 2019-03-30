/*Ustalenie łącznej ilości każdego produktu dostarczonej do poszczególnych krajów przez pracownika nr 2.
  Wynik powinien zawierać następujące kolumny: ProductId, ShipCountry, TotalQuantity*/

SELECT p.productid, o.shipcountry, sum(de.quantity) as totalquantity from products p join
  [order details] de on de.productid=p.productid join orders o
    on o.orderid=de.orderid where o.employeeid=2 group by o.shipcountry, p.productid order by p.productid;

/*Ustalenie listy pracowników, z których każdy sprzedał łącznie co najmniej100 sztuk produktu Chocolade w roku 1998
Wynik powinien zawierać następujące kolumny: EmployeeName, EmployeeSurname, TotalQuantity*/

select e.firstname, e.lastname, sum(de.quantity) as totalQuantity from products p join [order details]
de on de.productid=p.productid join orders o on o.orderid=de.orderid join employees e
on o.employeeid=e.employeeid where p.productname='Chocolade' and year(o.orderdate)='1998'
group by e.firstname, e.lastname having sum(de.quantity)>=100


/*Wymień wszystkie produkty, które zostały zamówione przez klientów z Włoch, takie, że średnio co najmniej 20 sztuk
tego produktu zostało zamówionych w pojedynczym zamówieniu złożonym przez danego klienta. Ułóż wyniki w kolejności
malejącej sumarycznej liczby zamówień złożonej przez klienta na dany produkt.*/

select p.productname, c.customerid, avg(de.quantity) as Average from orders o join [order details] de on o.orderid=de.orderid join customers c on
  o.customerid=c.customerid join products p on de.productid=p.productid where c.country='Italy' group by p.productname, c.customerid
having avg(de.quantity)>=20 order by avg(de.quantity) desc

/*Wymień wszystkich klientów z Berlina i zamówione przez nich produkty.Wynik zapytania powinien zawierać
  następujące kolumny: CustomerName, ProductName, OrderDate, Quantity.Posortuj wynik w kolejności CustomerName,
  ProductName, OrderDate*/

select c.contactname, p.productname, o.orderdate, de.quantity from orders o join [order details] de on o.orderid=de.orderid join products p on de.productid=p.productid
  join customers c
  on o.customerid=c.customerid where c.city='Berlin' order by c.contactname, p.productname, o.orderdate, de.quantity

  /*Wymień wszystkie produkty, które zostały dostarczone do Francji w 1998 roku*/

select p.productname from orders o join [order details] de on o.orderid=de.orderid join products p on de.productid=p.productid
where o.shipcountry='France' and year(o.shippeddate)='1998'


/*Wymień wszystkich klientów, którzy złożyli co najmniej dwa zamówienia, ale nigdy nie zamówili produktów
o nazwach zaczynających się od „Ravioli”*/

select c.contactname from customers c where c.contactname not in (select distinct c.contactname from customers c join orders o on o.customerid=c.customerid join [order details] de
  on de.orderid=o.orderid join products p on p.productid=de.productid where p.productname like 'Ravioli%') and c.customerid in (select o.customerid from orders o  group by o.customerid
            having count(o.customerid)>=2)


select * from Products

	/*zapytanie 7
	Znajdź wszystkie zamówienia zawierające co najmniej 4 różne produkty i złożone przez klientów z Francji
	Wynik powinien zawierać następujące kolumny: CompanyName, OrderId, ProductCount*/
select c.CompanyName, o.OrderID ,COUNT(od.OrderID) as ProductCount from Orders o join Customers c on c.CustomerID = o.CustomerID join [Order Details] od on
od.OrderID = o.OrderID where c.Country = 'France' group by c.CompanyName, o.OrderID having COUNT(od.OrderID) >= 4 

	/*zapytanie 8
	Wymień wszystkich klientów, którzy złożyli co najmniej pięć zamówień wysłanych do Francji, ale nie więcej niż 2
	zamówienia wysłane do Belgii. Wynik powinien zawierać jedną kolumnę: CompanyName*/
select c.CompanyName from Customers c 
	join Orders o on o.CustomerID = c.CustomerID
group by c.CompanyName having 
	COUNT(case when o.ShipCountry = 'France' then 1 end) >= 5
	and COUNT(case when o.ShipCountry = 'Belgium' then 1 end) <= 2 
order by c.CompanyName 

	/*zapytanie 9
	Dla każdego produktu znajdź wszystkich klientów, którzy złożyli zamówienie na największą kiedykolwiek zamówioną
	ilość tego produktu. Wynik: ProductName, CompanyName, MaxQuantity*/
select p.ProductName, c.CompanyName, mQ.MaxQuantity from Products p 
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on od.OrderID= o.OrderID
	join Customers c on c.CustomerID = o.CustomerID
	join (select p.ProductID, MAX(od2.Quantity) as MaxQuantity from Products p 
			join [Order Details] od2 on p.ProductID = od2.ProductID
			group by p.ProductID) mQ on mQ.ProductID = od.ProductID
where od.Quantity = mQ.MaxQuantity

	/*zapytanie 10
	Wymień wszystkich pracowników, którzy nadzorowali liczbę zamówień większą
	niż 120% średniej liczby zamówień nadzorowanych przez pracownika*/
select e.LastName, coor.Coordin from (select e.EmployeeID, COUNT(o.OrderID) as Coordin from Employees e
	join Orders o on o.EmployeeID = e.EmployeeID group by e.EmployeeID) coor
	join Employees e on e.EmployeeID = coor.EmployeeID
where coor.Coordin >= 1.2*(select AVG(Coordin) from (select e.EmployeeID, COUNT(o.OrderID) as Coordin from Employees e
	join Orders o on o.EmployeeID = e.EmployeeID group by e.EmployeeID) c) --nie wiedzialem jak nie powtorzyc query

	/*zapytanie 11
	Wyświetl dane 5 zamówień zawierających największą liczbę różnych produktów umieszczonych na jednym zamówieniu.
	Wynik powinien zawierać: OrderId, ProductCoun*/
select top 5 o.OrderID, COUNT(od.OrderID) as ProductCoun from orders o 
	join [Order Details] od on od.OrderID = o.OrderID 
group by o.OrderID 
order by ProductCoun desc

	/*zapytanie 12 
	Znajdź wszystkie produkty, które zamówiono w większej ilości w 1997 r. niż w 1996 r.
	Wynik powinien zawierać kolumny: ProductName, TotalQuantityIn1996, TotalQuantityIn1997*/
select p.ProductID, tq1996.TotalQuantityIn as TotalQuantityIn1996, tq1997.TotalQuantityIn as TotalQuantityIn1997 from Products p
	join  (select p.ProductID, SUM(od.Quantity) as TotalQuantityIn from Products p
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on o.OrderID = od.OrderID
	where YEAR(o.OrderDate) = 1996
	group by p.ProductID) tq1996 on tq1996.ProductID = p.ProductID

	join  (select p.ProductID, COUNT(od.Quantity) as TotalQuantityIn from Products p
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on o.OrderID = od.OrderID
	where YEAR(o.OrderDate) = 1997
	group by p.ProductID) tq1997 on tq1997.ProductID = p.ProductID
where tq1996.TotalQuantityIn < tq1997.TotalQuantityIn



	/*zapytanie 13
	Znajdź wszystkie produkty, na które złożono więcej zamówień w 1997 r. niż w 1996 r.
	Wynik powinien zawierać kolumny: ProductName, NumberOfOrdersIn1996, NumberOfOrdersIn1997*/
select p.ProductID, no1996.NumOfOrders, no1997.NumOfOrders from Products p
	join  (select p.ProductID, COUNT(*) as NumOfOrders from Products p
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on o.OrderID = od.OrderID
	where YEAR(o.OrderDate) = 1996
	group by p.ProductID) no1996 on no1996.ProductID = p.ProductID

	join  (select p.ProductID, COUNT(*) as NumOfOrders from Products p
	join [Order Details] od on od.ProductID = p.ProductID
	join Orders o on o.OrderID = od.OrderID
	where YEAR(o.OrderDate) = 1997
	group by p.ProductID) no1997 on no1997.ProductID = p.ProductID
where no1996.NumOfOrders < no1997.NumOfOrders
