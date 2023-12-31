
ALTER FUNCTION [dbo].[GetMonthlySavingsCombinedCollectionsheet] (
@branch_id UniqueIdentifier, @centId varchar(100),@dayOfWork DateTime, @programId varchar(100), @start_date DateTime) 
RETURNS @TABLE TABLE(programId int, programName varchar(256), ProductCode int, ProductName varchar(256), CentId int, CentName varchar(256),
					 customerId numeric(4), custName varchar(256), gsaccountbalance numeric(25,2), 
					 inst1_date DateTime, gs_inst1_amt numeric(15,2), gs_inst1_amt_act numeric(15,2), inst1_withdrawal_act numeric(15,2),
					 inst2_date DateTime, gs_inst2_amt numeric(15,2), gs_inst2_amt_act numeric(15,2), inst2_withdrawal_act numeric(15,2),
					 inst3_date DateTime, gs_inst3_amt numeric(15,2), gs_inst3_amt_act numeric(15,2), inst3_withdrawal_act numeric(15,2),
					 inst4_date DateTime, gs_inst4_amt numeric(15,2), gs_inst4_amt_act numeric(15,2), inst4_withdrawal_act numeric(15,2),
					 inst5_date DateTime, gs_inst5_amt numeric(15,2), gs_inst5_amt_act numeric(15,2), inst5_withdrawal_act numeric(15,2)) 					 
					 
AS
BEGIN
	DECLARE @firstWorkingDate DATETIME
	DECLARE @lastWorkingDateOfMonth DateTime
	SELECT @firstWorkingDate = dateadd(dd,(DATEPART(DW,@dayOfWork)-2),DATEADD(wk, DATEDIFF(wk,0,dateadd(dd,7-datepart(day,dbo.LastDayOfMonth(@start_date)),dbo.LastDayOfMonth(@start_date))), 0))
	if DATEPART(D,@firstWorkingDate) >7
		SET @firstWorkingDate = DATEADD(D,-7,@firstWorkingDate)	
		SET @lastWorkingDateOfMonth = DATEADD(D,28, @firstWorkingDate )    

	Insert into @TABLE
	select p.programId,p.programName, sp.ProductCode, sp.ProductName, r.CentId, r.Centname, RIGHT(c.customerId,4) customerId,'custName'= CASE WHEN cc.MobileNo is null THEN c.custName + ' / ' + ISNULL(c.sName, c.fName) else c.custName + ' / ' + ISNULL(c.sName, c.fName) + ' (' + cc.MobileNo + ')' END,
	'gsaccountbalance'=sao.AccountBalance,	
	'inst1_date'= DATEADD(D,0,@firstWorkingDate),
	'gs_inst1_amt'=sa.DepositScheme,
	'gs_inst1_amt_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 0 and t.transdate between @start_date and @firstWorkingDate),0),
	'inst1_withdrawal_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 1 and t.transdate between @start_date and @firstWorkingDate),0),
	'inst2_date'= DATEADD(D,7,@firstWorkingDate),
	'gs_inst2_amt'=sa.DepositScheme,
	'gs_inst2_amt_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 0 and t.transdate between DATEADD(D,1,@firstWorkingDate) and DATEADD(D,7,@firstWorkingDate)),0),
	'inst2_withdrawal_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 1 and t.transdate between DATEADD(D,1,@firstWorkingDate) and DATEADD(D,7,@firstWorkingDate)),0),
	'inst3_date'= DATEADD(D,14,@firstWorkingDate),
	'gs_inst3_amt'=sa.DepositScheme,
	'gs_inst3_amt_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 0 and t.transdate between DATEADD(D,8,@firstWorkingDate) and DATEADD(D,14,@firstWorkingDate)),0),
	'inst3_withdrawal_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 1 and t.transdate between DATEADD(D,8,@firstWorkingDate) and DATEADD(D,14,@firstWorkingDate)),0),
	'inst4_date'= DATEADD(D,21,@firstWorkingDate),
	'gs_inst4_amt'=sa.DepositScheme,
	'gs_inst4_amt_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 0 and t.transdate between DATEADD(D,15,@firstWorkingDate) and DATEADD(D,21,@firstWorkingDate)),0),
	'inst4_withdrawal_act'=ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 1 and t.transdate between DATEADD(D,15,@firstWorkingDate) and DATEADD(D,21,@firstWorkingDate)),0),
	'inst5_date'= CASE WHEN MONTH(@lastWorkingDateOfMonth) = MONTH(@start_date) THEN DATEADD(D,28,@firstWorkingDate) ELSE NULL END,
	'gs_inst5_amt'= CASE WHEN MONTH(@lastWorkingDateOfMonth) = MONTH(@start_date) THEN sa.DepositScheme ELSE NULL END,
	'gs_inst5_amt_act'=CASE WHEN MONTH(@lastWorkingDateOfMonth) = MONTH(@start_date) THEN ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 0 and t.transdate between DATEADD(D,22,@firstWorkingDate) and dbo.LastDayOfMonth(@start_date)),0) ELSE 0 END,
	'inst5_withdrawal_act'=CASE WHEN MONTH(@lastWorkingDateOfMonth) = MONTH(@start_date) THEN ISNULL((Select SUM(t.transAmount) from AccountTransaction t where t.AccountNo = sa.AccountNo and t.transType = 1 and t.transdate between DATEADD(D,22,@firstWorkingDate) and dbo.LastDayOfMonth(@start_date)),0) ELSE 0 END
	from MicrocreditProgram p inner join customer  c on p.programId = c.programId
	inner join center r on c.branch_id = r.branch_id and c.centId = r.centId
	left outer join EmployeeGenInfo e on r.branch_id = e.branch_id and r.devWorker = e.empId
	left join CustomerContact cc on c.id = cc.Customer_id
	left outer join SavingsAccount sa on c.branch_id = sa.branch_id and c.customerId = sa.customerId and (sa.AccountStatus = 'Operative' or ( sa.AccountStatus = 'Closed' and sa.closingDate >= @start_date)) 
	left outer join SavingsAccountsOpeningLine sao on sa.branch_id = sao.branch_id and sa.AccountNo = sao.AccountNo
	Left Join SavingsproductDef sp on sa.ProductCode = sp.ProductCode
	Where (c.customerStatus = 'Active' or (c.customerStatus = 'Dropout' and dropout_date >= @start_date)) AND c.branch_id =@branch_id 
	and c.centId = CASE WHEN @centId = '' THEN c.centId  ELSE @centId END  
	and p.programId  = CASE WHEN @programId = '' THEN p.programId  ELSE @programId END
	and IsNULL(sao.OpeningDate,@start_date) = @start_date
	and sa.DepositLife is null and (sa.numOfInstallment is null or sa.numOfInstallment = 0)
	return
END
---------------------------
