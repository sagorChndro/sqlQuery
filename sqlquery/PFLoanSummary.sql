go
Create FUNCTION [dbo].[fn_PFLoanSummaryInfo]    
(     
  @endDate date    
)    
RETURNS TABLE     
AS    
RETURN     
(    
select a.employee_id, a.empName, a.empId, a.EmployeeId, a.LoanId, a.DisburseDate, a.DisburseAmount, a.calServicecharge, 
a.PaidPrincipal, a.PaidServiceCharge,a.DisburseAmount-a.PaidPrincipal duePrincipal, 
a.calServicecharge - a.PaidServiceCharge dueServiceCharge   from 
(    
	select s.employee_id,e.empName, e.emp_manualCode empid, e.EmployeeId,s.LoanId, s.DisburseDate, s.DisburseAmount, s.calServicecharge,    
	sum(isnull(r.Principal,0)) PaidPrincipal, sum(isnull(r.ServiceCharge,0)) PaidServiceCharge, pfr.PFCode  
	 from StaffLoanInfo s with(nolock)    
	 left join StaffLoanRepaySchedule r with(nolock)    
	 on s.id=r.StaffLoan_Id and s.employee_id=r.employee_id    
	 inner join (select employee_id id, max(DisburseDate) disburseDate From StaffLoanInfo with(nolock)     
	 group by employee_id) ld on s.employee_id = ld.id    
	 inner join EmployeeGenInfo e with(nolock) on e.id=s.employee_id  
	 left join tblPFRefund pfr on  pfr.PFCode = e.emp_manualCode  
	 where pfr.PFCode is null --s.employee_id = 'F732DE62-3630-4B59-B881-040F0ABF7952' and    
	  --PayStatus='Paid'     
	group by s.employee_id,e.empName, e.emp_manualCode, e.EmployeeId,s.LoanId, s.DisburseDate, s.DisburseAmount, s.calServicecharge, pfr.PFCode    
)a  
where (a.DisburseDate <= @endDate)   
and ((a.DisburseAmount+a.calServicecharge)-(a.PaidPrincipal+a.PaidServiceCharge))>1    
    
)
go

go
create view [dbo].[View_PFLoanSummary] as  
select a.employee_id, a.empName, a.empId, a.EmployeeId, a.LoanId, a.DisburseDate, a.DisburseAmount, a.calServicecharge, a.PaidPrincipal, a.PaidServiceCharge,a.DisburseAmount-a.PaidPrincipal duePrincipal, a.calServicecharge - a.PaidServiceCharge dueServiceCharge   from (  
select s.employee_id,e.empName, e.empId, e.EmployeeId,s.LoanId, s.DisburseDate, s.DisburseAmount, s.calServicecharge,  
sum(r.Principal) PaidPrincipal, sum(r.ServiceCharge) PaidServiceCharge  
 from StaffLoanInfo s with(nolock)  
 inner join StaffLoanRepaySchedule r with(nolock)  
 on s.id=r.StaffLoan_Id and s.employee_id=r.employee_id  
 inner join (select employee_id id, max(DisburseDate) disburseDate From StaffLoanInfo with(nolock)   
 group by employee_id) ld on s.employee_id = ld.id  
 inner join EmployeeGenInfo e with(nolock) on e.id=s.employee_id  
 where --s.employee_id = 'F732DE62-3630-4B59-B881-040F0ABF7952' and  
  PayStatus='Paid'   
group by s.employee_id,e.empName, e.empId, e.EmployeeId,s.LoanId, s.DisburseDate, s.DisburseAmount, s.calServicecharge  
)a  
GO