
select * from item where id='B0CFFF8E-17BC-4B5F-8852-3A941E03BF36'
SELECT * from Item where submenu_id='E2726118-46F3-4410-BC3E-D80E666B1613'
--select * from Permission where item_id='B0CFFF8E-17BC-4B5F-8852-3A941E03BF36' order by slno asc 
--select * from Permission where name='Staffs Welfare Fund Assistance Payment Statement'

--select * from Permission where item_id='B0CFFF8E-17BC-4B5F-8852-3A941E03BF36' order by slno asc

--select * from item where name='HR'
--
Declare @permissionId uniqueidentifier =NEWID()
Declare @itemId uniqueidentifier ='B0CFFF8E-17BC-4B5F-8852-3A941E03BF36'
DECLARE @reportName nvarchar(100)='Transfer Order'
DECLARE @slNo int='47'
DECLARE @reportCode int='821'

INSERT INTO Permission VALUES(@permissionId,@reportName,@slNo,@itemId,@reportCode,@reportName)


--select * from Permission where item_id='13CCF15D-BBF2-4FFB-B233-67EDE7490776'
---select * from item where name ='Savings'
--select * from Permission where code='820'

--data move from one database to another database 
--if the database name was same name use this 
--INSERT INTO [IMFAS-ERP].dbo.Item
--SELECT * from Item WHERE ID='E5D0FC07-3D09-4211-9FB8-42FC7C054CA9'
--delete from Permission where id='96BF3573-13BE-48E8-AD4B-7A6F9A02D2D0'