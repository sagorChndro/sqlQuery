go
Alter function [dbo].[func_TransferOrder] (
	@startDate datetime,
	@endDate datetime,
	@FilterData varchar(max),
	@FilterBy varchar(20),
	@ProgramMajor UNIQUEIDENTIFIER,
	@ProgramSubMajor UNIQUEIDENTIFIER,
	@ProgramMinor UNIQUEIDENTIFIER  
 )  
 Returns @info table   (
	EmployeeId nvarchar(50),
	EmployeeName nvarchar(100),
	effectiveDate datetime,
	OldDesgName nvarchar(200),
	NewDesgName nvarchar(200),
	OldLocation nvarchar (200),
	NewLocation nvarchar (200)
)    

AS       
BEGIN	

	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)
	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@FilterBy, @filterData, @endDate)

	INSERT INTO @info
	SELECT e.employeeid,e.empName,d.effectiveDate,(Select desgName from Designation WHERE Id=
	IsNull(IsNull((SELECT top 1 prevDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id	and promotionEffectiveDate <= d.effectiveDate order by promotionEffectiveDate desc),(SELECT top 1 prevDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
	and promotionEffectiveDate > d.effectiveDate order by promotionEffectiveDate asc))
	,e.designation_id)
	) AS OldDesgName,

	(Select desgName from Designation WHERE Id=
	IsNull(
	IsNull((SELECT top 1 newDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
	and promotionEffectiveDate <= d.effectiveDate order by promotionEffectiveDate desc), 
	(SELECT top 1 prevDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
	and promotionEffectiveDate > d.effectiveDate order by promotionEffectiveDate asc))
	,e.designation_id)
	) AS NewDesgName,

	(select b.branchName+','+ta.AreaName+','+sz.SubZoneName from tblBranch b WITH(NOLOCK) 
	INNER JOIN tblBranchLines bl WITH(NOLOCK) ON bl.branch_id = b.ID
	INNER JOIN tblArea ta WITH(NOLOCK) ON ta.ID = bl.area_id
	INNER JOIN tblAreaLines tal WITH(NOLOCK) ON ta.ID = tal.area_id
	INNER JOIN tblSubZone sz WITH(NOLOCK) ON sz.ID = tal.subzone_id
	where (b.ID = IsNull(h.prevUnit_id, (select top 1 prevUnit_id from EmployeeTransferHistry WITH(NOLOCK) where employee_id = e.id and empTransferDate <= d.effectiveDate order by empTransferDate desc ))
	AND (ta.ID = ISNULL(h.prevArea_id,(select top 1 prevArea_id from EmployeeTransferHistry WITH(NOLOCK) where employee_id = e.id and empTransferDate <= d.effectiveDate order by empTransferDate desc))
	AND (sz.ID =ISNULL(h.prevSubZone_id,(select top 1 prevSubZone_id from EmployeeTransferHistry WITH(NOLOCK) WHERE employee_id = e.id and empTransferDate <=d.effectiveDate order by empTransferDate desc))
	)))) OldLocation,   
	
	(select b.branchName+','+ta.AreaName+','+sz.SubZoneName from tblBranch b WITH(NOLOCK) 
	Inner Join tblBranchLines bl WITH(NOLOCK) on bl.branch_id = b.ID
	Inner Join tblArea ta WITH(NOLOCK) on ta.ID = bl.area_id
	Inner Join tblAreaLines tal WITH(NOLOCK) on ta.ID = tal.area_id
	Inner Join tblSubZone sz WITH(NOLOCK) on sz.ID = tal.subzone_id
	where (b.ID=IsNull(h.newUnit_id,	(select top 1 newUnit_id from EmployeeTransferHistry WITH(NOLOCK) where employee_id = e.id	and empTransferDate <= d.effectiveDate order by empTransferDate desc ))
	And (ta.ID = IsNull(h.newArea_id,(select top 1 newArea_id from EmployeeTransferHistry WITH(NOLOCK) where employee_id = e.id and empTransferDate <= d.effectiveDate order by empTransferDate desc ))
	And (sz.ID = ISNULL(h.newSubZone_id,(select top 1 newSubZone_id from EmployeeTransferHistry WITH(NOLOCK) where employee_id = e.id and empTransferDate <= d.effectiveDate order by empTransferDate desc))
	)
	)))NewLocation
	FROM EmployeeGenInfo e inner join
	 (
		select a.id,a.employeeid,b.effectiveDate effectiveDate           
		from EmployeeGenInfo a with (nolock)               
		inner join EmployeeTransferHistry b with (nolock) on a.id=b.employee_id WHERE b.status=1             
	 ) d on e.id = d.id 
	Left Join EmployeeTransferHistry h with (nolock) on e.id=h.employee_id 
	and d.effectiveDate = h.effectiveDate
	Where d.effectiveDate BETWEEN @startDate AND @endDate AND h.status=1 AND e.branch_id IN (SELECT * from @tblBranch) AND	e.Program_MajorId=case @ProgramMajor when '00000000-0000-0000-0000-000000000000' then e.Program_MajorId else @ProgramMajor end 
	AND	e.Program_SubMajorId=case @ProgramSubMajor when '00000000-0000-0000-0000-000000000000' then e.Program_SubMajorId else @ProgramSubMajor end
	AND	e.Program_MinorId=case @ProgramMinor when '00000000-0000-0000-0000-000000000000' then e.Program_MinorId else @ProgramMinor end
	order by d.effectiveDate
	RETURN
END
go


Go
Alter View viw_TransferOrder
As
SELECT * from func_TransferOrder('2023-08-01','2023-08-31','','0','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
Go



