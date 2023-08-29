Alter PROCEDURE proc_GetProgramApprisal 
	@employeeId uniqueidentifier,
	@ApprisalDate datetime,
	@period int
AS
BEGIN
	Declare @isExist int=0
	Select @isExist=COUNT(Id) from tblProgramAppraisal Where ApprisalPeriod=@period AND Employee_Id=@employeeId AND ApprisalDate=@ApprisalDate

	if(@isExist>0)
		begin
			Select Heading,GenInfo,DefineMarks,PreviousMarks, CurrentMarks, TotalMarks from tblProgramAppraisal --Where ApprisalPeriod=@period AND Employee_Id=@employeeId AND ApprisalDate=@ApprisalDate
		end
	else
		begin
			select * from func_GetProgramApprisal(@employeeId,@ApprisalDate,@period)
		end
    
END
GO