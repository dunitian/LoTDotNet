use master

--存在就删除
if exists(select * from sysdatabases where Name=N'LawyerBlog')
begin
drop database LawyerBlog
end

--创建数据库
create database LawyerBlog
on primary					--数据库文件，主文件组
(
	name='LawyerBlog_Data', --逻辑名
	size=10mb,				--初始大小
	filegrowth=10%,			--文件增长
	maxsize=1024mb,			--最大值
	filename=N'E:\SQL\LawyerBlog_Data.mdf'--存放路径（包含文件后缀名）
)
log on --日记
(
	name='LawyerBlog_Log1',
	size=5mb,
	filegrowth=5%,
	filename=N'E:\SQL\LawyerBlog_log2.ldf'
)
go

use LawyerBlog
--存在就删除
if exists(select * from sysobjects where name=N'SeoTKD')
begin
drop table SeoTKD
end

--创建SeoTKD表
create table SeoTKD
(
	Gid varchar(36) primary key,
	SeoTitle nvarchar(100) default('标题') not null,	--最佳长度: 10 ~ 60 字符
	SeoKeyWords nvarchar(149) not null,
	SeoDescription nvarchar(249) not null,			--最佳长度: 50 ~ 160 字符
	SeoDataStatus tinyint default(0)				--0~255 size:1字节
)


--存在就删除
if exists(select * from sysobjects where name=N'Test')
begin
drop table Test
end
--在指定文件组中创建文件
create table Test
(
	Tid int primary key identity,
	Title01 nvarchar(100) default('标题01'),	
	Title02 nvarchar(100) default('标题02'),	
	Title23 nvarchar(100) default('标题03'),
	DataStatus tinyint default(0)				--0~255 size:1字节
)

exec sp_helpfilegroup --查看文件组