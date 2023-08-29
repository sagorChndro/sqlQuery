
-- first_name + ' ' + last_name AS full_name
Go
Alter PROCEDURE proc_InventoryMain 
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select i.[name] + '('+i.UPC+')' as [Name],t.reason,bip.price CostPrice,sp.wholeSaleAmount,sp.regularsaleamount 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	--left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where  t.item_Id=@itemId and g.branch_Id=@branch_id
END
GO

Go
Alter View [dbo].[view_Main]
as
    select i.[name] + '('+i.UPC+')' as [Name],t.reason,bip.price CostPrice,sp.wholeSaleAmount,sp.regularsaleamount 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	--left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	where t.item_Id='AD49D228-1F30-4193-92E8-453A89F56289' and g.branch_Id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
GO

--select unitCost, unitSale from tblItemTransaction
Go
ALTER PROCEDURE proc_InventoryPurchase 
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.transactionType,t.reason,t.quantity,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(s.mobile,'N/A')mobile, g.transactionId
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Opening Stock','New Stock')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
GO

Go
ALTER View [dbo].[viewPurchase]
as
select t.transactionType,t.reason,t.quantity,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(s.mobile,'N/A')mobile, g.transactionId
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	where t.reason in('Opening Stock','New Stock')
	and t.item_Id='AD49D228-1F30-4193-92E8-453A89F56289'
	and g.branch_Id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
GO



go
Alter PROCEDURE proc_InventorySales 
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.transactionType,t.reason,t.quantity,t.unitCost,isnull(tp.[name],'N/A') CustomerName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(tp.mobile,'N/A')mobile,g.invoiceId 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblParty tp with(nolock) on tp.id = g.groupName  
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Sales','Transfer')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
GO

Go
Alter View [dbo].[viewSales]
as
select t.transactionType,t.reason,t.quantity,t.unitCost,isnull(tp.[name],'N/A') CustomerName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(tp.mobile,'N/A')mobile,g.invoiceId 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblParty tp with(nolock) on tp.id = g.groupName  
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
	where t.reason in('Sales','Transfer')
	and t.item_Id='AD49D228-1F30-4193-92E8-453A89F56289'
	and g.branch_Id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
GO

Go
Alter PROCEDURE proc_PhysicalInventoryAndSalesReturn 
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.transactionType,t.reason,t.quantity,t.unitCost,isnull(tp.[name],'N/A') CustomerName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(tp.mobile,'N/A')mobile,g.invoiceId 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblParty tp with(nolock) on tp.id = g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Sales to Return')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
	
END

Go

Go
Alter View [dbo].[viewPurchesAddAndSalesReturn]
as
select t.transactionType,t.reason,t.quantity,t.unitCost,isnull(tp.[name],'N/A') CustomerName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(tp.mobile,'N/A')mobile,g.invoiceId  
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id  
	left join tblparty tp with (nolock) on tp.id=g.groupName
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	where t.reason in('Sales to Return')
	and t.item_Id='AAEE1766-1DFC-439B-8530-E7B17BA475FE'
	and g.branch_Id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
Go

Go
Alter PROCEDURE proc_PhysicalInventoryRemoveAndReturnSale
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select i.UPC,t.transactionType,t.reason,t.quantity,t.unitCost,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(s.mobile,'N/A')mobile,ISNULL(bip.price,0) AvgUnitCost,ISNULL(sp.wholeSaleAmount,0) wholeSaleAmount,ISNULL(sp.regularsaleamount,0) regularsaleamount 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName  
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Return to Supplier','PhysicalInventoryRemove')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
Go

Go
Alter View [dbo].[viewPhysicalInventoryRemoveAndReturnSale]
as
select i.UPC,t.transactionType,t.reason,t.quantity,t.unitCost,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
isnull(s.mobile,'N/A')mobile,ISNULL(bip.price,0) AvgUnitCost,ISNULL(sp.wholeSaleAmount,0) wholeSaleAmount,ISNULL(sp.regularsaleamount,0) regularsaleamount 
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	where t.reason in('Return to Supplier','PhysicalInventoryRemove')
	and t.item_Id='8BE1D002-F9FE-4EF3-AEA0-CF84411C3C10'
	and g.branch_Id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
Go


Alter PROCEDURE proc_PhysicalInventoryAddandRemove
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.reason,t.quantity,Cast(t.transactionDate as datetime) transactionDate, pt.remarks
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblParty tp with(nolock) on tp.id=g.groupName
	left join tblPartyTransaction pt with(nolock) on pt.customer=tp.Id
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('PhysicalInventoryAdd','PhysicalInventoryRemove')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
Go


Go
Create View [dbo].[view_AddandRemove]
as
select t.reason,t.quantity,Cast(t.transactionDate as datetime) transactionDate, pt.remarks
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblParty tp with(nolock) on tp.id=g.groupName
	left join tblPartyTransaction pt with(nolock) on pt.customer=tp.Id
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	where t.reason in('PhysicalInventoryAdd','PhysicalInventoryRemove')
	and t.item_Id='8BE1D002-F9FE-4EF3-AEA0-CF84411C3C10'
	and g.branch_Id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
Go

--select * from tblPartyTransaction
--select * from tblItemTransaction where item_Id='8BE1D002-F9FE-4EF3-AEA0-CF84411C3C10'
--select * from tblItem where Id='AAEE1766-1DFC-439B-8530-E7B17BA475FE'
--select * from tblParty
--select distinct(reason) from tblitemtransaction
--select * from tblitemtransaction where reason='PhysicalInventoryRemove'
--select * from tblGroupItem
--select * from tblBranchItemPrice
--select * from tblitemtransaction tR0ub1e#
--select * from tblItem
--select * from tblItemSellPrice

--exec proc_PhysicalInventoryRemoveAndReturnSale '1a7618a5-c359-4ea7-ab7a-10d80fce2c9d', '61a040e2-d737-49d6-8867-62a5184f1247' 

--exec proc_PhysicalInventoryRemoveAndReturnSale 'CE69FD67-DE29-4678-AF60-A1F506C5DD51','8BE1D002-F9FE-4EF3-AEA0-CF84411C3C10'
--exec proc_InventorySales 'CE69FD67-DE29-4678-AF60-A1F506C5DD51', '00000000-0000-0000-0000-000000000000' 
--exec proc_PhysicalInventoryAndSalesReturn 'CE69FD67-DE29-4678-AF60-A1F506C5DD51', '00000000-0000-0000-0000-000000000000', '6/1/2022 12:00:00 AM' , '6/30/2022 12:00:00 AM' 
--exec proc_InventoryPurchase'CE69FD67-DE29-4678-AF60-A1F506C5DD51', '00000000-0000-0000-0000-000000000000' 
--exec proc_InventorySales 'CE69FD67-DE29-4678-AF60-A1F506C5DD51', '00000000-0000-0000-0000-000000000000'
--exec proc_PhysicalInventoryRemoveAndReturnSale '1a7618a5-c359-4ea7-ab7a-10d80fce2c9d', '8be1d002-f9fe-4ef3-aea0-cf84411c3c10' 
--select * from tblBranch where id='1a7618a5-c359-4ea7-ab7a-10d80fce2c9d'
--select * from tblBranch where id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'

exec proc_PhysicalInventoryAddandRemove 'ce69fd67-de29-4678-af60-a1f506c5dd51', 'e48d0a06-530c-4f35-8adb-b5421667a722' 
exec proc_InventoryMaster'ce69fd67-de29-4678-af60-a1f506c5dd51', 'e48d0a06-530c-4f35-8adb-b5421667a722' 
exec proc_InventoryPurchase'ce69fd67-de29-4678-af60-a1f506c5dd51', 'e48d0a06-530c-4f35-8adb-b5421667a722' 
exec proc_PhysicalInventoryAddandRemove 'ce69fd67-de29-4678-af60-a1f506c5dd51', 'e48d0a06-530c-4f35-8adb-b5421667a722'
exec proc_PhysicalInventoryRemoveAndReturnSale 'ce69fd67-de29-4678-af60-a1f506c5dd51', 'e48d0a06-530c-4f35-8adb-b5421667a722' 
select * from OrganizationSettings


exec proc_InventoryMain'ce69fd67-de29-4678-af60-a1f506c5dd51', '61a040e2-d737-49d6-8867-62a5184f1247' 
exec proc_PhysicalInventoryAddandRemove 'ce69fd67-de29-4678-af60-a1f506c5dd51', '61a040e2-d737-49d6-8867-62a5184f1247' 
exec proc_PhysicalInventoryRemoveAndReturnSale 'ce69fd67-de29-4678-af60-a1f506c5dd51', '61a040e2-d737-49d6-8867-62a5184f1247' 

--viewPurchesAddAndSalesReturn


Go
Create PROCEDURE proc_PurchaseReturninfo
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.transactionType,t.quantity,t.unitCost,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(s.mobile,'N/A')mobile,g.transactionId
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName  
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Return to Supplier')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
Go



Go
Create View view_PurchaseReturninfo
as
	select t.transactionType,t.quantity,t.unitCost,isnull(s.[name],'N/A') SupplierName,Cast(t.transactionDate as datetime) transactionDate,
	isnull(s.mobile,'N/A')mobile,g.transactionId
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	left join tblSupplier s with(nolock)  on s.id= g.groupName  
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	where t.reason in('Return to Supplier')
	and t.item_Id='8BE1D002-F9FE-4EF3-AEA0-CF84411C3C10'
	and g.branch_Id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'

	Go