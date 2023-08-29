--select * from Permission
--SELECT * from Item where submenu_id='E2726118-46F3-4410-BC3E-D80E666B1613'
--select * from Permission where item_id='0C6297F7-C443-4C2D-98BB-E4AAABCA10EB' order by slNo, code
--select * from Item where submenu_id='E2726118-46F3-4410-BC3E-D80E666B1613'
--select * from item where name='Provident Fund'

Declare @permissionId uniqueidentifier =NEWID()
Declare @itemId uniqueidentifier ='0C6297F7-C443-4C2D-98BB-E4AAABCA10EB'
DECLARE @reportName nvarchar(100)='Inventory Master Report'
DECLARE @slNo int='20'
DECLARE @reportCode int='1220'



INSERT INTO Permission VALUES(@permissionId,@reportName,@slNo,@itemId,@reportCode,@reportName)
--INSERT INTO RolePermission VALUES( NEWID(),'55BA04B1-136D-4C15-B6EF-CD848C42CC42',@permissionId)
--delete from Permission where id='1B487D82-AC27-4DFB-89D6-EE9276189D7C'


--WF_RetiredEmployeePayableStatement
--select * from user_info where ='si'
select * from Permission 

SELECT * from Item where name='Inventory'
select * from SubMenu where id='E2726118-46F3-4410-BC3E-D80E666B1613'
select * from Permission where code='1220'