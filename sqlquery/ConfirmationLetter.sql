Go
Alter function [dbo].[func_ConfirmationLetter] (
	@employeeId uniqueidentifier,
	@startDate datetime,
	@endDate datetime	
 )  
 Returns @info table   (
	EmployeeId nvarchar(50),
	EmpName nvarchar(200),
	EmployeeName nvarchar(100),
	--Designation nvarchar(200),
	orgJoining datetime,
	DepartmentName nvarchar(200),
	GradeID nvarchar(100),
	GradeName nvarchar(100),
	stepId nvarchar(100),
	stepName nvarchar(100),
	[Basic] numeric(10,2),  
	[HouseRent] numeric(10,2),  
	[MedicalAllowance] numeric(10,2),  
	[ConveyanceAllowance] numeric(10,2),
	[MobileAllowance] numeric(10,2)  
	
)    

AS       
BEGIN
	INSERT INTO @info
	SELECT * FROM (
	SELECT e.EmployeeId, e.empName + '('+ e.EmployeeId +')' + ','+ p.[Name] + ',' + b.branchName +','+sz.SubZoneName as EmpName,e.empName as EmployeeName, e.orgJoinDate, dep.deptName, Cast(g.GradeID as nvarchar(100)) GradeID, g.GradeName, CAST(gsn.stepId as nvarchar(100)) stepId, gsn.stepName, si.ItemName, gs.SingleItemAmount 

	from EmployeeGenInfo e with(nolock)
	LEFT JOIN tblDistrict ds with(nolock) on ds.ID=e.presDist
	LEFT JOIN tblThana t with(nolock) on t.ID = e.presThana
	Inner Join Department dep with(nolock) on dep.ID=e.department_id
	INNER join Designation d on d.ID = dbo.func_getEmployeeDesignation(e.id,@endDate)
	INNER JOIN tblProgram_Major p with(nolock) on p.Id=e.Program_MajorId
	Inner Join tblBranch b with(nolock) on b.ID = dbo.func_getEmployeeBranch(e.id,@endDate)
	Inner Join tblBranchLines bl with(nolock) on bl.branch_id = b.ID
	Inner Join tblArea ta with(nolock) on ta.id = bl.area_id
	Inner Join tblAreaLines al with(nolock) on ta.ID = al.area_id
	Inner Join tblSubZone sz with(nolock) on sz.ID = al.subzone_id
	--INNER JOIN EmployeeSalInfo s with(nolock) on s.employee_id = e.id
	
	LEFT JOIN  EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
	LEFT JOIN EmployeeGradeStepNew gsn with(nolock) ON gsn.id=e.empStep_id
	INNER JOIN GradeStepSalaryItem gs with(nolock) on gs.gradeStep_id = gsn.id and g.ID=gs.grade_id
	INNER JOIN empSalaryItem si with(nolock) on si.Id = gs.salaryItem_Id

	WHERE e.id = @employeeId
	)x	
	PIVOT(  
	MAX(SingleItemAmount)  
	for ItemName in (  
	[Basic],[Housing],[Medical Allowance],[Conveyance Allowance],[Mobile Allowance]
   )  
  )  
   AS pivot_table;
	RETURN
END
Go

Go
Alter View viw_ConfirmationLetter
As
Select * from func_ConfirmationLetter('01827BB4-E891-4A97-B12B-3BF181FABBE6','2023-08-01','2023-08-31')
Go


--Select * from empSalaryItem