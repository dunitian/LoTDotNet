use master

--创建目录（如果指定的路径不存在就会报错）
exec sp_configure 'show advanced options',1 --显示高级选项
reconfigure with override--重新配置
	exec sp_configure 'xp_cmdshell',1 --1代表允许，0代表阻止
	reconfigure with override
		exec xp_cmdshell 'mkdir F:\Work\SQL mkdir E:\SQL'
	exec sp_configure 'xp_cmdshell',0
	reconfigure with override
exec sp_configure 'show advanced options',0
reconfigure with override

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
),
(
	name='LawyerBlog_Data1',
	size=10mb,
	filegrowth=10%,
	maxsize=1024mb,
	filename=N'F:\Work\SQL\LawyerBlog_Data.mdf'
),
filegroup ArticleData --Article文件组（表创建到不同的文件组里面可以分担压力）
(
	name='LawyerBlog_Data_Article',
	size=10mb,
	filegrowth=10%,
	maxsize=1024mb,
	filename=N'E:\SQL\LawyerBlog_Data_Article.ndf'
),
(
	name='LawyerBlog_Data_Article1',
	size=10mb,
	filegrowth=10%,
	maxsize=1024mb,
	filename=N'F:\Work\SQL\LawyerBlog_Data_Article.ndf'
)
log on --日记
(
	name='LawyerBlog_Log1',
	size=5mb,
	filegrowth=5%,
	filename=N'E:\SQL\LawyerBlog_log2.ldf'
),
(
	name='LawyerBlog_Log2',
	size=5mb,
	filegrowth=5%,
	filename=N'F:\Work\SQL\LawyerBlog_log1.ldf'
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
) on ArticleData

exec sp_helpfilegroup --查看文件组