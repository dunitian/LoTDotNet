--初步封装
declare @cloumnName varchar(100)='TName'
update ShopMenuType set @cloumnName=replace(@cloumnName,char(10),'') --- 除去换行符 
update ShopMenuType set @cloumnName=replace(@cloumnName,char(13),'') --- 除去回车符 
update ShopMenuType set @cloumnName=replace(@cloumnName,' ','') --- 除去空格符 

--尝试
declare @tableName varchar(100)='ShopMenuType'
exec('select * from '+ @tableName)
--引号转义
select '''','''''',''' '''
go

--最终封装
declare @tableName varchar(100),@cloumnName varchar(100),@sqlStr nvarchar(1000)
select @tableName='ShopMenuType',@cloumnName='TName'--每次替换这里的表名和列名就可以了
set @sqlStr='update '+@tableName+' set '+@cloumnName+'=replace('+@cloumnName+',char(10),'''')' --- 除去换行符 
set @sqlStr=@sqlStr+' update '+@tableName+' set '+@cloumnName+'=replace('+@cloumnName+',char(13),'''')' --- 除去回车符
set @sqlStr=@sqlStr+' update '+@tableName+' set '+@cloumnName+'=replace('+@cloumnName+','' '','''')' --- 除去空格符 
print @sqlStr
exec(@sqlStr)
