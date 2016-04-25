--事务的三条关键语句：
--创建事务--开启事务 begin transaction
--没有错误--提交事务 commit transaction
--出现错误--事务回滚 rollback transaction
--事务的使用方法:将你需要执行的业务逻辑语句块放到事务的开启和回滚，或者事务的开启和提交之间就可以了
--注意：事务一旦开启，就必须有提交或者回滚

--案例： 数据批量插入 （注意：set @error+=@@error 【每句后面都要加】）
--方法一
declare @error int=0
begin transaction
	insert into ShopModelBak values(N'test',1,1)
set @error+=@@error
	insert into ShopModelBak values(N'test',1,1)
set @error+=@@error
	insert into ShopModelBak values(N'test',1,1)
set @error+=@@error
	insert into ShopModelBak values(N'test',1,999999999)
set @error+=@@error
	insert into ShopModelBak values(N'test',1,1)
set @error+=@@error
if(@error=0)
	commit transaction
else
	rollback transaction

--方法二
begin try
	begin transaction
		insert into ShopModelBak values(N'test',1,1)
		insert into ShopModelBak values(N'test',1,1)
		insert into ShopModelBak values(N'test',1,1)
		insert into ShopModelBak values(N'test',1,1)
		insert into ShopModelBak values(N'test',1,999999999)
		insert into ShopModelBak values(N'test',1,1)
		insert into ShopModelBak values(N'test',1,1)
	commit transaction
end try
begin catch
	rollback transaction
	select @@error,error_message() --这句可有可无
end catch


--ADO.Net事物使用
--using (SqlConnection conn = new SqlConnection(connStr))
--{
--    string sql = @"insert into ShopModelBak values(N'test',1,1) 
--                   insert into ShopModelBak values(N'test',1,1) 
--                   insert into ShopModelBak values(N'test',1,1) 
--                   insert into ShopModelBak values(N'test',1,1) 
--                   insert into ShopModelBak values(N'test',1,999999999) 
--                   insert into ShopModelBak values(N'test',1,1) 
--                   insert into ShopModelBak values(N'test',1,1) ";
--    using (SqlCommand cmd = new SqlCommand(sql, conn))
--    {
--        conn.Open();
--        cmd.Transaction = conn.BeginTransaction();
--        try
--        {
--            int i = cmd.ExecuteNonQuery();
--            Console.WriteLine(i);
--        }
--        catch (Exception ex)
--        {
--            cmd.Transaction.Rollback();
--            Console.WriteLine(ex);
--        }
--    }
--}