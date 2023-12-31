
go
ALTER proc [dbo].[proc_ApprisalSubmission]
@empId uniqueidentifier,@apprisalPeriod int ,@isSubmitted nvarchar(20) ,@SubmissionType nvarchar(20), @Branch_id uniqueidentifier,
@tblProgramAppraisal_Type tblProgramAppraisal_Typee readonly, @appraisalDate datetime

as

declare @isAprrised int;
DECLARE @appraisalId uniqueidentifier =newid()
select @isAprrised=count(*) from tblApprisalSubmission where emp_id=@empId and apprisalPeriod=@apprisalPeriod and EntryDate=@appraisalDate
if(@isAprrised=0)

begin
insert into tblApprisalSubmission(id ,emp_id,apprisalPeriod,EntryDate) values( @appraisalId, @empId , @apprisalPeriod,@appraisalDate )
EXEC Proc_tblProgramAppraisalSave @tblProgramAppraisal_Type ,@appraisalId
end

if(@SubmissionType='individual' and @isSubmitted='true')
begin

update tblApprisalSubmission set subIndividual=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod  AND EntryDate= @appraisalDate
end

if(@SubmissionType='supervisor' and @isSubmitted='true')
begin

update tblApprisalSubmission set subSupervisor=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod AND EntryDate= @appraisalDate
end


if(@SubmissionType='evalutor' and @isSubmitted='true')
begin

update tblApprisalSubmission set subEvalutor=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod AND EntryDate= @appraisalDate
end

if(@SubmissionType='RCordinator' and @isSubmitted='true')
begin

update tblApprisalSubmission set subRegional=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod AND EntryDate= @appraisalDate
end

if(@SubmissionType='progHead' and @isSubmitted='true')
begin

update tblApprisalSubmission set subProgramm=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod AND EntryDate= @appraisalDate
end

if(@SubmissionType='HR' and @isSubmitted='true')
begin

update tblApprisalSubmission set subHr=1 where emp_id=@empId and apprisalPeriod=@apprisalPeriod AND EntryDate= @appraisalDate
end
go



go
Alter PROCEDURE  Proc_tblProgramAppraisalSave

@tblProgramAppraisal_Type tblProgramAppraisal_Typee readonly ,
@appraisalId uniqueidentifier
AS
BEGIN
	--UPDATE @tblProgramAppraisal_Type SET Appraisal_Id=@appraisalId
	--Select TOP(1) @AppraisalId = Appraisal_Id from @tblProgramAppraisal_Type

	--Declare @isExist int=0

	--Select @isExist=COUNT(Id) from tblProgramAppraisal Where Appraisal_Id=@AppraisalId

	--if(@isExist=0)
	--begin
		insert into tblProgramAppraisal (Id,Appraisal_Id,Employee_Id,Heading,GenInfo,DefineMarks,PreviousMarks,CurrentMarks,TotalMarks,ApprisalPeriod, ApprisalDate)
		select Id,@appraisalId,Employee_Id,Heading,GenInfo,DefineMarks,PreviousMarks,CurrentMarks,TotalMarks,ApprisalPeriod, ApprisalDate from @tblProgramAppraisal_Type
	--end	
END
GO


go
Alter PROCEDURE proc_GetProgramApprisal 
	@employee uniqueidentifier,
	@ApprisalDate datetime,
	@period int
AS
BEGIN
	Declare @isExist int=0
	Select @isExist=COUNT(Id) from tblProgramAppraisal Where ApprisalPeriod=@period AND Employee_Id=@employee AND ApprisalDate=@ApprisalDate

	if(@isExist>0)
		begin
			Select Heading,GenInfo,DefineMarks,PreviousMarks, CurrentMarks, TotalMarks from tblProgramAppraisal --Where ApprisalPeriod=@period AND Employee_Id=@employeeId AND ApprisalDate=@ApprisalDate
		end
	else
		begin
			select * from func_GetProgramApprisal(@employee,@ApprisalDate,@period)
		end
    
END
GO

--DELETE from tblApprisalSubmission

--select * from tblApprisalSubmission

--delete from tblProgramAppraisal

--select * from tblProgramAppraisal






