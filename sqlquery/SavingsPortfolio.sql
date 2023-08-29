go
ALTER FUNCTION func_SavingPortfolioStatement
(	
	@periodStartDate DateTime,  
	@periodEndDate DateTime, 
	@branch_id UniqueIdentifier 
	--@programOrganizer varchar(100),
	--@centerFilter varchar(100), 
	--@programId  varchar(20),  
	--@productFilter varchar(20) , 
	--@sessionId varchar(100)

)
RETURNS @savingPortfolio  TABLE 
(
	
	savingsType varchar(100),
	cMonth numeric(10,2),
	cYear numeric(10,2),
	branch_id UniqueIdentifier,
	VDW numeric(10,2),
	orgName varchar(100),
	orgAddress varchar(100),
	orgBranchCode varchar(100),
	orgBranchName varchar(100),
	orgBranchAddress varchar(100),
	centId int,
	centName varchar(100),
	VDWName varchar(100),
	productCode int,
	ProductName varchar(100),
	FineOpening numeric(10,2),
	InterestOpening numeric(10,2),
	BalanceOpening numeric(10,2),
	InterestCurMonth numeric(10,2),
	FineCurMonth numeric(10,2),
	DepositCurMonth numeric(10,2),
	WithDrawCurMonth numeric(10,2)
	
)
AS
BEGIN
	INSERT INTO @savingPortfolio
	SELECT DISTINCT sc.savingsType,sc.cMonth,sc.cYear, sc.branch_id,sc.VDW, c.orgName,c.orgAddress,c.orgBranchCode, c.orgBranchName,
	c.orgBranchAddress, sc.centId,sc.centName,sc.VDWName,sc.productCode,sc.ProductName,ISNULL(spp.FineOpening,0) AS FineOpening,
	'InterestOpening' = ISNULL(spp.InterestOpening,0), 
	ISNULL(spp.BalanceOpening,0) AS BalanceOpening,
	ISNULL(SUM(ISNULL(sc.InterestCurMonth,0)),0) AS InterestCurMonth,
	ISNULL(SUM(ISNULL(sc.FineCurMonth, 0)),0) AS FineCurMonth,
	ISNULL(SUM(ISNULL(sc.DepColAmountOne,0)+ ISNULL(sc.DepColAmountTwo,0)+ ISNULL(sc.DepColAmountThree,0)+ ISNULL(sc.DepColAmountFour,0)+ ISNULL(sc.DepColAmountFive,0)+ ISNULL(sc.OffAmountOne,0)+ ISNULL(sc.OffAmountTwo,0)+ ISNULL(sc.OffAmountThree,0)+ ISNULL(sc.OffAmountFour,0)+ ISNULL(sc.OffAmountFive,0) ),0) AS DepositCurMonth, 
	ISNULL(SUM(ISNULL(sc.WithDrawAmountOne,0)+ ISNULL(sc.WithDrawAmountTwo,0)+ ISNULL(sc.WithDrawAmountThree,0)+ ISNULL(sc.WithDrawAmountFour,0)+ ISNULL(sc.WithDrawAmountFive,0)+ ISNULL(sc.WithDrawAmountSix,0)+ ISNULL(sc.WithDrawAmountSeven,0)+ ISNULL(sc.WithDrawAmountEight,0)+ ISNULL(sc.WithDrawAmountNine,0)+ ISNULL(sc.WithDrawAmountTen,0)+ ISNULL(sc.WithDrawAmountEleven,0)+ ISNULL(sc.WithDrawAmountTwelve,0)+ ISNULL(sc.WithDrawAmountThirteen,0)+ ISNULL(sc.WithDrawAmountFourteen,0)+ ISNULL(sc.WithDrawAmountFifteen,0)+ ISNULL(sc.WithDrawAmountSixteen,0)+ ISNULL(sc.WithDrawAmountSeventeen,0)+ ISNULL(sc.WithDrawAmountEighteen,0)+ ISNULL(sc.WithDrawAmountNineteen,0)+ ISNULL(sc.WithDrawAmountTwenty,0)),0) AS WithDrawCurMonth
	FROM viwVDWSavingsCollectionReport sc WITH(NOLOCK)  
	INNER JOIN tblConfiguration c WITH(NOLOCK) ON sc.branch_id = c.branch_id
	LEFT OUTER JOIN viwVDWSavingsPortfolioOpeningPre spp WITH (NOLOCK) ON c.branch_id = spp.branch_id 

	GROUP BY sc.savingsType,sc.cMonth,sc.cYear, sc.branch_id,sc.VDW,c.orgName,c.orgAddress,c.orgBranchCode, c.orgBranchName,
	c.orgBranchAddress, sc.centId,sc.centName,sc.VDWName,sc.productCode,sc.ProductName, spp.FineOpening, spp.InterestOpening, spp.BalanceOpening
	RETURN 
END
GO

--select * from viwVDWSavingsCollectionReport


go
ALTER VIEW vw_SavingPortfolioStatement
As
SELECT * from func_SavingPortfolioStatement('6/1/2023 12:00:00 AM','6/30/2023 12:00:00 AM','3a878792-356b-4592-8bf9-260137f9061e')

gO
SELECT * from func_SavingPortfolioStatement('6/1/2023 12:00:00 AM','6/30/2023 12:00:00 AM','3a878792-356b-4592-8bf9-260137f9061e','9','ALL','ALL','0','04a323d8-8845-4521-9084-f80221af40fd')