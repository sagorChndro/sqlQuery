GO
Alter FUNCTION func_getStaffTraining
(
	@levelId nvarchar(100),
	@filterDate nvarchar(max),
	@periodStartDate dateTime,
	@periodEndDate dateTime,
	@ProgramMajor UNIQUEIDENTIFIER,	@ProgramSubMajor UNIQUEIDENTIFIER,	@ProgramMinor UNIQUEIDENTIFIER,
	@userId varchar(30)
)
RETURNS @staffTraining TABLE 
(
	Id uniqueidentifier,
	EmployeeId nvarchar(20),
	empName nvarchar(100),
	desgName nvarchar(200),
	gradeId int,
	gradeName nvarchar(100),
	Project nvarchar(100),
	TrainingLocation nvarchar(100),
	TrainingCategory nvarchar(100),
	TrainingName nvarchar(100),
	Institution nvarchar(100),
	TrainingDuration int,
	SubZoneName nvarchar(100),
	trainingStartDate dateTime,
	trainingEndDate dateTime,
	[Year] nvarchar(100),
	[Month] nvarchar(100)

)
AS
BEGIN
    Declare @tblBranch Table(branch_id uniqueidentifier)
	Insert into @tblBranch
	select branch_id from func_GetBranchInfo(@levelId,@filterDate,@periodEndDate)
	Insert Into @staffTraining

			Select e.id, e.EmployeeId, e.empName, d.desgName,Cast(g.GradeID as int) GradeId,g.GradeName,pm.Name Project,pt.trainingLocation,
			pt.trainingingCategoryName,pt.name TrainingName,pt.venue,DATEDIFF(DD, pt.periodStart, pt.periodEnd) AS TrainingDuration,s.SubZoneName,
			pt.periodStart as trainingStartDate,pt.periodEnd as trainingEndDate,DATEPART(YEAR,pt.periodStart) as [Year], DATENAME(MONTH, DATEADD(MONTH, 0, pt.periodStart)) AS [Month]
			from  trainingDetails td with(nolock)
			Inner Join PayrollTrainingInfo pt with(nolock) On pt.Id=td.training_id
			Inner Join EmployeeGenInfo e with(nolock) ON e.id=td.employee_id			
			Left JOIN Designation d with(nolock) ON e.designation_id=d.id
			Inner Join tblBranch b with(nolock) ON dbo.func_getEmployeeBranch(e.id,@periodEndDate)=b.ID
			Inner Join tblBranchLines bl with(nolock) ON bl.branch_id=b.ID
			Inner Join tblArea a with(nolock) ON a.ID=bl.area_id
			Inner Join tblAreaLines al with(nolock) ON a.ID=al.area_id
			Inner Join tblSubZone s with(nolock) ON s.ID=al.subzone_id
			Inner Join tblSubZoneLines sl with(nolock) ON sl.subzone_id=s.ID
			Left Join EmployeeGradeNew g with(nolock) ON g.ID=e.empGrade_Id
			Left Join tblProgram_Minor pm with(nolock) ON pm.Id = e.Program_MinorId
			where e.branch_id in(select branch_id from @tblBranch) and
			   	e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
			--and pt.periodStart between @periodStartDate and @periodEndDate

	RETURN 
END
GO


Go
Alter View view_StaffTraining
As 
SELECT * from func_getStaffTraining ('0','','6/1/2023 12:00:00 AM' , '6/30/2023 12:00:00 AM','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','si')

Go

SELECT * from View_StaffTrainingInfo   where trainingStartDate between '6/1/2023 12:00:00 AM' and '6/30/2023 12:00:00 AM' 