
GO   
ALTER PROCEDURE [dbo].[ProcGetEmployeeNumberByCategory] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS    
BEGIN    
 IF (@branchId = '00000000-0000-0000-0000-000000000000')    
 BEGIN    
  SELECT isnull(Regular, 0) Regular    
   ,isnull(Project, 0) Project    
   ,isnull([Contract], 0) [Contract]    
   ,isnull(Volunteer, 0) Volunteer    
   ,empGender    
   ,Regular+Project+[Contract]+Volunteer as Total  
   ,Project+[Contract]+Volunteer as Other  
  FROM (    
   SELECT e.Id Number,c.Name,e.empGender    
   FROM employeegeninfo e    
   INNER JOIN EmployeeCategory c ON e.empType = c.ID     
   where 
   e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
   and
   --e.workingStatus='Active'  
   e.empEndType=1
    
   ) Tab1    
  PIVOT(count(Number) FOR Name IN (    
     Regular    
     ,Project    
     ,[Contract]    
     ,Volunteer    
     )) AS Tab2    
     order by empGender asc    
 END    
 ELSE    
 BEGIN    
   SELECT isnull(Regular, 0) Regular    
   ,isnull(Project, 0) Project    
   ,isnull([Contract], 0) [Contract]    
   ,isnull(Volunteer, 0) Volunteer    
   ,empGender    
   ,Regular+Project+[Contract]+Volunteer as Total  
   ,Project+[Contract]+Volunteer as Other  
  FROM (    
   SELECT e.Id Number,c.Name,e.empGender    
   FROM employeegeninfo e    
   INNER JOIN EmployeeCategory c ON e.empType = c.ID    
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID    
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id    
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID    
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id    
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID    
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id    
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID    
   WHERE  --e.workingStatus='Active'    
   e.empEndType=1
   and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
     and     
     (    
     z.id = @branchId    
     OR tsz.id = @branchId    
     OR ta.id = @branchId    
     OR b.id = @branchId    
     )    
   ) Tab1    
  PIVOT(count(Number) FOR Name IN (    
     Regular    
     ,Project    
     ,[Contract]    
     ,Volunteer    
     )) AS Tab2    
     order by empGender asc    
 END    
END

go



GO 
ALTER PROCEDURE [dbo].[ProcGetSeparatedEmployeeNumberByCategory] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS  
BEGIN  
 IF (@branchId = '00000000-0000-0000-0000-000000000000')  
 BEGIN  
  SELECT isnull(Regular, 0) Regular  
   ,isnull(Project, 0) Project  
   ,isnull([Contract], 0) [Contract]  
   ,isnull(Volunteer, 0) Volunteer  
   ,empGender  
   ,Regular+Project+[Contract]+Volunteer as Total  
  FROM (  
   SELECT e.Id Number,c.Name,e.empGender  
   FROM EmployeeEndTypeHistory s 
   right join (          
select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
 INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId
 inner join tblAdministrativeActiontype ad with(nolock) on s.EndType=ad.actionTypeID and ad.isEndType=1  
   INNER JOIN EmployeeCategory c ON e.empType = c.ID   
   --where --e.workingStatus<>'Active'	and 
  -- month(e.terminDate)= month(GETDATE()) 
	--and   year(e.terminDate)= year(GETDATE())  
	--e.empEndType<>1
	where e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
   ) Tab1  
  PIVOT(count(Number) FOR Name IN (  
     Regular  
     ,Project  
     ,[Contract]  
     ,Volunteer  
     )) AS Tab2  
     order by empGender asc  
 END  
 ELSE  
 BEGIN  
   SELECT isnull(Regular, 0) Regular  
   ,isnull(Project, 0) Project  
   ,isnull([Contract], 0) [Contract]  
   ,isnull(Volunteer, 0) Volunteer  
   ,empGender  
   ,Regular+Project+[Contract]+Volunteer as Total  
  FROM (  
   SELECT e.Id Number,c.Name,e.empGender  
   FROM  EmployeeEndTypeHistory s 
   right join (          
select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
 INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId
 inner join tblAdministrativeActiontype ad with(nolock) on s.EndType=ad.actionTypeID and ad.isEndType=1  
   INNER JOIN EmployeeCategory c ON e.empType = c.ID  
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID  
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id  
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID  
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id  
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID  
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id  
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID  
   WHERE --e.workingStatus<>'Active' and
   -- month(e.terminDate)= month(GETDATE()) and   year(e.terminDate)= year(GETDATE()) 
     e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
	 and   
     (  
     z.id = @branchId  
     OR tsz.id = @branchId  
     OR ta.id = @branchId  
     OR b.id = @branchId  
     )  
   ) Tab1  
  PIVOT(count(Number) FOR Name IN (  
     Regular  
     ,Project  
     ,[Contract]  
     ,Volunteer  
     )) AS Tab2  
     order by empGender asc  
 END  
END

go



GO   
ALTER PROCEDURE [dbo].[ProcGetPendingEmpClearence] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS    
BEGIN    
 IF (@branchId = '00000000-0000-0000-0000-000000000000')    
 BEGIN    
  SELECT    
       Regular,Project,[Contract],Volunteer,empGender, Regular+Project+[Contract]+Volunteer as Total
  FROM (    
   SELECT e.id Number,    
    c.Name,e.empGender    
   FROM EmployeeEndTypeHistory s 
   right join (          
	select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
	) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
	INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId   
   INNER JOIN tblAdministrativeActiontype a ON s.EndType = a.actionTypeID  
   and a.isEndType=1  
   inner join EmployeeCategory c on e.empType=c.ID  
   WHERE e.terminDate IS NOT NULL    
   --AND e.empEndType <> 1
   and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
	AND e.workingStatus = 'Active'    
   ) Tab1    
  PIVOT(count(Number) FOR Name IN (    
   Regular,Project,[Contract],Volunteer  
     )) AS Tab2    
 END    
 ELSE    
 BEGIN    
      select Regular,Project,[Contract],Volunteer,empGender, Regular+Project+[Contract]+Volunteer as Total
  
  FROM (    
   SELECT e.id Number    
    ,c.Name,empGender    
   FROM EmployeeEndTypeHistory s 
   right join (          
	select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
	) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
	INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId   
   INNER JOIN tblAdministrativeActiontype a ON s.EndType = a.actionTypeID  
   and a.isEndType=1  
   inner join EmployeeCategory c on e.empType=c.ID  
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID    
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id    
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID    
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id    
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID    
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id    
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID    
   WHERE (    
     z.id = @branchId    
     OR tsz.id = @branchId    
     OR ta.id = @branchId    
     OR b.id = @branchId    
     )
	 and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
    AND e.terminDate IS NOT NULL    
   -- AND e.empEndType <> 1    
    AND e.workingStatus = 'Active'    
   ) Tab1    
  PIVOT(count(Number) FOR name IN (    
       Regular,Project,[Contract],Volunteer   
     )) AS Tab2    
 END    
END
go


GO 
ALTER PROCEDURE [dbo].[ProcGetPFemployeeNumberByCategory] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS
BEGIN
	IF (@branchId = '00000000-0000-0000-0000-000000000000')
	BEGIN
		SELECT isnull(Regular, 0) Regular
			,isnull(Project, 0) Project
			,isnull([Contract], 0) [Contract]
			,isnull(Volunteer, 0) Volunteer
			,empGender
			,Regular+Project+[Contract]+Volunteer as Total
		FROM (
			SELECT e.Id Number,c.Name,e.empGender
			FROM employeegeninfo e
			INNER JOIN EmployeeCategory c ON e.empType = c.ID 
			where e.workingStatus='Active' and (e.emp_manualCode<>0) and c.ID=1
			and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
			) Tab1
		PIVOT(count(Number) FOR Name IN (
					Regular
					,Project
					,[Contract]
					,Volunteer
					)) AS Tab2
					order by empGender asc
	END
	ELSE
	BEGIN
			SELECT isnull(Regular, 0) Regular
			,isnull(Project, 0) Project
			,isnull([Contract], 0) [Contract]
			,isnull(Volunteer, 0) Volunteer
			,empGender
			,Regular+Project+[Contract]+Volunteer as Total
		FROM (
			SELECT e.Id Number,c.Name,e.empGender
			FROM employeegeninfo e
			INNER JOIN EmployeeCategory c ON e.empType = c.ID
			LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID
			INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id
			INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID
			INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id
			INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID
			INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id
			INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID
			WHERE 	e.workingStatus<>'Active' and (e.emp_manualCode<>0) and c.ID=1
					and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
					and 
					(
					z.id = @branchId
					OR tsz.id = @branchId
					OR ta.id = @branchId
					OR b.id = @branchId
					)
			) Tab1
		PIVOT(count(Number) FOR Name IN (
					Regular
					,Project
					,[Contract]
					,Volunteer
					)) AS Tab2
					order by empGender asc
	END
END

go


GO      
ALTER PROCEDURE [dbo].[ProcGetPendingEmployeeJoining] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS      
BEGIN      
 IF (@branchId = '00000000-0000-0000-0000-000000000000')      
 BEGIN      
  SELECT isnull(Regular, 0) Regular      
   ,isnull(Project, 0) Project      
   ,isnull([Contract], 0) [Contract]      
   ,isnull(Volunteer, 0) Volunteer      
   ,empGender      
   ,Regular+Project+[Contract]+Volunteer as Total    
   ,Project+[Contract]+Volunteer as Other    
  FROM (      
   SELECT e.Id Number,c.Name,e.empGender      
   FROM employeegeninfo e      
   INNER JOIN EmployeeCategory c ON e.empType = c.ID       
   where month(e.orgJoinDate)= month(GETDATE()) and   year(e.orgJoinDate)= year(GETDATE())
		and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
   
   ) Tab1      
  PIVOT(count(Number) FOR Name IN (      
     Regular      
     ,Project      
     ,[Contract]      
     ,Volunteer      
     )) AS Tab2      
     order by empGender asc      
 END      
 ELSE      
 BEGIN      
   SELECT isnull(Regular, 0) Regular      
   ,isnull(Project, 0) Project      
   ,isnull([Contract], 0) [Contract]      
   ,isnull(Volunteer, 0) Volunteer      
   ,empGender      
   ,Regular+Project+[Contract]+Volunteer as Total    
   ,Project+[Contract]+Volunteer as Other    
  FROM (      
   SELECT e.Id Number,c.Name,e.empGender      
   FROM employeegeninfo e      
   INNER JOIN EmployeeCategory c ON e.empType = c.ID      
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID      
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id      
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID      
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id      
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID      
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id      
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID      
   where month(e.orgJoinDate)= month(GETDATE()) and   year(e.orgJoinDate)= year(GETDATE())   
		and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
     and       
     (      
     z.id = @branchId      
     OR tsz.id = @branchId      
     OR ta.id = @branchId      
     OR b.id = @branchId      
     )      
   ) Tab1      
  PIVOT(count(Number) FOR Name IN (      
     Regular      
     ,Project      
     ,[Contract]      
     ,Volunteer      
     )) AS Tab2      
     order by empGender asc      
 END      
END

go


GO
ALTER PROCEDURE [dbo].[ProcGetPendingEmpClearenceStatus] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS        
BEGIN        
 IF (@branchId = '00000000-0000-0000-0000-000000000000')        
 BEGIN        
  SELECT        
       Resigned,Terminated,Retired,[Released from Job] ReleasedfromJob,Died,Dismissed,Retrenched,[Post Closed] PostClosed,[Contract Ended] ContractEnded,    
    ([Early Retired]+[Project Closed]+[Discontinuation of Contract]) as Other,  
	Resigned+Terminated+Retired+[Released from Job]+Died+Dismissed+Retrenched+[Post Closed]+[Contract Ended]+[Early Retired]+[Project Closed]+[Discontinuation of Contract] as Total  
   
  FROM (        
   SELECT e.id Number,a.actionTypeName   
           
   FROM EmployeeEndTypeHistory s 
   right join (          
	select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
	) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
	INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId  
   INNER JOIN tblAdministrativeActiontype a ON s.EndType = a.actionTypeID    and a.isEndType=1    
   inner join EmployeeCategory c on e.empType=c.ID      
   WHERE e.terminDate IS NOT NULL        
    --AND e.empEndType <> 1
	and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
    AND e.workingStatus = 'Active'        
   ) Tab1        
  PIVOT(count(Number) FOR actionTypeName IN (        
  Resigned,Terminated,Retired,[Released from Job],Dismissed,Died,Retrenched,[Post Closed],[Contract Ended],[Early Retired],[Project Closed],[Discontinuation of Contract]
     )) AS Tab2        
 END        
 ELSE        
 BEGIN        
    select  
	 Resigned,Terminated,Retired,[Released from Job] ReleasedfromJob,Died,Dismissed,Retrenched,[Post Closed] PostClosed,[Contract Ended] ContractEnded,    
    ([Early Retired]+[Project Closed]+[Discontinuation of Contract]) as Other,  
	Resigned+Terminated+Retired+[Released from Job]+Died+Dismissed+Retrenched+[Post Closed]+[Contract Ended]+[Early Retired]+[Project Closed]+[Discontinuation of Contract] as Total     
      
  FROM (        
   SELECT e.id Number,a.actionTypeName   
         
   FROM EmployeeEndTypeHistory s 
   right join (          
	select distinct EmployeeId, MAX(EndDate) EndDate From EmployeeEndTypeHistory hi group by EmployeeId          
	) hii on hii.EmployeeId = s.EmployeeId and hii.EndDate = s.EndDate    
	INNER JOIN employeegeninfo e with(nolock) on e.id=s.EmployeeId         
   INNER JOIN tblAdministrativeActiontype a ON s.EndType = a.actionTypeID  and a.isEndType=1        
   inner join EmployeeCategory c on e.empType=c.ID      
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID        
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id        
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID        
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id        
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID        
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id        
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID        
   WHERE (        
     z.id = @branchId        
     OR tsz.id = @branchId        
     OR ta.id = @branchId        
     OR b.id = @branchId        
     )
	 and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
    AND e.terminDate IS NOT NULL        
    --AND e.empEndType <> 1        
    AND e.workingStatus = 'Active'        
   ) Tab1        
  PIVOT(count(Number) FOR actionTypeName IN (        
        Resigned,Terminated,Retired,[Released from Job],Dismissed,Died,Retrenched,[Post Closed],[Contract Ended],[Early Retired],[Project Closed],[Discontinuation of Contract]     
     )) AS Tab2        
 END        
END
go



GO 
ALTER PROCEDURE [dbo].[ProcGetEmployeeConfirmationByCategory] 
@branchId UNIQUEIDENTIFIER = NULL,
@user_id UNIQUEIDENTIFIER = null
AS    
BEGIN    
 IF (@branchId = '00000000-0000-0000-0000-000000000000')    
 BEGIN    
 SELECT isnull(Regular, 0) Regular    
   ,isnull(Project, 0) Project    
   ,isnull([Contract], 0) [Contract]    
   ,isnull(Volunteer, 0) Volunteer    
   ,empGender    
   ,Regular+Project+[Contract]+Volunteer as Total  
   ,Project+[Contract]+Volunteer as Other  
  FROM (    
   SELECT e.id number,e.empGender,c.Name    
   FROM employeegeninfo e    
   INNER JOIN EmployeeCategory c ON e.empType = c.ID     
   where e.workingStatus='Active' and DATEDIFF(MONTH, orgJoinDate, GETDATE()) >= 6 AND cnfDate IS NULL
		and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
   ) Tab1    
  PIVOT(count(Number) FOR Name IN (    
     Regular    
     ,Project    
     ,[Contract]    
     ,Volunteer    
     )) AS Tab2    
     order by empGender asc  
 END    
 ELSE    
 BEGIN    
  SELECT isnull(Regular, 0) Regular    
   ,isnull(Project, 0) Project    
   ,isnull([Contract], 0) [Contract]    
   ,isnull(Volunteer, 0) Volunteer    
   ,empGender    
   ,Regular+Project+[Contract]+Volunteer as Total  
   ,Project+[Contract]+Volunteer as Other  
  FROM (    
    SELECT e.id number,e.empGender,c.Name    
   FROM employeegeninfo e    
   INNER JOIN EmployeeCategory c ON e.empType = c.ID    
   LEFT JOIN tblBranch b WITH (NOLOCK) ON e.branch_id = b.ID    
   INNER JOIN tblBranchLines bl WITH (NOLOCK) ON b.ID = bl.branch_id    
   INNER JOIN tblArea ta WITH (NOLOCK) ON bl.area_id = ta.ID    
   INNER JOIN tblAreaLines tal WITH (NOLOCK) ON ta.ID = tal.area_id    
   INNER JOIN tblSubZone tsz WITH (NOLOCK) ON tal.subzone_id = tsz.ID    
   INNER JOIN tblSubZoneLines tszl WITH (NOLOCK) ON tsz.ID = tszl.subzone_id    
   INNER JOIN tblZone z WITH (NOLOCK) ON tszl.zone_id = z.ID    
   WHERE  e.workingStatus='Active' and DATEDIFF(MONTH, orgJoinDate, GETDATE()) >= 6 AND cnfDate IS NULL
   and e.Program_MinorId in(select projectOrComponent_id from tblUserProgramInterventionProject where [user_id]=@user_id)
     and     
     (    
     z.id = @branchId    
     OR tsz.id = @branchId    
     OR ta.id = @branchId    
     OR b.id = @branchId    
     )    
   ) Tab1    
  PIVOT(count(Number) FOR Name IN (    
     Regular    
     ,Project    
     ,[Contract]    
     ,Volunteer    
     )) AS Tab2    
     order by empGender asc    
 END    
END

go


