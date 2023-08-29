
GO
ALTER PROCEDURE [dbo].[proc_UpdateRelativeInfo]                          
 @EmployeeRelativeInfo_Type AS dbo.EmployeeRelativeInfo_Type READONLY  ,@id uniqueidentifier              
                     
                      
AS                          
BEGIN                          
                           
 SET NOCOUNT ON;                          
   
   
 delete from EmployeeRelativeInfo where EmployeeId=@id;  
  
 INSERT INTO EmployeeRelativeInfo (Id,Ecode,Name,DesignationId,DesignationName,ProgramId,ProgramName,SectorId,    
 SectorName,ProjectId,ProjectName,Relation,EmployeeId)                
 select NEWID(),Ecode,Name,DesignationId,DesignationName,ProgramId,ProgramName,SectorId,    
 SectorName,ProjectId,ProjectName,Relation,EmployeeId from @EmployeeRelativeInfo_Type              
               
                          
END 
