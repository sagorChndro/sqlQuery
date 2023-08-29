goinsert into submenu values('52C89B21-55BB-40A9-98FF-88FC706B031B','Discontinued Product',75,'initvent_inventory_discontinued_product',null,'E03FCE8C-FA23-4955-BB0B-226C6171AA20');insert into Item values('7E9D13F9-D991-4796-AB1D-02AA2CD9F6C7','Discontinued Product',5,'52C89B21-55BB-40A9-98FF-88FC706B031B',null,null);insert into Permission values(NEWID(),'Create',1,'7E9D13F9-D991-4796-AB1D-02AA2CD9F6C7',null,'Create');insert into Permission values(NEWID(),'Read',2,'7E9D13F9-D991-4796-AB1D-02AA2CD9F6C7',null,'Read');insert into Permission values(NEWID(),'Update',3,'7E9D13F9-D991-4796-AB1D-02AA2CD9F6C7',null,'Update');insert into Permission values(NEWID(),'Delete',4,'7E9D13F9-D991-4796-AB1D-02AA2CD9F6C7',null,'Delete');goselect * from SubMenu where id='52C89B21-55BB-40A9-98FF-88FC706B031B'--select NEWID()select * from SubMenu where name='Discontinued Product'select * from SubMenu where menu_id='E03FCE8C-FA23-4955-BB0B-226C6171AA20'--insert into dynamically for submenu--Declare @submenuId uniqueidentifier =NEWID()
--DECLARE @submenuName nvarchar(100)='Discontinued Product'
--DECLARE @submenuslNo int='9'
--Declare @pluginName nvarchar(100) ='initvent_inventory_discontinued_product'
--Declare @menuId uniqueidentifier ='E03FCE8C-FA23-4955-BB0B-226C6171AA20'

--insert into SubMenu values(@submenuId,@submenuName,@submenuslNo,@pluginName,null,@menuId)


--Declare @itemId uniqueidentifier =NEWID()
--DECLARE @itemName nvarchar(100)='Discontinued Product'
--DECLARE @itemslNo int='9'
--insert into Item values(@itemId,@submenuName,@itemslNo,@submenuId,null,null)

--insert into Permission values(NEWID(),'Create',1,'@itemId',null,'Create');--insert into Permission values(NEWID(),'Read',2,'@itemId',null,'Read');--insert into Permission values(NEWID(),'Update',3,'@itemId',null,'Update');--insert into Permission values(NEWID(),'Delete',4,'@itemId',null,'Delete');

select * from Permission
select * from Item order by slNo
select * from SubMenu where menu_id='E03FCE8C-FA23-4955-BB0B-226C6171AA20' order by slNo
select * from Menu where module_id='62044030-08F6-47A9-B2E4-CDD87D746D98' order by slNo
select * from Menu where name='Dashboard'
select * from Module where id='2F1388E1-BFF2-499F-AB5B-1F01D686AE00'

