
GO
ALTER function [dbo].[func_StatementOfEmpMonthlyContribution](@peiordStartDate datetime,@periodEndDate datetime)  
RETURNS table  
AS  
return(  
  
 select x.employee_id,x.branch_id,x.branchName,x.PFCode,x.empCode,y.LoanId,  
 x.empName,x.EmpContribution,isnull(y.Repayment,0) Repayment, x.orgContribution,  
 isnull(y.interestAmt, 0) interestAmt from   
 (  
  select e.id employee_id,e.branch_id,b.branchName,e.emp_manualCode PFCode,e.EmployeeId empCode,  
  e.empName,sum(p.selfPFamount) EmpContribution, sum(p.orgPFamount) orgContribution  
  from EmployeeGenInfo e   
  inner join tblProvidenFund p on p.employee_id = e.id  
  left join tblBranch b on b.id =e.branch_id  
  where   
  --p.employee_id='B457F80D-5347-4A1E-B3CC-A74C3FAF76D1' and   
  p.postingDate between @peiordStartDate and @periodEndDate  
  group by e.branch_id, e.id ,  
  b.branchName,e.emp_manualCode  ,e.EmployeeId  ,e.empName   
 )x  
   
 left join  
 (  
 select e.id employee_id ,s.LoanId,isnull(sum(r.Principal),0) Repayment,  
 isnull(sum(r.ServiceCharge) ,0) interestAmt  
 from  EmployeeGenInfo e   
 inner join StaffLoanInfo s on s.employee_id=e.id  
 inner join  StaffLoanRepaySchedule r on r.StaffLoan_Id=s.ID  
    
   
 where  
 -- r.employee_id='B457F80D-5347-4A1E-B3CC-A74C3FAF76D1' and   
  r.PaymentDate  between @peiordStartDate and @periodEndDate  
  
 group by  e.id,s.LoanId  
  )  
  
  
  y on x.employee_id = y.employee_id  
  
)

go




go
Create view [dbo].[view_StatementOfEmpMonthlyContribution] 
AS
	select x.employee_id,x.branch_id,x.branchName,x.PFCode,x.empCode,y.LoanId,
	x.empName,x.EmpContribution,isnull(y.Repayment,0) Repayment, x.orgContribution,
	isnull(y.interestAmt, 0) interestAmt from 
	(
		select e.id employee_id,e.branch_id,b.branchName,e.empId PFCode,e.EmployeeId empCode,
		e.empName,sum(p.selfPFamount) EmpContribution, sum(p.orgPFamount) orgContribution
		from EmployeeGenInfo e 
		inner join tblProvidenFund p on p.employee_id = e.id
		left join tblBranch b on b.id =e.branch_id
	 
		group by e.branch_id, e.id ,
		b.branchName,e.empId  ,e.EmployeeId  ,e.empName 
	)x
 
 left join
 (
	select e.id employee_id ,s.LoanId,isnull(sum(r.Principal),0) Repayment,
	isnull(sum(r.ServiceCharge) ,0) interestAmt
	from  EmployeeGenInfo e 
	inner join StaffLoanInfo s on s.employee_id=e.id
	inner join  StaffLoanRepaySchedule r on r.StaffLoan_Id=s.ID 

	group by  e.id,s.LoanId
  )


  y on x.employee_id = y.employee_id

 









 
GO