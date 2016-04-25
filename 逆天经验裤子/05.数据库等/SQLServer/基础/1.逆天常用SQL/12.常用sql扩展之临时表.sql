--局部临时表:只能在当前会话中使用，如果出了当前会话临时表就不能使用。
create table #temp
(
 SId int not null,
 SName nvarchar(20) not null,
 SOrder smallint not null,
 SDataStatus smallint not null
)
--将ShopModelBak表的数据存储到临时表空间
insert into #temp select * from ShopModelBak
--查看临时表的数据
select * from #temp

--删除ShopModelBak表的数据
truncate table ShopModelBak
select * from ShopModelBak

--将临时表的数据重新导入到ShopModelBakge
insert into ShopModelBak(SName,SOrder,SDataStatus) select SName,SOrder,SDataStatus from #temp
select * from ShopModelBak


---全局临时表:只在当前会话没有关闭，那么临时表在其它会话中也能够使用
create table ##temp1
(
 SId int not null,
 SName nvarchar(20) not null,
 SOrder smallint not null,
 SDataStatus smallint not null
)

insert into ##temp1 select * from #temp
select * from ##temp1