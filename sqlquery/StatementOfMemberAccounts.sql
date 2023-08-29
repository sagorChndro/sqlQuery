CREATE FUNCTION func_StatementOfMemberAccounts
(  
   @FilterBy varchar(20),  
   @FilterData varchar(max), 
   @periodStartDate DateTime,  
   @periodEndDate DateTime
)
RETURNS 
 @Member TABLE 
(
 empName varchar(100),  
 EmployeeId varchar(100),  
 brancName varchar(200),
 joiningDate datetime,
 DateOfSeparation datetime,
 BasicSalary numeric(10,2),
 GratuityAmount numeric(10,2),
 --[year] int,
 --[month] int,
 --[day] int,
 AsOn datetime  
)
AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
	 INSERT INTO @tblBranch  
	 SELECT branch_id FROM func_GetBranchInfo(@FilterBy,@FilterData, @periodEndDate) 
	
	DECLARE @basicSalaryInfo TABLE (
		EmployeeId varchar(100),
		BasicSalary numeric(10,2)
	) 

	Insert Into @basicSalaryInfo
	Select EmployeeId, dbo.func_getBasicSalaryAmount(eg.id, @periodEndDate) from EmployeeGenInfo eg with (nolock)
	Inner Join tblBranch b on b.ID = ISNULL(eg.SalaryLocation, dbo.func_getEmployeeBranch(eg.id, @periodEndDate))
	Where empEndType=1 AND empType=1 and ISNULL(eg.salaryLocation, b.id) in (Select branchId from @tblBranch) 

	Insert into @Member
	select eg.empName, eg.EmployeeId, b.branchName, eg.orgJoinDate, eg.terminDate,ISNULL(bi.BasicSalary,0), Sum(ISNULL( tg.amount,0)) GratuityAamount,
	--(select abs(years) from [dbo].[func_CalculateStaffServiceYearMonthDayInfo] (eg.id,Isnull(eg.terminDate, @periodEndDate))) 'year',  
    --(select abs(months) from [dbo].[func_CalculateStaffServiceYearMonthDayInfo] (eg.id,@periodEndDate)) 'month',
	--(select abs(days) from [dbo].[func_CalculateStaffServiceYearMonthDayInfo] (eg.id,@periodEndDate)) 'day', 
	Isnull(eg.terminDate, @periodEndDate) AsOn
	from EmployeeGenInfo eg with (nolock)
	Inner join tblBranch b with (nolock) on b.ID = ISNULL(eg.salaryLocation, dbo.func_getEmployeeBranch(eg.id,@periodEndDate))  
	INNER JOIN @basicSalaryInfo bi on bi.EmployeeId=eg.EmployeeId
	Left join tblGratuity tg with (nolock) on tg.employee_id=eg.id

	Where eg.empEndType=1 AND eg.empType=1 AND ISNULL(eg.salaryLocation, b.id) in (Select branchId from @tblBranch)
    And tg.gratuityDate between @periodStartDate and @periodEndDate
	GROUP BY eg.empName, eg.EmployeeId, bi.BasicSalary, eg.orgJoinDate, eg.terminDate, b.branchName
	RETURN 
END
GO