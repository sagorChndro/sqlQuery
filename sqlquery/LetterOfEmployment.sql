go
Alter function [dbo].[func_LetterOfEmployment] (
	@employeeId uniqueidentifier,
	@startDate datetime,
	@endDate datetime	
 )  
 Returns @info table   (
	EmployeeId nvarchar(50),
	empId numeric(10,2),
	EmpName nvarchar(50),
	Designation nvarchar(200),
	salary numeric(10,2),
	BranchName nvarchar (200),
	parentsName nvarchar (200),
	orgJoining datetime,
	presVill nvarchar(200),
	presPO nvarchar(200),
	thana nvarchar(200),
	districtName nvarchar(100),
	DepartmentName nvarchar(200),
	ProgramName nvarchar(100)
	
)    

AS       
BEGIN	
	INSERT INTO @info
	SELECT Distinct e.EmployeeId,e.empId, e.empName,d.desgName, dbo.func_GetGrossSalary(@employeeId) as salary,b.branchName,e.fName +' & '+ e.motheName as parentsName,e.orgJoinDate,e.presVill,e.presPO,t.thanaName,
	ds.districtName,dep.deptName,p.[Name] as ProgramName
	from EmployeeGenInfo e with(nolock)
	LEFT JOIN tblDistrict ds with(nolock) on ds.ID=e.presDist
	LEFT JOIN tblThana t with(nolock) on t.ID = e.presThana
	Inner Join Department dep with(nolock) on dep.ID=e.department_id
	INNER join Designation d on d.ID = dbo.func_getEmployeeDesignation(e.id,@endDate)
	INNER JOIN tblProgram_Major p with(nolock) on p.Id=e.Program_MajorId
	Inner Join tblBranch b with(nolock) on b.ID = dbo.func_getEmployeeBranch(e.id,@endDate)
	WHERE e.id = @employeeId 
	
	RETURN
END
go


Go
Alter View viw_LetterOfEmployment
As
SELECT * from func_LetterOfEmployment('01827BB4-E891-4A97-B12B-3BF181FABBE6','2023-08-01','2023-08-31')
Go
--select * from EmployeeGenInfo where empid='13637'
--select * from EmployeeGenInfo where EmployeeId='13637'
--select * from GradeStepSalaryItem
--select * from empSalaryItem
-- select * from SubMenu where name='Leave'
--select * from tblProgram_Major
--select * from EmployeeSalInfo 

	--INNER JOIN tblProgram_SubMajor ps with(nolock) on ps.Id = e.Program_SubMajorId
	--INNER JOIN tblProgram_Minor pm with(nolock) on pm.Id = e.Program_MinorId
	--INNER JOIN EmployeeSalInfo s with(nolock) on s.employee_id = e.id
	--INNER JOIN GradeStepSalaryItem gs with(nolock) on gs.salary_id = s.id
	--INNER JOIN empSalaryItem si with(nolock) on si.Id = gs.salaryItem_Id
	--LEFT JOIN  EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
	--LEFT JOIN EmployeeGradeStepNew gsn with(nolock) ON gsn.id=e.empStep_id

		--DECLARE @salary_id uniqueidentifier		
	--select @salary_id=es.id    
	--  from EmployeeSalInfo es     
	--  inner join(    
	--   select employee_id , salEffectiveDate=MAX(salEffectiveDate)     
	--   from EmployeeSalInfo with(nolock) Where salEffectiveDate<=@endDate group by employee_id    
	--  ) ee on es.employee_id = ee.employee_id and es.salEffectiveDate = ee.salEffectiveDate     
	--  inner join employeeGeninfo egi with(nolock)    
	--  on es.employee_id = egi.id 
	--  where  egi.id=@employeeId

	Parchase information: