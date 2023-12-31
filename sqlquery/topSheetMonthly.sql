--DECLARE @branch_Id uniqueidentifier,@period_start_Date dateTime='2023-07-01',@period_end_Date dateTime='2023-07-31'
----SELECT @branch_Id=id from tblBranch with (nolock) where branchId='001'
--SET @branch_Id='00000000-0000-0000-0000-000000000000' 
--SELECT * FROM func_TopsheetOfMonthlyWriteOffStatus_new(@branch_Id,@period_start_Date,@period_end_Date)

ALTER FUNCTION [dbo].[func_TopsheetOfMonthlyWriteOffStatus_new]
(	
	@branch_Id uniqueidentifier,@period_start_Date dateTime,@period_end_Date dateTime
)
RETURNS 
@topsheetOfMonthlyWriteOffStatus TABLE (
Region varchar(100),
Area varchar(100),
Unit varchar(100),
branchid varchar(3),
prevLoanee numeric(5),
prevAmount numeric(15,2),
currWOLoanee numeric(5),
currWOAmount numeric(15,2),
currLoanee numeric(5),
currAmount numeric(15,2),
uptoCurrLoanee numeric(5),
uptoCurrAmount numeric(15,2)
)
AS
BEGIN

	INSERT INTO @topsheetOfMonthlyWriteOffStatus
	
	SELECT Distinct
	ISNULL((select top(1) MappedZoneId from  tempZoneMapping with(nolock) where ZoneId = z.zoneid), '') + '- ' + ISNULL(z.zoneName, '')Region, 
	ISNULL(a.AreaId, '') + '- ' + ISNULL(a.AreaName, '')Area,
	ISNULL(b.branchid, '') + '- ' + ISNULL(b.BranchName, '')Unit,	
	b.branchid,
	w1.prevLoanee ,
	w1.prevAmount ,
	w1.currWOLoanee ,
	w1.currWOAmount ,
	w1.currLoanee ,
	w1.currAmount ,
	w1.uptoCurrLoanee ,
	w1.uptoCurrAmount 
	from tblSubZoneLines szl with (nolock) 
	inner join tblZone z with (nolock) on z.zoneid=szl.zoneid
	inner join tblarealines al with (nolock) on szl.subzone_id = al.subzone_id
	inner join tblArea a with (nolock) on a.id=al.area_id
	inner join tblbranchLines bl with (nolock) on al.area_id=bl.area_id
	inner join tblBranch b with (nolock) on b.id=bl.branch_id
	--inner join tblWriteofAccount wa with (nolock) on wa.branch_id = b.ID
	--inner join Customer cu on wa.customerid=cu.customerId 
	--inner join LoanAccount la with (nolock) on la.AccountNo = wa.loanAccountNo
	inner join func_getNumofLoaneeAmount_new(@branch_Id,@period_start_Date,@period_end_Date) w1 on b.branchId = w1.branchId
	where b.ID = CASE @branch_Id When '00000000-0000-0000-0000-000000000000' then b.ID else @branch_Id end 	
	
	
	
RETURN
END

