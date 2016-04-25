--修改-插入指定标识列的数据
set identity_insert ShopModelBak on
	insert into ShopModelBak(SId,SName,SOrder,SDataStatus) values(5,N'lll',1,1)
set identity_insert ShopModelBak off
--
--注意：如果这样写 ShopModelBak values(5,N'lll',1,1) 会出错 【看关键词：仅当使用了列列表】
----仅当使用了列列表并且 IDENTITY_INSERT 为 ON 时，才能为表'ShopModelBak'中的标识列指定显式值。