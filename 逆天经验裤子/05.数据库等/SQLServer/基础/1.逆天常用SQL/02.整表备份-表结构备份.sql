--一定注意：select into新表 只是复制了原表结构（包括标识）, 对于索引,约束并没有照搬的.

--把一个表的数据插入到另一个表中（ResultBak可以不存在）
select * into ShopMenuBak from ShopMenu

--创建同等结构的表
select top 0 * into ShopMenuBak1 from ShopMenu --推荐
--select * into ShopMenuBak1 from ShopMenu where 1=2

--一种思路：备份表数据(CityInfoBak必须先存在且和CityInfo结构兼容)
insert into CityInfoBak select CAreaCode,CName,CPid,CLevel,COrder,CNameEn,CShortname,CDataStatus from CityInfo