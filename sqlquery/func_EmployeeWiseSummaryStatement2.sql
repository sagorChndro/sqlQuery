
ALTER  function [dbo].[func_EmployeeWiseSummaryStatement]( @periodEndDate Datetime)                                   
RETURNS TABLE                                   
AS                                   
RETURN                                   
(                                   
                          
                           
select distinct x.*,y.noOfinstalment ,z.DepositedAmt,isnull(x1.profit,0) profit,                                   
(isnull(z.DepositedAmt,0)+isnull(x1.profit,0) ) total ,a.dateofLastInstallment ,isnull(b.securityAmount  ,0) securityAmount                               
from (                                   
                                  
select distinct e.id employee_id,                                
e.empName,                              
e.EmployeeId,                                 
d.desgName,                                   
e.orgJoinDate,                                  
(select min(InstallmentStartDate) from SecurityInfo where employee_id = e.id) InstallmentStartDate,                                
b.branchName,b.id branch_id,  b.branchId, e.empEndType,                            
e.terminDate,                                 
--e.workingStatus,               
case when  empEndType=0 then 'Active'            
 when  empEndType='' then 'Active'          
 when  empEndType is null  then 'Active'                  
  when empEndType=1 THEN 'Resign'                                
 when  empEndType=2 THEN 'Terminated'                                
 when empEndType=3 THEN 'Retired '      
 when empEndType=8 ThEN 'Released'      
 when empEndType=6 ThEN 'Dismissed'       
  when empEndType=11 ThEN 'Death' end workingStatus,                             
null Remarks,                          
case                           
 when a.accounttype=1 THEN 'Cash'                          
 when a.accounttype=2 THEN 'Cheque'                          
 END   paymentInformation ,e.designation_id                                  
                                  
from     EmployeeGenInfo e                              
inner join (select distinct employee_id from SecurityInfo) s on e.id = s.employee_id                                  
inner join SecurityRepaySchedule r on r.employee_id=s.employee_id                                
left join Designation d on d.id = e.designation_id                                 
left join tblSecurityAmtRefund sr on sr.employee_id = s.employee_id                                   
left join tblAccount a on a.id =sr.ledgerCr                                
left join tblBranch b on b.id =e.branch_id                                 
                                   
where  r.PaymentDate <=@periodEndDate                               
                              
)x left join                                   
(                                   
select distinct e.id employee_id, isnull(sum(p.interestAmt),0) as profit --,p.designation_id                                   
from EmployeeGenInfo e                                      
left join tblSecurityFundProfitDisburseAmt p on p.employee_id=e.id                                  
                                 
where p.postingDate <=@periodEndDate                              
group by e.id                                 
                                
                                
)x1 on x1.employee_id=x.employee_id --and x1.designation_id=x.designation_id                                   
                                  
left join                                   
(                                   
select  count(r.PayMonth) noOfinstalment                         
,r.employee_id--,s.designation_id                              
 from SecurityRepaySchedule r                                  
inner join SecurityInfo s on s.id =r.StaffLoan_Id                                   
group by r.employee_id                               
)y on x.employee_id = y.employee_id                                
left join                                   
(                                   
select sum(r.Amount) DepositedAmt,r.employee_id                               
from SecurityRepaySchedule r                                  
inner join SecurityInfo s on s.id =r.StaffLoan_Id                                   
where LOWER(PayStatus)='paid' group by r.employee_id       
) z on z.employee_id = y.employee_id                                    
left join                                   
(                                   
select p.employee_id, max(p.PaymentDate) dateofLastInstallment                                
From SecurityRepaySchedule p                                    
GROUP by p.employee_id                                   
) a on a.employee_id=x.employee_id                                
left join                               
(                              
 select s.employee_id                              
  ,sum(s.securityAmount   )securityAmount                              
 From   SecurityInfo s                                  
 GROUP by s.employee_id                                 
)b on b.employee_id = a.employee_id                              
                                  
) 