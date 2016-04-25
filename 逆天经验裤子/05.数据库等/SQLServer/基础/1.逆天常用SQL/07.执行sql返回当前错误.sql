--使用全局变量 @@error 【其实第一种就够了】
insert into ShopModelBak values(N'test',1,999999999)
select @@error

--使用 try catch
begin try
	insert into ShopModelBak values(N'test',1,999999999)
end try
begin catch
		select @@error,error_message()
end catch