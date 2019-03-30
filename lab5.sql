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
