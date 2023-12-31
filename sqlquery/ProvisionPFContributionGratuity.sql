
GO

ALTER FUNCTION [dbo].[func_ProvisionPFContributionGratuity]  
(  
 @FilterBy varchar(20),  
 @FilterData varchar(max),  
 @periodStartDate DateTime,  
 @periodEndDate DateTime  
)  
RETURNS   
@Provision TABLE   
(  
 empName varchar(100),  
 EmployeeId varchar(100),  
 desgName varchar(200), 
 SubZone varchar(200),
 BasicSalary numeric(10,2),  
 orgPFAmount numeric(10,2),  
 GratuityAmount numeric(10,2)  
)  
AS  
BEGIN  
 DECLARE @tblBranch TABLE (branchId UNIQUEIDENTIFIER)  
 INSERT INTO @tblBranch  
 SELECT branch_id FROM func_GetBranchInfo(@FilterBy, @FilterData, @periodEndDate)  
 
 DECLARE @basicSalaryInfo TABLE (
	EmployeeId varchar(100),
	BasicSalary numeric(10,2)
 ) 

 INSERT INTO @basicSalaryInfo
 SELECT EmployeeId,dbo.func_getBasicSalaryAmount(e.id,@periodEndDate) from EmployeeGenInfo e with (nolock) 
 INNER JOIN  tblBranch b on b.ID=ISNULL(e.salaryLocation, dbo.func_getEmployeeBranch(e.id,@periodEndDate)) 
 Where empEndType=1 AND empType=1  AND 
 ISNULL(e.salaryLocation, b.id) in (Select branchId from @tblBranch) 


 INSERT INTO @Provision  
 select eg.empName, eg.EmployeeId, d.desgName,s.SubZoneName,ISNULL(bi.BasicSalary,0) , Sum(ISNULL(pf.orgPFamount,0)) orgPFamount,Sum(ISNULL( tg.amount,0)) GratuityAamount from EmployeeGenInfo eg with (nolock)  
 inner join Designation d with (nolock) on eg.designation_id=d.ID  
 INNER JOIN  tblBranch b on b.ID=ISNULL(eg.salaryLocation, dbo.func_getEmployeeBranch(eg.id,@periodEndDate))
inner join tblBranchLines bl on bl.branch_id=b.ID
inner join tblArea a on a.id=bl.area_id                
inner join tblAreaLines al on a.ID=al.area_id                
inner join tblSubZone s on s.ID=al.subzone_id   
 INNER JOIN @basicSalaryInfo bi on bi.EmployeeId=eg.EmployeeId
 Left Join tblProvidenFund pf with (nolock) on pf.employee_id =eg.id  
 Left join tblGratuity tg with (nolock) on tg.employee_id=eg.id  
  
 Where eg.empEndType=1 AND eg.empType=1 AND ISNULL(eg.salaryLocation, b.id) in (Select branchId from @tblBranch) 
 And pf.pFDate between @periodStartDate and @periodEndDate
 And tg.gratuityDate between @periodStartDate and @periodEndDate
 GROUP BY eg.empName, eg.EmployeeId, d.desgName,bi.BasicSalary,s.SubZoneName
   
 RETURN   
END 

Go

GO

ALTER view [dbo].[view_ProvisionPFContributionGratuity]
As
Select * from func_ProvisionPFContributionGratuity('4','0391','2023-02-01','2023-02-28') 

GO