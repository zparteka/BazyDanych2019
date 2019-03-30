/*wyswietl nazwy tabeli*/
SELECT Distinct TABLE_NAME FROM information_schema.TABLES;

/*zadanie 6*/
select o.* from orders o join customers c on o.customerid=c.customerid where country='France'
/* 6a lista nazwisk klientow, ktorzy skladali zamowienie do niemiec*/
select distinct c.contactname from customers c join orders o on c.customerid=o.customerid and o.shipcountry='France'

/*zadanie 7*/
select distinct shipcountry from orders o join customers c on o.customerid=c.customerid where country='Germany'

  /*wyswietl szczegoly wszystkich zamowien do polski*/
select o.* from "order details" o join orders r on r.orderid=o.orderid where r.shipcountry='Poland'

/*lista klientow, ktorzy na zamowienie czekali dluzej niz tydzien/miesiac*/
select c.* from customers c join orders o on o.customerid=c.customerid where datediff(week , o.orderdate, o.shippeddate)>1

/*zad 10*/
select * from customers c where not
  exists(select * from orders o where o.customerid=c.customerid and
                                      exists(select * from [order details] od join products p on p.productid=od.productid where od.orderid=o.orderid and p.productname='Chocolade'))

/*Wyświetl firmę, nazwisko osoby kontaktowej, id zamówienia, nazwę produktu, oraz ilość zamówionych sztuk,
jeżeli danego produktu nie ma na stanie i nie zostal on zamówiony. Posortuj po nazwie produktu*/
select c.companyname, c.contactname, o.orderid, p.productname, de.quantity from customers c join orders o on c.customerid=o.customerid
  join "order details" de on o.orderid=de.orderid join products p on de.productid=p.productid
where p.unitsinstock=0 and p.unitsonorder=0 order by p.productname;

/*zad 11*/
select * from customers c where exists (select * from orders o join [order details] od on od.orderid=o.orderid
  join products p on p.productid=od.productid where p.productname='Scottish Longbreads' and o.customerid=c.customerid)