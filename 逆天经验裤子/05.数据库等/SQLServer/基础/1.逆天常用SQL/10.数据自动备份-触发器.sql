--科普
--DML触发器
--	Insert、delete、update（不支持select）
--	after触发器(for)、instead of触发器（不支持before触发器）
--DDL触发器
--	Create table、create database、alter、drop

--inserted表与deleted表
--	inserted表包含新数据
--		insert、update触发器会用到
--	deleted表包含旧数据
--		delete、update触发器会用到

--After触发器：
--	在语句执行完毕之后触发
--	按语句触发，而不是所影响的行数，无论所影响为多少行，只触发一次。
--	只能建立在常规表上，不能建立在视图和临时表上。
--	可以递归触发，最高可达32级。
----格式
----create trigger tr_name
----on 表名 after [insert|update|delete] 
----as 
----		xxx
----go

--准备工作
select * into BackupShopMenuBak from ShopMenuBak where 1=2

--把插入的数据自动备份到另一个表
if exists(select * from sysobjects where name='tr_ShopMenuBak')
	drop trigger tr_ShopMenuBak
go
create trigger tr_ShopMenuBak
on ShopMenuBak after insert
as
	insert into BackupShopMenuBak select * from inserted
go

select * from BackupShopMenuBak
insert into ShopMenuBak values(N'test',0,N'test',0,0,99,N'2016-04-08')
select * from BackupShopMenuBak

--把删除掉的数据自动备份到另一个表
if exists(select * from sysobjects where name='tr_ShopMenuBak_delete')
	drop trigger tr_ShopMenuBak
go
create trigger tr_ShopMenuBak_delete
on ShopMenuBak after delete
as
	insert into BackupShopMenuBak select * from deleted
go

select * from BackupShopMenuBak
delete ShopMenuBak where MDataStatus=99
select * from BackupShopMenuBak

--instead of触发器：
--	用来替换原本的操作
--	不会递归触发
--	可以在约束被检查之前触发
--	可以建在临时表和视图上
----格式
----create trigger tr_name
----on 表名 instead of
----as 
----		xxx
----go

--建议
--触发器会与SQL语句认为在同一个事务中
	--避免在触发器中做复杂操作
	--尽量避免在触发器中执行耗时操作
