go
alter Function [dbo].[func_statementOfContributionDiscountinue](@periodStartDate Datetime,@periodEndDate Datetime)      
RETURNS table      
AS      
return(       
  
  
select   
(select max(postingDate) from tblProvidenFund where employee_id=a.id having max(postingDate)<@periodEndDate) postingDate  
  
,a.id,a.emp_manualCode,a.EmployeeId,a.empName 
,(select branchname from tblBranch where id=a.branch_id) branchname
from EmployeeGenInfo  a   
  
where (emp_manualCode is not null and  emp_manualCode<>0)  
and (empEndType is null OR empEndType=0)  
and a.id not in(select employee_id from tblProvidenFund where pFDate=@periodEndDate)  
  
   
)
go

--select * from EmployeeGenInfo where empEndType=0

go
Create view [dbo].[view_statementOfContributionDiscountinue] as    
       
 select  postingDate,p.employee_id,e.emp_manualCode,e.EmployeeId,e.empName 
 ,(select branchname from tblBranch where id=e.branch_id) branchname
 from tblProvidenFund p    
 inner join EmployeeGenInfo e on e.id = p.employee_id 
GO

