go
--DECLARE @submenuName nvarchar(100)='Discontinued Product'
--DECLARE @submenuslNo int='9'
--Declare @pluginName nvarchar(100) ='initvent_inventory_discontinued_product'
--Declare @menuId uniqueidentifier ='E03FCE8C-FA23-4955-BB0B-226C6171AA20'

--insert into SubMenu values(@submenuId,@submenuName,@submenuslNo,@pluginName,null,@menuId)


--Declare @itemId uniqueidentifier =NEWID()
--DECLARE @itemName nvarchar(100)='Discontinued Product'
--DECLARE @itemslNo int='9'
--insert into Item values(@itemId,@submenuName,@itemslNo,@submenuId,null,null)

--insert into Permission values(NEWID(),'Create',1,'@itemId',null,'Create');

select * from Permission
select * from Item order by slNo
select * from SubMenu where menu_id='E03FCE8C-FA23-4955-BB0B-226C6171AA20' order by slNo
select * from Menu where module_id='62044030-08F6-47A9-B2E4-CDD87D746D98' order by slNo
select * from Menu where name='Dashboard'
select * from Module where id='2F1388E1-BFF2-499F-AB5B-1F01D686AE00'
