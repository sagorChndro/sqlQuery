
ALTER procedure [dbo].[proc_itemCategoryWiseStockReport]  
  @branch_Id UNIQUEIDENTIFIER   
 ,@category_id VARCHAR(100) NULL    
 ,@periodStartDate datetime NULL    
 ,@periodEndDate datetime NULL    
as  
begin  
  
SELECT sum(isnull((a.AvailableQnty - ISNULL(b.AvailableQnty, 0)), 0)) AS TotalAvailableQnty  
    ,sum(cast(a.defaultCost AS NUMERIC(22, 2))) TotalunitCost  
    ,sum(isnull((a.AvailableQnty - ISNULL(b.AvailableQnty, 0)), 0) * isnull(a.defaultCost, 0)) TotalCostPrice  
    ,a.category_id  
    ,a.categoryName  
      
   FROM (  
    SELECT ti.Id  
     ,ti.code  
     ,ti.UPC  
     ,isnull(Sum(isnull(tt.quantity, 0)), 0) AvailableQnty  
     ,bip.price defaultCost  
     ,tsp.RegularSaleAmount defaultPrice  
     ,tt.transactionType  
     ,tt.branch_Id  
     ,tic.categoryName categoryName  
     ,tic.Id category_id  
    FROM tblItem ti  
    INNER JOIN tblItemCategory tic ON tic.Id = ti.category_Id  
    INNER JOIN tblItemSubCategory tisc ON tisc.Id = ti.subCategory_Id  
    LEFT JOIN tblItemTransaction tt ON tt.item_Id = ti.Id  
     AND tt.transactionType = 'Add'  
     AND tt.branch_Id = @branch_Id  
     AND tt.transactionDate <= @periodEndDate    
    LEFT JOIN tblItemSellPrice tsp ON tsp.Item_Id = ti.Id  
     AND tsp.branch_id = @branch_Id  
    LEFT JOIN tblBranchItemPrice bip ON bip.item = ti.Id  
     AND bip.branchid = @branch_Id  
    WHERE ti.category_Id = case when @category_id='All' then ti.category_Id when @category_id='' then ti.category_Id else @category_id end  
    GROUP BY ti.Id  
     ,ti.upc  
     ,ti.code  
     ,bip.price  
     ,tsp.RegularSaleAmount  
     ,tt.transactionType  
     ,tt.branch_Id  
     ,tic.categoryName  
     ,tisc.name  
     ,tic.Id  
    ) a  
  
   INNER JOIN (  
    SELECT ti.Id  
     ,ti.code  
     ,ti.UPC  
     ,isnull(Sum(isnull(tt.quantity, 0)), 0) AvailableQnty  
     ,bip.price defaultCost  
     ,tsp.RegularSaleAmount defaultPrice  
     ,tt.transactionType  
     ,tt.branch_Id  
     ,tic.categoryName categoryName  
     ,tic.Id category_id  
  
    FROM tblItem ti  
    INNER JOIN tblItemCategory tic ON tic.Id = ti.category_Id  
    INNER JOIN tblItemSubCategory tisc ON tisc.Id = ti.subCategory_Id  
    LEFT JOIN tblItemTransaction tt ON tt.item_Id = ti.Id  
     AND tt.transactionType = 'Remove'  
     AND tt.branch_Id = @branch_Id  
     AND tt.transactionDate <= @periodEndDate   
    LEFT JOIN tblItemSellPrice tsp ON tsp.Item_Id = ti.Id  
     AND tsp.branch_id = @branch_Id  
    LEFT JOIN tblBranchItemPrice bip ON bip.item = ti.Id  
     AND bip.branchid = @branch_Id  
    WHERE ti.category_Id = case when @category_id='All' then ti.category_Id when @category_id='' then ti.category_Id else @category_id end  
    GROUP BY ti.Id  
     ,ti.upc  
     ,ti.code  
     ,bip.price  
     ,tsp.RegularSaleAmount  
     ,tt.transactionType  
     ,tt.branch_Id  
     ,tic.categoryName  
     ,tisc.name  
     ,tic.Id  
    ) b ON a.Id = b.Id  
  
    group by  
    a.category_id,  
    a.categoryName  
  
  
  
    end  
  
  