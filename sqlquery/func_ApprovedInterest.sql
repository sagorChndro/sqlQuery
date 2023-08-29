go
Alter FUNCTION [dbo].[func_ApprovedInterest] (@branch_id uniqueIdentifier,@reportDate Datetime)
RETURNS int
AS
BEGIN
	DECLARE @startDate datetime
	DECLARE @endDate datetime
	DECLARE @FYStartDate datetime
	DECLARE @ApprovedInterest numeric(15,2),@branch_id1 uniqueIdentifier
	set @branch_id1=@branch_id
	 select @startDate=dbo.LastDayOfMonth(@reportDate)
	 select @endDate=dbo.LastDayOfMonth(@reportDate)
	 SELECT @FYStartDate = dbo.FirstDayOfFY(@endDate)

	select @ApprovedInterest=IsNull(sum(l.Interest),0)-IsNull(sum(l.Fine),0) from savingsaccountsopeningline  l with (nolock)         
 inner join savingsaccount a with (nolock) on l.branch_id = a.branch_id and l.accountno = a.accountno         
 where l.branch_id = @branch_id1 and l.openingDate = @FYStartDate AND l.productcode in (2,3) and        
 (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed'        
  and a.closingDate>=@startDate))
	

	RETURN(@ApprovedInterest)
END