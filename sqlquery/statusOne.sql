
GO            
 ALTER procedure [dbo].[proc_GeneratedItemName_Imfage] @BarCodeImgName varchar(200)=null,@item_id uniqueidentifier                  
 AS                  
BEGIN                  
Declare @result varchar(100)                   
         
                 
                      
   --select @result = name +'-'+ (select name from tblItemSize where id=size) from tblitem where id=@item_id        
                
update tblItem set barCodeImgName=@BarCodeImgName , [Status]=1  --, name=@result  
 where id=@item_id        
             
        
        
  select  @BarCodeImgName                          
        
            
 END 

 go


 GO          
 ALTER procedure [dbo].[proc_GeneratedItemName_Imfage] @BarCodeImgName varchar(200)=null,@item_id uniqueidentifier                  
 AS                  
BEGIN                  
Declare @result varchar(100)                   
         
                 
                      
   --select @result = name +'-'+ (select name from tblItemSize where id=size) from tblitem where id=@item_id        
                
update tblItem set barCodeImgName=@BarCodeImgName,[Status]=1 --, name=@result  
 where id=@item_id        
             
        
        
  select  @BarCodeImgName                          
        
            
 END 
 go


 GO
ALTER PROCEDURE [dbo].[proc_GeneratedItemName_Imfage_Size] @BarCodeImgName NVARCHAR(200) = NULL
	,@item_id UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @result NVARCHAR(200)

	SELECT @result = name + '-' + (
			SELECT name
			FROM tblItemSize
			WHERE id = size
			)
	FROM tblitem
	WHERE id = @item_id

	UPDATE tblItem
	SET barCodeImgName = @BarCodeImgName,[Status]=1
		--,name = @result
	WHERE id = @item_id

	SELECT @result
		,@BarCodeImgName
END


go

