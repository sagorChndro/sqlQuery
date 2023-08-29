
ALTER function [dbo].[func_AppointmentLetter] (
	@employeeId uniqueidentifier,
	@startDate datetime,
	@endDate datetime	
 )  
 Returns @info table   (
	EmployeeId nvarchar(50),
	EmpName nvarchar(50),
	Designation nvarchar(200),
	BranchName nvarchar (200),
	FatherName nvarchar (200),
	orgJoining datetime,
	VillPo nvarchar(200),
	thanaDistrict nvarchar(200),
	DepartmentName nvarchar(200),
	GradeID nvarchar(100),
	GradeName nvarchar(100),
	stepId nvarchar(100),
	stepName nvarchar(100),
	[Basic] numeric(10,2),  
	[HouseRent] numeric(10,2),  
	[HouseRent(Dhaka)] numeric(10,2),  
	[MedicalAllowance] numeric(10,2),  
	[ConveyanceAllowance] numeric(10,2),
	[MobileAllowance] numeric(10,2),
	[TiffinAllowance] numeric(10,2),  
	[TiffinAllowance (Dhaka)] numeric(10,2),  	
	[MotorcycleAllow. (Fuel Cost)] numeric(10,2)  
	
)    

AS       
BEGIN
	DECLARE @salary_id uniqueidentifier		
	select @salary_id=es.id    
	  from EmployeeSalInfo es     
	  inner join(    
	   select employee_id , salEffectiveDate=MAX(salEffectiveDate)     
	   from EmployeeSalInfo with(nolock) Where salEffectiveDate<=@endDate group by employee_id    
	  ) ee on es.employee_id = ee.employee_id and es.salEffectiveDate = ee.salEffectiveDate     
	  inner join employeeGeninfo egi with(nolock)    
	  left join tblSalaryStation s with(nolock) on egi.id=s.empid  
	  on es.employee_id = egi.id 
	  where  egi.id=@employeeId
	
	INSERT INTO @info
	SELECT * FROM (
	SELECT e.EmployeeId, e.empName,d.desgName,b.branchId+'-'+b.branchName as BranchName,e.fName,e.orgJoinDate,e.presVill+','+e.presPO as VillPo,t.thanaName+','+ds.districtName As thanaDistrict,
	dep.deptName, Cast(g.GradeID as nvarchar(100)) GradeID, g.GradeName, CAST(gsn.stepId as nvarchar(100)) stepId, gsn.stepName, si.ItemName, gs.SingleItemAmount 

	from EmployeeGenInfo e with(nolock)
	LEFT JOIN tblDistrict ds with(nolock) on ds.ID=e.presDist
	LEFT JOIN tblThana t with(nolock) on t.ID = e.presThana
	Inner Join Department dep with(nolock) on dep.ID=e.department_id
	INNER JOIN Designation d with(nolock) on d.ID = e.designation_id
	Inner Join tblBranch b with(nolock) on b.ID = dbo.func_getEmployeeBranch(e.id,@endDate)
	INNER JOIN EmployeeSalInfo s with(nolock) on s.employee_id = e.id
	INNER JOIN GradeStepSalaryItem gs with(nolock) on gs.salary_id = s.id
	INNER JOIN empSalaryItem si with(nolock) on si.Id = gs.salaryItem_Id
	LEFT JOIN  EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
	LEFT JOIN EmployeeGradeStepNew gsn with(nolock) ON gsn.id=e.empStep_id	
	WHERE e.orgJoinDate between @startDate and @endDate and 
	e.id = @employeeId AND s.id =@salary_id
	)x	
	PIVOT(  
	MAX(SingleItemAmount)  
	for ItemName in (  
	[Basic],[House Rent],[House Rent (Dhaka)],[Medical Allowance],[Conveyance Allowance],[Mobile Allowance],
	[Tiffin Allowance],[Tiffin Allowance (Dhaka)],[Motorcycle Allow. (Fuel Cost)]
   )  
  )  
   AS pivot_table;
	RETURN
END