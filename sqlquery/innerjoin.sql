--pos
select * from tblGroupItem where group_Id='C6740BB0-4EC0-4A9E-B76C-24BB3B2983F9'
select * from tblItemTransaction where group_Id='C6740BB0-4EC0-4A9E-B76C-24BB3B2983F9'

select * from tblItem 

SELECT  UPC, ti.name itemName, tu.name unitName, tc.categoryName,ts.name subcategoryName
FROM tblGroupItem tg
INNER JOIN tblItemTransaction tt ON tg.group_Id = tt.group_Id
inner join tblItem ti on ti.Id= tt.item_Id
inner join tblItemUnit tu on tu.Id = ti.unit_Id
inner join tblItemCategory tc on tc.Id = ti.category_Id
inner join tblItemSubCategory ts on ts.Id = ti.subCategory_Id


where tg.group_Id='C6740BB0-4EC0-4A9E-B76C-24BB3B2983F9'


select * from tblItem where subCategory_Id='77686CE8-2E55-46AB-9573-434448208715'
select * from tblItemUnit 
select * from tblItemCategory 
select * from tblItemSubCategory where category_Id='F9764C99-D5B4-4828-981C-E8A946029BC4'
select * from tblItemSize
select * from tblItemType 
select * from tblBrand




select * from tblGroupItem
select * from tblPartyTransaction
select * from tblparty

select name,sum(tt.customerPayment) customerpayment
from tblPartyTransaction tt 
inner join tblParty tp on tt.customer = tp.Id
where name like '%a%'
group by name
having sum(tt.customerPayment) > 2000



--setu
Select * from empSalaryItem

select * from paySlipSalaryItem where salaryItem_Id='5DD2A1C3-8368-47AF-B27F-37F6971E1B85'


Select * from PaySlip where id='BF539DA1-F824-4C07-B2AA-8FB95D8E7201'

Select branch_id from EmployeeGenInfo where id='9D865B8A-C254-409B-A737-A624D8A95A05'

select * from tblBranch where id='6780D640-9627-46C4-85DA-827DD98B9F6D'
select * from EmployeeGenInfo

Select * from StaffLoanInfoSelect * from StaffLoanRepayScheduleSelect * from StaffLoanSectorselect * from HrStaffLoanInfoselect hl.*  from HrStaffLoanInfo hlinner join  StaffLoanSector sl on sl.Id=hl.Sector_Idwhere sl.Id='910B84DA-DD09-4121-9024-34C20A12A99D' and employee_id is nullselect EmployeeId from EmployeeGenInfowhere id='EAB420F6-C223-4784-BFED-C41D4A43B2C5'--select * from HrStaffLoanRepaySchedule where StaffLoan_Id='F00E22F7-93FE-44B3-BB07-D2287F5A2675'select * from SubMenu where name='Staff Loan'select * from EmployeeGenInfo where empName='Md. Al- Toufik Hossain'select * from HrStaffLoanInfo


