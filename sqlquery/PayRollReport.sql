--1
GO

ALTER PROCEDURE [dbo].[proc_Employee_Loan_Balances] @levelId INT
	,@filterData NVARCHAR(max)
	,@periodStartDate DATETIME
	,@periodEndDate DATETIME
	,@ProgramMajor UNIQUEIDENTIFIER 
	,@ProgramSubMajor UNIQUEIDENTIFIER  
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	SELECT ai.employee_id
		,egi.empId
		,egi.EmployeeId
		,egi.empName
		,ai.DisburseAmount
		,ai.DisburseDate
		,ai.installmentDate
		,ServiceCharge = (
			SELECT sum(isnull(servicecharge, 0))
			FROM HRStaffLoanRepaySchedule
			WHERE staffLoanSecId = ai.SectorId
				AND employee_id = ai.employee_id
				AND approved_by_id IS NOT NULL
			    and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			)
		,NoOfDeduction = (
			SELECT COUNT(*)
			FROM HRStaffLoanRepaySchedule
			WHERE staffLoanSecId = ai.SectorId
				AND employee_id = ai.employee_id
				and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				AND PayStatus = 'Paid'
			)
		,LoanPeriod = (
			SELECT COUNT(*)
			FROM HRStaffLoanRepaySchedule
			WHERE staffLoanSecId = ai.SectorId
				AND employee_id = ai.employee_id
				AND approved_by_id IS NOT NULL
				and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			)
		,CurrentDeduction = isnull((
				SELECT SUM(isnull(Amount, 0))
				FROM HRStaffLoanRepaySchedule
				WHERE staffLoanSecId = ai.SectorId
					AND employee_id = ai.employee_id
					AND PayMonth BETWEEN dbo.startDayofMonth(@periodStartDate)
						AND dbo.lastDayofMonth(@periodEndDate)
					AND realizationDate IS NOT NULL
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				), 0)
		,YearToDateDeduction = isnull((
				SELECT SUM(isnull(Amount, 0))
				FROM HRStaffLoanRepaySchedule
				WHERE staffLoanSecId = ai.SectorId
					AND employee_id = ai.employee_id
					AND PayMonth BETWEEN DATEADD(yy, DATEDIFF(yy, 0, @periodStartDate), 0)
						AND dbo.lastDayofMonth(@periodEndDate)
					AND realizationDate IS NOT NULL
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				), 0)
		,closingBalance = (
			ai.DisburseAmount + (
				SELECT sum(isnull(servicecharge, 0))
				FROM HRStaffLoanRepaySchedule
				WHERE staffLoanSecId = ai.SectorId
					AND employee_id = ai.employee_id
					AND approved_by_id IS NOT NULL
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				) - isnull((
					SELECT SUM(isnull(Amount, 0))
					FROM HRStaffLoanRepaySchedule
					WHERE staffLoanSecId = ai.SectorId
						AND employee_id = ai.employee_id
						AND PayMonth <= dbo.lastDayofMonth(@periodStartDate)
						AND realizationDate IS NOT NULL
						and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
					), 0)
			)
		,egi.payrollType
		,sls.SectorName AS sectorId
	FROM EmployeeGenInfo egi
	INNER JOIN HRStaffLoanInfo ai ON egi.id = ai.employee_id
	INNER JOIN StaffLoanSector sls ON ai.Sector_Id = sls.Id
	WHERE egi.branch_id IN (
			SELECT branchId
			FROM @tblBranch
			)
			and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
END
	---
go

--2
GO
ALTER PROCEDURE [dbo].[proc_empsalIncrement] 
	@levelId INT,
	@filterData NVARCHAR(max),
	@periodStartDate DATETIME,
	@periodEndDate DATETIME,
	@ProgramMajor UNIQUEIDENTIFIER, 
	@ProgramSubMajor UNIQUEIDENTIFIER,  
	@ProgramMinor UNIQUEIDENTIFIER,
	@userId varchar(30),
	@empId UNIQUEIDENTIFIER = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	SELECT eg.empId,
		eg.empName,
		d.desgName,
		dp.deptName,
		g.GradeName,
		gs.stepName,
		es.ItemName,
		gd.SingleItemAmount,
		eh.promotionEffectiveDate
	FROM EmployeePromostionHistry eh
	INNER JOIN EmployeeGenInfo eg ON eg.Id = eh.employee_id
	INNER JOIN EmployeeGradeNew g ON g.id = eh.NewEmpGrade_Id
	INNER JOIN EmployeeGradeStepNew gs ON gs.id = eh.NewEmpStep_id
	INNER JOIN Designation d ON d.ID = eh.newDesignation_id
	LEFT JOIN Department dp ON dp.ID = eh.newDepartment_id
	INNER JOIN GradeStepSalaryItem gd ON gd.grade_id = eh.NewEmpGrade_Id
		AND gd.gradeStep_id = eh.NewEmpStep_id
	INNER JOIN empSalaryItem es ON es.Id = gd.salaryItem_Id
	INNER JOIN EmployeeSalInfo esl ON esl.employee_id = eg.id
	WHERE eg.id = @empId
		AND eg.branch_id IN (SELECT branchId FROM @tblBranch)
		AND eh.promotionEffectiveDate BETWEEN @periodStartDate AND @periodEndDate
		and eg.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
END
go

--3

GO
ALTER PROCEDURE [dbo].[proc_Payroll_Summary_Analysis] @levelId INT
	,@filterData NVARCHAR(max)
	,@periodStartDate DATETIME
	,@periodEndDate DATETIME
	,@ProgramMajor UNIQUEIDENTIFIER
	,@ProgramSubMajor UNIQUEIDENTIFIER
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	SELECT item_id
		,salId
		,ItemName
		,'CurrentMonth' = SUM(curAmount)
		,'PreviousMonth' = SUM(prevAmount)
		,'variance' = 0
		,'remarks' = ''
	FROM (
		SELECT 'branch_id' = b.ID
			,b.branchId
			,b.branchName
			,p.Id AS item_id
			,p.salId
			,p.ItemName
			,'curAmount' = Sum(IsNull(d.currentAmount, 0))
			,'prevAmount' = Sum(IsNull(e.previousAmount, 0))
		FROM tblBranch b
		CROSS JOIN empSalaryItem p
		LEFT JOIN (
			SELECT ps.branch_id
				,pss.salaryItem_Id
				,pss.salaryItemId
				,'currentAmount' = sum(pss.SingleItemAmount)
			FROM paySlipSalaryItem pss
			INNER JOIN PaySlip ps ON ps.ID = pss.paySlip_id
			INNER JOIN employeeGenInfo egi ON egi.id = ps.employee_id
			WHERE ps.PayMonth BETWEEN dbo.startDayofMonth(@periodStartDate)
					AND dbo.lastDayofMonth(@periodEndDate)
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
						--and egi.payrollType = @parollType
				AND egi.branch_id IN (
					SELECT branchId
					FROM @tblBranch
					)
			GROUP BY ps.branch_id
				,pss.salaryItem_Id
				,pss.salaryItemId
			) d ON b.ID = d.branch_id
			AND p.id = d.salaryItem_Id
		LEFT JOIN (
			SELECT ps.branch_id
				,pss.salaryItem_Id
				,pss.salaryItemId
				,'previousAmount' = sum(pss.SingleItemAmount)
			FROM paySlipSalaryItem pss
			INNER JOIN PaySlip ps ON ps.ID = pss.paySlip_id
			INNER JOIN employeeGenInfo egi ON egi.id = ps.employee_id
			WHERE ps.PayMonth BETWEEN dbo.startDayofMonth(DATEADD(MONTH, DATEDIFF(MONTH, 0, @periodStartDate) - 1, 0))
					AND dbo.lastDayofMonth(DATEADD(MONTH, DATEDIFF(MONTH, 0, @periodEndDate) - 1, 0))
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			--and egi.payrollType = @parollType
			GROUP BY ps.branch_id
				,pss.salaryItem_Id
				,pss.salaryItemId
			) e ON b.ID = e.branch_id
			AND p.id = e.salaryItem_Id
		GROUP BY b.ID
			,b.branchId
			,b.branchName
			,p.Id
			,p.salId
			,p.ItemName
		) abc
	WHERE salId NOT IN (
			199
			,299
			)
		AND branch_id IN (
			SELECT branchId
			FROM @tblBranch
			)
	GROUP BY item_id
		,salId
		,ItemName --order by salId
END
Go

--4
GO  
ALTER PROCEDURE [dbo].[proc_salaryStatement]   
 @levelId INT,  
 @filterData NVARCHAR(max),  
 @periodStartDate DATETIME,  
 @periodEndDate DATETIME,  
 @ProgramMajor UNIQUEIDENTIFIER,  
 @ProgramSubMajor UNIQUEIDENTIFIER,  
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId varchar(30)
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
  
 INSERT INTO @tblBranch  
 SELECT branch_id  
 FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)  
  
 SELECT a.EmployeeId  
  ,a.empName  
  ,a.desgName eDesignation   
  ,a.accountNo  
  ,a.bankName  
  ,a.routingNo  
  ,ROUND(a.tNetpay - (b.tNetpay + isnull(c.advAmount, 0) + isnull(d.loanAmount, 0)), 0) tNetpay 
  ,a.Program_MinorId
  
 FROM (  
  SELECT e.EmployeeId AS EmployeeId  
   ,empname  
   ,d.desgName  
   ,ISNULL(accountNo,'-') accountNo  
   ,IsNULL(b.name,'-') bankName  
   ,ISNULL(e.routingNo,'-') routingNo  
   ,sum(ps.SingleItemAmount) tNetpay  
   ,e.Program_MinorId
  FROM EmployeeGenInfo e with(nolock)  
  INNER JOIN Designation d with(nolock) ON d.ID=e.designation_id  
  INNER JOIN payslip p with(nolock) ON e.id = p.employee_id  
  INNER JOIN paySlipSalaryItem ps with(nolock) ON p.id = ps.paySlip_id  
  INNER JOIN empSalaryItem es with(nolock) ON es.id = ps.salaryItem_Id  
  LEFT JOIN tblBank b with(nolock) on b.ID=e.bank_id  
  WHERE  e.Program_MajorId=case @ProgramMajor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_MajorId else @ProgramMajor end       
  AND  
   e.Program_SubMajorId=case @ProgramSubMajor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_SubMajorId else @ProgramSubMajor end       
  AND  
   e.Program_MinorId=case @ProgramMinor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_MinorId else @ProgramMinor end AND  
  es.ItemType = 1  
   AND paymonth BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND e.terminDate IS NULL  
   AND e.branch_id IN (  
    SELECT branchId  
    FROM @tblBranch  
    )  
  
  GROUP BY e.EmployeeId  
   ,empName  
   ,d.desgName  
   ,accountNo  
   ,b.name  
   ,e.routingNo  
   ,e.Program_MinorId
  ) a  
 LEFT JOIN (  
  SELECT e.EmployeeId AS EmployeeId  
   ,empname  
   ,d.desgName  
   ,accountNo  
   ,sum(ps.SingleItemAmount) tNetpay  
  FROM EmployeeGenInfo e  
  INNER JOIN Designation d with(nolock) ON d.ID=e.designation_id  
  INNER JOIN payslip p with(nolock) ON e.id = p.employee_id  
  INNER JOIN paySlipSalaryItem ps with(nolock) ON p.id = ps.paySlip_id  
  INNER JOIN empSalaryItem es with(nolock) ON es.id = ps.salaryItem_Id  
  WHERE  e.Program_MajorId=case @ProgramMajor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_MajorId else @ProgramMajor end       
  AND  
   e.Program_SubMajorId=case @ProgramSubMajor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_SubMajorId else @ProgramSubMajor end       
  AND  
   e.Program_MinorId=case @ProgramMinor when '00000000-0000-0000-0000-000000000000'  
   then e.Program_MinorId else @ProgramMinor end AND  
  es.ItemType = 0  
   AND paymonth BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND e.terminDate IS NULL  
   AND e.branch_id IN (  
    SELECT branchId  
    FROM @tblBranch  
    )  
  GROUP BY e.EmployeeId  
   ,empName  
   ,d.desgName  
   ,accountNo  
  ) b ON b.EmployeeId = a.EmployeeId  
 LEFT JOIN (  
  SELECT e.EmployeeId  
   ,isnull(Amount, 0) advAmount  
  FROM AdvanceRepaySchedule ars with(nolock)  
  INNER JOIN EmployeeGenInfo e with(nolock) ON e.id=ars.employee_id  
  WHERE PayMonth BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND PayStatus = 'Paid'  
  ) c ON c.EmployeeId = a.EmployeeId  
 LEFT JOIN (  
  SELECT e.EmployeeId  
   ,isnull(Amount, 0) loanAmount  
  FROM HrStaffLoanRepaySchedule hls with(nolock)   
  INNER JOIN EmployeeGenInfo e with(nolock) ON e.id=hls.employee_id  
  WHERE PayMonth BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND PayStatus = 'Paid'  
  ) d ON d.EmployeeId = a.EmployeeId  
 where a.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))

END    
 Go

 --5
GO

ALTER PROCEDURE [dbo].[proc_Employee_Advance_Balances] @levelId INT
	,@filterData NVARCHAR(max)
	,@periodStartDate DATETIME
	,@periodEndDate DATETIME
	,@ProgramMajor UNIQUEIDENTIFIER  
	,@ProgramSubMajor UNIQUEIDENTIFIER  
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	SELECT egi.branch_id
		,ai.employee_id
		,egi.empId
		,egi.empName
		,ai.AdvanceAmount
		,advPeriod = (
			SELECT COUNT(*)
			FROM AdvanceRepaySchedule
			WHERE AdvanceSectorId = ai.AdvanceSectorId
				AND employee_id = ai.employee_id
				and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				AND PayStatus = 'Paid'
			)
		,NoOfDeduction = (
			SELECT COUNT(*)
			FROM AdvanceRepaySchedule
			WHERE AdvanceSectorId = ai.AdvanceSectorId
				AND employee_id = ai.employee_id
				AND approved_by_id IS NOT NULL
				and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			)
		,CurrentDeduction = isnull((
				SELECT SUM(isnull(Amount, 0))
				FROM AdvanceRepaySchedule
				WHERE AdvanceSectorId = ai.AdvanceSectorId
					AND employee_id = ai.employee_id
					AND PayMonth BETWEEN dbo.startDayofMonth(@periodStartDate)
						AND dbo.lastDayofMonth(@periodEndDate)
					AND realizedDate IS NOT NULL
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				), 0)
		,YearToDateDeduction = isnull((
				SELECT SUM(isnull(Amount, 0))
				FROM AdvanceRepaySchedule
				WHERE AdvanceSectorId = ai.AdvanceSectorId
					AND employee_id = ai.employee_id
					AND PayMonth BETWEEN DATEADD(yy, DATEDIFF(yy, 0, @periodStartDate), 0)
						AND dbo.lastDayofMonth(@periodEndDate)
					AND realizedDate IS NOT NULL
					and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
				), 0)
		,closingBalance = (
			ai.AdvanceAmount - isnull((
					SELECT SUM(isnull(Amount, 0))
					FROM AdvanceRepaySchedule
					WHERE AdvanceSectorId = ai.AdvanceSectorId
						AND employee_id = ai.employee_id
						AND PayMonth <= dbo.lastDayofMonth(@periodEndDate)
						AND realizedDate IS NOT NULL
						and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
					), 0)
			)
		,egi.payrolltype
	FROM EmployeeGenInfo egi
	INNER JOIN AdvanceInfo ai ON egi.id = ai.employee_id
	WHERE egi.branch_id IN (
			SELECT branchId
			FROM @tblBranch
			)
			and egi.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
END
	---
Go

--6

GO
ALTER PROCEDURE [dbo].[proc_EmployeeNetPayForbankTransfer] @levelId INT
	,@filterData NVARCHAR(max)
	,@periodStartDate DATETIME
	,@periodEndDate DATETIME
	,@ProgramMajor UNIQUEIDENTIFIER  
	,@ProgramSubMajor UNIQUEIDENTIFIER  
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	SELECT empId
		,a.empName
		,a.desgName
		,routingNo
		,empBranchId 
		,empBranchName
		,empBankName 
		,empBankBranchName
		,b.paymonth
		,a.accountNo
		,ROUND(ISNULL(a.tNetpay,0) - (isNULL(b.tNetpay,0) + isnull(c.advAmount, 0) + isnull(d.loanAmount, 0)+isnull(e.PfloanAmount, 0)), 0) tNetpay
	FROM (
		SELECT e.EmployeeId empId
			,e.id AS EmployeeId
			,empname,
			d.desgName,
			e.routingNo
			,br.branchId empBranchId
			,br.branchName empBranchName
			,b.[name] empBankName
			,e.BankBranchName empBankBranchName
			,e.accountNo
			,sum(ps.SingleItemAmount) tNetpay
		FROM EmployeeGenInfo e
		INNER JOIN Designation d ON d.ID = dbo.func_getEmployeeDesignation(e.id,@periodEndDate)
		INNER JOIN payslip p ON e.id = p.employee_id
		INNER JOIN paySlipSalaryItem ps ON p.id = ps.paySlip_id
		INNER JOIN empSalaryItem es ON es.id = ps.salaryItem_Id
		INNER JOIN tblBranch br ON br.ID = dbo.func_getEmployeeBranch(e.id,@periodEndDate)
		LEFT JOIN tblBank b on e.bank_id =b.ID
		--LEFT JOIN BankBranch bb on bb.id =e.bankBranch_id
		WHERE es.ItemType = 1
			AND paymonth BETWEEN @periodStartDate
				AND @periodEndDate
			AND e.terminDate IS NULL
			and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			AND e.branch_id IN (
				SELECT branchId
				FROM @tblBranch
				)
		GROUP BY e.EmployeeId
			,e.id
			,empName
			,d.desgName
			,e.routingNo
			,br.branchId
			,br.branchName
			,b.name
			,e.BankBranchName
			,accountNo
		) a
	LEFT JOIN (
		SELECT employee_id AS EmployeeId
			,empname
			,e.branch_id
			,accountNo
			,sum(ps.SingleItemAmount) tNetpay
			,p.PayMonth
		FROM EmployeeGenInfo e
		INNER JOIN Designation d ON d.ID = dbo.func_getEmployeeDesignation(e.id,@periodEndDate)
		INNER JOIN payslip p ON e.id = p.employee_id
		INNER JOIN paySlipSalaryItem ps ON p.id = ps.paySlip_id
		INNER JOIN empSalaryItem es ON es.id = ps.salaryItem_Id
		INNER JOIN tblBranch br ON br.ID = dbo.func_getEmployeeBranch(e.id,@periodEndDate)
		LEFT JOIN tblBank b on e.bank_id =b.ID
		--LEFT JOIN BankBranch bb on bb.id =e.bankBranch_id
		WHERE es.ItemType = 0
			AND paymonth BETWEEN @periodStartDate
				AND @periodEndDate
			AND e.terminDate IS NULL
			and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			AND e.branch_id IN (
				SELECT branchId
				FROM @tblBranch
				)
		GROUP BY employee_id
			,empName
			,accountNo
			,e.branch_id
			,p.PayMonth
		) b ON b.EmployeeId = a.EmployeeId
	LEFT JOIN (
		SELECT employee_id
			,isnull(Amount, 0) advAmount
		FROM AdvanceRepaySchedule
		WHERE PayMonth BETWEEN @periodStartDate
				AND @periodEndDate
			AND PayStatus = 'Paid'
		) c ON c.employee_id = a.EmployeeId
	LEFT JOIN (
		SELECT employee_id
			,isnull(Amount, 0) loanAmount
		FROM HrStaffLoanRepaySchedule
		WHERE PayMonth BETWEEN @periodStartDate
				AND @periodEndDate
			AND PayStatus = 'Paid'

		) d ON d.employee_id = a.EmployeeId
	LEFT JOIN (
		SELECT employee_id
			,isnull(Amount, 0) PfloanAmount
		FROM StaffLoanRepaySchedule
		WHERE PayMonth BETWEEN @periodStartDate
				AND @periodEndDate
			AND PayStatus = 'Paid'

		) e ON e.employee_id = a.EmployeeId
END
	--
Go
--7
GO
ALTER FUNCTION [dbo].[func_ProvisionPFContributionGratuity]  
(  
 @FilterBy varchar(20),  
 @FilterData varchar(max),  
 @periodStartDate DateTime,  
 @periodEndDate DateTime,
 @ProgramMajor UNIQUEIDENTIFIER, 
 @ProgramSubMajor UNIQUEIDENTIFIER,  
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId varchar(30)
)  
RETURNS   
@Provision TABLE   
(  
 empName varchar(100),  
 EmployeeId varchar(100),  
 desgName varchar(200), 
 SubZone varchar(200),
 BasicSalary numeric(10,2),  
 orgPFAmount numeric(10,2),  
 GratuityAmount numeric(10,2)  
)  
AS  
BEGIN  
 DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
 INSERT INTO @tblBranch  
 SELECT branch_id FROM func_GetBranchInfo(@FilterBy, @FilterData, @periodEndDate)  
 
 DECLARE @basicSalaryInfo TABLE (
	EmployeeId varchar(100),
	BasicSalary numeric(10,2)
 ) 

 INSERT INTO @basicSalaryInfo
 SELECT EmployeeId,dbo.func_getBasicSalaryAmount(e.id,@periodEndDate) from EmployeeGenInfo e with (nolock) 
 INNER JOIN  tblBranch b on b.ID=ISNULL(e.salaryLocation, dbo.func_getEmployeeBranch(e.id,@periodEndDate)) 
 Where empEndType=1 AND empType=1 and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))  AND 
 ISNULL(e.salaryLocation, b.id) in (Select branchId from @tblBranch) 


 INSERT INTO @Provision  
 select eg.empName, eg.EmployeeId, d.desgName,s.SubZoneName,ISNULL(bi.BasicSalary,0) , Sum(ISNULL(pf.orgPFamount,0)) orgPFamount,Sum(ISNULL( tg.amount,0)) GratuityAamount from EmployeeGenInfo eg with (nolock)  
 inner join Designation d with (nolock) on eg.designation_id=d.ID  
 INNER JOIN  tblBranch b on b.ID=ISNULL(eg.salaryLocation, dbo.func_getEmployeeBranch(eg.id,@periodEndDate))
inner join tblBranchLines bl on bl.branch_id=b.ID
inner join tblArea a on a.id=bl.area_id                
inner join tblAreaLines al on a.ID=al.area_id                
inner join tblSubZone s on s.ID=al.subzone_id   
 INNER JOIN @basicSalaryInfo bi on bi.EmployeeId=eg.EmployeeId
 Left Join tblProvidenFund pf with (nolock) on pf.employee_id =eg.id  
 Left join tblGratuity tg with (nolock) on tg.employee_id=eg.id  
  
 Where eg.empEndType=1 AND eg.empType=1 AND ISNULL(eg.salaryLocation, b.id) in (Select branchId from @tblBranch) 
 And pf.pFDate between @periodStartDate and @periodEndDate
 And tg.gratuityDate between @periodStartDate and @periodEndDate
 and eg.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
 GROUP BY eg.empName, eg.EmployeeId, d.desgName,bi.BasicSalary,s.SubZoneName
   
 RETURN   
END  
go

--8

GO
ALTER PROCEDURE [dbo].[proc_StaffLoanInfo] @levelId INT,  
 @filterData NVARCHAR(max),  
 @periodStartDate DATETIME,  
 @periodEndDate DATETIME,
 @ProgramMajor UNIQUEIDENTIFIER, 
 @ProgramSubMajor UNIQUEIDENTIFIER,  
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId varchar(30),
 @empId UNIQUEIDENTIFIER = NULL  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
  
 INSERT INTO @tblBranch  
 SELECT branch_id  
 FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)  

  select e.empId,e.id,d.desgName eDesignation,e.eDepartment,emp_manualCode,e.EmployeeId,e.empName,
  s.SectorName as loanName,ISNULL(l.DisburseAmount,0) DisburseAmount,l.installmentDate DisburseDate,cast(0 as varchar(10)) as loanCode,                    
  r.PayMonth,ISNULL(r.ServiceCharge,0) ServiceCharge ,ISNULL(r.Principal,0) Principal ,(ISNULL(r.ServiceCharge,0) +ISNULL(r.Principal,0)) as PrincipalInterest,                   
  l.LoanPeriod,r.PayStatus,ISNULL(0,0) as[LoanInterest] ,b.branchId,b.branchName                
  from EmployeeGenInfo e with(nolock)      
  LEFT join HRStaffLoanInfo l with(nolock) on l.employee_id = e.id                    
  left join HRStaffLoanRepaySchedule r with(nolock) on l.ID = r.StaffLoan_Id 
  left join StaffLoanSector s with(nolock) on s.id = l.Sector_Id                
  left join InstallmentType iin  with(nolock) on   iin.noInstallment = l.LoanPeriod 
  left join tblBranch b with(nolock) on b.id = e.branch_id       
  left join Designation d with(nolock) on d.id=e.designation_id            
  where e.Id=@empId  and r.StaffLoan_Id=( select top 1 id from HRStaffLoanInfo  with(nolock) where employee_id=@empId and DisburseDate<=@periodEndDate order by DisburseDate desc) and l.packageId=1-- and r.PaymentDate <= @periodEndDate
		and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
END  

go

--9

GO
ALTER procedure [dbo].[proc_accounts_clearence](
	 @levelId INT
	,@filterData NVARCHAR(max)
	,@periodStartDate DATETIME
	,@periodEndDate DATETIME
	,@ProgramMajor UNIQUEIDENTIFIER 
	,@ProgramSubMajor UNIQUEIDENTIFIER  
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
	,@employee_id uniqueidentifier)              
 
as
declare @isMonthly int
declare @isYearly int
declare @securityAmount int 
declare @securityInterest int 
declare @numberOfYr int
declare @countOfYR int
declare @countOfMonth int
declare @unpaidSalary  numeric(10,2)
declare @ResultSecurityAmount numeric(10,2)
BEGIN
select @isMonthly= isMonthly 
from tblEmpSecurityinfo with(nolock) where employee_id=@employee_id and paymentStatus=0
print @isMonthly
select @isYearly=isYearly
from tblEmpSecurityinfo with(nolock) where employee_id=@employee_id  and paymentStatus=0 
print @isYearly
select @countOfYR=DATEDIFF(year,cnfDate,terminDate ) 
from EmployeeGenInfo with(nolock) where id=@employee_id and EmployeeGenInfo.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
print @countOfYR 
select @countOfMonth=DATEDIFF(MONTH,cnfDate,terminDate )
from EmployeeGenInfo where id=@employee_id and EmployeeGenInfo.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
print @countOfMonth 
select @securityAmount=securityamount from tblEmpSecurityinfo with(nolock) where employee_id =@employee_id and paymentStatus=0
print @securityAmount
select @securityInterest=securityInerest from tblEmpSecurityinfo with(nolock) where employee_id =@employee_id  and paymentStatus=0
print @securityInterest
Begin  
if(@isMonthly =1) 
set @ResultSecurityAmount= ((@securityAmount*@securityInterest*.01)*isnull(@countOfMonth ,0)+@securityAmount)
end
print  '@securityInterest'+cast(@securityInterest as varchar(10))
Begin
if(@isYearly =1)
set @ResultSecurityAmount= (@securityAmount*@securityInterest*.01)*isnull(@countOfYR,0) +@securityAmount                
end   
select @unpaidSalary=dbo.func_getTotalUnpaidSalaryFromPaySlipByEmployee_id(@employee_id,'2018-09-04 00:00:00.000')         
 declare   @scheduleId uniqueidentifier,   @serviceCharge int,@principal int , @reginingDate datetime, @loanAmoun int, @empid uniqueidentifier 
  select @reginingDate= termindate from EmployeeGenInfo with(nolock) where id=@employee_id and EmployeeGenInfo.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor)) 
   select top 1 @scheduleId=id  from hrStaffLoanInfo with(nolock) where employee_id=@employee_id order by DisburseDate  
Declare @T Table (empid uniqueidentifier, serviceCharge numeric(10,2),principal numeric(10,2)) 
insert into @T         
 exec proc_HRCalServiceChrgPrinciple   @scheduleId, @reginingDate
 select @empid= empid, @loanAmoun= serviceCharge+principal  from @T    
       
----------------------return sql----------------------               

select a.*,isnull(b.AdvanceAmount,0) AdvanceAmount,isnull(@loanAmoun,0) LoanAmount,
ISNULL(e.UnpaidSalary,0) UnpaidSalaryforpayslip,isnull(@ResultSecurityAmount,0) ResultSecurityAmount,isnull(@unpaidSalary,0) UnpaidSalary 
from 
(select Id as employee_Id,emp_manualCode,empName
 from EmployeeGenInfo with(nolock)
where id = @employee_Id and EmployeeGenInfo.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor)))a 
left join
(select employee_id,IsNUll(SUM(Amount),0) as AdvanceAmount
from AdvanceRepaySchedule with(nolock)
where employee_id=@employee_Id 
and PayStatus='Not Paid'
group by employee_id )b 
on a.employee_Id = b.employee_id  
left join        
(  
 select sl.employee_id,IsNUll(SUM(Principal),0) +(select top 1 isnull(a.ServiceCharge,0) from hrStaffLoanRepaySchedule a with(nolock)       
        inner join HrStaffLoanInfo b with(nolock) on a.StaffLoan_Id=b.Id           
        where PayStatus='Not Paid' and b.packageId=1 and a.employee_id=@employee_Id)as LoanAmount  from hrStaffLoanRepaySchedule slr with(nolock)
 inner join HrStaffLoanInfo sl with(nolock) on sl.Id=slr.StaffLoan_Id  
    where sl.employee_id=@employee_Id and packageId=1 
    and PayStatus='Not Paid'
    group by sl.employee_id    
 ------------start staff lona data deduction-----------------------     
    
  )c  
on a.employee_Id  =c.employee_id              
 
left join                
  
(select employee_id,ISNULL(tNetpay,0) UnpaidSalary from PaySlip  with(nolock) 
where approvalStatus=0 and employee_id=@employee_Id )e on e.employee_id = a.employee_Id  
END    
Go

--10

GO
ALTER FUNCTION [dbo].[func_getSalarySheet]
(	
	@levelId nvarchar(20), 
	@filterData nvarchar(max), 
	@periodStartDate dateTime,
	@periodEndDate dateTime,
	@ProgramMajor UNIQUEIDENTIFIER,
	@ProgramSubMajor UNIQUEIDENTIFIER,
	@ProgramMinor UNIQUEIDENTIFIER,
	@SalarySource int,
	@bonus int,
	@userId varchar(30)
	
)
RETURNS @salarySheet TABLE (
	Id uniqueidentifier,
	EmployeeId nvarchar(20),
	empName nvarchar(100),
	desgName nvarchar(200),
	accountNo nvarchar(100),
	bankName nvarchar(100),
	GradeID int,
	eGradeID int,
	GradeName nvarchar(100),
	stepId int,
	eStepId int,
	stepName nvarchar(100),
	[Basic] numeric(10,2),
	[Housing] numeric(10,2),
	[Housing (Dhaka)] numeric(10,2),
	[Medical Allowance] numeric(10,2),
	[Conveyance Allowance] numeric(10,2),
	[Conveyance Allowance (Dhaka)] numeric(10,2),
	[Char Allowance] numeric(10,2),
	[Bicycle Allowance] numeric(10,2),
	[Child Care Allowance] numeric(10,2),
	[Festival Bonus] numeric(10,2),
	[Other Earning ] numeric(10,2),
	[Provident Fund (Self)] numeric(10,2),
	[PF Loan] numeric(10,2),
	[PF Loan Interest] numeric(10,2),
	[SalaryLoan] numeric(10,2),
	[Motor Cycle Loan] numeric(10,2),
	[Motor Cycle Loan Interest] numeric(10,2),
	[Bi-Cycle Loan] numeric(10,2),
	[Mobile Loan] numeric(10,2),
	[LWP Deduction] numeric(10,2),
	[Income Tax] numeric(10,2),
	[Other Deduction] numeric(10,2),
	[SSM] numeric(10,2)
)
AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)
	INSERT INTO @tblBranch
	SELECT branch_id FROM func_GetBranchInfo(@levelId, @FilterData, @periodEndDate)
	INSERT INTO @salarySheet
	SELECT * FROM (
	SELECT e.Id, e.EmployeeId,e.empName,d.desgName,e.accountNo,b.name bankName,Cast(g.GradeID as int) GradeID,Cast(eg.GradeID as int) eGradeID,G.GradeName,CAST(s.stepId as int) stepId,CAST(egs.stepId as int) eStepId,s.stepName,
	ISNULL(si.ItemName,pssi.ItemName) ItemName, pssi.SingleItemAmount
	  from EmployeeGenInfo e with(nolock)
	LEFT JOIN tblBank b with(nolock) ON e.bank_id=b.ID
	Left JOIN Designation d with(nolock) ON e.designation_id=d.id
	INNER JOIN Payslip ps with (NOLOCK) on e.id = ps.employee_id
	INNER JOIN PayslipsalaryItem pssi with (NOLOCK) on ps.Id = pssi.paySlip_Id
	LEFT Join EmpSalaryItem si  with (NOLOCK) on si.Id =  pssi.salaryItem_Id	
	inner join tblBranch tb with(nolock) on tb.id=ISNULL(e.SalaryLocation,e.branch_id)
	LEFT JOIN  EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
	LEFT JOIN EmployeeGradeStepNew s with(nolock) ON s.id=e.empStep_id
	LEFT JOIN EmployeeConsolidatedGradeStep es with(nolock) on es.EmployeeId=e.id
	LEFT JOIN  EmployeeGradeNew eg with(nolock) ON eg.ID=es.EmpGrade
	LEFT JOIN EmployeeGradeStepNew egs with(nolock) ON egs.id=es.EmpStep
	where 

--	e.Program_MajorId=case when  @ProgramMajor='00000000-0000-0000-0000-000000000000'
--			 then e.Program_MajorId else @ProgramMajor end 		  
--			AND e.Program_SubMajorId=case when @ProgramSubMajor='00000000-0000-0000-0000-000000000000'
--			 then e.Program_SubMajorId else @ProgramSubMajor end 		  
--			AND e.Program_MinorId=case when @ProgramMinor='00000000-0000-0000-0000-000000000000'
--then e.Program_MinorId else @ProgramMinor end

--			 AND

			 e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			 and

			 ISNULL(e.SalaryLocation,e.branch_id)  in (select branchId from @tblBranch)
			 AND ps.PayMonth BETWEEN dbo.StartDayOfMonth(@periodStartDate)
			  AND dbo.LastDayOfMonth(@periodStartDate)
			AND isnull(e.SalarySource,0)= CASE WHEN @SalarySource=0 THEN isNULL(e.SalarySource,0) ELSE @SalarySource END
			AND ISNULL(ps.bonusOnly,0)= CASE WHEN @bonus=0 THEN 0 
											 WHEN @bonus=2 THEN 2
											 ELSE ISNULL(ps.bonusOnly,0) END
			 group by e.Id,e.EmployeeId,e.empName,d.desgName ,pssi.ItemName,si.ItemName,pssi.SingleItemAmount,e.accountNo,b.name,g.GradeID,s.stepId,s.stepName,G.GradeName,eg.GradeID,egs.stepId
			 --Order by e.EmployeeId
		
	 )x
	 PIVOT(
	 MAX(SingleItemAmount)
	  for ItemName in (
	  [Basic],[Housing],[Housing (Dhaka)],[Medical Allowance],[Conveyance Allowance],[Conveyance Allowance (Dhaka)],[Char Allowance],[Bicycle Allowance],[Child Care Allowance],[Festival Bonus],[Other Earning ],[Provident Fund (Self)],[PF Loan],[PF Loan Interest],[Salary Loan],[Motor Cycle Loan],[Motor Cycle Loan Interest],[Bi-Cycle Loan],[Mobile Loan],[LWP Deduction],[Income Tax],[Other Deduction],[SSM]
	  )
	 )
	  AS pivot_table;
	  return
END
--
--select * from EmployeeGradeStepNew
--select * from EmployeeGradeNew


go


--11


GO       
 ALTER FUNCTION [dbo].[func_Total_Payroll] (  
 @levelId INT,  
 @filterData NVARCHAR(max),  
 @periodStartDate DateTime,  
 @periodEndDate DateTime,
 @ProgramMajor UNIQUEIDENTIFIER,
 @ProgramSubMajor UNIQUEIDENTIFIER,
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId varchar(30)
)          
RETURNS         
@salarystatement TABLE                   
(                  
                   
 ID uniqueidentifier null,   
 emp_manualCode nvarchar(100) null,     
 empName varchar(100) null,      
 tEarning numeric(20,0) null,      
 tDeduction numeric(20,0) null,      
 tNetpay numeric(20,0) null,      
 payrollType varchar(30) null,
 Program_MinorId uniqueidentifier null
                             
)        
AS      
BEGIN       
       
 DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
  
 INSERT INTO @tblBranch  
 SELECT branch_id  
 FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)  
  
   INSERT INTO @salarystatement       
 select a.employee_id,a.EmployeeId emp_manualCode,a.empName,a.tNetpay,b.tNetpay + isnull(c.advAmount,0) + isnull(d.loanAmount,0),ROUND(a.tNetpay - (b.tNetpay + isnull(c.advAmount,0) + isnull(d.loanAmount,0)),2)tNetpay, a.payrollType,a.Program_MinorId  from        
 (select employee_id,e.EmployeeId,empname,eDesignation,accountNo, sum(ps.SingleItemAmount)tNetpay,e.payrollType,e.Program_MinorId  from EmployeeGenInfo e with(nolock)   
 inner join payslip p on e.id=p.employee_id inner join paySlipSalaryItem ps with(nolock) on p.id=ps.paySlip_id inner join empSalaryItem es with(nolock) on es.id=ps.salaryItem_Id  where es.ItemType=1 and paymonth  between @periodStartDate and @periodEndDate and e.terminDate is null   AND e.branch_id IN (SELECT branchId FROM @tblBranch)   
  group by employee_id,e.EmployeeId,empName,eDesignation,accountNo,e.payrollType,e.Program_MinorId) a      
          
 left join       
 (select employee_id,e.EmployeeId,empname,eDesignation,accountNo, sum(ps.SingleItemAmount)tNetpay,e.payrollType  from EmployeeGenInfo e with(nolock) inner join payslip p with(nolock) on e.id=p.employee_id          
  inner join paySlipSalaryItem ps with(nolock) on p.id=ps.paySlip_id      
  inner join empSalaryItem es with(nolock) on es.id=ps.salaryItem_Id      
  where es.ItemType=0 and paymonth  between @periodStartDate and @periodEndDate
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and e.terminDate is null  AND e.branch_id IN (SELECT branchId FROM @tblBranch)   
 group by employee_id,e.EmployeeId,empName,eDesignation,accountNo, e.payrollType) b on b.employee_id = a.employee_id      
    
 left join    
 (select employee_id,isnull(Amount,0)advAmount from AdvanceRepaySchedule with(nolock) where PayMonth between @periodStartDate and @periodEndDate and  PayStatus='Paid') c    
 on c.employee_id =a.employee_id
    
 left join    
 (select employee_id,isnull(Amount,0) loanAmount from HrStaffLoanRepaySchedule with(nolock) where PayMonth between @periodStartDate and @periodEndDate and PayStatus='Paid') d    
 on d.employee_id =a.employee_id 

   RETURN      
END       
          
        
        
--Select * FROM  PaySlip

go


