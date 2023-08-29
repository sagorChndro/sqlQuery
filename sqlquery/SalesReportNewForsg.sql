USE [pos-sg]
GO
/****** Object:  UserDefinedFunction [dbo].[func_SalesReportNew]    Script Date: 6/22/2023 3:09:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[func_SalesReportNew] (  
 -- Add the parameters for the function here                                      
 @periodStartDate DATETIME  
 ,@periodEndDate DATETIME  
 ,@party_id UNIQUEIDENTIFIER  
 ,@item_id UNIQUEIDENTIFIER  
 ,@branch_id UNIQUEIDENTIFIER  
 )  
RETURNS @SalesReportNew TABLE (  
 -- Add the column definitions for the TABLE variable here                                      
 CustomerName VARCHAR(250)  
 ,mobile VARCHAR(250)  
 ,productCode VARCHAR(50)  
 ,itemName VARCHAR(250)  
 ,quantity NUMERIC(18, 2)  
 ,unitCost NUMERIC(18, 2)  
 ,unitSale NUMERIC(18, 2)  
 ,transactionDate DATETIME  
 ,invoiceid VARCHAR(250)  
 ,DiscountAmount NUMERIC(18, 2)  
 ,vat NUMERIC(18, 2)  
 ,totalSale NUMERIC(18, 2)  
 ,ProfitMargin NUMERIC(18, 2)  
 ,unitName NVARCHAR(100)  
 )  
AS  
BEGIN  
 IF (@party_id = '00000000-0000-0000-0000-000000000000')  
                                               
  INSERT INTO @SalesReportNew  
  SELECT p.[name] CustomerName  
   ,p.mobile  
   ,i.UPC productCode  
   ,i.[name] itemName  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.quantity  
    ELSE t.quantity * - 1  
    END quantity  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitCost  
    ELSE t.unitCost * - 1  
    END unitCost  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitSale  
    ELSE t.unitSale * - 1  
    END unitSale  
   ,t.transactionDate  
   ,g.invoiceId  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.discountAmount*t.quantity  
    ELSE t.discountAmount *t.quantity* - 1  
    END discountAmount  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount)))  
    ELSE ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount))) * - 1  
    END vat  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))  
    ELSE ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))) * - 1  
    END totalSale  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0))  
    WHEN t.reason = 'Sales to Return'  
     THEN - 1 * ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0)))  
    ELSE 0  
    END ProfitMargin  
   ,u.name unitname  
  FROM tblItemTransaction t  
  LEFT JOIN tblGroupItem g ON t.group_Id = g.group_Id  
  LEFT JOIN tblParty p ON g.groupName = p.id  
   AND p.id = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN p.id  
    ELSE @party_id  
    END  
  LEFT JOIN tblItem i ON t.item_Id = i.id  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
  LEFT JOIN tblItemUnit u ON u.Id = i.unit_Id  
  WHERE t.transactionDate BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
   AND t.transactiontype IN ('Remove')  
   AND t.reason IN ('Sales')  
   AND t.branch_Id = @branch_id  
    
  UNION  
    
  SELECT p.[name] CustomerName  
   ,p.mobile  
   ,i.UPC productCode  
   ,i.[name] itemName  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.quantity  
    ELSE t.quantity * - 1  
    END quantity  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitCost  
    ELSE t.unitCost * - 1  
    END unitCost  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitSale  
    ELSE t.unitSale * - 1  
    END unitSale  
   ,t.transactionDate  
   ,g.invoiceId  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.discountAmount*t.quantity  
    ELSE t.discountAmount * - 1*t.quantity  
    END discountAmount  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount)))  
    ELSE ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount))) * - 1  
    END vat  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))  
    ELSE ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))) * - 1  
    END totalSale  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0))  
    WHEN t.reason = 'Sales to Return'  
     THEN - 1 * ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0)))  
    ELSE 0  
    END ProfitMargin  
   ,u.name unitname  
  FROM tblItemTransaction t  
  LEFT JOIN tblGroupItem g ON t.group_Id = g.group_Id  
  LEFT JOIN tblParty p ON g.groupName = p.id  
   AND p.id = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN p.id  
    ELSE @party_id  
    END  
  LEFT JOIN tblItem i ON t.item_Id = i.id  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
  LEFT JOIN tblItemUnit u ON u.Id = i.unit_Id  
  WHERE t.transactionDate BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
   AND t.transactiontype IN ('Add')  
   AND t.reason IN ('Sales to Return')  
   AND t.branch_Id = @branch_id  
 ELSE  
  INSERT INTO @SalesReportNew  
  SELECT p.[name] CustomerName  
   ,p.mobile  
   ,i.UPC productCode  
   ,i.[name] itemName  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.quantity  
    ELSE t.quantity * - 1  
    END quantity  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitCost  
    ELSE t.unitCost * - 1  
    END unitCost  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitSale  
    ELSE t.unitSale * - 1  
    END unitSale  
   ,t.transactionDate  
   ,g.invoiceId  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (t.discountAmount * t.quantity)  
    ELSE t.discountAmount * - 1*t.quantity  
    END discountAmount  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount)))  
    ELSE ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount))) * - 1  
    END vat  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))  
    ELSE ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))) * - 1  
    END totalSale  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0))  
    WHEN t.reason = 'Sales to Return'  
     THEN - 1 * ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0)))  
    ELSE 0  
    END ProfitMargin  
   ,u.name unitname  
  FROM tblItemTransaction t  
  LEFT JOIN tblGroupItem g ON t.group_Id = g.group_Id  
  LEFT JOIN tblParty p ON g.groupName = p.id  
   AND p.id = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN p.id  
    ELSE @party_id  
    END  
  LEFT JOIN tblItem i ON t.item_Id = i.id  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
  LEFT JOIN tblItemUnit u ON u.Id = i.unit_Id  
  WHERE t.transactionDate BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND g.groupName = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN g.groupName  
    ELSE @party_id  
    END  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
   AND t.transactiontype IN ('Remove')  
   AND t.reason IN ('Sales')  
   AND t.branch_Id = @branch_id  
    
  UNION  
    
  SELECT p.[name] CustomerName  
   ,p.mobile  
   ,i.UPC productCode  
   ,i.[name] itemName  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.quantity  
    ELSE t.quantity * - 1  
    END quantity  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitCost  
    ELSE t.unitCost * - 1  
    END unitCost  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN t.unitSale  
    ELSE t.unitSale * - 1  
    END unitSale  
   ,t.transactionDate  
   ,g.invoiceId  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (t.discountAmount * t.quantity)  
    ELSE t.discountAmount * - 1*t.quantity  
    END discountAmount  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount)))  
    ELSE ((isnull(t.vat, 0) / 100) * ((t.quantity * t.unitSale) - (t.discountAmount))) * - 1  
    END vat  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))  
    ELSE ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0) * isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0)))) * - 1  
    END totalSale  
   ,CASE   
    WHEN t.reason = 'Sales'  
     THEN (isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0))  
    WHEN t.reason = 'Sales to Return'  
     THEN - 1 * ((isnull(t.quantity, 0) * isnull(t.unitSale, 0)) - isnull(t.discountAmount, 0)*isnull(t.quantity, 0) + ((isnull(t.vat, 0) / 100) * (isnull(t.quantity, 0) * isnull(t.unitSale, 0))) - (isnull(t.quantity, 0) * isnull(t.unitCost, 0)))  
    ELSE 0  
    END ProfitMargin  
   ,u.name unitname  
  FROM tblItemTransaction t  
  LEFT JOIN tblGroupItem g ON t.group_Id = g.group_Id  
  LEFT JOIN tblParty p ON g.groupName = p.id  
   AND p.id = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN p.id  
    ELSE @party_id  
    END  
  LEFT JOIN tblItem i ON t.item_Id = i.id  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
  LEFT JOIN tblItemUnit u ON u.Id = i.unit_Id  
  WHERE t.transactionDate BETWEEN @periodStartDate  
    AND @periodEndDate  
   AND g.groupName = CASE   
    WHEN @party_id = '00000000-0000-0000-0000-000000000000'  
     THEN g.groupName  
    ELSE @party_id  
    END  
   AND t.item_Id = CASE   
    WHEN @item_id = '00000000-0000-0000-0000-000000000000'  
     THEN t.item_Id  
    ELSE @item_id  
    END  
   AND t.transactiontype IN ('Add')  
   AND t.reason IN ('Sales to Return')  
   AND t.branch_Id = @branch_id  
  
 RETURN  
END