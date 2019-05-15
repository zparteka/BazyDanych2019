CREATE PROCEDURE GiveDiscount @CustomerId nchar(5)
AS
  declare @fetch_status_ord int
  declare @fetch_status_prod int
  declare @ProductCount TABLE (ProdId int, numb int)
  declare @order int
  declare ord CURSOR FOR SELECT OrderID from Orders where CustomerID=@CustomerId
  open ord
  fetch next from ord into @order
  set @fetch_status_ord = @@fetch_status
  WHILE @fetch_status_ord = 0
    begin
      DECLARE @product int
      DECLARE prod CURSOR FOR SELECT ProductID FROM [Order Details] where OrderID=@order
      open prod
      FETCH NEXT FROM prod INTO @product
      set @fetch_status_prod = @@fetch_status
      WHILE @fetch_status_prod = 0
        begin
          if exists(select numb from @ProductCount where ProdId=@product)
            begin
              declare @productNumb int
              set @productNumb = (select numb from @ProductCount where ProdId=@product)
              if @productNumb>0 and @productNumb<3
                update [Order Details] set Discount=0.05 where OrderID=@order and ProductID=@product
              else if @productNumb<4
                update [Order Details] set Discount=0.10 where OrderID=@order and ProductID=@product
              else if @productNumb>=4
                update [Order Details] set Discount=0.20 where OrderID=@order and ProductID=@product
            end
          if not exists(select * from @ProductCount where ProdId=@product)
            begin
              insert into @ProductCount(ProdId, numb) values (@product, 1)
              update [Order Details] set Discount=0 where OrderID=@order and ProductID=@product
            end
          else
            update @ProductCount set numb+=1 where ProdId=@product

          FETCH NEXT FROM prod INTO @product
          set @fetch_status_prod = @@fetch_status
        end;
      close prod
      deallocate prod

      fetch next from ord into @order
      set @fetch_status_ord = @@fetch_status
    end
  close ord
  deallocate ord

RETURN

EXEC GiveDiscount @CustomerId = 'ALFKI';

DROP PROCEDURE GiveDiscount;


