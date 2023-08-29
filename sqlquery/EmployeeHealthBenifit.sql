GO
Alter FUNCTION [dbo].[func_getEmployeeHealthBenefit]
(	
	@levelId nvarchar(20), 
	@filterData nvarchar(max), 
	@periodStartDate dateTime,
	@periodEndDate dateTime,
	@ProgramMajor UNIQUEIDENTIFIER,
	@ProgramSubMajor UNIQUEIDENTIFIER,
	@ProgramMinor UNIQUEIDENTIFIER,
	@userId varchar(30)
	
)
RETURNS @employeeHealthBenefit TABLE (
	Id uniqueidentifier,
	EmployeeId nvarchar(20),
	empName nvarchar(100),
	desgName nvarchar(200),
	GradeID int,
	eGradeID int,
	GradeName nvarchar(100),
	stepId int,
	eStepId int,
	stepName nvarchar(100),
	sex nvarchar(100),
	Program nvarchar(100),
	Sector nvarchar(100),
	Project nvarchar(100),
	EmpType nvarchar(100),
	SubZone nvarchar(100),
	Area nvarchar(100),
	Branch nvarchar(100),
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
	[EHBS] numeric(10,2)
)
AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)
	INSERT INTO @tblBranch
	SELECT branch_id FROM func_GetBranchInfo(@levelId, @FilterData, @periodEndDate)
	INSERT INTO @employeeHealthBenefit
	SELECT * FROM (
	SELECT e.Id, e.EmployeeId,e.empName,d.desgName,Cast(g.GradeID as int) GradeID,Cast(eg.GradeID as int) eGradeID,G.GradeName,CAST(s.stepId as int) stepId,CAST(egs.stepId as int) eStepId,s.stepName,
	e.empGender sex,p.Name Program,psm.Name Sector,pm.Name Project,ec.Name EmpType,sz.SubZoneName SubZone,a.AreaName Area,tb.branchName Branch,
	ISNULL(si.ItemName,pssi.ItemName) ItemName, pssi.SingleItemAmount 
	  from EmployeeGenInfo e with(nolock)	
	Left JOIN Designation d with(nolock) ON e.designation_id=d.id
	INNER JOIN Payslip ps with (NOLOCK) on e.id = ps.employee_id
	INNER JOIN PayslipsalaryItem pssi with (NOLOCK) on ps.Id = pssi.paySlip_Id
	LEFT Join EmpSalaryItem si  with (NOLOCK) on si.Id =  pssi.salaryItem_Id	
	inner join tblBranch tb with(nolock) on dbo.func_getEmployeeBranch(e.id,@periodEndDate)=tb.id
	inner join tblBranchLines bl with(nolock) on bl.branch_id=tb.ID 
	inner join tblArea a with(nolock) on a.id=bl.area_id
	inner join tblAreaLines al with(nolock) on a.ID=al.area_id 
	inner join tblSubZone sz with(nolock) on sz.ID=al.subzone_id
	inner join tblSubZoneLines sl with(nolock) on sl.subzone_id = sz.ID  
	LEFT JOIN  EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
	LEFT JOIN EmployeeGradeStepNew s with(nolock) ON s.id=e.empStep_id
	LEFT JOIN EmployeeConsolidatedGradeStep es with(nolock) on es.EmployeeId=e.id
	LEFT Join EmployeeCategory ec with(nolock) on ec.ID=e.empType 
	LEFT JOIN tblProgram_Major p with(nolock) on p.Id=e.Program_MajorId  
	LEFT JOIN tblProgram_SubMajor psm with(nolock)  on psm.Id=e.Program_SubMajorId  
	LEFT JOIN tblProgram_Minor pm with(nolock) on pm.Id=e.Program_MinorId
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

			 e.branch_id in (select branchId from @tblBranch)
			 AND ps.PayMonth BETWEEN dbo.StartDayOfMonth(@periodStartDate)
			  AND dbo.LastDayOfMonth(@periodStartDate)			
			 group by e.Id,e.EmployeeId,e.empName,d.desgName ,e.empGender,p.Name,psm.Name,pm.Name,ec.Name,sz.SubZoneName,a.AreaName,tb.branchName,pssi.ItemName,si.ItemName,pssi.SingleItemAmount,g.GradeID,s.stepId,s.stepName,G.GradeName,eg.GradeID,egs.stepId
			 --Order by e.EmployeeId
		
	 )x
	 PIVOT(
	 MAX(SingleItemAmount)
	  for ItemName in (
	  [Basic],[Housing],[Housing (Dhaka)],[Medical Allowance],[Conveyance Allowance],[Conveyance Allowance (Dhaka)],[Char Allowance],[Bicycle Allowance],[Child Care Allowance],[Festival Bonus],[Other Earning ],[EHBS]
	  )
	 )
	  AS pivot_table;
	  return
END
Go



GO
Alter View [dbo].[viwEmployeeHealthBenefitScheme]
As 
SELECT        Id, EmployeeId, empName, desgName, GradeID, GradeName, stepId, stepName,sex, Program, Sector, Project,EmpType, SubZone, Area,Branch,
			  Basic, Housing, [Housing (Dhaka)], [Medical Allowance], [Conveyance Allowance], [Conveyance Allowance (Dhaka)], 
              [Char Allowance], [Bicycle Allowance], [Child Care Allowance], [Festival Bonus], [Other Earning ],[EHBS]
FROM func_getEmployeeHealthBenefit(0,'','2023-01-01','2023-01-31', '00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','si')
GO