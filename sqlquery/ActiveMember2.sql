go
Alter function [dbo].[func_PfActiveMemberList](@periodStartDate date,@periodEndDate date)                    
  returns table                    
  as                    
  return (                    
 

select emp_manualCode,EmployeeId,empName,(select desgName from Designation where id=ex.designation_id) desgName,
 (select top 1  dateOfMembership from tblPFInformtaion where application_id=ex.id) dateOfMembership,
(select branchname from tblBranch where id=ex.branch_id) branchname, ex.cnfDate, ex.orgJoinDate

from EmployeeGenInfo ex where(workingStatus ='Active' and  terminDate IS NULL and emp_manualCode is not null and emp_manualCode<>0)                  
and emp_manualCode not in  (select  empId  from tblProvidendfundRefund  )

				

) 

go
 select * from EmployeeGenInfo

go
Alter view [dbo].[view_pfActiveMemberList]
as
select emp_manualCode,EmployeeId,empName,(select desgName from Designation where id=ex.designation_id) desgName,
 (select top 1  dateOfMembership from tblPFInformtaion where application_id=ex.id) dateOfMembership,
(select branchname from tblBranch where id=ex.branch_id) branchname, ex.cnfDate, ex.orgJoinDate

from EmployeeGenInfo ex where(workingStatus ='Active' and  terminDate IS NULL and emp_manualCode is not null and emp_manualCode<>0)                  
and emp_manualCode not in  (select  empId  from tblProvidendfundRefund  )
GO
