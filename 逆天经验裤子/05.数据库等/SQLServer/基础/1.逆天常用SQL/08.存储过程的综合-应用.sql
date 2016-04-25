--创建无参存储过程
create proc usp_ShopMenuList
as
begin
	select * from ShopMenu where MDataStatus<>99
end
go
exec usp_ShopMenuList
go

-----------------------------------------------------------------

--创建有参存储过程
create proc usp_ShopMenuListByCityName
@cityName nvarchar(30)
as
begin
	select CPName,CName,SName,MType,MName,Mprice from ShopMenu 
	inner join ShopModel on ShopMenu.MShopId=ShopModel.SId
	inner join View_CityData on ShopMenu.MCityId=CId
	where CName=@cityName
end
go
exec usp_ShopMenuListByCityName @cityName='滨湖区'
go

-----------------------------------------------------------------

--创建有返回值的存储过程（返回值只能是int类型）--很少用
create proc usp_UpdateShopModelStatus
as
begin
	update ShopModelBak set SDataStatus=0
	return (select count(1) from ShopMenuBak) --return @@rowcount
end
go
declare @total int
exec @total=usp_UpdateShopModelStatus
select @total
go

-----------------------------------------------------------------

--创建有输出参数的存储过程（比较常用）
create proc usp_GetShopMenus
@cityName nvarchar(30),@total int output
as
begin
	select CPName,CName,SName,MType,MName,Mprice from ShopMenu 
	inner join ShopModel on ShopMenu.MShopId=ShopModel.SId
	inner join View_CityData on ShopMenu.MCityId=CId
	where CName=@cityName
	select @total=count(1) from ShopMenu
end
go
declare @toal int
exec usp_GetShopMenus '滨湖区',@toal output
select @toal
go

-----------------------------------------------------------------

--综合应用-三种参数混搭
if exists(select * from sysobjects where name='usp_AllPmsTest')
	drop proc usp_AllPmsTest
go
create proc usp_AllPmsTest
@cityName nvarchar(30),
@id int output
as
begin
	insert into ShopModelBak values(@cityName,1,1)
	set @id=@@identity

	select CPName,CName,SName,MType,MName,Mprice from ShopMenu 
	inner join ShopModel on ShopMenu.MShopId=ShopModel.SId
	inner join View_CityData on ShopMenu.MCityId=CId
	where CName=@cityName

	return (select count(1) from ShopMenu)
end
go
declare @total int,@id int
exec @total=usp_AllPmsTest '滨湖区',@id output
select @id Id,@total total
go

--综合应用--分页
if exists(select * from sysobjects where name='usp_GetShopMenus_Page')
	drop proc usp_GetShopMenus_Page
go
create proc usp_GetShopMenus_Page
@mIndex int,@mCount int=7
as
begin
	select * from(select row_number() over(order by MType) Id, CPName,CName,SName,MType,MName,Mprice from ShopMenu 
	inner join ShopModel on ShopMenu.MShopId=ShopModel.SId
	inner join View_CityData on ShopMenu.MCityId=CId) as temp
	where Id between (@mIndex-1)*@mCount  and (@mIndex)*@mCount
	return (select count(1) from ShopMenu)
end
go
declare @total int,@index int=1,@count int=9
exec @total=usp_GetShopMenus_Page @index,@count
select @index Mindex,@count MCount, @total MTotal
-----------------------------------------------------------------
--ADO.Net调用
-----------------------------------------------------------------------
----创建有参存储过程
----using (SqlConnection conn = new SqlConnection(connStr))
----{
----    conn.Open();
----    string sql = "usp_ShopMenuListByCityName";
----    var pms = new SqlParameter("@cityName", "滨湖区");
----    using (SqlCommand cmd = new SqlCommand(sql, conn))
----    {
----        cmd.Parameters.Add(pms);
----        cmd.CommandType = CommandType.StoredProcedure;
----        var reader = cmd.ExecuteReader();
----    }
----}

-----------------------------------------------------------------------
----执行有返回值的存储过程
----using (SqlConnection conn = new SqlConnection(connStr))
----{
----    using (SqlCommand cmd = new SqlCommand("usp_UpdateShopModelStatus", conn))
----    {
----        var pms = new SqlParameter("@Count", SqlDbType.Int);
----        pms.Direction = ParameterDirection.ReturnValue;
----        cmd.Parameters.Add(pms);
----        cmd.CommandType = CommandType.StoredProcedure;
----        conn.Open();
----        int i = cmd.ExecuteNonQuery();
----        Console.WriteLine(string.Format("{0}行数受影响(共：{1}行)", i, pms.Value));
----    }
----}
----#region SQLHelper
----	var pms = new SqlParameter("@Count", SqlDbType.Int);
----	pms.Direction = ParameterDirection.ReturnValue;
----	int i = SQLHelper.ExecuteNonQuery("usp_UpdateShopModelStatus", CommandType.StoredProcedure, pms);
----	Console.WriteLine(string.Format("{0}行数受影响(共：{1}行)", i, pms.Value)); 
----#endregion

-----------------------------------------------------------------------
----创建有输出参数的存储过程（比较常用）

----推荐方法
----using (SqlConnection conn = new SqlConnection(connStr))
----{
----    DataTable dt = new DataTable();
----    var adapter = new SqlDataAdapter("usp_GetShopMenus", conn);
----    var pms = new SqlParameter[]
----    {
----    new SqlParameter("@cityName", "滨湖区"),
----    new SqlParameter("@total", SqlDbType.Int)
----    };
----    pms[1].Direction = ParameterDirection.Output;
----    adapter.SelectCommand.Parameters.AddRange(pms);
----    adapter.SelectCommand.CommandType = CommandType.StoredProcedure;
----    adapter.Fill(dt);
----    Console.WriteLine("总共{0}条数据", pms[1].Value);
----}

----ExecuteReaer
----using (SqlConnection conn = new SqlConnection(connStr))
----{
----    using (SqlCommand cmd = new SqlCommand("usp_GetShopMenus", conn))
----    {
----        cmd.CommandType = CommandType.StoredProcedure;
----        var pms = new SqlParameter[]
----        {
----            new SqlParameter("@cityName", "滨湖区"),
----            new SqlParameter("@total", SqlDbType.Int)
----        };
----        pms[1].Direction = ParameterDirection.Output;
----        cmd.Parameters.AddRange(pms);
----        conn.Open();
----        var reader = cmd.ExecuteReader();
----        using (reader)
----        {

----        }
----        //reader 如果没有关闭，那么pms[i].Value就没有值
----        Console.WriteLine("总共{0}条数据", pms[1].Value);
----    }
----}

----#region SQLHelper (注意点：cmd.Parameters.Clear(); SQLHelper加这句就导致 调用有输出参数的存储过程 出错)
----var pms = new SqlParameter[]
----        {
----            new SqlParameter("@cityName", "滨湖区"),
----            new SqlParameter("@total", SqlDbType.Int)
----        };
----pms[1].Direction = ParameterDirection.Output;
----var reader = SQLHelper.ExecuteReader("usp_GetShopMenus", CommandType.StoredProcedure, pms);
----using (reader)
----{

----}
----Console.WriteLine("总共{0}条数据", pms[1].Value);
----#endregion
-----------------------------------------------------------------------
--综合系列-三种参数混搭
----var pms = new SqlParameter[]
----                {
----                new SqlParameter("@cityName", "滨湖区"),
----                new SqlParameter("@id", SqlDbType.Int),
----                new SqlParameter("@total", SqlDbType.Int)
----                };
----pms[1].Direction = ParameterDirection.Output;
----pms[2].Direction = ParameterDirection.ReturnValue;
----var list = SQLHelper.ExecuteReader<ShopMenu>("usp_AllPmsTest", CommandType.StoredProcedure, pms);
----foreach (var item in list)
----{
----    Console.WriteLine(item.MName + " " + item.MPrice);
----}
----Console.WriteLine("刚才插入的ID是：{0},总共{1}条数据", pms[1].Value, pms[2].Value);
------------------------------------------------------------------------------------------------------------------
--综合系列-分页
----var pms = new SqlParameter[]
----{
----    new SqlParameter("@mIndex",1),
----    new SqlParameter("@mCount",9),
----    new SqlParameter("@total",SqlDbType.Int)
----};
----pms[2].Direction = ParameterDirection.ReturnValue;
----var list=SQLHelper.ExecuteReader<ShopMenu>("usp_GetShopMenus_Page", CommandType.StoredProcedure, pms);
----foreach (var item in list)
----{
----    Console.WriteLine(item.MName + " " + item.MPrice);
----}
----Console.WriteLine("总共："+pms[2].Value);