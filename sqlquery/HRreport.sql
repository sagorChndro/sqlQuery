--1
GO
ALTER FUNCTION [dbo].[func_DesignationWiseStaffInfoNew]            
(            
 @designation_id UNIQUEIDENTIFIER
	,@periodStartDate DateTime
	,@periodEndDate DateTime
	,@FilterData varchar(max)
	,@FilterBy varchar(20)
 	,@ProgramMajor UNIQUEIDENTIFIER 
	,@ProgramSubMajor UNIQUEIDENTIFIER  
	,@ProgramMinor UNIQUEIDENTIFIER
	,@userId varchar(30)
)            
RETURNS             
@staffDropOutInfoNew TABLE             
(            
 -- Add the column definitions for the TABLE variable here            
 desgId varchar(250),desgName varchar(250),  Male numeric(10,0), Female numeric(10,0)            
)            
AS            
BEGIN            
 DECLARE @BranchList Table (branchId varchar(10) NOT NULL)            
  INSERT INTO @BranchList            
            
  select branchId from func_TempBranchLines(@periodEndDate) bl            
  where (            
              @FilterBy = '1'            
     AND bl.ZoneId IN (SELECT            
       value            
     FROM dbo.fn_Split(@FilterData, ',')) OR            
            
              @FilterBy = '2'            
     AND bl.subzoneId IN (SELECT            
       value            
     FROM dbo.fn_Split(@FilterData, ',')) OR             
                 
     @FilterBy = '3'            
     AND bl.areaId IN (SELECT            
       value            
     FROM dbo.fn_Split(@FilterData, ',')) OR             
                 
     @FilterBy = '4'            
     AND bl.branchId IN (SELECT            
       value            
     FROM dbo.fn_Split(@FilterData, ',')) OR            
     @FilterBy = '0'            
     AND bl.branchId IN (SELECT branchId from func_TempBranchLines(@periodEndDate))            
    )            
  INSERT INTO @staffDropOutInfoNew            
    select desgId,(desgId +'-'+ desgName) desgName,isnull(Male,0) as Male,isnull(Female,0) as Female from(             
  select e.empGender, d.desgId, d.desgName,COUNT(e.empGender) empgenders                
  from EmployeeGenInfo e             
   inner join tblBranch b on b.id=e.branch_id                  
  inner join Designation d on d.ID = e.designation_id           
  where    
  -- e.workingStatus = 'Active' AND     
--  e.empEndType=1 and   
   B.branchId in (SELECT * FROM @BranchList) 
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and (e.terminDate>@periodStartDate or e.terminDate is null or e.empEndType=1)          
  group by desgName,empGender,desgId           
            
   ) t                 
 PIVOT                
 (                 
  sum(empgenders)                
  For empGender                 
  IN([Male],[Female])                  
 ) as PivotTable                       
 RETURN             
END 
go

--2
GO  
ALTER PROCEDURE [dbo].[proc_staffListDetails]  
 @levelId nvarchar(100),  
 @filterData nvarchar(max),   
 @designation_id uniqueidentifier,  
 @workingStatus varchar(512) ,  
 @primaryWorkingStatus varchar(512),   
 @endDate datetime  ,
 @ProgramMajor UNIQUEIDENTIFIER,
 @ProgramSubMajor UNIQUEIDENTIFIER,
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId VARCHAR(30)
  
AS  
BEGIN  
 SET NOCOUNT ON;  
 Declare @branchCode Table (branchId varchar(5))  
   
 if(@levelId=4)  
 BEGIN  
  INSERT INTO @branchCode  
  select branchid from func_TempBranchLines(@endDate) where branchid in (select value from fn_Split(@filterData,','))  
 END  
 else if(@levelId=3)  
 BEGIN  
  INSERT INTO @branchCode  
  select branchid from func_TempBranchLines(@endDate) where areaId in (select value from fn_Split(@filterData,','))  
 END  
 else if(@levelId=2)  
 BEGIN  
  INSERT INTO @branchCode  
  select branchid from func_TempBranchLines(@endDate) where subzoneId in (select value from fn_Split(@filterData,','))  
 END  
 else if(@levelId=1)  
 BEGIN  
  INSERT INTO @branchCode  
  select branchid from func_TempBranchLines(@endDate) where zoneId in (select value from fn_Split(@filterData,','))  
 END  
 else if(@levelId=0)  
 BEGIN  
  INSERT INTO @branchCode  
  select branchid from func_TempBranchLines(@endDate)  
 END  
   
 select e.EmployeeId,e.emp_manualCode,e.empName,s.subzonename,s.SubZoneId as ProgramId,a.AreaName as project,a.AreaId as projectId,b.branchId,z.ZoneId as DivId,z.ZoneName as DivName,ISNULL(e.permPO,'')permPO,ISNULL(e.presPO,'')presPO,e.fName,e.motheName,ISNULL(e.sName,'') sName,e.workingStatus ,ISNULL(e.presEmail,'') presEmail,e.presPhone,e.cnfDate as permanentDate,                 
   (select top 1  edd.degName from EmployeeEducation edd with(nolock) where employee_id = e.id order by eduYear desc ) as educationInfo,                
   case                 
    when e.employeeLevel =0 THEN 'Organization'            
    when e.employeeLevel = 1 THEN  'Sector'               
    when e.employeeLevel = 2 THEN 'Program'                
    when e.employeeLevel = 3 THEN 'Area'               
    when e.employeeLevel = 4 THEN 'Unit'                
    END as employeelevelName ,                
                
   case                 
    when e.employeeLevel =0 THEN 'Organization'               
    when e.employeeLevel = 1 THEN (select z.ZoneId+'-'+z.ZoneName from tblZone  z with(nolock) where z.id = e.branch_id)                 
    when e.employeeLevel = 2 THEN (select sz.SubZoneId+'-'+sz.SubZoneName from tblSubZone  sz with(nolock) where sz.id = e.branch_id)                
    when e.employeeLevel = 3 THEN (select a.AreaId+'-'+a.AreaName from tblArea  a with(nolock) where a.id = e.branch_id)                
    when e.employeeLevel = 4 THEN (select b.branchId+'-'+b.branchName from tblBranch  b with(nolock) where b.ID = e.branch_id)                  
    END as workingPlace ,   
    d.desgName,d.desgId, ISNULL(d1.districtName,'') as presDis,ISNULL(d2.districtName,'') as permDist,                
    ISNULL(t1.thanaName,'') as presthana,ISNULL(t2.thanaName,'') as permThana,  
    ISNULL(u1.unionName,'') as presUnion , ISNULL(u2.unionName,'') as permUnion,  
    e.empGender , e.bloodGrp,e.signature,e.photo,e.branch_id as controlLevel_id,ISNULL(e.presVill,'') presVill,ISNULL(e.permVill,'')permVill,            
    e.birthDate,e.orgJoinDate,e.cnfDate,  
 dbo.func_getEmployeeBranchJoinDate(e.id,@endDate) brJoinDate ,  
 case when e.terminDate<@endDate then  
  CASE e.empEndType    
 when 2     then 'Suspend'    
 when 3     then 'On Leave'    
 when 4     then 'Terminated'    
 when 5     then 'Resigned'    
 when 6     then 'Show cause'     
 when 7     then 'Reprehension'    
 when 8     then 'Written Warning'      
 when 9     then 'Final Warning'    
 when 10    then 'Transfer'     
 when 11    then 'Remove from Responsibility'  
 when 12    then 'Promotion Suspension'    
 when 13    then 'Salary Deduc'   
 when 14    then 'Release from Job'  
 when 15    then 'Dismissed'    
 when 16    then 'Retired' else 'Active' end   
 else 'Active' end primaryWokornigStatus  
                 
   from EmployeeGenInfo e  with(nolock)              
   inner join tblBranch b with(nolock) on dbo.func_getEmployeeBranch(e.id,@endDate)=b.id     
   inner join tblBranchLines bl with(nolock) on bl.branch_id=b.ID                
   inner join tblArea a with(nolock) on a.id=bl.area_id                
   inner join tblAreaLines al with(nolock) on a.ID=al.area_id                
   inner join tblSubZone s with(nolock) on s.ID=al.subzone_id                
   inner join tblSubZoneLines sl with(nolock) on sl.subzone_id = s.ID                
   inner join tblZone z with(nolock) on z.ID  =  sl.zone_id  
   INNER join Designation d with(nolock) on  dbo.func_getEmployeeDesignation(e.id,@endDate)=d.ID  
   INNER Join EmployeeGradeNew g with(nolock) on g.ID=e.empGrade_Id  
   INNER Join EmployeeGradeStepNew gs with(nolock) on gs.ID=e.empStep_id  
   left join tblDistrict d1 on d1.id = e.presDist                
   left join tblDistrict d2 on d2.ID = e.permDist                
   left join tblThana t1 on t1.ID = e.presThana                
   left join tblThana t2 on t2.ID = e.permThana                
   left join tblUnion u1 on u1.ID = e.presUnion                
   left join tblunion u2 on u2.ID =e.permUnion  
                   
   --left join EmployeeEducation ed on ed.employee_id = e.id                 
   where    
    b.branchid in (select branchId from @branchCode)   
 AND e.designation_id=case @designation_id when '00000000-0000-0000-0000-000000000000'  
  then e.designation_id else @designation_id end AND  
   e.workingStatus=CASE @workingStatus WHEN '00000000-0000-0000-0000-000000000000'   
   THEN e.workingStatus else @workingStatus END AND e.empEndType= CASE @primaryWorkingStatus WHEN '00000000-0000-0000-0000-000000000000' THEN e.empEndType ELSE @primaryWorkingStatus END  
   and
   e.Program_MinorId IN (
				SELECT *
				FROM func_getProgramInterventionListByUserId(@userId, @ProgramMajor, @ProgramSubMajor, @ProgramMinor)
				)
   order by g.GradeID asc, gs.stepId asc  
END 
Go


--3
GO
ALTER FUNCTION [dbo].[func_staffDropOutInfoNew]
(
	@designation_id UNIQUEIDENTIFIER,
	@periodStartDate DateTime,
	@periodEndDate DateTime,
	@FilterData varchar(max),
	@FilterBy varchar(20),
	@ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)
)
RETURNS 
@staffDropOutInfoNew TABLE 
(
	-- Add the column definitions for the TABLE variable here
	desgId varchar(250),
	desgName varchar(250),  
	Male numeric(10,0),
	 Female numeric(10,0),
	 PercentageMale nvarchar(50),
	 PercentageFemale nvarchar(50)
)
AS
BEGIN
	Declare @tblBranch Table (branchId uniqueidentifier)
	INSERT INTO @tblBranch
	SELECT branch_id from func_GetBranchInfo(@FilterBy,@filterData,@periodEndDate)
		INSERT INTO @staffDropOutInfoNew
		select desgId,desgName,isnull(Male,0) as Male,isnull(Female,0) as Female, CAST(((100*isnull(Male,0))/(isnull(Male,0)+isnull(Female,0))) AS numeric(10,2)) PercentageMale,CAST(((100*isnull(Female,0))/(isnull(Male,0)+isnull(Female,0))) AS numeric(10,2))  PercentageFemale  from(    
		select e.empGender, d.desgId, d.desgName,COUNT(e.empGender) empgenders    
		from EmployeeGenInfo e      
		inner join tblBranch b on b.id=e.branch_id      
		inner join tblBranchLines bl on bl.branch_id=b.ID      
		inner join tblArea a on a.id=bl.area_id      
		inner join tblAreaLines al on a.ID=al.area_id      
		inner join tblSubZone s on s.ID=al.subzone_id      
		inner join tblSubZoneLines sl on sl.subzone_id = s.ID      
		inner join tblZone z on z.ID  =  sl.zone_id
		INNER join Designation d on d.ID = e.designation_id      
		INNER JOIN EmployeeEndTypeHistory ta on ta.EmployeeId=e.id
		WHERE
		 e.designation_id=case @designation_id when '00000000-0000-0000-0000-000000000000'
		 then e.designation_id else @designation_id end 		  
		and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
		and
		ta.EndDate between @periodStartDate and @periodEndDate 
		AND e.branch_id in (SELECT * FROM @tblBranch) 
		group by desgName,empGender,desgId  
	  
 ) t     
 PIVOT    
 (     
  sum(empgenders)    
  For empGender     
  IN([Male],[Female],[Per],[PercentageFemale])      
 ) as PivotTable    

	RETURN 
END

go

--4
GO
ALTER function [dbo].[fun_ViewEmpCv](
	@designation_id UNIQUEIDENTIFIER,
	@periodStartDate DateTime,
	@periodEndDate DateTime,
	@FilterBy varchar(20),
    @ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)
)            
RETURNS TABLE             
AS            
RETURN(    
  
select  empgen.id, empgen.empId,            
  empgen.empName,empgen.empGender,empgen.fName,empgen.mName,empgen.sName,empgen.employeeid,            
  cast(empgen.birthDate as date)as birthDate,'D:\Ripon_Development\wave-erp\server\iMFAS.NetSvc\Documents\EmpImage\'+empgen.photo photo,empgen.maritalStat,empgen.religion,            
  empgen.bloodGrp, empgen.empNational_id, empgen.permPO, empgen.presPO,            
  permDist= (select districtName from tblDistrict where cast(ID  as varchar(40)) =empgen.permDist),                
  permThana= (select thanaName from tblThana where cast(ID  as varchar(40)) = empgen.permThana),             
  empgen.permVill,            
  permUnion= (select unionName from tblUnion where cast(ID  as varchar(40))=empgen.permUnion),                
  empgen.permHouse,empgen.permPhone,empgen.presEmail,          
  empgen.eDesignation,           
  presDist= (select districtName from tblDistrict where cast(ID  as varchar(40)) =empgen.presDist),                
  presThana= (select thanaName from tblThana where cast(ID  as varchar(40)) = empgen.presThana),             
  empgen.presVill,            
  presUnion= (select unionName from tblUnion where cast(ID  as varchar(40))=empgen.presUnion),        
  empgen.presHouse,empgen.presPhone,           
  empGrade_Id=(select GradeName from EmployeeGradeNew where ID=empgen.empGrade_Id),            
  empStep_id=(select stepName from EmployeeGradeStepNew where id=empgen.empStep_id),              
  empgen.transferedBranch,            
  cast(empgen.transferDate as date)as transferDate,            
  cast(empgen.orgJoinDate as date)as orgJoinDate ,            
  cast(empgen.brJoinDate as date)as brJoinDate,            
  case    
  when empgen.empType =1 THEN 'Permanent'    
  when empgen.empType =2 THEN 'Temporary'    
  when empgen.empType =3 THEN 'Contractual'    
  when empgen.empType =4 THEN 'Volunteer'   end empType ,       
  empgen.experience, empgen.workingStatus,             
  bankName=(select name from  tblBank where ID =empgen.bank_id),            
  bankBranchName=(select branchName from BankBranch  where ID =empgen.bankBranch_id),              
  empgen.accountNo,g.maxYear,empgen.cnfDate,empgen.empEndType     
         
  from EmployeeGenInfo empgen         
 left join (            
  Select  empId = empgen.empId , maxYear = max(empEdu.eduYear)            
  From EmployeeGenInfo empgen            
  INNER JOIN EmployeeEducation empEdu            
  ON empEdu.empId = empgen.empId            
  group by empgen.empId            
  )g on  empgen.empId = g.empId 
  where empgen.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
 
 -- where empgen.empid=518     
  
) 

go


--5
GO
ALTER PROCEDURE [dbo].[proc_staffDetails]  
 @levelId nvarchar(100),  
 @filterData nvarchar(max),   
 @designation_id uniqueidentifier,  
 @workingStatus varchar(512) ,  
 @primaryWorkingStatus varchar(512),   
 @endDate datetime,
 @ProgramMajor UNIQUEIDENTIFIER,  
 @ProgramSubMajor UNIQUEIDENTIFIER,  
 @ProgramMinor UNIQUEIDENTIFIER, 
 @userId VARCHAR(30)
AS  
BEGIN  
SET NOCOUNT ON;  
DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
 INSERT INTO @tblBranch  
 SELECT branch_id FROM func_GetBranchInfo(@levelId, @filterData, @endDate)  
 select e.EmployeeId Ecode,e.emp_manualCode pfNumber, e.empName,ec.Name EmpType ,e.fName,e.motheName,e.sName,dept.deptName,  
 e.orgJoinDate,e.brJoinDate,e.cnfDate,e.StartDate,e.terminDate EndDate,desg.desgName,e.maritalStat maritalStatus,   
 e.empGender sex,e.religion, e.birthDate, e.bloodGrp, e.empNational_id nid,sp.empName supervisorName, e.tin_Id,p.Name program,   
 psm.Name Sector,  
 pm.Name project,z.ZoneName,s.subzonename,a.AreaName,b.branchName,pred.divisionName presentDivision,  
 permd.divisionName permenantDivision,d1.districtName presentDistrict,d2.districtName permenantDistrict,t1.thanaName presentThana,   
 t2.thanaName permenantThana,e.presPO,e.permPO,e.presVill,e.permVill,e.presHouse,e.permHouse,e.presRoad,e.permRoad,e.permPhone,  
 e.presMobile1,e.presMobile2,e.presSkype,e.presEmail,e.emgPersonName,e.emgRelation,e.emgMobile,g.GradeName GradeID,gs.stepName stepId,   
 aat.actionTypeName,(select top 1  edd.degName from EmployeeEducation edd with(nolock) where employee_id = e.id order by eduYear desc )   
 as educationInfo,  
 dbo.func_GetGrossSalary(e.id) consSalary   
  from EmployeeGenInfo e with(nolock)   
 LEFT JOIN EmployeeGenInfo sp with(nolock) on sp.Id=e.supervisor_id  
 inner join tblBranch b with(nolock) on dbo.func_getEmployeeBranch(e.id,@endDate)=b.id   
 --inner join tblBranch b with(nolock) on e.branch_id=b.id   
 inner join tblBranchLines bl with(nolock) on bl.branch_id=b.ID                
 inner join tblArea a with(nolock) on a.id=bl.area_id                
 inner join tblAreaLines al with(nolock) on a.ID=al.area_id                
 inner join tblSubZone s with(nolock) on s.ID=al.subzone_id                
 inner join tblSubZoneLines sl with(nolock) on sl.subzone_id = s.ID                
 inner join tblZone z with(nolock) on z.ID  =  sl.zone_id  
 INNER join Designation desg with(nolock) on  dbo.func_getEmployeeDesignation(e.id,@endDate)=desg.ID   
 LEFT JOIN tblSalarySource ss with(nolock) on ss.Id=e.SalarySource  
 --LEFT join Designation desg with(nolock) on desg.ID=e.designation_id  
 LEFT Join EmployeeGradeNew g with(nolock) on g.ID=e.empGrade_Id  
 LEFT Join EmployeeGradeStepNew gs with(nolock) on gs.ID=e.empStep_id  
 LEFT Join EmployeeCategory ec with(nolock) on ec.ID=e.empType  
 LEFT JOIN Department dept with(nolock) on dept.ID=e.department_id  
 LEFT JOIN tblAdministrativeActiontype aat with(nolock) on aat.actionTypeID=e.empEndType  
 LEFT JOIN tblProgram_Major p with(nolock) on p.Id=e.Program_MajorId  
 LEFT JOIN tblProgram_SubMajor psm with(nolock)  on psm.Id=e.Program_SubMajorId  
 LEFT JOIN tblProgram_Minor pm with(nolock) on pm.Id=e.Program_MinorId  
 LEFT JOIN tblDivision pred with(nolock) on pred.Id=e.preDiv  
 LEFT JOIN tblDivision permd with(nolock) on permd.Id=e.permDiv  
 left join tblDistrict d1 on d1.id = e.presDist                
 left join tblDistrict d2 on d2.ID = e.permDist                
 left join tblThana t1 on t1.ID = e.presThana                
 left join tblThana t2 on t2.ID = e.permThana  
 where e.branch_id in (select branchId from @tblBranch) AND  
 e.orgJoinDate<=@endDate  
 AND (e.designation_id=case @designation_id when '00000000-0000-0000-0000-000000000000' then e.designation_id  else @designation_id end 
 OR ISNULL(e.designation_id,'00000000-0000-0000-0000-000000000000')=case @designation_id when '00000000-0000-0000-0000-000000000000' then '00000000-0000-0000-0000-000000000000'   
 else @designation_id end) AND e.workingStatus=CASE @workingStatus WHEN '00000000-0000-0000-0000-000000000000'   
    THEN e.workingStatus else @workingStatus END AND e.empEndType= CASE @primaryWorkingStatus WHEN '00000000-0000-0000-0000-000000000000' THEN e.empEndType ELSE @primaryWorkingStatus END  
	and e.Program_MinorId IN ( SELECT * FROM func_getProgramInterventionListByUserId(@userId, @ProgramMajor, @ProgramSubMajor, @ProgramMinor)) 
    order by g.GradeID asc, gs.stepId asc  
  
END
go

--6
GO               
ALTER FUNCTION [dbo].[func_DesignationWiseRequiretmentStaffInfoNew]                
(                
 @designation_id UNIQUEIDENTIFIER,
 @periodStartDate DateTime,
 @periodEndDate DateTime,
 @FilterData varchar(max),
 @FilterBy varchar(20),
 @ProgramMajor UNIQUEIDENTIFIER,
 @ProgramSubMajor UNIQUEIDENTIFIER,
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId VARCHAR(30)
)                
RETURNS                 
@staffDropOutInfoNew TABLE                 
(                
 -- Add the column definitions for the TABLE variable here                
 desgId varchar(250),desgName varchar(250),  Male numeric(10,0), Female numeric(10,0)                
)                
AS                
BEGIN                
 DECLARE @BranchList Table (branchId varchar(10) NOT NULL)                
  INSERT INTO @BranchList                
                
  select branchId from func_TempBranchLines(@periodEndDate) bl                
  where (                
              @FilterBy = '1'                
     AND bl.ZoneId IN (SELECT                
       value                
     FROM dbo.fn_Split(@FilterData, ',')) OR                
                
              @FilterBy = '2'                
     AND bl.subzoneId IN (SELECT                
       value                
     FROM dbo.fn_Split(@FilterData, ',')) OR                 
                     
     @FilterBy = '3'                
     AND bl.areaId IN (SELECT                
       value                
     FROM dbo.fn_Split(@FilterData, ',')) OR                 
                     
     @FilterBy = '4'                
     AND bl.branchId IN (SELECT                
       value                
     FROM dbo.fn_Split(@FilterData, ',')) OR                
     @FilterBy = '0'                
     AND bl.branchId IN (SELECT branchId from func_TempBranchLines(@periodEndDate))                
    )                
  INSERT INTO @staffDropOutInfoNew                
    select desgId, desgName,isnull(Male,0) as Male,isnull(Female,0) as Female from(                 
  select e.empGender, d.desgId, d.desgName,COUNT(e.empGender) empgenders                    
  from EmployeeGenInfo e                 
   inner join tblBranch b on b.id=e.branch_id                      
  inner join Designation d on d.ID = e.designation_id               
  where        
  -- e.workingStatus = 'Active' AND         
--  e.empEndType=1 and       
   B.branchId in (SELECT * FROM @BranchList)      
  and e.orgJoinDate between     @periodStartDate and @periodEndDate
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))

 -- and (e.terminDate>@periodStartDate or e.terminDate is null or e.empEndType=1)              
  group by desgName,empGender,desgId               
                
   ) t                     
 PIVOT                    
 (                     
  sum(empgenders)                    
  For empGender                     
  IN([Male],[Female])                      
 ) as PivotTable                    
                 
              
                 
                 
 RETURN                 
END 

go


--7
GO
ALTER FUNCTION [dbo].[func_getEmployeeAttendanceByEmpid]               
(              
 @emp_Id uniqueidentifier ,
 @startDate datetime, 
 @endDate datetime, 
 @reportFlag int,
 @ProgramMajor UNIQUEIDENTIFIER,
 @ProgramSubMajor UNIQUEIDENTIFIER,
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId VARCHAR(30)
)              
RETURNS               
@tblAttendance TABLE               
(              
               
 PFCode varchar(100) null,EmpId varchar(100) null,EmpName varchar(100) null, AttendanceDate datetime null, InTime varchar(30) null, OutTime varchar(30) null, TotalTime varchar(30) null              
   ,Designation varchar(100)            
)              
AS              
BEGIN              
 IF @reportFlag = 1              
 BEGIN              
 INSERT INTO @tblAttendance              
  select 'PFCode'=CAST(e.emp_manualCode as varchar) ,            
  'EmpId'=CAST(e.empId as varchar) ,            
  'EmpName' =  e.empName,             
  a.attendance_date AttendanceDate,               
  'InTime' = convert(char(08),convert(time(0),checkIn), 100),               
  'OutTime' = convert(char(08),convert(time(0),chekcOut), 100),               
  'TotalTime' = cast(CAST(chekcOut - checkIn as time(0)) as varchar(5))  ,'Designation'=e.eDesignation            
  from tblempAttendance a with(nolock) inner join EmployeeGenInfo e with(nolock) on a.empId = e.empId and a.branch_id = e.branch_id              
  where a.attendance_date between @startDate and @endDate
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and e.id =case when @emp_Id ='00000000-0000-0000-0000-000000000000' then e.id else @emp_Id end        
  order by      attendance_date desc          
 END              
 ELSE              
 BEGIN              
  INSERT INTO @tblAttendance              
  select 'PFCode'=CAST(e.emp_manualCode as varchar) ,            
  'EmpId'=CAST(e.empId as varchar) ,            
  'EmpName' =  e.empName,             
  a.attendance_date AttendanceDate,               
  'InTime' = convert(char(08),convert(time(0),MIN(checkIn)), 100),               
  'OutTime' = convert(char(08),convert(time(0),MAX(chekcOut)), 100),               
  'TotalTime' = cast(CAST(MAX(chekcOut) - MIN(checkIn) as time(0)) as varchar(5)),'Designation'=e.eDesignation            
  from tblempAttendance a with(nolock) inner join EmployeeGenInfo e with(nolock) on a.empId = e.empId and a.branch_id = e.branch_id              
  where a.attendance_date between @startDate and @endDate 
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and e.id =case when @emp_Id ='00000000-0000-0000-0000-000000000000' then e.id else @emp_Id end               
  GROUP BY e.empId, e.empName, a.attendance_date ,e.emp_manualCode,e.eDesignation            
 END              
              
 RETURN               
END 

go


--8
GO
ALTER FUNCTION [dbo].[func_getEmployeeAttendanceByEmpid]               
(              
 @emp_Id uniqueidentifier ,
 @startDate datetime, 
 @endDate datetime, 
 @reportFlag int,
 @ProgramMajor UNIQUEIDENTIFIER,
 @ProgramSubMajor UNIQUEIDENTIFIER,
 @ProgramMinor UNIQUEIDENTIFIER,
 @userId VARCHAR(30)
)              
RETURNS               
@tblAttendance TABLE               
(              
               
 PFCode varchar(100) null,EmpId varchar(100) null,EmpName varchar(100) null, AttendanceDate datetime null, InTime varchar(30) null, OutTime varchar(30) null, TotalTime varchar(30) null              
   ,Designation varchar(100)            
)              
AS              
BEGIN              
 IF @reportFlag = 1              
 BEGIN              
 INSERT INTO @tblAttendance              
  select 'PFCode'=CAST(e.emp_manualCode as varchar) ,            
  'EmpId'=CAST(e.empId as varchar) ,            
  'EmpName' =  e.empName,             
  a.attendance_date AttendanceDate,               
  'InTime' = convert(char(08),convert(time(0),checkIn), 100),               
  'OutTime' = convert(char(08),convert(time(0),chekcOut), 100),               
  'TotalTime' = cast(CAST(chekcOut - checkIn as time(0)) as varchar(5))  ,'Designation'=e.eDesignation            
  from tblempAttendance a with(nolock) inner join EmployeeGenInfo e with(nolock) on a.empId = e.empId and a.branch_id = e.branch_id              
  where a.attendance_date between @startDate and @endDate
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and e.id =case when @emp_Id ='00000000-0000-0000-0000-000000000000' then e.id else @emp_Id end        
  order by      attendance_date desc          
 END              
 ELSE              
 BEGIN              
  INSERT INTO @tblAttendance              
  select 'PFCode'=CAST(e.emp_manualCode as varchar) ,            
  'EmpId'=CAST(e.empId as varchar) ,            
  'EmpName' =  e.empName,             
  a.attendance_date AttendanceDate,               
  'InTime' = convert(char(08),convert(time(0),MIN(checkIn)), 100),               
  'OutTime' = convert(char(08),convert(time(0),MAX(chekcOut)), 100),               
  'TotalTime' = cast(CAST(MAX(chekcOut) - MIN(checkIn) as time(0)) as varchar(5)),'Designation'=e.eDesignation            
  from tblempAttendance a with(nolock) inner join EmployeeGenInfo e with(nolock) on a.empId = e.empId and a.branch_id = e.branch_id              
  where a.attendance_date between @startDate and @endDate 
  and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
  and e.id =case when @emp_Id ='00000000-0000-0000-0000-000000000000' then e.id else @emp_Id end               
  GROUP BY e.empId, e.empName, a.attendance_date ,e.emp_manualCode,e.eDesignation            
 END              
              
 RETURN               
END 
go


--9

GO
ALTER PROCEDURE [dbo].[proc_StaffReleaseInfo]
	@levelId int,
	@filterData nvarchar(max),
	@periodStartDate datetime,
	@periodEndDate datetime,
	@ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)

AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	select e.EmployeeId,e.emp_manualCode,e.empName,b.branchid,a.areaid as projectId,        
	s.subzoneid as ProgramId,sl.zoneid as DivId--,p.programid    
	, 0 domainid,
	e.fName,e.motheName,        
	e.empGender , e.bloodGrp,e.signature,e.photo,e.branch_id as controlLevel_id,         
	e.birthDate,e.orgJoinDate,e.cnfDate   ,e.terminDate  ,cast(e.empActivities as varchar(250)) as releaseReason,        
	e.sName, d.desgName,        
	(select deptId +'-'+deptName from Department where id=e.department_id) deptname ,            
	case             
	 when e.employeeLevel =0 THEN 'Organization'            
	 when e.employeeLevel = 1 THEN (select z.ZoneName from tblZone  z where z.id = e.branch_id)             
	 when e.employeeLevel = 2 THEN (select sz.SubZoneName from tblSubZone  sz where sz.id = e.branch_id)            
	 when e.employeeLevel = 3 THEN (select a.AreaName from tblArea  a where a.id = e.branch_id)            
	 when e.employeeLevel = 4 THEN (select b.branchName from tblBranch  b where b.ID = e.branch_id)
	 END as workingStatus ,
	e.presEmail,e.presPhone,t1.thanaName as presthana, u1.unionName as presUnion ,e.presPO, d1.districtName as presDis,        
	isnull(e.permPO,'') permPO, isnull(d2.districtName,'')  permDist,        
	isnull(t2.thanaName,'')  permThana,isnull(u2.unionName,'')  permUnion,        
	isnull(e.permVill,'') permVill,e.presVill        
	from EmployeeGenInfo e 
	inner join tblBranch b on b.id=e.branch_id            
	inner join tblBranchLines bl on bl.branch_id=b.ID            
	inner join tblArea a on a.id=bl.area_id            
	inner join tblAreaLines al on a.ID=al.area_id            
	inner join tblSubZone s on s.ID=al.subzone_id            
	--inner join tblSubZoneLinesDomain sl on sl.subzone_id = s.ID   //Reyad  
	inner join tblSubZoneLines sl on sl.subzone_id = s.ID                      
	--inner join tblZone z on z.ID  =  sl.zone_id           
	--inner join tblZoneLines zl on zl.zone_id  =  z.id             
	--inner join tblprogram p on p.ID  =  zl.program_id          
	--inner join tblPrgramLines pl on pl.program_id  =  p.id             
	--inner join tblDomain do on do.ID  =  pl.domain_id  //Reyad            
            
	left join Designation d on d.ID = e.designation_id            
	left join tblDistrict d1 on d1.id = e.presDist            
	left join tblDistrict d2 on d2.ID = e.permDist            
	left join tblThana t1 on t1.ID = e.presThana            
	left join tblThana t2 on t2.ID = e.permThana            
	left join tblUnion u1 on u1.ID = e.presUnion            
	left join tblunion u2 on u2.ID =e.permUnion 
	where e.terminDate between @periodStartDate and @periodEndDate  
	and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
	and (  e.empendtype in( 4, 5, 7, 14, 15, 16)) AND e.branch_id in (select * from @tblBranch)
END
go

--10
GO
ALTER function [dbo].[func_Indivisual_employeeTransfer]        
(
	@empid uniqueidentifier ,
	@statDate Date,
	@endDate Date,
	@FilterData varchar(max),
	@FilterBy varchar(20),
	@ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)
)              
 RETURNS                            
@TransferList TABLE                             
(    
	emp_manualCode nvarchar(250),
	empName nvarchar(250),  
	oldDesgName  nvarchar(250), 
	desgName  nvarchar(250), 
	oldDeptName nvarchar(250),
	deptName nvarchar(250),
	oldWorkingPlace   nvarchar(250) ,
	newWorkingPlace   nvarchar(250)  ,
	transferDate date              
)                                
                           
AS                            
BEGIN                            
 DECLARE @BranchList Table (branchId varchar(10) NOT NULL)                            
  
  INSERT INTO @BranchList            
  select branchId from func_TempBranchLines(@endDate) bl                            
  where (                            
              @FilterBy = '1'                            
     AND bl.ZoneId IN (SELECT                          
       value                            
     FROM dbo.fn_Split(@FilterData, ',')) OR                            
                            
              @FilterBy = '2'                            
     AND bl.subzoneId IN (SELECT                            
       value                            
     FROM dbo.fn_Split(@FilterData, ',')) OR                             
                                 
     @FilterBy = '3'                            
     AND bl.areaId IN (SELECT                            
       value                            
     FROM dbo.fn_Split(@FilterData, ',')) OR                             
                                 
     @FilterBy = '4'                            
     AND bl.branchId IN (SELECT                            
       value                            
     FROM dbo.fn_Split(@FilterData, ',')) OR                            
     @FilterBy = '0'                            
     AND bl.branchId IN (SELECT branchId from func_TempBranchLines(@endDate))                            
    )     
	
 INSERT INTO @TransferList  
SELECT e.employeeid emp_manualCode,e.empName,
(Select desgName from Designation WHERE Id=
IsNull(
IsNull((SELECT top 1 prevDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
and promotionEffectiveDate <= d.effectiveDate order by promotionEffectiveDate desc), 
(SELECT top 1 prevDesignation_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
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
) AS desgName,


(Select deptName from Department WHERE Id=
IsNull(
	IsNull((SELECT top 1 prevDepartment_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
and promotionEffectiveDate <= d.effectiveDate order by promotionEffectiveDate desc),
(SELECT top 1 prevDepartment_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
and promotionEffectiveDate > d.effectiveDate order by promotionEffectiveDate asc))
,e.department_id)
) AS oldDeptName,

	(Select deptName from Department WHERE Id=
	IsNull(
	IsNull((SELECT top 1 newDepartment_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
and promotionEffectiveDate <= d.effectiveDate order by promotionEffectiveDate desc),
(SELECT top 1 prevDepartment_id FROM EmployeePromostionHistry with (nolock) Where employee_id =e.id
and promotionEffectiveDate > d.effectiveDate order by promotionEffectiveDate asc))
,e.department_id)

) AS deptName,



(select branchId+'-'+ branchname from tblBranch where id=
IsNull(h.prevUnit_id,
(select top 1 newUnit_id from EmployeeTransferHistry with (nolock) where employee_id = e.id
and empTransferDate <= d.effectiveDate order by empTransferDate desc )

)) oldWorkingPlace,              
(select branchId+'-'+ branchname from tblBranch where id=
IsNull(h.newUnit_id,
(select top 1 newUnit_id from EmployeeTransferHistry with (nolock) where employee_id = e.id
and empTransferDate <= d.effectiveDate order by empTransferDate desc )
)
) newWorkingPlace,
d.effectiveDate transferDate   
FROM EmployeeGenInfo e inner join
 (
	select employeeid,empTransferDate effectiveDate           
	from EmployeeGenInfo a with (nolock)               
	inner join EmployeeTransferHistry b with (nolock) on a.id=b.employee_id              
	WHERE a.id=@empid 
	UNION
	select employeeid,c.promotionEffectiveDate         
	from EmployeeGenInfo a with (nolock)               
	INNER Join EmployeePromostionHistry c with (nolock) on a.id=c.employee_id           
	WHERE a.id=@empid 
 ) d on e.EmployeeId = d.EmployeeId 
Left Join EmployeeTransferHistry h with (nolock) on e.id=h.employee_id and d.effectiveDate = h.empTransferDate
Where d.effectiveDate <= @endDate and e.id = @empid 
and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
order by d.effectiveDate

              
 RETURN                             
END
go


--11
GO
ALTER FUNCTION [dbo].[func_EmployeeLeaveReg] (
	@levelId INT,
	@filterData NVARCHAR(max),
	@periodStartDate DATETIME,
	@periodEndDate DATETIME,
	@ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)
	)
RETURNS @EmployeeLeaveReg TABLE (
	empId NVARCHAR(20),
	empName NVARCHAR(50),
	eDesignation NVARCHAR(100),
	LeaveTypName NVARCHAR(100),
	FromDate DATETIME,
	ToDate DATETIME,
	totalDays NUMERIC(18, 0),
	contactAddress NVARCHAR(500),
	phoneNo NVARCHAR(20),
	remarks NVARCHAR(500),
	leaveStatus NVARCHAR(100)
	)
AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	INSERT INTO @EmployeeLeaveReg
	SELECT empgen.EmployeeId empId,
		empgen.empName,
		d.desgName eDesignation,
		ltyp.LeaveTypName,
		lv.FromDate,
		lv.ToDate,
		lv.totalDays,
		lv.contactAddress,
		empgen.emgMobile phoneNo,
		lv.remarks,
		lv.leaveStatus
	FROM EmployeeGenInfo empgen WITH (NOLOCK)
	INNER JOIN Designation d WITH (NOLOCK) ON d.ID = empgen.designation_id
	INNER JOIN EmployeeLeave lv WITH (NOLOCK) ON empgen.id = lv.empId
	INNER JOIN LeaveType ltyp WITH (NOLOCK) ON ltyp.ID = lv.leaveTypeId
	WHERE empgen.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
	and empgen.branch_id IN (
			SELECT *
			FROM @tblBranch
			)
		AND (
			(
				lv.FromDate BETWEEN @periodStartDate
					AND @periodEndDate
				)
			OR (
				lv.ToDate BETWEEN @periodStartDate
					AND @periodEndDate
				)
			)

	RETURN
END

go



 --12 
GO
ALTER function [dbo].[func_empLeaveStatus](
@levelId int,
@filterData nvarchar(max),
@empId uniqueIdentifier,
@periodStartDate datetime,
@periodEndDate datetime,
@ProgramMajor UNIQUEIDENTIFIER,
@ProgramSubMajor UNIQUEIDENTIFIER,
@ProgramMinor UNIQUEIDENTIFIER,
@userId VARCHAR(30)
)      
RETURNS @info TABLE  (
	empId numeric(18,0),
	empName nvarchar(100),
	desgName nvarchar(100),
	GradeName nvarchar(50),
	LeaveTypName nvarchar(50),
	NoOfDays numeric(18,0),
	FromDate datetime,
	ToDate datetime,
	totalDays numeric(18,0),
	RunningTotal numeric(18,0)
)    
 AS      
  BEGIN
	Declare @tblBranch Table (branchId uniqueidentifier)
	INSERT INTO @tblBranch
	SELECT branch_id from func_GetBranchInfo(@levelId,@filterData,@periodEndDate)

	INSERT Into @info
	select  e.empId,e.empName,d.desgName,g.GradeName,lt.LeaveTypName, al.NoOfDays,el.FromDate,el.ToDate, el.totalDays,  
	sum(el.totalDays) OVER(PARTITION BY lt.LeaveTypName ORDER BY el.FromDate ) AS RunningTotal       
	from EmployeeGenInfo e with (nolock)       
	inner join Designation d with (nolock) on e.designation_id = d.id      
	inner join EmployeeGradeNew g with (nolock) on e.empGrade_Id = g.id       
	inner join AnnualLeave al with (nolock) on al.GradeID = g.id       
	inner join LeaveType lt with (nolock) on al.LeaveTypeID =lt.ID       
	left join EmployeeLeave el with (nolock) on el.empId = e.id and lt.id = el.leaveTypeId   
	 where  e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))
	 and e.branch_id in (Select * from @tblBranch) and e.id=case when @empId='00000000-0000-0000-0000-000000000000' then e.id else @empId end   
	 --and el.FromDate between  @fromdate and @enddate  
 RETURN
END

go


--13 
GO
ALTER function [dbo].[func_HRInfoSummaryGlobal] (  
 @levelId int,  
 @filterData nvarchar(max),   
 @periodStartDate datetime,  
 @periodEndDate datetime,  
 @ProgramMajorId uniqueidentifier,  
 @ProgramSubMajorId uniqueidentifier,  
 @ProgramMinorId uniqueidentifier  ,
 @userId VARCHAR(30)
 )        
Returns @info table   (  
 ProgramId int,  
 Program nvarchar(500),  
 categoryId int,  
 categoryName nvarchar(max),  
 Male int,  
 Female int,  
 Total int  
   
)      
AS         
BEGIN  
Declare @tblBranch Table (branchId uniqueidentifier)  
 INSERT INTO @tblBranch  
 SELECT branch_id from func_GetBranchInfo(@levelId,@filterData,@periodEndDate)  
   
 Declare @Table1 as table(  
  ProgramId int,  
  Program nvarchar(500),  
  sectorid int,  
  sector nvarchar(max),  
  categoryId int,  
  categoryName nvarchar(max),  
  Male int,  
  Female int,  
  Total int  
 )   
 insert into @info  
 select ProgramId,Program,categoryId,categoryName,isnull(Male,0) as Male,isnull(Female,0) as Female, (isnull(Male,0) + isnull(Female,0)) Total from(   
   select e.empGender, p.MajorId ProgramId,p.Name Program,c.ID categoryId, c.Name categoryName,COUNT(e.empGender) empgenders      
   from EmployeeGenInfo e        
   inner join tblBranch b on b.id=dbo.func_getEmployeeBranch(e.id,@periodEndDate)      
   --inner join tblAdministrativeActiontype a with(nolock) on a.actionTypeID = e.empEndType  
   inner join EmployeeCategory c with(nolock) on e.empType = c.ID  
   inner join dbo.tblProgram_Major p WITH (nolock) ON p.Id = e.Program_MajorId   
   inner join dbo.tblProgram_SubMajor sm WITH (nolock) ON sm.Id = e.Program_SubMajorId  
   INNER JOIN dbo.tblProgram_Minor m with(nolock) On m.Id=e.Program_MinorId   
    
   WHERE e.empEndType = 1 and e.orgJoinDate <= @periodEndDate   and
   
			e.Program_MinorId IN (
				SELECT *
				FROM func_getProgramInterventionListByUserId(@userId, @ProgramMajorId, @ProgramSubMajorId, @ProgramMinorID)
				)

    

   AND e.branch_id in (SELECT * FROM @tblBranch)   
   group by p.MajorId,p.Name,c.ID, c.Name,empGender  
     
  ) t       
  PIVOT      
  (       
   sum(empgenders)  
   For empGender       
   IN([Male],[Female],[Total])        
  ) as PivotTable    
 return  
END

go
  
  
 GO
 ALTER FUNCTION [dbo].[fn_EmployeeIncrement] (
	@employee_id UNIQUEIDENTIFIER,
	@FilterData VARCHAR(max),
	@levelId INT,
	@periodStartDate DATETIME,
	@periodEndDate DATETIME,
	@ProgramMajor UNIQUEIDENTIFIER,  
   @ProgramSubMajor UNIQUEIDENTIFIER,  
   @ProgramMinor UNIQUEIDENTIFIER,
   @userId VARCHAR(30)
	)
RETURNS @IncrementInfo TABLE (
	empId NVARCHAR(50),
	empName NVARCHAR(250),
	incrementEffectiveDate DATETIME,
	orgJoinDate DATETIME,
	cnfDate DATETIME,
	desgName NVARCHAR(250),
	deptName NVARCHAR(250),
	newgr INT,
	pregr INT,
	newst INT,
	prest INT
	)
AS
BEGIN
	DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)

	INSERT INTO @tblBranch
	SELECT branch_id
	FROM func_GetBranchInfo(@levelId, @filterData, @periodEndDate)

	INSERT INTO @IncrementInfo
	SELECT x.empId,
		x.empName,
		y.incrementEffectiveDate,
		x.orgJoinDate,
		x.cnfDate,
		x.desgName,
		x.deptName,
		y.newgr,
		y.pregr,
		y.newst,
		y.prest
	FROM (
		SELECT emp.id,
			emp.EmployeeId empId,
			emp.empName,
			emp.orgJoinDate,
			emp.cnfDate,
			(
				SELECT desgName
				FROM Designation WITH (NOLOCK)
				WHERE Id = emp.designation_id
				) AS desgName,
			(
				SELECT deptName
				FROM Department WITH (NOLOCK)
				WHERE Id = emp.department_id
				) AS deptName
		FROM EmployeeGenInfo emp
		WHERE emp.id = @employee_id
		) x
	LEFT JOIN (
		SELECT emp.id,
			ph.promotionEffectiveDate incrementEffectiveDate,
			newgr = (
				SELECT a.GradeID
				FROM (
					SELECT egn.GradeID,
						egn.ID
					FROM EmployeeGradeNew egn
					) a
				WHERE a.ID = ph.NewEmpGrade_Id
				),
			pregr = (
				SELECT a.GradeID
				FROM (
					SELECT egn.GradeID,
						egn.ID
					FROM EmployeeGradeNew egn
					) a
				WHERE a.ID = ph.PrevEmpGrade_Id
				),
			newst = (
				SELECT a.stepId
				FROM (
					SELECT egs.stepId,
						egs.id
					FROM EmployeeGradeStepNew egs
					) a
				WHERE a.id = ph.NewEmpStep_id
				),
			prest = (
				SELECT a.stepId
				FROM (
					SELECT egs.stepId,
						egs.id
					FROM EmployeeGradeStepNew egs
					) a
				WHERE a.id = ph.PrevEmpStep_id
				)
		FROM EmployeeGenInfo emp
		INNER JOIN EmployeePromostionHistry ph ON emp.id = ph.employee_id
		WHERE
				emp.Program_MinorId IN (
				SELECT *
				FROM func_getProgramInterventionListByUserId(@userId, @ProgramMajor, @ProgramSubMajor, @ProgramMinor)
				)and (
				ph.PrevEmpGrade_Id <> ph.NewEmpGrade_Id
				OR ph.NewEmpStep_id <> ph.PrevEmpStep_id
				)
			AND emp.id = @employee_id
			AND ph.promotionEffectiveDate BETWEEN @periodStartDate
				AND @periodEndDate
			AND emp.branch_id IN (
				SELECT *
				FROM @tblBranch
				)
		) y ON x.id = x.id

	RETURN
END ----  


go


go
ALTER function [dbo].[fun_EmployeeDetails](
	@employee_id uniqueidentifier,
	@ProgramMajor UNIQUEIDENTIFIER,
    @ProgramSubMajor UNIQUEIDENTIFIER,
    @ProgramMinor UNIQUEIDENTIFIER,
    @userId VARCHAR(30)

)         
RETURNS TABLE      
AS                    
RETURN(            
          
      
SELECT e.id      
 ,ec.[Name]      
 ,e.empName      
 ,e.fName      
 ,'D:\Ripon_Development\wave-erp\server\iMFAS.NetSvc\Documents\EmpImage\'+e.photo photo      
 ,e.sName      
 ,e.empGender      
 ,e.birthDate      
 ,super.empName Supervisor      
 ,ROLE.name [role]      
 ,bank.name bank      
 ,bankBranch.branchName      
 ,p.Name programm      
 ,pm.Name sector      
 ,pm.name project      
 ,e.emp_manualCode pfnumber      
 ,e.EmployeeId      
 ,e.motheName      
 ,e.maritalStat      
 ,e.religion      
 ,e.bloodGrp      
 ,e.empNational_id      
 ,e.tin_Id      
 ,e.workingStatus [Employee Status]      
  , case   
 when e.isSupervisor=1   
 then 'Yes'  
 else 'No'  
 end isSupervisor     
 ,e.accountNo      
 ,e.routingNo      
 ,z.ZoneName Program      
 ,s.SubZoneName Region      
 ,a.AreaName Area      
 ,b.branchName Branch      
 ,preparedBy.empName createdBy      
 ,checkedBy.empName CheckedBy      
 ,approvedBy.empName ApprovedBy      
 ,e.orgJoinDate      
 ,e.brJoinDate      
 ,CASE       
  WHEN e.cnfDate IS NULL      
   THEN 'Non Confirm'      
  ELSE 'Confirm'      
  END [Job Status]      
 ,e.cnfDate      
 ,e.workingStatus [Admin Status]      
 ,e.StartDate      
 ,e.terminDate      
 ,e.lastIncrementDate      
 ,e.transferDate      
 ,dept.deptName      
 ,desg.desgName      
 ,g.GradeName      
 ,gs.stepName      
 ,permd.divisionName perDivision      
 ,d2.districtName perDistrict      
 ,t2.thanaName perThana      
 ,pred.divisionName preDiv      
 ,d1.districtName preDis      
 ,t1.thanaName preThana      
 ,preUnion.unionName preUnion      
 ,perUnion.unionName perUnion      
 ,e.permVill      
 ,e.presVill      
 ,e.permPO      
 ,e.presPO      
 ,e.permPhone      
 ,e.presPhone      
 ,e.permHouse      
 ,e.presHouse      
 ,e.permRoad      
 ,e.presRoad      
 ,sec.securityAmount      
 ,sec.securityInerest      
 ,sec.postingdate      
 ,case when  sec.isMonthly=1 then 'Yes'
 else 'No' end isMonthly
 ,case when sec.IsYearly=1 then 'Yes'
 else 'No' end IsYearly 
 ,e.emgPersonName  
 ,e.emgRelation  
 ,e.emgMobile  
 ,e.presMobile1  
 ,e.presMobile2  
 ,e.presSkype  
 ,e.presEmail  
  
FROM EmployeeGenInfo e      
LEFT JOIN EmployeeGenInfo sp WITH (NOLOCK) ON sp.Id = e.supervisor_id      
--inner join tblBranch b with(nolock) on dbo.func_getEmployeeBranch(e.id,@endDate)=b.id         
INNER JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.id      
INNER JOIN tblBranchLines bl WITH (NOLOCK) ON bl.branch_id = b.ID      
INNER JOIN tblArea a WITH (NOLOCK) ON a.id = bl.area_id      
INNER JOIN tblAreaLines al WITH (NOLOCK) ON a.ID = al.area_id      
INNER JOIN tblSubZone s WITH (NOLOCK) ON s.ID = al.subzone_id      
INNER JOIN tblSubZoneLines sl WITH (NOLOCK) ON sl.subzone_id = s.ID      
INNER JOIN tblZone z WITH (NOLOCK) ON z.ID = sl.zone_id      
--INNER join Designation desg with(nolock) on  dbo.func_getEmployeeDesignation(e.id,@endDate)=desg.ID         
LEFT JOIN Designation desg WITH (NOLOCK) ON desg.ID = e.designation_id      
LEFT JOIN EmployeeGradeNew g WITH (NOLOCK) ON g.ID = e.empGrade_Id      
LEFT JOIN EmployeeGradeStepNew gs WITH (NOLOCK) ON gs.ID = e.empStep_id      
LEFT JOIN EmployeeCategory ec WITH (NOLOCK) ON ec.ID = e.empType      
LEFT JOIN Department dept WITH (NOLOCK) ON dept.ID = e.department_id      
LEFT JOIN tblAdministrativeActiontype aat WITH (NOLOCK) ON aat.actionTypeID = e.empEndType      
LEFT JOIN tblProgram_Major p WITH (NOLOCK) ON p.Id = e.Program_MajorId      
LEFT JOIN tblProgram_SubMajor psm WITH (NOLOCK) ON psm.Id = e.Program_SubMajorId      
LEFT JOIN tblProgram_Minor pm WITH (NOLOCK) ON pm.Id = e.Program_MinorId      
LEFT JOIN tblDivision pred WITH (NOLOCK) ON pred.Id = e.preDiv      
LEFT JOIN tblDivision permd WITH (NOLOCK) ON permd.Id = e.permDiv      
LEFT JOIN tblDistrict d1 WITH (NOLOCK) ON d1.id = e.presDist      
LEFT JOIN tblDistrict d2 WITH (NOLOCK) ON d2.ID = e.permDist      
LEFT JOIN tblThana t1 WITH (NOLOCK) ON t1.ID = e.presThana      
LEFT JOIN tblThana t2 WITH (NOLOCK) ON t2.ID = e.permThana      
LEFT JOIN tblUnion preUnion WITH (NOLOCK) ON e.presUnion = preUnion.ID      
LEFT JOIN tblUnion perUnion WITH (NOLOCK) ON e.permUnion = perUnion.ID      
LEFT JOIN EmployeeGenInfo super WITH (NOLOCK) ON e.supervisor_id = super.id      
LEFT JOIN ROLE WITH (NOLOCK) ON e.role_id = ROLE.id      
LEFT JOIN tblBank bank WITH (NOLOCK) ON e.bank_id = bank.ID      
LEFT JOIN BankBranch bankBranch WITH (NOLOCK) ON e.bankBranch_id = BankBranch.id      
LEFT JOIN EmployeeGenInfo preparedBy WITH (NOLOCK) ON e.PreparedBy = PreparedBy.id      
LEFT JOIN EmployeeGenInfo checkedBy WITH (NOLOCK) ON e.CheckerBy = checkedBy.id      
LEFT JOIN EmployeeGenInfo approvedBy WITH (NOLOCK) ON e.ApprovedBy = approvedBy.id      
LEFT JOIN tblEmpSecurityinfo sec WITH (NOLOCK) ON e.id = sec.employee_id      
WHERE e.id = @employee_id and e.Program_MinorId in(select * from func_getProgramInterventionListByUserId(@userId,@ProgramMajor,@ProgramSubMajor,@ProgramMinor))    
          
) 

go


