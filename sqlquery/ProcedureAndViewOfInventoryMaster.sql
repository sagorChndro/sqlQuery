Go
Declare @permissionId uniqueidentifier =NEWID()
Declare @itemId uniqueidentifier ='0C6297F7-C443-4C2D-98BB-E4AAABCA10EB'
DECLARE @reportName nvarchar(100)='Inventory Master Report'
DECLARE @slNo int='20'
DECLARE @reportCode int='1220'



INSERT INTO Permission VALUES(@permissionId,@reportName,@slNo,@itemId,@reportCode,@reportName)

Go


--InventoryMaster
ALTER PROCEDURE [dbo].[proc_InventoryMain] 
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN
	select   i.Id,i.[name] + '('+i.UPC+')' as [Name],t.reason,dbo.func_getItemInStockWithOutLocationForReport(@itemId,@branch_id) AS currentStock,
	bip.price as costPrice, sp.wholeSaleAmount, sp.regularsaleamount,
	 t.quantity openingStock
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	--left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId=@branch_id
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id=@branch_id
	where t.reason in('Opening Stock') and t.item_Id=@itemId and g.branch_Id=@branch_id
	Group By i.id, i.[name], i.UPC,t.reason,t.transactionType,bip.price,sp.wholeSaleAmount, sp.regularsaleamount, t.quantity
END





GO
ALTER View [dbo].[view_Main]
as
	select   i.Id,i.[name] + '('+i.UPC+')' as [Name],t.reason,dbo.func_getItemInStockWithOutLocationForReport('042453BE-E54F-4D2A-82AD-4A210188AF87','CE69FD67-DE29-4678-AF60-A1F506C5DD51') AS currentStock,
	bip.price as costPrice, sp.wholeSaleAmount, sp.regularsaleamount,
	t.quantity openingStock
	from tblitemtransaction t with(nolock)
	left join tblGroupItem g with(nolock) on t.group_id=g.group_id
	left join tblitem i with(nolock) on t.item_id=i.id
	--left join tblSupplier s with(nolock)  on s.id= g.groupName 
	left join tblBranchItemPrice bip with(nolock) on i.id=bip.item and bip.branchId='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	left join tblItemSellPrice sp with(nolock) on t.item_id=sp.item_id and sp.branch_id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	where t.reason in('Opening Stock') and t.item_Id='042453BE-E54F-4D2A-82AD-4A210188AF87' and g.branch_Id='CE69FD67-DE29-4678-AF60-A1F506C5DD51'
	Group By i.id, i.[name], i.UPC,t.reason,t.transactionType,bip.price,sp.wholeSaleAmount, sp.regularsaleamount, t.quantity

GO


--PurchaseInfo  Item Stock Register
GO
ALTER PROCEDURE [dbo].[proc_InventoryPurchase] 
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
	where t.reason in('New Stock')
	and t.item_Id=@itemId
	and g.branch_Id=@branch_id
END
Go


GO
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
	where t.reason in('New Stock')
	and t.item_Id='AD49D228-1F30-4193-92E8-453A89F56289'
	and g.branch_Id='EE69C4E2-3F4C-4EAF-9820-4453181FCAEB'
GO


--Salesinfo
GO
ALTER PROCEDURE [dbo].[proc_InventorySales] 
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
Go


GO
ALTER View [dbo].[viewSales]
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



--SalesReturnInfo
GO
ALTER PROCEDURE [dbo].[proc_PhysicalInventoryAndSalesReturn] 
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


GO
ALTER View [dbo].[viewPurchesAddAndSalesReturn]
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
GO


--Add and remove
GO
ALTER PROCEDURE [dbo].[proc_PhysicalInventoryAddandRemove]
	@branch_id uniqueidentifier,
	@itemId uniqueidentifier
AS
BEGIN 
	select t.reason,t.quantity,Cast(t.transactionDate as datetime) transactionDate, pt.remarks,t.transactionType
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



GO
ALTER View [dbo].[view_AddandRemove]
as
select t.reason,t.quantity,Cast(t.transactionDate as datetime) transactionDate, pt.remarks, t.transactionType
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
GO


--proc_PurchaseReturninfo
GO
ALTER PROCEDURE [dbo].[proc_PurchaseReturninfo]
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


GO
ALTER View [dbo].[view_PurchaseReturninfo]
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
GO


