go
ALTER function [dbo].[func_ResignationAcceptanceLetter] (
	@employeeId uniqueidentifier,
	@startDate datetime,
	@endDate datetime	
 )  
 Returns @info table   (
	EmployeeId nvarchar(50),
	empId numeric(10,2),
	EmployeeName nvarchar(100),
	EmpName nvarchar(300),
	Designation nvarchar(200),
	BranchName nvarchar (200),
	orgJoining datetime,
	DepartmentName nvarchar(200),
	ProgramName nvarchar(100),
	projectName nvarchar(100)
	
)    

AS       
BEGIN	
	INSERT INTO @info
	SELECT Distinct e.EmployeeId,e.empId, e.empName as EmployeeName,e.empName + '('+ e.EmployeeId +')' + ','+ d.desgName + ','+ pm.[Name] + ',' + b.branchName + ',' + sz.SubZoneName as EmpName,d.desgName
	,b.branchName,e.orgJoinDate,dep.deptName,p.[Name] as ProgramName, pm.[Name] as projectName
	from EmployeeGenInfo e with(nolock)
	LEFT JOIN tblDistrict ds with(nolock) on ds.ID=e.presDist
	LEFT JOIN tblThana t with(nolock) on t.ID = e.presThana
	Inner Join Department dep with(nolock) on dep.ID=e.department_id
	INNER join Designation d on d.ID = dbo.func_getEmployeeDesignation(e.id,@endDate)
	INNER JOIN tblProgram_Major p with(nolock) on p.Id=e.Program_MajorId
	Inner join tblProgram_Minor pm with(nolock) on pm.Id= e.Program_MinorId
	Inner Join tblBranch b with(nolock) on b.ID = dbo.func_getEmployeeBranch(e.id,@endDate)
	Inner Join tblBranchLines bl with(nolock) on bl.branch_id = b.ID
	Inner Join tblArea ta with(nolock) on ta.id = bl.area_id
	Inner Join tblAreaLines al with(nolock) on ta.ID = al.area_id
	Inner Join tblSubZone sz with(nolock) on sz.ID = al.subzone_id
	WHERE e.id = @employeeId 
	
	RETURN
END
go


Go
Alter View viw_ResignationAcceptanceLetter
As
SELECT * from func_ResignationAcceptanceLetter('01827BB4-E891-4A97-B12B-3BF181FABBE6','2023-08-01','2023-08-31')
Go

