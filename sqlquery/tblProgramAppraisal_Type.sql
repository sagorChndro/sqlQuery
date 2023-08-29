go
Alter PROCEDURE  Proc_tblProgramAppraisalSave

@tblProgramAppraisal_Type tblProgramAppraisal_Type readonly AS
BEGIN
	Declare @AppraisalId uniqueidentifier
	Select TOP(1) @AppraisalId = Appraisal_Id from @tblProgramAppraisal_Type

	Declare @isExist int=0

	Select @isExist=COUNT(Id) from tblProgramAppraisal Where Appraisal_Id=@AppraisalId

	if(@isExist=0)
	begin
		insert into tblProgramAppraisal
		select * from @tblProgramAppraisal_Type
	end	
END
GO


select * from tblProgramAppraisal

select * from tblApprisalSubmission

--delete from tblApprisalSubmission

--select * from tblProgramAppraisal
