select * from func_getEmployeeSecurityInfo('00000000-0000-0000-0000-000000000000','4733A2C3-CA40-442C-89D7-F9AA1AE143BA')
go
alter FUNCTION [dbo].[func_getEmployeeSecurityInfo]
(	
	@branch_id UNIQUEIDENTIFIER,
	@user_id UNIQUEIDENTIFIER
)
RETURNS @employeeSecurityTable
TABLE 
(
	Id uniqueidentifier,
	manualCode nvarchar(20),
	empName nvarchar(100),
	cnfDate dateTime,
	terminDate dateTime,
	assignSecurityAmt numeric(10,2),
	eligableAmt numeric(10,2),
	employeeID nvarchar(100),
	desgName nvarchar(100)
)
AS
BEGIN
	IF(@branch_id ='00000000-0000-0000-0000-000000000000')
	Begin
		Insert into @employeeSecurityTable	
		select *from (
		select e.id,e.emp_manualCode,e.empname,e.cnfDate,e.terminDate,isnull(b.assignSecurityAmt,0) assignSecurityAmt,isnull(b.eligableAmt,0) as eligableAmt,e.employeeID,b.desgName
        from EmployeeGenInfo e 
		left join designation b on b.id=e.designation_id and b.assignSecurityAmt<>0  
        where e.empEndType=1 and  e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id))
		x order by cast(x.EmployeeId as int) 
	End
	Else
	Begin
		Insert into @employeeSecurityTable	
		select *from (
		select e.id,e.emp_manualCode,e.empname,e.cnfDate,e.terminDate,isnull(ds.assignSecurityAmt,0) assignSecurityAmt,isnull(ds.eligableAmt,0) as eligableAmt,e.employeeID,ds.desgName
        from EmployeeGenInfo e 
		left join designation ds on ds.id=e.designation_id and ds.assignSecurityAmt<>0  
		inner join tblBranch b with(nolock) on dbo.func_getEmployeeBranch(e.id,GETDATE())=b.id   
		inner join tblBranchLines bl with(nolock) on bl.branch_id=b.ID                
		inner join tblArea a with(nolock) on a.id=bl.area_id                
		inner join tblAreaLines al with(nolock) on a.ID=al.area_id                
		inner join tblSubZone sz with(nolock) on sz.ID=al.subzone_id                
		inner join tblSubZoneLines sl with(nolock) on sl.subzone_id = sz.ID                
		inner join tblZone z with(nolock) on z.ID  =  sl.zone_id  
		where e.empEndType=1 and (b.ID=@branch_id OR a.ID=@branch_id OR sz.ID=@branch_id OR z.ID=@branch_id) AND
		e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject
		where [user_id]=@user_id)) x order by cast(x.EmployeeId as int) 
	End
	RETURN 
END
go


select * from func_getEmployeeSecurityInfo('006c0ab8-f0ed-4f52-b1a7-e4d90cce9da7','5472a2ba-cbcf-4998-92dc-d1fb958ceb0f')
select * from tblBranch where branchId='0391'