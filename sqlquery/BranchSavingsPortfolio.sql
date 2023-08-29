--Exec spSavingsPortfolioReportBranch '2023-08-01', '2023-08-31','1A2E3216-5862-493F-80D6-EA362AB61DB7'
--select * from tblBranch
ALTER PROCEDURE [dbo].[spSavingsPortfolioReportBranch]        
 @startDate DateTime,@endDate DateTime,@branch_id uniqueIdentifier        
 AS        
 BEGIN    
 declare @startDate1 DateTime,@endDate1 DateTime,@branch_id1 uniqueIdentifier 
     set @startDate1=@startDate
	 set @endDate1=@endDate
	 set @branch_id1=@branch_id
  --Declare @Month as int        
  --set @Month=Month(@startDate1)        
  Declare @GS_Loan_DepositOP as numeric(18,0)        
  Declare @GS_Loan_WithdrawalOP as numeric(18,0)        
  Declare @GS_Loan_InterestOP as numeric(18,0)        
  Declare @GS_Loan_FineOP as numeric(18,0)        
  Declare @GS_Loan_BalanceOP as numeric(18,0)        
  Declare @GS_Loan_CustomerOP as numeric(18,0)        
  Declare @CS_Loan_ApprovedInterestOPT as numeric(18,0)        
  Declare @CS_NL_ApprovedInterestOPT as numeric(18,0)        
  Declare @CS_Total_ApprovedInterestOPT as numeric(18,0)        
        
  Declare @GS_NL_DepositOP as numeric(18,0)        
  Declare @GS_NL_WithdrawalOP as numeric(18,0)        
  Declare @GS_NL_InterestOP as numeric(18,0)        
  Declare @GS_NL_FineOP as numeric(18,0)        
  Declare @GS_NL_BalanceOP as numeric(18,0)        
  Declare @GS_NL_CustomerOP as numeric(18,0)        
        
  Declare @GS_Total_DepositOP as numeric(18,0)        
  Declare @GS_Total_WithdrawalOP as numeric(18,0)        
  Declare @GS_Total_InterestOP as numeric(18,0)        
  Declare @GS_Total_FineOP as numeric(18,0)        
  Declare @GS_Total_BalanceOP as numeric(18,0)        
  Declare @GS_Total_CustomerOP as numeric(18,0)
  Declare @GS_Total as numeric(18,0)
  
        
  Declare @RVS_Loan_DepositOP as numeric(18,0)        
  Declare @RVS_Loan_WithdrawalOP as numeric(18,0)        
  Declare @RVS_Loan_InterestOP as numeric(18,0)        
  Declare @RVS_Loan_FineOP as numeric(18,0)        
  Declare @RVS_Loan_BalanceOP as numeric(18,0)        
  Declare @RVS_Loan_CustomerOP as numeric(18,0)        
        
  Declare @RVS_NL_DepositOP as numeric(18,0)        
  Declare @RVS_NL_WithdrawalOP as numeric(18,0)        
  Declare @RVS_NL_InterestOP as numeric(18,0)        
  Declare @RVS_NL_FineOP as numeric(18,0)        
  Declare @RVS_NL_BalanceOP as numeric(18,0)        
  Declare @RVS_NL_CustomerOP as numeric(18,0)        
        
  Declare @RVS_Total_DepositOP as numeric(18,0)        
  Declare @RVS_Total_WithdrawalOP as numeric(18,0)        
  Declare @RVS_Total_InterestOP as numeric(18,0)        
  Declare @RVS_Total_FineOP as numeric(18,0)        
  Declare @RVS_Total_BalanceOP as numeric(18,0)        
  Declare @RVS_Total_CustomerOP as numeric(18,0)
  Declare @RVS_Total as numeric(18,0)
        
  Declare @CS_Loan_DepositOP as numeric(18,0)        
  Declare @CS_Loan_WithdrawalOP as numeric(18,0)        
  Declare @CS_Loan_InterestOP as numeric(18,0)        
        
  Declare @CS_Loan_InterestOP_June as numeric(18,0)        
  Declare @CS_NL_InterestOP_June as numeric(18,0)        
  Declare @CS_Total_InterestOP_June as numeric(18,0)        
        
  Declare @CS_Loan_FineOP as numeric(18,0)        
  Declare @CS_Loan_BalanceOP as numeric(18,0)        
  Declare @CS_Loan_CustomerOP as numeric(18,0)        
        
  Declare @CS_NL_DepositOP as numeric(18,0)        
  Declare @CS_NL_WithdrawalOP as numeric(18,0)        
  Declare @CS_NL_InterestOP as numeric(18,0)        
  Declare @CS_NL_FineOP as numeric(18,0)        
  Declare @CS_NL_BalanceOP as numeric(18,0)        
  Declare @CS_NL_CustomerOP as numeric(18,0)        
        
  Declare @CS_Total_DepositOP as numeric(18,0)        
  Declare @CS_Total_WithdrawalOP as numeric(18,0)        
  Declare @CS_Total_InterestOP as numeric(18,0)        
  Declare @CS_Total_FineOP as numeric(18,0)        
  Declare @CS_Total_BalanceOP as numeric(18,0)        
  Declare @CS_Total_CustomerOP as numeric(18,0)
  Declare @CS_Total as numeric(18,0)
        
  Declare @GT_DepositOP as numeric(18,0)        
  Declare @GT_WithdrawalOP as numeric(18,0)        
  Declare @GT_InterestOP as numeric(18,0)        
  Declare @GT_FineOP as numeric(18,0)        
  Declare @GT_BalanceOP as numeric(18,0)        
  Declare @GT_CustomerOP as numeric(18,0)        
  Declare @Grand_Total as numeric(18,0)  
  ---Transfer Opening--        
  ---------------------------        
  Declare @GS_Loan_DepositOPT as numeric(18,0)        
  Declare @GS_Loan_WithdrawalOPT as numeric(18,0)        
  Declare @GS_Loan_InterestOPT as numeric(18,0)        
  Declare @GS_Loan_FineOPT as numeric(18,0)        
  Declare @GS_Loan_BalanceOPT as numeric(18,0)        
  Declare @GS_Loan_CustomerOPT as numeric(18,0)        
        
  Declare @GS_NL_DepositOPT as numeric(18,0)        
  Declare @GS_NL_WithdrawalOPT as numeric(18,0)       
  Declare @GS_NL_InterestOPT as numeric(18,0)        
  Declare @GS_NL_FineOPT as numeric(18,0)        
  Declare @GS_NL_BalanceOPT as numeric(18,0)        
  Declare @GS_NL_CustomerOPT as numeric(18,0)        
        
  Declare @GS_Total_DepositOPT as numeric(18,0)        
  Declare @GS_Total_WithdrawalOPT as numeric(18,0)        
  Declare @GS_Total_InterestOPT as numeric(18,0)        
  Declare @GS_Total_FineOPT as numeric(18,0)        
  Declare @GS_Total_BalanceOPT as numeric(18,0)        
  Declare @GS_Total_CustomerOPT as numeric(18,0)        
        
  Declare @RVS_Loan_DepositOPT as numeric(18,0)        
  Declare @RVS_Loan_WithdrawalOPT as numeric(18,0)        
  Declare @RVS_Loan_InterestOPT as numeric(18,0)        
  Declare @RVS_Loan_FineOPT as numeric(18,0)        
  Declare @RVS_Loan_BalanceOPT as numeric(18,0)        
  Declare @RVS_Loan_CustomerOPT as numeric(18,0)        
        
  Declare @RVS_NL_DepositOPT as numeric(18,0)        
  Declare @RVS_NL_WithdrawalOPT as numeric(18,0)        
  Declare @RVS_NL_InterestOPT as numeric(18,0)        
  Declare @RVS_NL_FineOPT as numeric(18,0)        
  Declare @RVS_NL_BalanceOPT as numeric(18,0)        
  Declare @RVS_NL_CustomerOPT as numeric(18,0)        
        
  Declare @RVS_Total_DepositOPT as numeric(18,0)        
  Declare @RVS_Total_WithdrawalOPT as numeric(18,0)        
  Declare @RVS_Total_InterestOPT as numeric(18,0)        
  Declare @RVS_Total_FineOPT as numeric(18,0)        
  Declare @RVS_Total_BalanceOPT as numeric(18,0)        
  Declare @RVS_Total_CustomerOPT as numeric(18,0)        
        
  Declare @CS_Loan_DepositOPT as numeric(18,0)        
  Declare @CS_Loan_WithdrawalOPT as numeric(18,0)        
  Declare @CS_Loan_InterestOPT as numeric(18,0)        
  Declare @CS_Loan_FineOPT as numeric(18,0)        
  Declare @CS_Loan_BalanceOPT as numeric(18,0)        
  Declare @CS_Loan_CustomerOPT as numeric(18,0)        
        
  Declare @CS_NL_DepositOPT as numeric(18,0)        
  Declare @CS_NL_WithdrawalOPT as numeric(18,0)        
  Declare @CS_NL_InterestOPT as numeric(18,0)        
  Declare @CS_NL_FineOPT as numeric(18,0)        
  Declare @CS_NL_BalanceOPT as numeric(18,0)        
  Declare @CS_NL_CustomerOPT as numeric(18,0)        
        
  Declare @CS_Total_DepositOPT as numeric(18,0)        
  Declare @CS_Total_WithdrawalOPT as numeric(18,0)        
  Declare @CS_Total_InterestOPT as numeric(18,0)        
  Declare @CS_Total_FineOPT as numeric(18,0)        
  Declare @CS_Total_BalanceOPT as numeric(18,0)        
  Declare @CS_Total_CustomerOPT as numeric(18,0)        
        
  Declare @GT_DepositOPT as numeric(18,0)        
  Declare @GT_WithdrawalOPT as numeric(18,0)        
  Declare @GT_InterestOPT as numeric(18,0)        
  Declare @GT_FineOPT as numeric(18,0)        
  Declare @GT_BalanceOPT as numeric(18,0)        
  Declare @GT_CustomerOPT as numeric(18,0)        
  -------------------------------------------------        
  --Current Month        
  Declare @GS_Loan_DepositCM as numeric(18,0)        
  Declare @GS_Loan_WithdrawalCM as numeric(18,0)        
  Declare @GS_Loan_InterestCM as numeric(18,0)        
  Declare @GS_Loan_FineCM as numeric(18,0)        
  Declare @GS_Loan_BalanceCM as numeric(18,0)        
  Declare @GS_Loan_CustomerCM as numeric(18,0)        
        
  Declare @GS_NL_DepositCM as numeric(18,0)        
  Declare @GS_NL_WithdrawalCM as numeric(18,0)        
  Declare @GS_NL_InterestCM as numeric(18,0)        
  Declare @GS_NL_FineCM as numeric(18,0)        
  Declare @GS_NL_BalanceCM as numeric(18,0)        
  Declare @GS_NL_CustomerCM as numeric(18,0)        
        
  Declare @GS_Total_DepositCM as numeric(18,0)        
  Declare @GS_Total_WithdrawalCM as numeric(18,0)        
  Declare @GS_Total_InterestCM as numeric(18,0)        
  Declare @GS_Total_FineCM as numeric(18,0)        
  Declare @GS_Total_BalanceCM as numeric(18,0)        
  Declare @GS_Total_CustomerCM as numeric(18,0)        
        
  Declare @RVS_Loan_DepositCM as numeric(18,0)     
  Declare @RVS_Loan_WithdrawalCM as numeric(18,0)        
  Declare @RVS_Loan_InterestCM as numeric(18,0)        
  Declare @RVS_Loan_FineCM as numeric(18,0)        
  Declare @RVS_Loan_BalanceCM as numeric(18,0)        
  Declare @RVS_Loan_CustomerCM as numeric(18,0)        
        
  Declare @RVS_NL_DepositCM as numeric(18,0)        
  Declare @RVS_NL_WithdrawalCM as numeric(18,0)        
  Declare @RVS_NL_InterestCM as numeric(18,0)        
  Declare @RVS_NL_FineCM as numeric(18,0)        
  Declare @RVS_NL_BalanceCM as numeric(18,0)        
  Declare @RVS_NL_CustomerCM as numeric(18,0)        
        
  Declare @RVS_Total_DepositCM as numeric(18,0)        
  Declare @RVS_Total_WithdrawalCM as numeric(18,0)        
  Declare @RVS_Total_InterestCM as numeric(18,0)        
  Declare @RVS_Total_FineCM as numeric(18,0)        
  Declare @RVS_Total_BalanceCM as numeric(18,0)        
  Declare @RVS_Total_CustomerCM as numeric(18,0)        
        
  Declare @CS_Loan_DepositCM as numeric(18,0)        
  Declare @CS_Loan_WithdrawalCM as numeric(18,0)        
  Declare @CS_Loan_InterestCM as numeric(18,0)        
  Declare @CS_Loan_FineCM as numeric(18,0)        
  Declare @CS_Loan_BalanceCM as numeric(18,0)        
  Declare @CS_Loan_CustomerCM as numeric(18,0)        
        
  Declare @CS_NL_DepositCM as numeric(18,0)        
  Declare @CS_NL_WithdrawalCM as numeric(18,0)        
  Declare @CS_NL_InterestCM as numeric(18,0)        
  Declare @CS_NL_FineCM as numeric(18,0)        
  Declare @CS_NL_BalanceCM as numeric(18,0)        
  Declare @CS_NL_CustomerCM as numeric(18,0)        
        
  Declare @CS_Total_DepositCM as numeric(18,0)        
  Declare @CS_Total_WithdrawalCM as numeric(18,0)        
  Declare @CS_Total_InterestCM as numeric(18,0)        
  Declare @CS_Total_FineCM as numeric(18,0)        
  Declare @CS_Total_BalanceCM as numeric(18,0)        
  Declare @CS_Total_CustomerCM as numeric(18,0)        
        
  Declare @GT_DepositCM as numeric(18,0)        
  Declare @GT_WithdrawalCM as numeric(18,0)        
  Declare @GT_InterestCM as numeric(18,0)        
  Declare @GT_FineCM as numeric(18,0)        
  Declare @GT_BalanceCM as numeric(18,0)        
  Declare @GT_CustomerCM as numeric(18,0)        
         
  --Closing        
  Declare @GS_Loan_DepositCL as numeric(18,0)        
  Declare @GS_Loan_WithdrawalCL as numeric(18,0)        
  Declare @GS_Loan_InterestCL as numeric(18,0)        
  Declare @GS_Loan_FineCL as numeric(18,0)        
  Declare @GS_Loan_BalanceCL as numeric(18,0)        
  Declare @GS_Loan_CustomerCL as numeric(18,0)        
        
  Declare @GS_NL_DepositCL as numeric(18,0)        
  Declare @GS_NL_WithdrawalCL as numeric(18,0)        
  Declare @GS_NL_InterestCL as numeric(18,0)        
  Declare @GS_NL_FineCL as numeric(18,0)        
  Declare @GS_NL_BalanceCL as numeric(18,0)        
  Declare @GS_NL_CustomerCL as numeric(18,0)        
        
  Declare @GS_Total_DepositCL as numeric(18,0)        
  Declare @GS_Total_WithdrawalCL as numeric(18,0)        
  Declare @GS_Total_InterestCL as numeric(18,0)        
  Declare @GS_Total_FineCL as numeric(18,0)        
  Declare @GS_Total_BalanceCL as numeric(18,0)        
  Declare @GS_Total_CustomerCL as numeric(18,0)        
        
  Declare @RVS_Loan_DepositCL as numeric(18,0)        
  Declare @RVS_Loan_WithdrawalCL as numeric(18,0)        
  Declare @RVS_Loan_InterestCL as numeric(18,0)        
  Declare @RVS_Loan_FineCL as numeric(18,0)        
  Declare @RVS_Loan_BalanceCL as numeric(18,0)        
  Declare @RVS_Loan_CustomerCL as numeric(18,0)        
        
  Declare @RVS_NL_DepositCL as numeric(18,0)        
  Declare @RVS_NL_WithdrawalCL as numeric(18,0)        
  Declare @RVS_NL_InterestCL as numeric(18,0)        
  Declare @RVS_NL_FineCL as numeric(18,0)        
  Declare @RVS_NL_BalanceCL as numeric(18,0)        
  Declare @RVS_NL_CustomerCL as numeric(18,0)        
        
  Declare @RVS_Total_DepositCL as numeric(18,0)        
  Declare @RVS_Total_WithdrawalCL as numeric(18,0)        
  Declare @RVS_Total_InterestCL as numeric(18,0)        
  Declare @RVS_Total_FineCL as numeric(18,0)        
  Declare @RVS_Total_BalanceCL as numeric(18,0)        
  Declare @RVS_Total_CustomerCL as numeric(18,0)        
        
  Declare @CS_Loan_DepositCL as numeric(18,0)        
  Declare @CS_Loan_WithdrawalCL as numeric(18,0)        
  Declare @CS_Loan_InterestCL as numeric(18,0)        
  Declare @CS_Loan_FineCL as numeric(18,0)        
  Declare @CS_Loan_BalanceCL as numeric(18,0)        
  Declare @CS_Loan_CustomerCL as numeric(18,0)        
        
  Declare @CS_NL_DepositCL as numeric(18,0)        
  Declare @CS_NL_WithdrawalCL as numeric(18,0)        
  Declare @CS_NL_InterestCL as numeric(18,0)        
  Declare @CS_NL_FineCL as numeric(18,0)        
  Declare @CS_NL_BalanceCL as numeric(18,0)        
  Declare @CS_NL_CustomerCL as numeric(18,0)        
        
  Declare @CS_Total_DepositCL as numeric(18,0)        
  Declare @CS_Total_WithdrawalCL as numeric(18,0)        
  Declare @CS_Total_InterestCL as numeric(18,0)        
  Declare @CS_Total_FineCL as numeric(18,0)        
  Declare @CS_Total_BalanceCL as numeric(18,0)        
  Declare @CS_Total_CustomerCL as numeric(18,0)        
        
  Declare @GT_DepositCL as numeric(18,0)        
  Declare @GT_WithdrawalCL as numeric(18,0)        
  Declare @GT_InterestCL as numeric(18,0)        
  Declare @GT_FineCL as numeric(18,0)        
  Declare @GT_BalanceCL as numeric(18,0)        
  Declare @GT_CustomerCL as numeric(18,0)        
          
        
  Declare @GS_NLRM_DropOut as numeric(18,0)        
  Declare @GS_NLRM_DropOut_Total as numeric(18,0)        
  Declare @CS_NLRM_DropOut as numeric(18,0)        
  Declare @CS_NLRM_DropOut_Total as numeric(18,0)        
  Declare @GT_DropOut_Customer as numeric(18,0)        
  Declare @SS_Upto_2000_Customer as numeric(18,0)        
  Declare @SS_Upto_2000_Balance as numeric(18,0)        
  Declare @SS_2001_5000_Customer as numeric(18,0)        
  Declare @SS_2001_5000_Balance as numeric(18,0)        
  Declare @SS_5001_10000_Customer as numeric(18,0)        
  Declare @SS_5001_10000_Balance as numeric(18,0)        
  Declare @SS_10001_20000_Customer as numeric(18,0)        
  Declare @SS_10001_20000_Balance as numeric(18,0)        
  Declare @SS_20001Above_Customer as numeric(18,0)        
  Declare @SS_20001Above_Balance as numeric(18,0)        
  Declare @SS_Total_Customer as numeric(18,0)        
  Declare @SS_Total_Balance as numeric(18,0)        
  Declare @ss_opening_Balance as numeric(18,0)        
  Declare @ssrealcustomerno as numeric(18,0)        
  Declare @showcustomerno as numeric(18,0)        
        
          
  DECLARE  @AccountTransaction TABLE        
  (        
   [id] [uniqueidentifier] NOT NULL,
	[WorkingType] [varchar](15) NULL,
	[workingId] [numeric](10, 0) NULL,
	[productCode] [numeric](2, 0) NULL,
	[AccountNo] [numeric](20, 0) NULL,
	[TransNo] [varchar](32) NULL,
	[TransType] [numeric](1, 0) NULL,
	[SingleOrCollection] [numeric](1, 0) NULL,
	[TransDate] [datetime] NULL,
	[TransAmount] [numeric](10, 0) NULL,
	[InstallmentNum] [numeric](3, 0) NULL,
	[AdvanceInstNum] [numeric](3, 0) NULL,
	[Fine] [numeric](5, 0) NULL,
	[FineExempted] [numeric](5, 0) NULL,
	[ApprovalStatus] [numeric](1, 0) NULL,
	[PostingStatus] [numeric](1, 0) NULL,
	[preparedBy] [numeric](10, 0) NULL,
	[checkedBy] [numeric](10, 0) NULL,
	[approvedBy] [numeric](10, 0) NULL,
	[adjustAmount] [numeric](18, 0) NULL,
	[interest] [numeric](10, 0) NULL,
	[ServiceChargExempted] [numeric](1, 0) NULL,
	[AccountTransfered] [numeric](1, 0) NULL,
	[customerId] [numeric](15, 0) NULL,
	[principalamount] [numeric](12, 2) NULL,
	[servicecharge] [numeric](12, 2) NULL,
	[rebate_flag] [int] NOT NULL,
	[branch_id] [uniqueidentifier] NULL,
	[working_id] [uniqueidentifier] NULL,
	[product_type] [int] NULL,
	[product_id] [uniqueidentifier] NULL,
	[customer_id] [uniqueidentifier] NULL,
	[prepared_by_id] [uniqueidentifier] NULL,
	[checked_by_id] [uniqueidentifier] NULL,
	[approved_by_id] [uniqueidentifier] NULL,
	[collection_sheet_id] [uniqueidentifier] NULL,
	[account_id] [uniqueidentifier] NULL,
	[transMode] [numeric](1, 0) NULL,
	[bankName] [varchar](256) NULL,
	[checkNo] [varchar](100) NULL,
	[checkDate] [datetime] NULL,
	[bankAccountNo] [varchar](50) NULL,
	[refund_amount] [numeric](10, 2) NULL,
	[TransCatType] [varchar](5) NULL,
	[DueAmount] [numeric](10, 2) NULL,
	[DueRecovery] [numeric](10, 2) NULL,
	[AdvanceRecovery] [numeric](10, 2) NULL,
	[Payable_Amount] [numeric](10, 2) NULL,
	[DueDays] [numeric](4, 0) NULL,
	[DueAmount_Principal] [numeric](10, 2) NULL,
	[DueRecovery_Principal] [numeric](10, 2) NULL,
	[AdvanceRecovery_Principal] [numeric](10, 2) NULL,
	[PayableAmount_Principal] [numeric](10, 2) NULL,
	[CumulativePayableAmount] [numeric](15, 2) NULL,
	[CumulativePayableAmount_Principal] [numeric](15, 2) NULL,
	[advanceRemaining] [numeric](15, 2) NULL,
	[advanceRemaining_Principal] [numeric](15, 2) NULL,
	[isClosingTransaction] [bit] NOT NULL,
	[entryTime] [datetime] NULL,
	[lastModifiedTime] [datetime] NULL
  )        
        
        
  INSERT INTO @AccountTransaction        
  SELECT * FROM AccountTransaction With (nolock) Where branch_id = @branch_id1 and Transdate 
  between @startDate1 and @endDate1        
  UNION ALL        
  SELECT * FROM AccountTransaction_prev With (nolock) Where branch_id = @branch_id1 and Transdate 
  between @startDate1 and @endDate1        
  
        
  DECLARE @FYStartDate DATETIME        
        
  SELECT @FYStartDate = dbo.FirstDayOfFY(@endDate1)        
        
        
  SET @GS_Loan_DepositOP = 0;        
  SET @GS_Loan_WithdrawalOP = 0;        
  SET @GS_Loan_InterestOP = 0;        
  SET @GS_Loan_FineOP = 0;        
  SET @GS_Loan_BalanceOP = 0;        
  SET @GS_Loan_CustomerOP = 0;        
  SET @CS_Loan_ApprovedInterestOPT = 0;        
  SET @CS_Total_ApprovedInterestOPT = 0;        
  SET @CS_NL_ApprovedInterestOPT = 0;        
        
  SET @GS_NL_DepositOP = 0;        
  SET @GS_NL_WithdrawalOP = 0;        
  SET @GS_NL_InterestOP = 0;        
  SET @GS_NL_FineOP = 0;        
  SET @GS_NL_BalanceOP = 0;        
  SET @GS_NL_CustomerOP = 0;        
        
  SET @GS_Total_DepositOP = 0;        
  SET @GS_Total_WithdrawalOP = 0;        
  SET @GS_Total_InterestOP = 0;        
  SET @GS_Total_FineOP = 0;        
  SET @GS_Total_BalanceOP = 0;        
  SET @GS_Total_CustomerOP = 0;        
        
  SET @RVS_Loan_DepositOP = 0;        
  SET @RVS_Loan_WithdrawalOP = 0;        
  SET @RVS_Loan_InterestOP = 0;        
  SET @RVS_Loan_FineOP = 0;        
  SET @RVS_Loan_BalanceOP = 0;        
  SET @RVS_Loan_CustomerOP = 0;        
        
  SET @RVS_NL_DepositOP = 0;        
  SET @RVS_NL_WithdrawalOP = 0;        
  SET @RVS_NL_InterestOP = 0;        
  SET @RVS_NL_FineOP = 0;        
  SET @RVS_NL_BalanceOP = 0;        
  SET @RVS_NL_CustomerOP = 0;        
        
  SET @RVS_Total_DepositOP = 0;        
  SET @RVS_Total_WithdrawalOP = 0;        
  SET @RVS_Total_InterestOP = 0;        
  SET @RVS_Total_FineOP = 0;        
  SET @RVS_Total_BalanceOP = 0;        
  SET @RVS_Total_CustomerOP = 0;        
        
  SET @CS_Loan_DepositOP = 0;        
  SET @CS_Loan_WithdrawalOP = 0;        
  SET @CS_Loan_InterestOP = 0;        
        
  SET @CS_Loan_InterestOP_June = 0;        
  SET @CS_NL_InterestOP_June = 0;        
  SET @CS_Total_InterestOP_June = 0;        
        
  SET @CS_Loan_FineOP = 0;        
  SET @CS_Loan_BalanceOP = 0;        
  SET @CS_Loan_CustomerOP = 0;        
        
  SET @CS_NL_DepositOP = 0;        
  SET @CS_NL_WithdrawalOP = 0;        
  SET @CS_NL_InterestOP = 0;        
  SET @CS_NL_FineOP = 0;        
  SET @CS_NL_BalanceOP = 0;        
  SET @CS_NL_CustomerOP = 0;        
        
  SET @CS_Total_DepositOP = 0;        
  SET @CS_Total_WithdrawalOP = 0;        
  SET @CS_Total_InterestOP = 0;        
  SET @CS_Total_FineOP = 0;        
  SET @CS_Total_BalanceOP = 0;        
  SET @CS_Total_CustomerOP = 0;        
        
  SET @GT_DepositOP = 0;        
  SET @GT_WithdrawalOP = 0;        
  SET @GT_InterestOP = 0;        
  SET @GT_FineOP = 0;        
  SET @GT_BalanceOP = 0;        
  SET @GT_CustomerOP = 0;        
  --Transfer         
  -------------------        
  SET @GS_Loan_DepositOPT = 0;        
  SET @GS_Loan_WithdrawalOPT = 0;        
  SET @GS_Loan_InterestOPT = 0;        
  SET @GS_Loan_FineOPT = 0;        
  SET @GS_Loan_BalanceOPT = 0;        
  SET @GS_Loan_CustomerOPT = 0;        
        
  SET @GS_NL_DepositOPT = 0;        
  SET @GS_NL_WithdrawalOPT = 0;        
  SET @GS_NL_InterestOPT = 0;        
  SET @GS_NL_FineOPT = 0;        
  SET @GS_NL_BalanceOPT = 0;        
  SET @GS_NL_CustomerOPT = 0;        
        
  SET @GS_Total_DepositOPT = 0;        
  SET @GS_Total_WithdrawalOPT = 0;        
  SET @GS_Total_InterestOPT = 0;        
  SET @GS_Total_FineOPT = 0;        
  SET @GS_Total_BalanceOPT = 0;        
  SET @GS_Total_CustomerOPT = 0;        
        
  SET @RVS_Loan_DepositOPT = 0;        
  SET @RVS_Loan_WithdrawalOPT = 0;        
  SET @RVS_Loan_InterestOPT = 0;        
  SET @RVS_Loan_FineOPT = 0;        
  SET @RVS_Loan_BalanceOPT = 0;        
  SET @RVS_Loan_CustomerOPT = 0;        
        
  SET @RVS_NL_DepositOPT = 0;        
  SET @RVS_NL_WithdrawalOPT = 0;        
  SET @RVS_NL_InterestOPT = 0;        
  SET @RVS_NL_FineOPT = 0;        
  SET @RVS_NL_BalanceOPT = 0;        
  SET @RVS_NL_CustomerOPT = 0;        
        
  SET @RVS_Total_DepositOPT = 0;        
  SET @RVS_Total_WithdrawalOPT = 0;        
  SET @RVS_Total_InterestOPT = 0;        
  SET @RVS_Total_FineOPT = 0;        
  SET @RVS_Total_BalanceOPT = 0;        
  SET @RVS_Total_CustomerOPT = 0;        
        
  SET @CS_Loan_DepositOPT = 0;        
  SET @CS_Loan_WithdrawalOPT = 0;        
  SET @CS_Loan_InterestOPT = 0;        
  SET @CS_Loan_FineOPT = 0;        
  SET @CS_Loan_BalanceOPT = 0;        
  SET @CS_Loan_CustomerOPT = 0;        
        
  SET @CS_NL_DepositOPT = 0;        
  SET @CS_NL_WithdrawalOPT = 0;        
  SET @CS_NL_InterestOPT = 0;        
  SET @CS_NL_FineOPT = 0;        
  SET @CS_NL_BalanceOPT = 0;        
  SET @CS_NL_CustomerOPT = 0;        
        
  SET @CS_Total_DepositOPT = 0;        
  SET @CS_Total_WithdrawalOPT = 0;        
  SET @CS_Total_InterestOPT = 0;        
  SET @CS_Total_FineOPT = 0;        
  SET @CS_Total_BalanceOPT = 0;        
  SET @CS_Total_CustomerOPT = 0;        
        
  SET @GT_DepositOPT = 0;        
  SET @GT_WithdrawalOPT = 0;        
  SET @GT_InterestOPT = 0;        
  SET @GT_FineOPT = 0;        
  SET @GT_BalanceOPT = 0;        
  SET @GT_CustomerOPT = 0;        
  --------------------------------        
        
        
  SET @GS_Loan_DepositCM = 0;        
  SET @GS_Loan_WithdrawalCM = 0;        
  SET @GS_Loan_InterestCM = 0;        
  SET @GS_Loan_FineCM = 0;        
  SET @GS_Loan_BalanceCM = 0;        
  SET @GS_Loan_CustomerCM = 0;        
        
  SET @GS_NL_DepositCM = 0;        
  SET @GS_NL_WithdrawalCM = 0;        
  SET @GS_NL_InterestCM = 0;        
  SET @GS_NL_FineCM = 0;        
  SET @GS_NL_BalanceCM = 0;        
  SET @GS_NL_CustomerCM = 0;        
        
  SET @GS_Total_DepositCM = 0;        
  SET @GS_Total_WithdrawalCM = 0;        
  SET @GS_Total_InterestCM = 0;        
  SET @GS_Total_FineCM = 0;        
  SET @GS_Total_BalanceCM = 0;        
  SET @GS_Total_CustomerCM = 0;        
        
  SET @RVS_Loan_DepositCM = 0;        
  SET @RVS_Loan_WithdrawalCM = 0;        
  SET @RVS_Loan_InterestCM = 0;        
  SET @RVS_Loan_FineCM = 0;        
  SET @RVS_Loan_BalanceCM = 0;        
  SET @RVS_Loan_CustomerCM = 0;        
        
  SET @RVS_NL_DepositCM = 0;        
  SET @RVS_NL_WithdrawalCM = 0;        
  SET @RVS_NL_InterestCM = 0;        
  SET @RVS_NL_FineCM = 0;        
  SET @RVS_NL_BalanceCM = 0;        
  SET @RVS_NL_CustomerCM = 0;        
        
  SET @RVS_Total_DepositCM = 0;        
  SET @RVS_Total_WithdrawalCM = 0;        
  SET @RVS_Total_InterestCM = 0;        
  SET @RVS_Total_FineCM = 0;        
  SET @RVS_Total_BalanceCM = 0;        
  SET @RVS_Total_CustomerCM = 0;        
        
  SET @CS_Loan_DepositCM = 0;        
  SET @CS_Loan_WithdrawalCM = 0;        
  SET @CS_Loan_InterestCM = 0;        
  SET @CS_Loan_FineCM = 0;        
  SET @CS_Loan_BalanceCM = 0;        
  SET @CS_Loan_CustomerCM = 0;        
        
  SET @CS_NL_DepositCM = 0;        
  SET @CS_NL_WithdrawalCM = 0;        
  SET @CS_NL_InterestCM = 0;        
  SET @CS_NL_FineCM = 0;        
  SET @CS_NL_BalanceCM = 0;        
  SET @CS_NL_CustomerCM = 0;        
        
  SET @CS_Total_DepositCM = 0;        
  SET @CS_Total_WithdrawalCM = 0;        
  SET @CS_Total_InterestCM = 0;        
  SET @CS_Total_FineCM = 0;        
  SET @CS_Total_BalanceCM = 0;        
  SET @CS_Total_CustomerCM = 0;        
        
  SET @GT_DepositCM = 0;        
  SET @GT_WithdrawalCM = 0;        
  SET @GT_InterestCM = 0;        
  SET @GT_FineCM = 0;        
  SET @GT_BalanceCM = 0;        
  SET @GT_CustomerCM = 0;        
        
  SET @GS_Loan_DepositCL = 0;        
  SET @GS_Loan_WithdrawalCL = 0;        
  SET @GS_Loan_InterestCL = 0;        
  SET @GS_Loan_FineCL = 0;        
  SET @GS_Loan_BalanceCL = 0;        
  SET @GS_Loan_CustomerCL = 0;        
        
  SET @GS_NL_DepositCL = 0;        
  SET @GS_NL_WithdrawalCL = 0;        
  SET @GS_NL_InterestCL = 0;        
  SET @GS_NL_FineCL = 0;        
  SET @GS_NL_BalanceCL = 0;        
  SET @GS_NL_CustomerCL = 0;        
        
  SET @GS_Total_DepositCL = 0;        
  SET @GS_Total_WithdrawalCL = 0;        
  SET @GS_Total_InterestCL = 0;        
  SET @GS_Total_FineCL = 0;        
  SET @GS_Total_BalanceCL = 0;        
  SET @GS_Total_CustomerCL = 0;        
        
  SET @RVS_Loan_DepositCL = 0;        
  SET @RVS_Loan_WithdrawalCL = 0;        
  SET @RVS_Loan_InterestCL = 0;        
  SET @RVS_Loan_FineCL = 0;        
  SET @RVS_Loan_BalanceCL = 0;        
  SET @RVS_Loan_CustomerCL = 0;        
        
  SET @RVS_NL_DepositCL = 0;        
  SET @RVS_NL_WithdrawalCL = 0;        
  SET @RVS_NL_InterestCL = 0;        
  SET @RVS_NL_FineCL = 0;        
  SET @RVS_NL_BalanceCL = 0;        
  SET @RVS_NL_CustomerCL = 0;        
        
  SET @RVS_Total_DepositCL = 0;        
  SET @RVS_Total_WithdrawalCL = 0;        
  SET @RVS_Total_InterestCL = 0;        
  SET @RVS_Total_FineCL = 0;        
  SET @RVS_Total_BalanceCL = 0;        
  SET @RVS_Total_CustomerCL = 0;        
        
  SET @CS_Loan_DepositCL = 0;        
  SET @CS_Loan_WithdrawalCL = 0;        
  SET @CS_Loan_InterestCL = 0;        
  SET @CS_Loan_FineCL = 0;        
  SET @CS_Loan_BalanceCL = 0;        
  SET @CS_Loan_CustomerCL = 0;        
        
  SET @CS_NL_DepositCL = 0;        
  SET @CS_NL_WithdrawalCL = 0;        
  SET @CS_NL_InterestCL = 0;        
  SET @CS_NL_FineCL = 0;        
  SET @CS_NL_BalanceCL = 0;        
  SET @CS_NL_CustomerCL = 0;        
        
  SET @CS_Total_DepositCL = 0;        
  SET @CS_Total_WithdrawalCL = 0;        
  SET @CS_Total_InterestCL = 0;        
  SET @CS_Total_FineCL = 0;        
  SET @CS_Total_BalanceCL = 0;        
  SET @CS_Total_CustomerCL = 0;        
        
  SET @GT_DepositCL = 0;        
  SET @GT_WithdrawalCL = 0;        
  SET @GT_InterestCL = 0;        
  SET @GT_FineCL = 0;        
  SET @GT_BalanceCL = 0;        
  SET @GT_CustomerCL = 0;        
    
        
  SET @GS_NLRM_DropOut = 0;        
  SET @GS_NLRM_DropOut_Total = 0;        
  SET @CS_NLRM_DropOut = 0;        
  SET @CS_NLRM_DropOut_Total = 0;        
  SET @GT_DropOut_Customer = 0;        
  SET @SS_Upto_2000_Customer = 0;        
  SET @SS_Upto_2000_Balance = 0;        
  SET @SS_2001_5000_Customer = 0;        
  SET @SS_2001_5000_Balance = 0;        
  SET @SS_5001_10000_Customer = 0;        
  SET @SS_5001_10000_Balance = 0;        
  SET @SS_10001_20000_Customer = 0;        
  SET @SS_10001_20000_Balance = 0;        
  SET @SS_20001Above_Customer = 0;        
  SET @SS_20001Above_Balance = 0;        
  SET @SS_Total_Customer = 0;        
  SET @SS_Total_Balance = 0;        
  SET @ss_opening_Balance = 0;        
  SET @ssrealcustomerno = 0;        
  SET @showcustomerno = 0;        
          
  declare @BranchCode nvarchar(30)        
  declare @BranchName nvarchar(100)        
  declare @BranchAddress nvarchar(200)        
        
  DECLARE @tempTrnsLoanCustomers Table        
  (id uniqueidentifier NOT NULL, customerId numeric(15) NULL, branch_id uniqueidentifier)        
  Insert into @tempTrnsLoanCustomers         
  SELECT newId(),customerId,branch_id FROM ( Select distinct customerId, branch_id from @AccountTransaction         
  where transdate Between @startDate1 and @endDate1 and branch_id=@branch_id1  and product_type=2) x        
               
 --Step 1: Setting GS Customer & Balacne Opening        
 -----------------------------------------------------        
  select @GS_Loan_CustomerOP=count(distinct s.customerId),        
  @GS_Loan_DepositOP=IsNull(sum(s.Deposit),0),        
  @GS_Loan_WithdrawalOP=IsNull(sum(s.Withdrawal),0),        
  @GS_Loan_BalanceOP=IsNull(sum(s.Deposit),0)-IsNull(sum(s.Withdrawal),0)        
  from savingsaccountsopeningline s with (nolock)        
  inner join loanAccountsOpeningLine l with (nolock) on s.customerId = l.customerId AND s.branch_id = l.branch_id         
  where s.branch_id=@branch_id1 AND l.openingDate = @startDate1 AND s.openingDate = @startDate1 
  AND s.productcode in (1,3)        
        
  --Step 1.0: Setting GS Interest Opening        
  ---------------------------------------------        
  select @GS_Loan_InterestOP=IsNull(sum(CASE WHEN  a.closingDate <= @endDate1 
  and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @GS_Loan_FineOP=IsNull(sum(CASE WHEN  a.closingDate <= @endDate1 
  and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  from savingsaccountsopeningline l with (nolock) 
  inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id= a.branch_id         
  inner join loanAccountsOpeningLine lo with (nolock) on lo.customerId = l.customerId 
  AND lo.branch_id = l.branch_id         
  where l.branch_id =@branch_id1 AND lo.openingDate = @startDate1 AND l.openingDate = @startDate1 
  AND l.productcode in (1,3)          
        
  --Step 1.a: Adding earlier opening        
  ----------------------------------------------        
  Select @GS_Loan_CustomerOP=@GS_Loan_CustomerOP+isnull(sum(customer),0) FROM tblSavingsPortfolioOpeningBr  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate <= @endDate1 and productcode in (1)          
  and Category = 'Having Loan During Reporting Month'        
          
  Select @GS_Loan_DepositOP=@GS_Loan_DepositOP+isnull(sum(Deposit),0),         
  @GS_Loan_WithdrawalOP=@GS_Loan_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @GS_Loan_InterestOP=@GS_Loan_InterestOP+isnull(sum(Interest),0),          
  @GS_Loan_FineOP=@GS_Loan_FineOP+isnull(sum(Fine),0),         
  @GS_Loan_BalanceOP=@GS_Loan_BalanceOP+isnull(sum(Deposit-Withdrawal),0) 
  FROM tblSavingsPortfolioOpeningBr  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate <= @endDate1 and productcode in (1,3)          
  and Category = 'Having Loan During Reporting Month'        
        
        
  --Step 1.a: Adding Transfer opening        
  ----------------------------------------------        
  Select @GS_Loan_DepositOPT=isnull(sum(Deposit),0),         
  @GS_Loan_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @GS_Loan_InterestOPT=isnull(sum(Interest),0),          
  @GS_Loan_FineOPT=isnull(sum(Fine),0),         
  @GS_Loan_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @GS_Loan_CustomerOPT=isnull(sum(customer),0)           
  FROM tblSavingsTransferOpening  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate = @startDate1 and productcode in (1,3)          
  and Category = 'Having Loan During Reporting Month'        
          


  SET @GS_Loan_DepositOP=@GS_Loan_DepositOP-@GS_Loan_DepositOPT        
  SET @GS_Loan_WithdrawalOP=@GS_Loan_WithdrawalOP-@GS_Loan_WithdrawalOPT        
  SET @GS_Loan_InterestOP=@GS_Loan_InterestOP-@GS_Loan_InterestOPT        
  SET @GS_Loan_FineOP=@GS_Loan_FineOP-@GS_Loan_FineOPT        
  SET @GS_Loan_BalanceOP=@GS_Loan_BalanceOP-@GS_Loan_BalanceOPT        
  SET @GS_Loan_CustomerOP=@GS_Loan_CustomerOP- @GS_Loan_CustomerOPT        
            
  --Step 1.0: Setting GS Total Customer & Deposit Opening        
  ----------------------------- --------------------        
  select @GS_Total_CustomerOP=count(distinct customerId) from savingsaccountsopeningline  with (nolock)        
  where branch_id=@branch_id1 AND openingDate = @startDate1 AND productcode in (1)          
          
  select @GS_Total_DepositOP=IsNull(sum(Deposit),0),        
  @GS_Total_WithdrawalOP=IsNull(sum(Withdrawal),0),        
  @GS_Total_BalanceOP=IsNull(sum(Deposit),0)-IsNull(sum(Withdrawal),0)        
  from savingsaccountsopeningline  with (nolock) where branch_id=@branch_id1 AND openingDate = @startDate1 
  AND productcode in (1,3)          
        
  --Step 1.0: Setting GS Total Interest Opening        
  ----------------------------- --------------------        
  select @GS_Total_InterestOP=IsNull(sum(CASE WHEN  a.closingdate <= @endDate1 and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @GS_Total_FineOP=IsNull(sum(CASE WHEN  a.closingdate <= @endDate1 and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  from savingsaccountsopeningline l with (nolock) inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id = a.branch_id         
  where l.branch_id=@branch_id1 AND openingDate = @startDate1 AND l.productcode in (1,3)        
        
  --Step 1.a: Adding earlier opening        
  ------------------------------------------        
  select @GS_Total_CustomerOP=@GS_Total_CustomerOP+isnull(sum(customer),0) FROM tblSavingsPortfolioOpeningBr  with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate <= @startDate1 and productcode in (1)         
           
  select @GS_Total_DepositOP=@GS_Total_DepositOP+isnull(sum(Deposit),0),         
  @GS_Total_WithdrawalOP=@GS_Total_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @GS_Total_InterestOP=@GS_Total_InterestOP+isnull(sum(Interest),0),         
  @GS_Total_FineOP=@GS_Total_FineOP+isnull(Sum(Fine),0),          
  @GS_Total_BalanceOP=@GS_Total_BalanceOP+isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0)         
  FROM tblSavingsPortfolioOpeningBr with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate <= @startDate1 and productcode in (1,3)         
        
  --Step 1.a: Adding Transfer opening        
  ------------------------------------------        
  select @GS_Total_DepositOPT= isnull(sum(Deposit),0),    @GS_Total_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @GS_Total_InterestOPT=isnull(sum(Interest),0),    @GS_Total_FineOPT=isnull(Sum(Fine),0),          
  @GS_Total_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @GS_Total_CustomerOPT=isnull(sum(customer),0) FROM tblSavingsTransferOpening with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate = @startDate1 and productcode in (1,3)         
        
  SET @GS_Total_DepositOP= @GS_Total_DepositOP-@GS_Total_DepositOPT        
  SET @GS_Total_WithdrawalOP=@GS_Total_WithdrawalOP-@GS_Total_WithdrawalOPT      
  SET @GS_Total_InterestOP=@GS_Total_InterestOP-@GS_Total_InterestOPT        
  SET @GS_Total_FineOP=@GS_Total_FineOP-@GS_Total_FineOPT        
  SET @GS_Total_BalanceOP=@GS_Total_BalanceOP-@GS_Total_BalanceOPT        
  SET @GS_Total_CustomerOP=@GS_Total_CustomerOP-@GS_Total_CustomerOPT        
        
  SET @GS_NL_DepositOPT = @GS_Total_DepositOPT - @GS_Loan_DepositOPT;        
  SET @GS_NL_WithdrawalOPT = @GS_Total_WithdrawalOPT - @GS_Loan_WithdrawalOPT;        
  SET @GS_NL_InterestOPT = @GS_Total_InterestOPT - @GS_Loan_InterestOPT;        
  SET @GS_NL_FineOPT = @GS_Total_FineOPT - @GS_Loan_FineOPT;        
  SET @GS_NL_BalanceOPT = @GS_Total_BalanceOPT - @GS_Loan_BalanceOPT;        
  SET @GS_NL_CustomerOPT = @GS_Total_CustomerOPT - @GS_Loan_CustomerOPT;        
        
  -------------------------------------------------------------------        
        
  SET @GS_NL_CustomerOP = @GS_Total_CustomerOP - @GS_Loan_CustomerOP;        
  SET @GS_NL_DepositOP = @GS_Total_DepositOP - @GS_Loan_DepositOP;        
  SET @GS_NL_WithdrawalOP = @GS_Total_WithdrawalOP - @GS_Loan_WithdrawalOP;        
  SET @GS_NL_InterestOP = @GS_Total_InterestOP - @GS_Loan_InterestOP;        
  SET @GS_NL_FineOP = @GS_Total_FineOP - @GS_Loan_FineOP;        
  SET @GS_NL_BalanceOP = @GS_Total_BalanceOP - @GS_Loan_BalanceOP;        
        
   

   

  --Step 1: Setting RVS Customer & Balacne Opening        
 -----------------------------------------------------        
  select @RVS_Loan_CustomerOP=count(distinct s.customerId),        
  @RVS_Loan_DepositOP=IsNull(sum(s.Deposit),0),        
  @RVS_Loan_WithdrawalOP=IsNull(sum(s.Withdrawal),0),        
  @RVS_Loan_BalanceOP=IsNull(sum(s.Deposit),0)-IsNull(sum(s.Withdrawal),0)        
  from savingsaccountsopeningline s with (nolock)        
  inner join loanAccountsOpeningLine l with (nolock) on s.customerId = l.customerId AND s.branch_id = l.branch_id         
  where s.branch_id=@branch_id1 AND l.openingDate = @startDate1 AND s.openingDate = @startDate1 
  AND s.productcode in (4,5)        
        
  --Step 1.0: Setting RVS Interest Opening        
  ---------------------------------------------        
  select @RVS_Loan_InterestOP=IsNull(sum(CASE WHEN  a.closingDate <= @endDate1 
  and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @RVS_Loan_FineOP=IsNull(sum(CASE WHEN  a.closingDate <= @endDate1 
  and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  from savingsaccountsopeningline l with (nolock) 
  inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id= a.branch_id         
  inner join loanAccountsOpeningLine lo with (nolock) on lo.customerId = l.customerId 
  AND lo.branch_id = l.branch_id         
  where l.branch_id =@branch_id1 AND lo.openingDate = @startDate1 AND l.openingDate = @startDate1 
  AND l.productcode in (4,5)          
        
  --Step 1.a: Adding earlier opening        
  ----------------------------------------------        
  Select @RVS_Loan_CustomerOP=@RVS_Loan_CustomerOP+isnull(sum(customer),0) FROM tblSavingsPortfolioOpeningBr  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate <= @endDate1 and productcode in (4,5)          
  and Category = 'Having Loan During Reporting Month'        
          
  Select @RVS_Loan_DepositOP=@RVS_Loan_DepositOP+isnull(sum(Deposit),0),         
  @RVS_Loan_WithdrawalOP=@RVS_Loan_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @RVS_Loan_InterestOP=@RVS_Loan_InterestOP+isnull(sum(Interest),0),          
  @RVS_Loan_FineOP=@RVS_Loan_FineOP+isnull(sum(Fine),0),         
  @RVS_Loan_BalanceOP=@RVS_Loan_BalanceOP+isnull(sum(Deposit-Withdrawal),0) 
  FROM tblSavingsPortfolioOpeningBr  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate <= @endDate1 and productcode in (4,5)          
  and Category = 'Having Loan During Reporting Month'        
        
        
  --Step 1.a: Adding Transfer opening        
  ----------------------------------------------        
  Select @RVS_Loan_DepositOPT=isnull(sum(Deposit),0),         
  @RVS_Loan_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @RVS_Loan_InterestOPT=isnull(sum(Interest),0),          
  @RVS_Loan_FineOPT=isnull(sum(Fine),0),         
  @RVS_Loan_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @RVS_Loan_CustomerOPT=isnull(sum(customer),0)           
  FROM tblSavingsTransferOpening  with (nolock)         
  WHERE branch_id=@branch_id1 AND openingDate = @startDate1 and productcode in (4,5)          
  and Category = 'Having Loan During Reporting Month'        
          


  SET @RVS_Loan_DepositOP=@RVS_Loan_DepositOP-@RVS_Loan_DepositOPT        
  SET @RVS_Loan_WithdrawalOP=@RVS_Loan_WithdrawalOP-@RVS_Loan_WithdrawalOPT        
  SET @RVS_Loan_InterestOP=@RVS_Loan_InterestOP-@RVS_Loan_InterestOPT        
  SET @RVS_Loan_FineOP=@RVS_Loan_FineOP-@RVS_Loan_FineOPT        
  SET @RVS_Loan_BalanceOP=@RVS_Loan_BalanceOP-@RVS_Loan_BalanceOPT        
  SET @RVS_Loan_CustomerOP=@RVS_Loan_CustomerOP- @RVS_Loan_CustomerOPT        
            
  --Step 1.0: Setting GS Total Customer & Deposit Opening        
  ----------------------------- --------------------        
  select @RVS_Total_CustomerOP=count(distinct customerId) from savingsaccountsopeningline  with (nolock)        
  where branch_id=@branch_id1 AND openingDate = @startDate1 AND productcode in (4,5)          
          
  select @RVS_Total_DepositOP=IsNull(sum(Deposit),0),        
  @RVS_Total_WithdrawalOP=IsNull(sum(Withdrawal),0),        
  @RVS_Total_BalanceOP=IsNull(sum(Deposit),0)-IsNull(sum(Withdrawal),0)        
  from savingsaccountsopeningline  with (nolock) where branch_id=@branch_id1 AND openingDate = @startDate1 
  AND productcode in (4,5)          
        
  --Step 1.0: Setting GS Total Interest Opening        
  ----------------------------- --------------------        
  select @RVS_Total_InterestOP=IsNull(sum(CASE WHEN  a.closingdate <= @endDate1 and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @RVS_Total_FineOP=IsNull(sum(CASE WHEN  a.closingdate <= @endDate1 and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  from savingsaccountsopeningline l with (nolock) inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id = a.branch_id         
  where l.branch_id=@branch_id1 AND openingDate = @startDate1 AND l.productcode in (4,5)        
        
  --Step 1.a: Adding earlier opening        
  ------------------------------------------        
  select @RVS_Total_CustomerOP=@RVS_Total_CustomerOP+isnull(sum(customer),0) FROM tblSavingsPortfolioOpeningBr  with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate <= @startDate1 and productcode in (4,5)         
           
  select @RVS_Total_DepositOP=@RVS_Total_DepositOP+isnull(sum(Deposit),0),         
  @RVS_Total_WithdrawalOP=@RVS_Total_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @RVS_Total_InterestOP=@RVS_Total_InterestOP+isnull(sum(Interest),0),         
  @RVS_Total_FineOP=@RVS_Total_FineOP+isnull(Sum(Fine),0),          
  @RVS_Total_BalanceOP=@RVS_Total_BalanceOP+isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0)         
  FROM tblSavingsPortfolioOpeningBr with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate <= @startDate1 and productcode in (4,5)         
        
  --Step 1.a: Adding Transfer opening        
  ------------------------------------------        
  select @RVS_Total_DepositOPT= isnull(sum(Deposit),0),    @RVS_Total_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @RVS_Total_InterestOPT=isnull(sum(Interest),0),    @RVS_Total_FineOPT=isnull(Sum(Fine),0),          
  @RVS_Total_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @RVS_Total_CustomerOPT=isnull(sum(customer),0) FROM tblSavingsTransferOpening with (nolock)        
  WHERE branch_id=@branch_id1 AND  openingDate = @startDate1 and productcode in (4,5)

  SET @RVS_Total_DepositOP= @RVS_Total_DepositOP-@RVS_Total_DepositOPT        
  SET @RVS_Total_WithdrawalOP=@RVS_Total_WithdrawalOP-@RVS_Total_WithdrawalOPT      
  SET @RVS_Total_InterestOP=@RVS_Total_InterestOP-@RVS_Total_InterestOPT        
  SET @RVS_Total_FineOP=@RVS_Total_FineOP-@RVS_Total_FineOPT        
  SET @RVS_Total_BalanceOP=@RVS_Total_BalanceOP-@RVS_Total_BalanceOPT        
  SET @RVS_Total_CustomerOP=@RVS_Total_CustomerOP-@RVS_Total_CustomerOPT        
        
  SET @RVS_NL_DepositOPT = @RVS_Total_DepositOPT - @RVS_Loan_DepositOPT;        
  SET @RVS_NL_WithdrawalOPT = @RVS_Total_WithdrawalOPT - @RVS_Loan_WithdrawalOPT;        
  SET @RVS_NL_InterestOPT = @RVS_Total_InterestOPT - @RVS_Loan_InterestOPT;        
  SET @RVS_NL_FineOPT = @RVS_Total_FineOPT - @RVS_Loan_FineOPT;        
  SET @RVS_NL_BalanceOPT = @RVS_Total_BalanceOPT - @RVS_Loan_BalanceOPT;        
  SET @RVS_NL_CustomerOPT = @RVS_Total_CustomerOPT - @RVS_Loan_CustomerOPT;        
        
  -------------------------------------------------------------------        
        
  SET @RVS_NL_CustomerOP = @RVS_Total_CustomerOP - @RVS_Loan_CustomerOP;        
  SET @RVS_NL_DepositOP = @RVS_Total_DepositOP - @RVS_Loan_DepositOP;        
  SET @RVS_NL_WithdrawalOP = @RVS_Total_WithdrawalOP - @RVS_Loan_WithdrawalOP;        
  SET @RVS_NL_InterestOP = @RVS_Total_InterestOP - @RVS_Loan_InterestOP;        
  SET @RVS_NL_FineOP = @RVS_Total_FineOP - @RVS_Loan_FineOP;        
  SET @RVS_NL_BalanceOP = @RVS_Total_BalanceOP - @RVS_Loan_BalanceOP;  







  --Step 3: Setting CS Opening        
  ---------------------------------        
  select @CS_Loan_CustomerOP=count(distinct s.customerId),        
  @CS_Loan_DepositOP=IsNull(sum(s.Deposit),0),        
  @CS_Loan_WithdrawalOP=IsNull(sum(s.Withdrawal),0),        
  @CS_Loan_BalanceOP=IsNull(sum(s.Deposit),0)-IsNull(sum(s.Withdrawal),0)        
  from savingsaccountsopeningline s with (nolock) inner join loanAccountsOpeningLine l with (nolock) on s.customerId = l.customerId         
  AND s.branch_id = l.branch_id         
  where l.branch_id=@branch_id1 AND l.openingDate = @startDate1 AND s.openingDate = @startDate1 AND s.productcode in (2,3)        
        
  ---Desktop        
  --select count(distinct s.customerId) as CustomerCount,IsNull(sum(s.Deposit),0) as Deposit,IsNull(sum(s.Withdrawal),0) as Withdrawal,        
  --IsNull(sum(s.Interest),0) as Interest, IsNull(sum(s.Fine),0) as Fine,IsNull(sum(s.AccountBalance),0) as AccountBalance         
  --from savingsaccountsopeningline s inner join loanAccountsOpeningLine l on s.customerId = l.customerId        
  -- where l.openingDate = '" & strStartDate & "' AND s.openingDate = '" & strStartDate & "' AND s.productcode in (2,3)        
        
  --Setting Prev June Interestest-        
  ---------------------------        
  DECLARE @CS_Loan_InterestOPJune numeric(25,2)        
  DECLARE @CS_NL_InterestOPJune numeric(25,2)        
          
 select @CS_Loan_InterestOP =IsNull(sum(l.Interest ),0) ,@CS_Loan_FineOP=IsNull(sum(l.Fine ),0)         
 from savingsaccountsopeningline l with (nolock) inner join savingsaccount a with (nolock) on l.branch_id = a.branch_id and        
 l.accountno = a.accountno   inner join loanAccountsOpeningLine lo with (nolock) on lo.branch_id = l.branch_id and        
 lo.customerId = l.customerId where l.branch_id = @branch_id1 and l.openingDate = @startDate1         
 AND lo.openingDate = @startDate1 AND l.productcode in (2,3)         
 and (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed' and a.closingDate>=@startDate1))        
 --AND ((a.AccountStatus = 'Closed' and a.closingDate>@FYstartDate) OR a.accountStatus <> 'Closed')        
 --Desktop         
 --select IsNull(sum(l.Interest ),0) as Interest,IsNull(sum(l.Fine ),0) as Fine from savingsaccountsopeningline l         
 --inner join savingsaccount a on l.accountno = a.accountno inner join loanAccountsOpeningLine lo on lo.customerId = l.customerId         
 --where lo.openingDate = '" & strStartDate & "' AND l.openingDate = '" & strStartDate & "' AND l.productcode in (2,3)        
  --and (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed' and a.closingDate>='" & strStartDate & "'))           
               
 --Commented by SI & NUR (June/18)        
 -------------------------------        
 --If @CS_Loan_InterestOP > @CS_Loan_FineOP         
 -- SET @CS_Loan_InterestOP = @CS_Loan_InterestOP - @CS_Loan_FineOP        
 --Else        
 -- SET @CS_Loan_InterestOP = 0        
 ----------------------------------------        
        
            
 SET @CS_Loan_InterestOPJune = @CS_Loan_InterestOP        
        
        
 --- Find Value for @CS_Loan_InterestOP_June        
 select @CS_Loan_InterestOP_June =IsNull(sum(l.Interest ),0)-IsNull(sum(l.Fine ),0)         
 from savingsaccountsopeningline l with (nolock) inner join savingsaccount a with (nolock)         
 on l.branch_id = a.branch_id and l.accountno = a.accountno   inner join loanAccountsOpeningLine lo         
 with (nolock) on lo.branch_id = l.branch_id and lo.customerId = l.customerId         
 where l.branch_id = @branch_id1 and l.openingDate =@FYstartDate AND lo.openingDate = @startDate1        
 AND l.productcode in (2,3) AND (a.accountStatus in ('Operative','Halt') or         
 (a.accountStatus = 'Closed' and a.closingDate>=@startDate1))        
        
 --Desktop         
 --select IsNull(sum(l.Interest ),0) - IsNull(sum(l.Fine ),0) as Interest from savingsaccountsopeningline   l         
 --inner join savingsaccount a on l.accountno = a.accountno           
 --inner join loanAccountsOpeningLine lo on lo.customerId = l.customerId         
 --where l.openingDate = '" & strFYStartDate & "' AND lo.openingDate = '" & strStartDate & "'         
 --AND l.productcode in (2,3) AND (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed' and a.closingDate>='" & strStartDate & "'))        
        
 If @CS_Loan_InterestOP_June < 0        
  set @CS_Loan_InterestOP_June=0        
        
        
 SET @CS_Loan_DepositOP = @CS_Loan_DepositOP + @CS_Loan_InterestOP        
        
         
        
 SET @CS_Loan_BalanceOP = @CS_Loan_BalanceOP + @CS_Loan_InterestOP        
 --Desktop        
 SET @CS_Loan_DepositOP = @CS_Loan_DepositOP - @CS_Loan_InterestOP_June        
 SET @CS_Loan_BalanceOP = @CS_Loan_BalanceOP - @CS_Loan_InterestOP_June        
        
         
 -------        
 SET @CS_Loan_InterestOP = 0        
 SET @CS_Loan_FineOP = 0        
         
        
  --Step 3.0: Setting CS Interest & Fine Opening        
  -------------------------------------------------        
  --select @CS_Loan_InterestOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  --@CS_Loan_FineOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  --from savingsaccountsopeningline l with (nolock) inner join savingsaccount a with (nolock) on l.accountno = a.accountno          
  --AND l.branch_id = a.branch_id  inner join loanAccountsOpeningLine lo with (nolock) on lo.customerId = l.customerId         
  --AND lo.branch_id = l.branch_id         
  --where lo.branch_id=@branch_id1 AND lo.openingDate = @startDate1 AND l.openingDate = @startDate1 AND l.productcode in (2,3)        
        
        
   ----Desktop        
   select @CS_Loan_InterestOP=IsNull(sum(l.Interest ),0) ,
   @CS_Loan_FineOP=IsNull(sum(l.Fine ),0) from savingsaccountsopeningline   l with (nolock)       
    inner join savingsaccount a with (nolock) on l.accountno = a.accountno  AND l.branch_id = a.branch_id         
    inner join loanAccountsOpeningLine lo with (nolock) on lo.customerId = l.customerId AND lo.branch_id = l.branch_id        
    where lo.branch_id=@branch_id1 and  l.openingDate = @FYstartDate AND lo.openingDate = @startDate1 AND l.productcode in (2,3) AND         
   (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed' and a.closingDate>=@FYstartDate))        
        
        
  --Setp 3.a: Setting earlier CS opening        
  ----------------------------------------        
  select @CS_Loan_CustomerOP=@CS_Loan_CustomerOP+isnull(sum(customer),0),         
  @CS_Loan_DepositOP=@CS_Loan_DepositOP+isnull(sum(Deposit),0),    
  @CS_Loan_WithdrawalOP=@CS_Loan_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @CS_Loan_InterestOP=@CS_Loan_InterestOP+isnull(sum(Interest),0),         
  @CS_Loan_FineOP=@CS_Loan_FineOP+isnull(sum(Fine),0),         
  @CS_Loan_BalanceOP=@CS_Loan_BalanceOP+isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0)         
  FROM tblSavingsPortfolioOpeningBr with (nolock)         
  WHERE branch_id=@branch_id1 AND  openingDate <= @endDate1 and ProductCode in (2,3)          
  and Category = 'Having Loan During Reporting Month'        
        
  --Setp 3.a: Setting Transfer CS opening        
  ----------------------------------------        
  select @CS_Loan_DepositOPT=isnull(sum(Deposit),0),         
  @CS_Loan_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @CS_Loan_InterestOPT=isnull(sum(Interest),0),         
  @CS_Loan_ApprovedInterestOPT=isnull(sum(ApprovedInterest),0),         
  @CS_Loan_FineOPT=isnull(sum(Fine),0),         
  @CS_Loan_BalanceOPT=isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0) ,        
  @CS_Loan_CustomerOPT=isnull(sum(customer),0)         
  FROM tblSavingsTransferOpening with (nolock)         
  WHERE branch_id=@branch_id1 AND  openingDate = @startDate1 and ProductCode in (2,3)          
  and Category = 'Having Loan During Reporting Month'        
        
  SET @CS_Loan_DepositOP=@CS_Loan_DepositOP-@CS_Loan_DepositOPT        
  SET @CS_Loan_WithdrawalOP=@CS_Loan_WithdrawalOP-@CS_Loan_WithdrawalOPT        
  SET @CS_Loan_InterestOP=@CS_Loan_InterestOP-@CS_Loan_InterestOPT        
  SET @CS_Loan_FineOP=@CS_Loan_FineOP-@CS_Loan_FineOPT        
  SET @CS_Loan_BalanceOP=@CS_Loan_BalanceOP-@CS_Loan_BalanceOPT         
  SET @CS_Loan_CustomerOP=@CS_Loan_CustomerOP-@CS_Loan_CustomerOPT        
        
  -------------------------------------------------------------        
           
  select @CS_Total_CustomerOP=count(distinct customerId),        
  @CS_Total_DepositOP=IsNull(sum(Deposit),0)        
  ,@CS_Total_WithdrawalOP=IsNull(sum(Withdrawal),0),        
  @CS_Total_BalanceOP=IsNull(sum(Deposit),0)-IsNull(sum(Withdrawal),0)        
  from savingsaccountsopeningline with (nolock)         
  where branch_id=@branch_id1 AND openingDate = @startDate1 AND productcode in (2,3)        
           
  --Prev June Interest        
  --------------------------        
  DECLARE @csJuneInterest numeric(25,2)        
                
  select @CS_Total_InterestOP=IsNull(sum(l.Interest),0),@CS_Total_FineOP=IsNull(sum(l.Fine),0) from savingsaccountsopeningline  l with (nolock)         
  inner join savingsaccount a with (nolock) on l.branch_id = a.branch_id and l.accountno = a.accountno         
  where l.branch_id = @branch_id1 and l.openingDate = @FYStartDate AND l.productcode in (2,3)         
  --AND ((a.AccountStatus = 'Closed' and a.closingDate>=@FYstartDate) OR a.accountStatus <> 'Closed')        
  and (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed'  and a.closingDate>=@FYstartDate))        
        
  --Desktop        
  --select IsNull(sum(l.Interest),0) as Interest,IsNull(sum(l.Fine),0) as Fine from savingsaccountsopeningline  l         
  --inner join savingsaccount a on l.accountno = a.accountno where l.openingDate = '" & strFYStartDate & "'         
  --AND l.productcode in (2,3)        
  --and (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed'  and a.closingDate>='" & strFYStartDate & "'))        
                
 --If @CS_Total_InterestOP > @CS_Total_FineOP        
 -- SET @CS_Total_InterestOP = @CS_Total_InterestOP - @CS_Total_FineOP        
 --Else        
 -- SET @CS_Total_InterestOP = 0        
        
        
  SET @csJuneInterest = @CS_Total_InterestOP        
            
 SET @CS_Total_DepositOP = @CS_Total_DepositOP-- + @CS_Total_InterestOP        
        
        
 SET @CS_Total_BalanceOP = @CS_Total_BalanceOP-- + @CS_Total_InterestOP        
                
 SET @CS_Total_InterestOP = 0        
 SET @CS_Total_FineOP = 0        
        
 select @CS_Total_InterestOP_June=IsNull(sum(l.Interest),0)-IsNull(sum(l.Fine),0) from savingsaccountsopeningline  l with (nolock)         
 inner join savingsaccount a with (nolock) on l.branch_id = a.branch_id and l.accountno = a.accountno         
 where l.branch_id = @branch_id1 and l.openingDate = @FYStartDate AND l.productcode in (2,3) and        
 (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed'        
  and a.closingDate>=@startDate1))        
             
 --where l.branch_id = @branch_id1 and l.openingDate = @FYStartDate AND l.productcode in (2,3)         
 --AND ((a.AccountStatus = 'Closed' and a.closingDate>@startDate1) OR a.accountStatus <> 'Closed')        
         
 --   ---Desktop        
  --select IsNull(sum(l.Interest),0) -IsNull(sum(l.Fine),0) as Interest from savingsaccountsopeningline  l         
  --inner join savingsaccount a on l.accountno = a.accountno         
  --where l.openingDate = '" & strFYStartDate & "'         
  --AND l.productcode in (2,3) and (a.accountStatus in ('Operative','Halt') or (a.accountStatus = 'Closed'        
  -- and a.closingDate>='" & strStartDate & "'))"        
        
        
 If @CS_Total_InterestOP_June < 0 set @CS_Total_InterestOP_June = 0        
        
 ---Desktop        
            
     SET @CS_Total_DepositOP = @CS_Total_DepositOP -- - @CS_Total_InterestOP_June        
  SET @CS_Total_BalanceOP = @CS_Total_BalanceOP -- -@CS_Total_InterestOP_June        
  --Step 3.0: Setting CS interest Opening        
  -----------------------------------------------        
  select @CS_Total_InterestOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @CS_Total_FineOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)         
  from savingsaccountsopeningline  l with (nolock) inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id = a.branch_id         
  where l.branch_id=@branch_id1 AND l.openingDate = @startDate1 AND l.productcode in (2,3)        
        
  --Setp 3.a: Setting earlier opening        
  -----------------------------------------------        
  select @CS_Total_CustomerOP=@CS_Total_CustomerOP+isnull(sum(customer),0),         
  @CS_Total_DepositOP=@CS_Total_DepositOP+isnull(sum(Deposit),0),         
  @CS_Total_WithdrawalOP=@CS_Total_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @CS_Total_InterestOP=@CS_Total_InterestOP+isnull(sum(Interest),0),         
  @CS_Total_FineOP=@CS_Total_FineOP+isnull(sum(Fine),0),        
  @CS_Total_BalanceOP=@CS_Total_BalanceOP+isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0)         
  FROM tblSavingsPortfolioOpeningBr with (nolock)         
  WHERE branch_id=@branch_id1 AND  openingDate <= @startDate1 and ProductCode in (2,3)         
        
        
   --Setp 3.a: Setting Transfer opening        
  -----------------------------------------------        
  select @CS_Total_DepositOPT=isnull(sum(Deposit),0),         
  @CS_Total_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @CS_Total_InterestOPT=isnull(sum(Interest),0),         
  @CS_Total_ApprovedInterestOPT=isnull(sum(approvedInterest),0),         
  @CS_Total_FineOPT=isnull(sum(Fine),0),        
  @CS_Total_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @CS_Total_CustomerOPT=isnull(sum(customer),0)        
  FROM tblSavingsTransferOpening with (nolock)         
  WHERE branch_id=@branch_id1 AND  openingDate = @startDate1 and ProductCode in (2,3)         
            
  SET @CS_Total_DepositOP=@CS_Total_DepositOP-@CS_Total_DepositOPT        
  SET @CS_Total_WithdrawalOP=@CS_Total_WithdrawalOP-@CS_Total_WithdrawalOPT         
  SET @CS_Total_InterestOP=@CS_Total_InterestOP-@CS_Total_InterestOPT        
  SET @CS_Total_InterestOP=@CS_Total_InterestOP-@CS_Total_InterestOPT        
  SET @CS_Total_FineOP=@CS_Total_FineOP-@CS_Total_FineOPT        
  SET @CS_Total_BalanceOP=@CS_Total_BalanceOP-@CS_Total_BalanceOPT         
  SET @CS_Total_CustomerOP=@CS_Total_CustomerOP-@CS_Total_CustomerOPT        
        
  SET @CS_NL_DepositOPT = @CS_Total_DepositOPT - @CS_Loan_DepositOPT;        
  SET @CS_NL_WithdrawalOPT = @CS_Total_WithdrawalOPT - @CS_Loan_WithdrawalOPT;        
  SET @CS_NL_ApprovedInterestOPT = @CS_Total_ApprovedInterestOPT - @CS_Loan_ApprovedInterestOPT        
  SET @CS_NL_InterestOPT = @CS_Total_InterestOPT - @CS_Loan_InterestOPT;        
  SET @CS_NL_FineOPT = @CS_Total_FineOPT - @CS_Loan_FineOPT;        
  SET @CS_NL_BalanceOPT = @CS_Total_BalanceOPT - @CS_Loan_BalanceOPT;        
  SET @CS_NL_CustomerOPT = @CS_Total_CustomerOPT - @CS_Loan_CustomerOPT;        
  -------------------------------------------------------------------------        
            
  SET @CS_NL_CustomerOP = @CS_Total_CustomerOP - @CS_Loan_CustomerOP;        
  SET @CS_NL_DepositOP = @CS_Total_DepositOP - @CS_Loan_DepositOP;        
  SET @CS_NL_WithdrawalOP = @CS_Total_WithdrawalOP - @CS_Loan_WithdrawalOP;        
          
  SET @CS_NL_InterestOP = @CS_Total_InterestOP - @CS_Loan_InterestOP;        
        
  set @CS_Loan_InterestOP_June=@CS_Loan_InterestOP_June-@CS_Loan_ApprovedInterestOPT        
  set @CS_Loan_InterestOP=@CS_Loan_InterestOP-@CS_Loan_ApprovedInterestOPT        
  set @CS_Total_InterestOP_June=@CS_Total_InterestOP_June-@CS_Total_ApprovedInterestOPT        
  set @CS_Total_InterestOP=@CS_Total_InterestOP-@CS_Total_ApprovedInterestOPT        
  SET @CS_NL_InterestOP_June = @CS_Total_InterestOP_June - @CS_Loan_InterestOP_June;        
  SET @CS_NL_FineOP = @CS_Total_FineOP - @CS_Loan_FineOP;        
  SET @CS_NL_BalanceOP = @CS_Total_BalanceOP - @CS_Loan_BalanceOP;        
        
  SET @CS_NL_InterestOPJune = @csJuneInterest - @CS_Loan_InterestOPJune        
        
  --Step 4: Grand Total Opening        
  ----------------------------------        
  select @GT_CustomerOP=count(distinct customerId) from savingsaccountsopeningline with (nolock) where branch_id=@branch_id1         
  AND openingDate = @startDate1 AND productcode in (1)        
        
  select @GT_DepositOP=IsNull(sum(Deposit),0), @GT_WithdrawalOP=IsNull(sum(Withdrawal),0),         
  @GT_BalanceOP=IsNull(sum(Deposit),0)-IsNull(sum(Withdrawal),0)        
  from savingsaccountsopeningline with (nolock)         
  where branch_id=@branch_id1 AND openingDate = @startDate1 AND productcode in (1,2,3,5,6)        
        
  --Step 4.0: Setting Grand Total Interest Opening        
  -----------------------------------        
  select @GT_InterestOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Interest END),0),        
  @GT_FineOP=IsNull(sum(CASE WHEN  a.closingdate <= @FYstartDate and a.accountStatus='Closed' THEN 0 ELSE l.Fine END),0)        
  from savingsaccountsopeningline  l with (nolock) inner join savingsaccount a with (nolock) on l.accountno = a.accountno         
  AND l.branch_id = a.branch_id         
  where l.branch_id=@branch_id1 AND l.openingDate = @startDate1 AND l.productcode in (1,2,3,5,6)        
          
        
  ----Step 4.1. Setting Earlier Opening        
  --Desktop        
          
          
  Select @CS_Total_WithdrawalOP =IsNull(sum(Transamount),0) from AccountTransaction_prev with (nolock) where Branch_id =@branch_id1  and Productcode in (2,3)        
  and Transdate <@startDate1 and TransType=1 and Transamount>0 --And customerId  in (Select customerId from loanAccountsOpeningLine where Openingdate =@startDate1)       
    
  if @CS_Loan_WithdrawalOP=0        
  begin 
   --set @CS_Loan_WithdrawalOP=ROUND((@CS_Total_WithdrawalOP*58)/100,0 )
   --set @CS_NL_WithdrawalOP=ROUND((@CS_Total_WithdrawalOP*42)/100,0 )    

  set @CS_NL_WithdrawalOP=@CS_Total_WithdrawalOP        
  end        
    
  set @GT_WithdrawalOP=@GT_WithdrawalOP+ @CS_Total_WithdrawalOP    
     
  --------------------------------------        
        
  select @GT_CustomerOP=@GT_CustomerOP+isnull(sum(customer),0),         
  @GT_DepositOP=@GT_DepositOP+isnull(sum(Deposit),0),         
  @GT_WithdrawalOP=@GT_WithdrawalOP+isnull(sum(Withdrawal),0),         
  @GT_InterestOP=@GT_InterestOP+isnull(sum(Interest),0),         
  @GT_FineOP=@GT_FineOP+isnull(sum(Fine),0),          
  @GT_BalanceOP=@GT_BalanceOP+isnull(sum(Deposit),0)-isnull(sum(Withdrawal),0)         
  FROM tblSavingsPortfolioOpeningBr with (nolock)           
  Where branch_id=@branch_id1 AND openingDate <= @endDate1        
          
  ----Step 4.1. Setting Transfer Opening        
  select @GT_DepositOPT=isnull(sum(Deposit),0),         
  @GT_WithdrawalOPT=isnull(sum(Withdrawal),0),         
  @GT_InterestOPT=isnull(sum(Interest),0),         
  @GT_FineOPT=isnull(sum(Fine),0),          
  @GT_BalanceOPT=isnull(sum(IsNull(Deposit,0)-IsNull(Withdrawal,0)),0) ,        
  @GT_CustomerOPT=isnull(sum(customer),0)         
  FROM tblSavingsTransferOpening with (nolock)           
  Where branch_id=@branch_id1 AND openingDate =@startDate1        
        
  SET @GT_DepositOP=@GT_DepositOP-@GT_DepositOPT        
  SET @GT_WithdrawalOP=@GT_WithdrawalOP-@GT_WithdrawalOPT        
  SET @GT_InterestOP=@GT_InterestOP-@GT_InterestOPT        
  SET @GT_FineOP=@GT_FineOP-@GT_FineOPT        
  SET @GT_BalanceOP=@GT_BalanceOP-@GT_BalanceOPT       
       
     
    
  SET @GT_CustomerOP=@GT_CustomerOP-@GT_CustomerOPT         
  if @GT_CustomerOP<0        
  begin        
  SET @GT_CustomerOP=0        
   end        
  ------------------------------------------------------------        
          
  SET @GT_DepositOP = @GT_DepositOP + @csJuneInterest         
  SET @GT_BalanceOP = @GT_BalanceOP + @csJuneInterest         
        
  ---Desktop        
  SET @GT_BalanceOP = @GT_BalanceOP -@CS_Total_InterestOP_June        
  SET @GT_DepositOP = @GT_DepositOP - @CS_Total_InterestOP_June         
        
        
  --Step 5: Setting GS Current Month        
  ----------------------------------------------        
  select @GS_Loan_CustomerCM=IsNull((select count(distinct customerid) from savingsAccount with (nolock) where branch_id=@branch_id1         
  AND accountopeningdate Between @startDate1 and @endDate1 and productcode in (1,5,6)         
  and customerid in (select customerId from @tempTrnsLoanCustomers where branch_id=@branch_id1)),0),        
  @GS_Loan_DepositCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0),        
  @GS_Loan_WithdrawalCM=IsNull(sum(Case TransType when 1 then transAmount when 0 then 0 end),0),        
  @GS_Loan_FineCM=IsNull(sum(fine),0),        
  @GS_Loan_BalanceCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0)-        
  IsNull(sum(Case TransType when 1 then transAmount when 0 then 0 end),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1         
  and @endDate1 and a.product_type = 1 and customerId in (select distinct customerId from @tempTrnsLoanCustomers          
  where branch_id=@branch_id1) and a.productcode in (1,5,6)        
          
  --Step 5.0: Setting GS Current Month        
  -------------------------------------------        
  Select @GS_Loan_InterestCM=IsNull(sum(CASE WHEN closingdate <= @endDate1 and accountStatus='Closed' THEN 0 ELSE amount END),0)        
  FROM (  Select AccountNo, amount, closingDate, AccountStatus FROM         
    (        
    Select i.AccountNo, i.amount, s.closingDate, s.AccountStatus         
    FROM unpaidinterests i with (nolock)         
    inner join savingsaccount s with (nolock) on i.accountno = s.accountno AND i.branch_id = s.branch_id         
    inner join SavingsProductDef p with (nolock) on s.ProductCode = p.ProductCode        
    inner join @tempTrnsLoanCustomers c on s.branch_id = c.branch_id and s.customerId = c.customerId        
    Where i.branch_id = @branch_id1 and i.ForTheMonth = @endDate1 AND i.ProductCode in (1,5,6)         
    ) a         
  ) oi        
          
  --Step 6.1: Setting Savings-2 Interest Adjust Current Month        
  -----------------------------------------------------------------        
  select @GS_Loan_DepositCM=@GS_Loan_DepositCM+IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0),        
  @GS_Loan_WithdrawalCM=@GS_Loan_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0),        
  @GS_Loan_BalanceCM=@GS_Loan_DepositCM+IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0)-        
  (@GS_Loan_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0))        
  from @AccountTransaction a         
  inner join savingsaccount s with (nolock) on a.accountno=s.accountno AND a.branch_id = s.branch_id         
  where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1 and         
  a.customerId in (select distinct t.customerId from @AccountTransaction t  where t.branch_id=@branch_id1 AND t.transdate         
  Between @startDate1 and @endDate1 and t.product_type = 1)         
  and a.productcode in (5,6) and s.accountstatus='Closed'         
  and (a.interest<>0 or a.interest<>NULL)        
          
  select @GS_Total_CustomerCM=IsNull((select count(distinct customerid) from savingsAccount with (nolock) where branch_id=@branch_id1 AND accountopeningdate         
  Between @startDate1 and @endDate1 and productcode in (1,5,6)),0),         
  @GS_Total_DepositCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0),        
  @GS_Total_WithdrawalCM=IsNull(sum(Case TransType when 1 then transAmount + Isnull(adjustAmount,0) when 0 then 0 end),0),        
  @GS_Total_FineCM=IsNull(sum(fine),0),        
  @GS_Total_BalanceCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0)-IsNull(sum(Case TransType when 1         
  then transAmount + Isnull(adjustAmount,0) when 0 then 0 end),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and left(right(accountno,5),1) = 1 and a.productcode in (1,5,6)        
          
  --Step 6.1: Setting Savings-2 Interest Adjust Current Month        
  --------------------------------------------------------------        
  select @GS_Total_DepositCM=@GS_Total_DepositCM+IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0),        
  @GS_Total_WithdrawalCM=@GS_Total_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0),        
  @GS_Total_BalanceCM=@GS_Total_DepositCM+IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0)-        
  (@GS_Total_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0))        
  from @AccountTransaction a inner join savingsaccount s with (nolock) on a.accountno=s.accountno         
  AND a.branch_id = s.branch_id where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (5,6) and s.accountstatus='Closed' and s.closingdate <= @endDate1         
  and (a.interest<>0 or a.interest<>NULL)        
        
  --Step 6.0: Setting GS Current Month Interest        
  -----------------------------------------------------------        
  select @GS_Total_InterestCM= IsNull((select IsNull(sum(CASE WHEN s.closingdate <= @endDate1 and s.accountStatus='Closed' THEN 0 ELSE i.amount END),0)         
  from unpaidinterests i with (nolock) inner join savingsaccount s with (nolock) on i.accountno = s.accountno AND i.branch_id = s.branch_id         
  where i.branch_id=@branch_id1 AND ForTheMonth=@endDate1 and left(right(s.accountno,4),2) in (1,5,6) ),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (1,5,6)        
        
  SET @GS_NL_CustomerCM = @GS_Total_CustomerCM - @GS_Loan_CustomerCM;        
  SET @GS_NL_DepositCM = @GS_Total_DepositCM - @GS_Loan_DepositCM;        
  SET @GS_NL_WithdrawalCM = @GS_Total_WithdrawalCM - @GS_Loan_WithdrawalCM;        
  SET @GS_NL_InterestCM = @GS_Total_InterestCM - @GS_Loan_InterestCM;        
  SET @GS_NL_FineCM = @GS_Total_FineCM - @GS_Loan_FineCM;        
  SET @GS_NL_BalanceCM = @GS_Total_BalanceCM - @GS_Loan_BalanceCM;        
        
         
  --Step 7: Setting CS Current Month        
  ----------------------------------------------------        
  select @CS_Loan_CustomerCM=IsNull((select count(distinct customerid) from savingsAccount with (nolock) where branch_id=@branch_id1         
  AND accountopeningdate Between @startDate1 and @endDate1 and productcode in (2,3) and customerid in         
  (select distinct customerId from @AccountTransaction where branch_id=@branch_id1 AND transdate Between @startDate1         
  and @endDate1  and  product_type = 2)),0),        
  @CS_Loan_DepositCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0),        
  @CS_Loan_WithdrawalCM=IsNull(sum(Case TransType when 1 then transAmount+adjustAmount when 0 then 0 end),0),        
  @CS_Loan_FineCM=IsNull(sum(fine),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and product_type = 1 and         
  customerId in (select customerId from @tempTrnsLoanCustomers where branch_id=@branch_id1) and a.productcode in (2,3)        
        
        
        
  SET @CS_Loan_BalanceCM = @CS_Loan_DepositCM - @CS_Loan_WithdrawalCM;        
          
  Select @CS_Loan_InterestCM=IsNull(sum(CASE WHEN closingdate <= @endDate1 and accountStatus='Closed' THEN 0 ELSE amount END),0)        
  FROM (        
   Select  AccountNo, amount, closingDate, AccountStatus FROM (        
    Select i.AccountNo, i.amount, s.closingDate, s.AccountStatus         
    FROM unpaidinterests i with (nolock)         
    inner join savingsaccount s with (nolock) on i.accountno = s.accountno AND i.branch_id = s.branch_id         
    inner join SavingsProductDef p with (nolock) on s.ProductCode = p.ProductCode        
    inner join @tempTrnsLoanCustomers c on s.branch_id = c.branch_id and s.customerId = c.customerId        
    Where i.branch_id = @branch_id1 and i.ForTheMonth = @endDate1 AND i.ProductCode in (2,3)         
   ) a         
  ) oi        
        
  select @CS_Loan_FineCM=IsNull(sum(fine),0) from @AccountTransaction a inner join SavingsAccount s with (nolock)        
  on a.account_id = s.id where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1         
  and a.productcode in (2,3) and (s.accountStatus = 'Operative' or (s.AccountStatus = 'Closed' and s.closingDate>@endDate1))        
  --and S.customerId in (select customerId from @tempTrnsLoanCustomers where branch_id=@branch_id1)         
          
  --Step 7.1: Setting CS Interest Adjust Current Month        
        
        
  DECLARE @CS_Loan_Trans_InterestCM numeric(25,2),@CS_Total_Trans_InterestCM numeric(25,2)        
        
        
  select @CS_Loan_Trans_InterestCM=IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0)        
  from @AccountTransaction a inner join savingsaccount s with (nolock) on a.accountno=s.accountno AND a.branch_id = s.branch_id         
  where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1 and         
  a.customerId in (select distinct t.customerId from @AccountTransaction t  where t.branch_id = @branch_id1         
  AND t.transdate Between @startDate1 and @endDate1 and t.product_type = 1)         
  and a.productcode in (2,3) and s.accountstatus='Closed' and (a.interest<>0 or a.interest<>NULL)        
        
  SET @CS_Loan_Trans_InterestCM = IsNull(@CS_Loan_Trans_InterestCM,0)        
        
  select @CS_Loan_DepositCM=@CS_Loan_DepositCM+@CS_Loan_Trans_InterestCM,        
  @CS_Loan_WithdrawalCM=@CS_Loan_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0)         
  from @AccountTransaction a inner join savingsaccount s with (nolock) on a.accountno=s.accountno AND a.branch_id = s.branch_id         
  where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1 and         
  a.customerId in (select distinct t.customerId from @AccountTransaction t  where t.branch_id = @branch_id1         
  AND t.transdate Between @startDate1 and @endDate1 and t.product_type = 1)         
  and a.productcode in (2,3) and s.accountstatus='Closed' and (a.interest<>0 or a.interest<>NULL)        
        
  SET @CS_Loan_BalanceCM = @CS_Loan_DepositCM - @CS_Loan_WithdrawalCM;        
          
  select @CS_Total_CustomerCM=IsNull((select count(distinct customerid) from savingsAccount with (nolock) where branch_id=@branch_id1         
  AND accountopeningdate Between @startDate1 and @endDate1 and productcode in (2,3)),0),         
  @CS_Total_DepositCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0),        
  @CS_Total_WithdrawalCM=IsNull(sum(Case TransType when 1 then transAmount+adjustAmount when 0 then 0 end),0),        
  @CS_Total_FineCM=IsNull(sum(fine),0),        
  @CS_Total_BalanceCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0)-IsNull(sum(Case TransType when 1         
  then transAmount+adjustAmount when 0 then 0 end),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (2,3)        
          
  --Step 7: Setting CS Current Month        
  select @CS_Total_InterestCM=IsNull((select IsNull(sum(CASE WHEN  s.closingdate <= @endDate1 and s.accountStatus='Closed'         
  THEN 0 ELSE i.amount END),0)  as Interest from unpaidinterests i with (nolock) inner join savingsaccount s with (nolock) on         
  i.accountno = s.accountno AND i.branch_id = s.branch_id where i.branch_id=@branch_id1 AND ForTheMonth=@endDate1         
  and s.ProductCode in (2,3) ),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (2,3)        
        
  --@CS_Total_FineCM        
  select @CS_Total_FineCM=IsNull(sum(fine),0) from @AccountTransaction a inner join SavingsAccount s with (nolock)        
  on a.account_id = s.id where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1         
  and a.productcode in (2,3) and (s.accountStatus = 'Operative' or (s.AccountStatus = 'Closed' and s.closingDate>@endDate1))        
            
  select @CS_Total_Trans_InterestCM=IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0)        
  from @AccountTransaction a         
  inner join savingsaccount s with (nolock) on a.accountno=s.accountno AND a.branch_id = s.branch_id         
  where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1         
  and a.productcode in (2,3) and s.accountstatus='Closed' and (a.interest<>0 or a.interest<>NULL)        
        
  SET @CS_Total_Trans_InterestCM = IsNull(@CS_Total_Trans_InterestCM,0)        
        
  select @CS_Total_DepositCM=@CS_Total_DepositCM+@CS_Total_Trans_InterestCM,        
  @CS_Total_WithdrawalCM=@CS_Total_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0),        
  @CS_Total_BalanceCM=@CS_Total_DepositCM+@CS_Total_Trans_InterestCM-        
  (@CS_Total_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0))        
  from @AccountTransaction a         
  inner join savingsaccount s with (nolock) on a.accountno=s.accountno AND a.branch_id = s.branch_id         
  where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and a.product_type = 1         
  and a.productcode in (2,3) and s.accountstatus='Closed' and (a.interest<>0 or a.interest<>NULL)        
          
        
  set @CS_NL_CustomerCM = @CS_Total_CustomerCM - @CS_Loan_CustomerCM;        
  set @CS_NL_DepositCM = @CS_Total_DepositCM - @CS_Loan_DepositCM;        
  set @CS_NL_WithdrawalCM = @CS_Total_WithdrawalCM - @CS_Loan_WithdrawalCM;        
  set @CS_NL_InterestCM = @CS_Total_InterestCM - @CS_Loan_InterestCM;        
  set @CS_NL_FineCM = @CS_Total_FineCM - @CS_Loan_FineCM;        
  set @CS_NL_BalanceCM = @CS_Total_BalanceCM - @CS_Loan_BalanceCM;        
            
  --Step 8: Grand Total Current Month        
  -------------------------------------------------        
  select @GT_CustomerCM=IsNull((select count(customerid) from savingsAccount with (nolock) where branch_id=@branch_id1         
  AND accountopeningdate Between @startDate1 and @endDate1 and productcode in (1,5,6)),0)         
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and left(right(accountno,5),1) = 1 and a.productcode in (1)        
          
  select @GT_DepositCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0),        
  @GT_WithdrawalCM=IsNull(sum(Case TransType when 1 then transAmount+adjustAmount when 0 then 0 end),0),        
  @GT_FineCM=IsNull(sum(fine),0),        
  @GT_BalanceCM=IsNull(sum(Case TransType when 0 then transAmount when 1 then 0 end),0)-IsNull(sum(Case TransType when 1         
  then transAmount+adjustAmount when 0 then 0 end),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (1,2,3,5,6)        
          
  --Step 8: Setting CS Current Month        
  --------------------------------------------        
  select @GT_InterestCM=IsNull((select distinct IsNull(sum(CASE WHEN   s.closingdate <= @endDate1 and s.accountStatus='Closed'         
  THEN 0 ELSE i.amount END),0)  as Interest from unpaidinterests i with (nolock) inner join savingsaccount s with (nolock) on i.accountno = s.accountno         
  AND i.branch_id = s.branch_id  where i.branch_id=@branch_id1 AND ForTheMonth=@endDate1 and s.productCode in (1,2,3,5,6) ),0)        
  from @AccountTransaction a where a.branch_id=@branch_id1 AND transdate between  @startDate1 and @endDate1         
  and a.product_type = 1 and a.productcode in (1,2,3,5,6)        
        
  --@GT_FineCM        
  --------------        
  --select @GT_FineCM=IsNull(sum(fine),0) from @AccountTransaction a inner join SavingsAccount s with (nolock)        
  --on a.account_id = s.id where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1 and         
  --a.product_type = 1 and a.productcode in (1,2,3,5,6) and (s.accountStatus = 'Operative' or (s.AccountStatus = 'Closed' and s.closingDate>@endDate1))        
  --and s.customerId in (select customerId from @tempTrnsLoanCustomers where branch_id=@branch_id1)         
            
  select @GT_DepositCM=@GT_DepositCM+IsNull(Sum(Case  when a.interest>=0 then interest when  a.interest<0 then 0 end),0),        
  @GT_WithdrawalCM=@GT_WithdrawalCM+IsNull(Sum(Case when a.interest<0 then interest*(-1) when  a.interest>=0 then 0 end),0)        
  from @AccountTransaction a inner join savingsaccount s with (nolock) on a.accountno=s.accountno         
  AND a.branch_id = s.branch_id where a.branch_id=@branch_id1 AND a.transdate between @startDate1 and @endDate1        
  and a.product_type = 1 and a.productcode in (2,3,5,6) and s.accountstatus='Closed' and  s.closingdate <= @endDate1         
  and (a.interest<>0 or a.interest<>NULL)        
        
  SET @GT_BalanceCM = @GT_DepositCM - @GT_WithdrawalCM;        
          
  --Current Month Information Drop Out Customer for General Savings        
  ------------------------------------------------------------------------        
  set @GS_NLRM_DropOut = 0;        
  set @GS_NLRM_DropOut_Total = 0;        
        
   select @GS_NLRM_DropOut_Total=count(customerid) from savingsAccount with (nolock) where branch_id=@branch_id1 AND closingDate         
   Between @startDate1 and @endDate1 and productcode in (1) and AccountStatus='Closed'         
        
   --Current Month Information Drop Out Customer        
   set @CS_NLRM_DropOut = 0;        
   set @CS_NLRM_DropOut_Total = 0;        
        
   select @CS_NLRM_DropOut_Total=count(customerid) from savingsAccount with (nolock) where branch_id=@branch_id1 AND closingDate         
   Between @startDate1 and @endDate1 and productcode in (2,3) and AccountStatus='Closed'         
        
   set @GT_DropOut_Customer = 0;        
   -- -Start-Changed(Ripon) March( For Report) :2019-04-07(Nazrul vai) Previous portion      
      
   --set @GT_DropOut_Customer = @GS_NLRM_DropOut_Total + @CS_NLRM_DropOut_Total;       
          
   --end Start-Changed(Ripon) March( For Report) :2019-04-07(Nazrul vai) Previous      
         
   --Start Changed(Ripon) March( For Report) :2019-04-07(Nazrul vai) Present      
   set @GT_DropOut_Customer = @GS_NLRM_DropOut_Total;        
   --end Start-Changed(Ripon) March( For Report) :2019-04-07(Nazrul vai) Present      
      
           
   --Step 9: Setting Breakdown data        
  set @SS_Upto_2000_Customer = 0;        
  set @SS_Upto_2000_Balance = 0;        
  set @SS_2001_5000_Customer = 0;        
  set @SS_2001_5000_Balance = 0;        
  set @SS_5001_10000_Customer = 0;        
  set @SS_5001_10000_Balance = 0;        
  set @SS_10001_20000_Customer = 0;        
  set @SS_10001_20000_Balance = 0;        
  set @SS_20001Above_Customer = 0;        
  set @SS_20001Above_Balance = 0;        
  set @SS_Total_Customer = 0;        
  set @SS_Total_Balance = 0;        
  set @ss_opening_Balance = 0;        
  ---Changed by Ripon--date:2019-01-27        
  --begin        
  ----exec sp_tmpSavingsBreakdown @branch_id1,@startDate1,@endDate1        
  --end---date:2019-01-27        
        
  select @ss_opening_Balance = isnull(sum(deposit-withdrawal),0) from tblSavingsPortfolioOpeningBr with (nolock)         
  where branch_id=@branch_id1 AND openingDate<=@endDate1        
          
  select @SS_Upto_2000_Customer=count(customerId),@SS_Upto_2000_Balance=isnull(sum(opening + deposit -withdrawal),0)         
  from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1 AND  opening + deposit -withdrawal <= 2000        
        
  set @SS_Upto_2000_Balance = @SS_Upto_2000_Balance + @ss_opening_Balance;        
        
  select @SS_2001_5000_Customer=count(customerId),@SS_2001_5000_Balance=IsNULL(sum(IsNUll(opening,0)         
  + IsNUll(deposit,0) -IsNUll(withdrawal,0)),0) from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1         
  AND  opening + deposit -withdrawal between 2001 and 5000        
        
  select @SS_5001_10000_Customer=count(customerId),@SS_5001_10000_Balance=IsNULL(sum(IsNUll(opening,0)         
  + IsNUll(deposit,0) -IsNUll(withdrawal,0)),0) from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1 AND          
  opening + deposit -withdrawal between 5001 and 10000        
        
  select @SS_10001_20000_Customer=count(customerId),@SS_10001_20000_Balance=IsNULL(sum(IsNUll(opening,0)         
  + IsNUll(deposit,0) -IsNUll(withdrawal,0)),0) from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1 AND          
  opening + deposit -withdrawal between 10001 and 20000        
        
  select @SS_20001Above_Customer=count(customerId),@SS_20001Above_Balance=IsNULL(sum(IsNUll(opening,0)         
  + IsNUll(deposit,0) -IsNUll(withdrawal,0)),0) from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1 AND          
  opening + deposit -withdrawal >= 20001        
        
 -- --Changed(For March Report Previous)    
  --select @SS_Total_Customer=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  --AND productcode in (1) and accountStatus<>'Closed' and AccountOpeningDate <=@endDate1        
    
   --Changed(Boss-Nazrul:2019-04-08,For March Report Present)    
   select @SS_Total_Customer=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1 AND productcode in (1)         
  and (AccountStatus in ('Operative','Halt') or (accountStatus = 'Closed' and closingDate>@endDate1))  and AccountOpeningDate <=@endDate1    
    
          
  set @ssrealcustomerno = 0;        
        
  select @ssrealcustomerno=count(customerId),@SS_Total_Balance=IsNULL(sum(IsNUll(opening,0) + IsNUll(deposit,0) -        
  IsNUll(withdrawal,0)),0) from tmpSavingsBreakdown with (nolock) where branch_id=@branch_id1        
        
  set @SS_Total_Balance = @SS_Total_Balance + @ss_opening_Balance;        
        
  set @showcustomerno = 0;        
        
  set @showcustomerno = @ssrealcustomerno - @SS_Total_Customer;        
  set @SS_Upto_2000_Customer = @SS_Upto_2000_Customer - @showcustomerno;        
        
  select @BranchCode=orgBranchCode,@BranchName=orgBranchName,@BranchAddress=orgBranchAddress from tblConfiguration with (nolock)         
  where branch_id=@branch_id1;        
        

  set @BranchName = @BranchCode + ' - ' + @BranchName;        
          
  --Setting Closing        
  -- Step 9: Grand Total Current Month        
  --General Savings        
  select @GS_Loan_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (1) and accountStatus<>'Closed' and customerid in (select customerId from @tempTrnsLoanCustomers         
  where branch_id=@branch_id1) and AccountOpeningDate <=@endDate1        
        
  select @GS_Total_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (1) and accountStatus<>'Closed' and AccountOpeningDate <=@endDate1        
        
  select @RVS_Loan_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (0) and accountStatus<>'Closed' and customerid in (select customerId from @tempTrnsLoanCustomers )         
  and AccountOpeningDate <=@endDate1        
        
  select @RVS_Total_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (0) and accountStatus<>'Closed' and AccountOpeningDate <=@endDate1        
        
  select @CS_Loan_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (2,3) and accountStatus<>'Closed' and customerid in (select customerId from @tempTrnsLoanCustomers         
  where branch_id=@branch_id1) and AccountOpeningDate <=@endDate1        
        
  select @CS_Total_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1         
  AND productcode in (2,3) and accountStatus<>'Closed' and AccountOpeningDate <=@endDate1        
       
    
  -- --Changed(For March Report Previous)    
  --select @GT_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1 AND productcode in (1)         
  --and accountStatus<>'Closed' and AccountOpeningDate <=@endDate1        
    
    --Changed(Boss-Nazrul:2019-04-08,For March Report Present)    
   select @GT_CustomerCL=count(distinct customerId) from savingsaccount with (nolock) where branch_id=@branch_id1 AND productcode in (1)         
  and (AccountStatus in ('Operative','Halt') or (accountStatus = 'Closed' and closingDate>@endDate1))  and AccountOpeningDate <=@endDate1    
    
        
        
  --GS_Loan_CustomerCL = GS_Loan_CustomerCM        
  declare @month as int;        
  declare @year as int;        
  select @month=datepart(mm,@startDate1),@year=datepart(YYYY,@startDate1)        
        
  set @GS_Loan_DepositCL = @GS_Loan_DepositOP + @GS_Loan_DepositCM;        
  set @GS_Loan_WithdrawalCL = @GS_Loan_WithdrawalOP + @GS_Loan_WithdrawalCM;        
  set @GS_Loan_InterestCL = @GS_Loan_InterestOP + @GS_Loan_InterestCM;        
  set @GS_Loan_FineCL = @GS_Loan_FineOP + @GS_Loan_FineCM;        
  set @GS_Loan_BalanceCL = @GS_Loan_BalanceOP + @GS_Loan_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   set @GS_Loan_BalanceCL = @GS_Loan_BalanceCL + @GS_Loan_InterestCL - @GS_Loan_FineCL;        
  END        
        
  set @GS_NL_CustomerCL = @GS_Total_CustomerCL - @GS_Loan_CustomerCL;        
  set @GS_NL_DepositCL = @GS_NL_DepositOP + @GS_NL_DepositCM;        
  set @GS_NL_WithdrawalCL = @GS_NL_WithdrawalOP + @GS_NL_WithdrawalCM;        
  set @GS_NL_InterestCL = @GS_NL_InterestOP + @GS_NL_InterestCM;        
  set @GS_NL_FineCL = @GS_NL_FineOP + @GS_NL_FineCM;        
  set @GS_NL_BalanceCL = @GS_NL_BalanceOP + @GS_NL_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   set @GS_NL_BalanceCL = @GS_NL_BalanceCL + @GS_NL_InterestCL - @GS_NL_FineCL;        
  END        
        
  --GS_Total_CustomerCL = GS_Total_CustomerCM;        
  set @GS_Total_DepositCL = @GS_Total_DepositOP + @GS_Total_DepositCM;        
  set @GS_Total_WithdrawalCL = @GS_Total_WithdrawalOP + @GS_Total_WithdrawalCM;        
  set @GS_Total_InterestCL = @GS_Total_InterestOP + @GS_Total_InterestCM;        
  set @GS_Total_FineCL = @GS_Total_FineOP + @GS_Total_FineCM;        
  set @GS_Total_BalanceCL = @GS_Total_BalanceOP + @GS_Total_BalanceCM;        
        
  if (@month = 6)        
  BEGIN        
   set @GS_Total_BalanceCL = @GS_Total_BalanceCL - @GS_Total_FineCL + @GS_Total_InterestCL ;        
  END        
        
  --RVS_Loan_CustomerCL = RVS_Loan_CustomerCM;        
  set @RVS_Loan_DepositCL = @RVS_Loan_DepositOP + @RVS_Loan_DepositCM;        
  set @RVS_Loan_WithdrawalCL = @RVS_Loan_WithdrawalOP + @RVS_Loan_WithdrawalCM;        
  set @RVS_Loan_InterestCL = @RVS_Loan_InterestOP + @RVS_Loan_InterestCM;        
  set @RVS_Loan_FineCL = @RVS_Loan_FineOP + @RVS_Loan_FineCM;        
  set @RVS_Loan_BalanceCL = @RVS_Loan_BalanceOP + @RVS_Loan_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   set @RVS_Loan_BalanceCL = @RVS_Loan_BalanceCL + @RVS_Loan_InterestCL - @RVS_Loan_FineCL;        
  END        
        
  set @RVS_NL_CustomerCL = @RVS_Total_CustomerCL - @RVS_Loan_CustomerCL;        
  set @RVS_NL_DepositCL = @RVS_NL_DepositOP + @RVS_NL_DepositCM;        
  set @RVS_NL_WithdrawalCL = @RVS_NL_WithdrawalOP + @RVS_NL_WithdrawalCM;        
  set @RVS_NL_InterestCL = @RVS_NL_InterestOP + @RVS_NL_InterestCM;        
  set @RVS_NL_FineCL = @RVS_NL_FineOP + @RVS_NL_FineCM;        
  set @RVS_NL_BalanceCL = @RVS_NL_BalanceOP + @RVS_NL_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   set @RVS_NL_BalanceCL = @RVS_NL_BalanceCL + @RVS_NL_InterestCL - @RVS_NL_FineCL;        
  END        
        
  --RVS_Total_CustomerCL = RVS_Total_CustomerCM;        
  set @RVS_Total_DepositCL = @RVS_Total_DepositOP + @RVS_Total_DepositCM;        
  set @RVS_Total_WithdrawalCL = @RVS_Total_WithdrawalOP + @RVS_Total_WithdrawalCM;        
  set @RVS_Total_InterestCL = @RVS_Total_InterestOP + @RVS_Total_InterestCM;        
  set @RVS_Total_FineCL = @RVS_Total_FineOP + @RVS_Total_FineCM;        
  set @RVS_Total_BalanceCL = @RVS_Total_BalanceOP + @RVS_Total_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   set @RVS_Total_BalanceCL = @RVS_Total_BalanceCL + @RVS_Total_InterestCL - @RVS_Total_FineCL;        
  END        
        
          
        
  --CS_Loan_CustomerCL = CS_Loan_CustomerCM;        
  set @CS_Loan_DepositCL = @CS_Loan_DepositOP + @CS_Loan_DepositCM;        
  set @CS_Loan_WithdrawalCL = @CS_Loan_WithdrawalOP + @CS_Loan_WithdrawalCM;        
  set @CS_Loan_InterestCL = @CS_Loan_InterestOP + @CS_Loan_InterestCM;        
  set @CS_Loan_FineCL = @CS_Loan_FineOP + @CS_Loan_FineCM;        
  set @CS_Loan_BalanceCL = @CS_Loan_BalanceOP + @CS_Loan_BalanceCM-@CS_Loan_Trans_InterestCM;        
 --      if (@month = 6)        
  --BEGIN        
 --          set @CS_Loan_BalanceCL = @CS_Loan_BalanceCL + @CS_Loan_InterestCL - @CS_Loan_FineCL;        
  --END        
        
          
  set @CS_NL_CustomerCL = @CS_Total_CustomerCL - @CS_Loan_CustomerCL;        
  set @CS_NL_DepositCL = @CS_NL_DepositOP + @CS_NL_DepositCM;        
  set @CS_NL_WithdrawalCL = @CS_NL_WithdrawalOP + @CS_NL_WithdrawalCM;        
  set @CS_NL_InterestCL = @CS_NL_InterestOP + @CS_NL_InterestCM;        
  set @CS_NL_FineCL = @CS_NL_FineOP + @CS_NL_FineCM;        
  set @CS_NL_BalanceCL = @CS_NL_BalanceOP + @CS_NL_BalanceCM -(@CS_Total_Trans_InterestCM-@CS_Loan_Trans_InterestCM);        
 --      if (@month = 6)        
  --BEGIN        
 --          set @CS_NL_BalanceCL = @CS_NL_BalanceCL + @CS_NL_InterestCL - @CS_NL_FineCL;        
  --END        
        
          
  --CS_Total_CustomerCL = CS_Total_CustomerCM;        
  set @CS_Total_DepositCL = @CS_Total_DepositOP + @CS_Total_DepositCM;        
  set @CS_Total_WithdrawalCL = @CS_Total_WithdrawalOP + @CS_Total_WithdrawalCM;        
  set @CS_Total_InterestCL = @CS_Total_InterestOP + @CS_Total_InterestCM;        
  set @CS_Total_FineCL = @CS_Total_FineOP + @CS_Total_FineCM;        
  set @CS_Total_BalanceCL = @CS_Total_BalanceOP + @CS_Total_BalanceCM-@CS_Total_Trans_InterestCM;        
 --      if (@month = 6)        
  --BEGIN        
 --          set @CS_Total_BalanceCL = @CS_Total_BalanceCL + @CS_Total_InterestCL - @CS_Total_FineCL;        
  --END        
        
        
  --GT_CustomerCL = GT_CustomerCM;        
  set @GT_DepositCL = @GT_DepositOP + @GT_DepositCM;        
  set @GT_WithdrawalCL = @GT_WithdrawalOP + @GT_WithdrawalCM;        
  set @GT_InterestCL = @GT_InterestOP + @GT_InterestCM;        
          
  set @GT_FineCM=@GS_Total_FineCM + @CS_Total_FineCM        
  set @GT_FineCL = @GT_FineOP + @GT_FineCM;        
  set @GT_BalanceCL = @GT_BalanceOP + @GT_BalanceCM;        
  if (@month = 6)        
  BEGIN        
   --set @GT_BalanceCL = @GT_BalanceCL + @GT_InterestCL - @GT_FineCL;        
   set @GT_BalanceCL = @GS_Total_BalanceCL + @CS_Total_BalanceCL + @RVS_Total_BalanceCL        
  END        
        
  --Excluding June Interest 20180630        
  ---------------------------------        
  --SET @CS_Loan_InterestCL = @CS_Loan_InterestCL - @CS_Loan_InterestOPJune        
  --SET @CS_NL_InterestCL = @CS_NL_InterestCL - @CS_NL_InterestOPJune        
  --SET @CS_Total_InterestCL = @CS_Total_InterestCL - @csJuneInterest        
  --SET @GT_InterestCL = @GT_InterestCL - @csJuneInterest        
        
        
        
  --Adjust for Transfer        
  ----------------------------        
  --SET @GS_Loan_CustomerCL = @GS_Loan_CustomerCL + @GS_Loan_CustomerOPT        
  --SET @GS_Total_CustomerCL = @GS_Total_CustomerCL + @GS_Total_CustomerOPT        
        
  --SET @RVS_Loan_CustomerCL = @RVS_Loan_CustomerCL + @RVS_Loan_CustomerOPT        
  --SET @RVS_Total_CustomerCL = @RVS_Total_CustomerCL + @RVS_Total_CustomerOPT        
        
  --SET @CS_Loan_CustomerCL = @CS_Loan_CustomerCL + @CS_Loan_CustomerOPT        
  --SET @CS_Total_CustomerCL = @CS_Total_CustomerCL + @CS_Total_CustomerOPT        
        
  --SET @GT_CustomerCL = @GT_CustomerCL + @GT_CustomerOPT        
        
        
  set @GS_Loan_DepositCL = @GS_Loan_DepositCL + @GS_Loan_DepositOPT;        
  set @GS_Loan_WithdrawalCL = @GS_Loan_WithdrawalCL + @GS_Loan_WithdrawalOPT;        
  set @GS_Loan_InterestCL = @GS_Loan_InterestCL + @GS_Loan_InterestOPT;        
  set @GS_Loan_FineCL = @GS_Loan_FineCL + @GS_Loan_FineOPT;        
  set @GS_Loan_BalanceCL = @GS_Loan_BalanceCL + @GS_Loan_BalanceOPT;        
               
        
  --set @GS_NL_CustomerCL = @GS_NL_CustomerCL + @GS_NL_CustomerOPT        
  set @GS_NL_DepositCL = @GS_NL_DepositCL + @GS_NL_DepositOPT;        
  set @GS_NL_WithdrawalCL = @GS_NL_WithdrawalCL + @GS_NL_WithdrawalOPT;        
  set @GS_NL_InterestCL = @GS_NL_InterestCL + @GS_NL_InterestOPT;        
  set @GS_NL_FineCL = @GS_NL_FineCL + @GS_NL_FineOPT;        
  set @GS_NL_BalanceCL = @GS_NL_BalanceCL + @GS_NL_BalanceOPT;        
            
  set @GS_Total_DepositCL = @GS_Total_DepositCL + @GS_Total_DepositOPT;        
  set @GS_Total_WithdrawalCL = @GS_Total_WithdrawalCL + @GS_Total_WithdrawalOPT;        
  set @GS_Total_InterestCL = @GS_Total_InterestCL + @GS_Total_InterestOPT;        
  set @GS_Total_FineCL = @GS_Total_FineCL + @GS_Total_FineOPT;        
  set @GS_Total_BalanceCL = @GS_Total_BalanceCL + @GS_Total_BalanceOPT;        
               
  set @RVS_Loan_DepositCL = @RVS_Loan_DepositCL + @RVS_Loan_DepositOPT;        
  set @RVS_Loan_WithdrawalCL = @RVS_Loan_WithdrawalCL + @RVS_Loan_WithdrawalOPT;        
  set @RVS_Loan_InterestCL = @RVS_Loan_InterestCL + @RVS_Loan_InterestOPT;        
  set @RVS_Loan_FineCL = @RVS_Loan_FineCL + @RVS_Loan_FineOPT;        
  set @RVS_Loan_BalanceCL = @RVS_Loan_BalanceCL + @RVS_Loan_BalanceOPT;        
               
  --set @RVS_NL_CustomerCL = @RVS_NL_CustomerCL + @RVS_NL_CustomerOPT;        
  set @RVS_NL_DepositCL = @RVS_NL_DepositCL + @RVS_NL_DepositOPT;        
  set @RVS_NL_WithdrawalCL = @RVS_NL_WithdrawalCL + @RVS_NL_WithdrawalOPT;        
  set @RVS_NL_InterestCL = @RVS_NL_InterestCL + @RVS_NL_InterestOPT;        
  set @RVS_NL_FineCL = @RVS_NL_FineCL + @RVS_NL_FineOPT;        
  set @RVS_NL_BalanceCL = @RVS_NL_BalanceCL + @RVS_NL_BalanceOPT;        
               
  set @RVS_Total_DepositCL = @RVS_Total_DepositCL + @RVS_Total_DepositOPT;        
  set @RVS_Total_WithdrawalCL = @RVS_Total_WithdrawalCL + @RVS_Total_WithdrawalOPT;        
  set @RVS_Total_InterestCL = @RVS_Total_InterestCL + @RVS_Total_InterestOPT;        
  set @RVS_Total_FineCL = @RVS_Total_FineCL + @RVS_Total_FineOPT;        
  set @RVS_Total_BalanceCL = @RVS_Total_BalanceCL + @RVS_Total_BalanceOPT;        
                
  set @CS_Loan_DepositCL = @CS_Loan_DepositCL + @CS_Loan_DepositOPT;        
  set @CS_Loan_WithdrawalCL = @CS_Loan_WithdrawalCL --+ @CS_Loan_WithdrawalOPT;        
  set @CS_Loan_InterestCL = @CS_Loan_InterestCL + @CS_Loan_InterestOPT;        
  set @CS_Loan_FineCL = @CS_Loan_FineCL + @CS_Loan_FineOPT;        
  set @CS_Loan_BalanceCL = @CS_Loan_BalanceCL + @CS_Loan_BalanceOPT;        
        
  --Changed 2018-06-24        
   --set @CS_NL_CustomerCL = @CS_NL_CustomerCL + @CS_NL_CustomerOPT;        
  set @CS_NL_DepositCL = @CS_NL_DepositCL + @CS_NL_DepositOPT;        
  set @CS_NL_WithdrawalCL = @CS_NL_WithdrawalCL --+ @CS_NL_WithdrawalOPT;        
  set @CS_NL_InterestCL = @CS_NL_InterestCL + @CS_NL_InterestOPT;        
  set @CS_NL_FineCL = @CS_NL_FineCL + @CS_NL_FineOPT;        
  set @CS_NL_BalanceCL = @CS_NL_BalanceCL+@CS_NL_BalanceOPT;        
  set @CS_NL_BalanceCL = @CS_NL_BalanceCL+@CS_NL_BalanceOPT;        
  --Changed 2018-06-24        
        
  set @CS_Total_DepositCL = @CS_Total_DepositCL + @CS_Total_DepositOPT;        
  set @CS_Total_WithdrawalCL = @CS_Total_WithdrawalCL-- + @CS_Total_WithdrawalOPT;        
  set @CS_Total_InterestCL = @CS_Total_InterestCL + @CS_Total_InterestOPT;        
  set @CS_Total_FineCL = @CS_Total_FineCL + @CS_Total_FineOPT;        
  set @CS_Total_BalanceCL = @CS_Total_BalanceCL + @CS_Total_BalanceOPT;        
  --Changed 2018-06-24        
        
          
  set @GT_DepositCL = @GT_DepositCL + @GT_DepositOPT;        
        
  set @GT_WithdrawalCL = @GT_WithdrawalCL + @GT_WithdrawalOPT;        
  set @GT_InterestCL = @GT_InterestCL + @GT_InterestOPT;        
  set @GT_FineCL = @GT_FineCL + @GT_FineOPT;        
  set @GT_BalanceCL = @GT_BalanceCL + @GT_BalanceOPT;        
  set @GT_BalanceCL = @GT_BalanceCL + @CS_Total_InterestOP_June-@CS_Total_WithdrawalCL-@CS_Total_WithdrawalCM;        
        
  -----------Approved/June inerest Adjustment--------------        
  ---------------------------------------------------------------------        
  set @CS_Loan_InterestOP=@CS_Loan_InterestOP-@CS_Loan_InterestOP_June        
  set @CS_NL_InterestOP=@CS_NL_InterestOP-@CS_NL_InterestOP_June        
        
  if @CS_Loan_InterestOP<0        
  Begin        
   set @CS_Loan_InterestOP=@CS_Loan_InterestOP*(-1)        
   set @CS_NL_InterestOP = @CS_NL_InterestOP -@CS_Loan_InterestOP        
  End        
        
  if @CS_NL_InterestOP < 0        
   set @CS_NL_InterestOP = 0        
        
  set @CS_Total_InterestOP= @CS_Loan_InterestOP+@CS_NL_InterestOP        
  SET @GT_InterestOP = @CS_Total_InterestOP + @GS_Total_InterestOP        
        
  ----Desktop 20180630        
  --set @CS_Loan_InterestCL = @CS_Loan_InterestOP + @CS_Loan_InterestCM + @CS_Loan_InterestOP_June        
  --set @CS_NL_InterestCL = @CS_NL_InterestOP + @CS_NL_InterestCM + @CS_NL_InterestOP_June        
          
  -- ---Opeinging Deposit        
        
     SET @CS_Loan_DepositOP = @CS_Loan_DepositOP +@CS_Loan_WithdrawalOP        
  SET @CS_NL_DepositOP = @CS_NL_DepositOP +@CS_NL_WithdrawalOP     
  SET @CS_Total_DepositOP = @CS_Total_DepositOP +@CS_Total_WithdrawalOP        
  set @GT_DepositOP=@CS_Total_DepositOP+@GS_Total_DepositOP        
  SET @GT_DepositOP = @GT_DepositOP --+@GT_WithdrawalOP        
        
  ---Opeinging Withdrawal        
  set @CS_Loan_InterestCL=@CS_Loan_InterestOP+@CS_Loan_InterestCM        
  set @CS_Total_InterestCL = @CS_Total_InterestOP + @CS_Total_InterestCM---@CS_Total_InterestOP_June        
        
  set @CS_NL_InterestCL=@CS_Total_InterestCL-@CS_Loan_InterestCL        
  set @GT_InterestCL = @CS_Total_InterestCL + @GS_Total_InterestCL        
        
     SET @CS_Loan_BalanceOP = @CS_Loan_DepositOP -@CS_Loan_WithdrawalOP        
  SET @CS_NL_BalanceOP = @CS_NL_DepositOP -@CS_NL_WithdrawalOP        
  SET @CS_Total_BalanceOP = @CS_Total_DepositOP -@CS_Total_WithdrawalOP        
  SET @GT_BalanceOP = @GT_DepositOP -@GT_WithdrawalOP        
          
  if @CS_Loan_WithdrawalCL=0        
  begin        
  set @CS_NL_WithdrawalCL=@CS_Total_WithdrawalCL        
  end        
  set @CS_Loan_DepositCL=@CS_Loan_DepositCL+@CS_Loan_WithdrawalOP        
  set @CS_NL_DepositCL=@CS_NL_DepositCL+@CS_NL_WithdrawalOP        
  set @CS_Total_DepositCL=@CS_Total_DepositCL+@CS_Total_WithdrawalOP        
  set @GT_DepositCL=@CS_Total_DepositCL+@GS_Total_DepositCL--+@GT_WithdrawalOP        
           
 ----start changed 2019-04-08(Ripon) previous portion    
 -- set @CS_Loan_BalanceCL=@CS_Loan_DepositCL-@CS_Loan_WithdrawalCL+@CS_Loan_InterestOP_June        
 -- set @CS_NL_BalanceCL=@CS_NL_DepositCL-@CS_NL_WithdrawalCL+@CS_NL_InterestOP_June        
 -- set @CS_Total_BalanceCL=@CS_Total_DepositCL-@CS_Total_WithdrawalCL+@CS_Total_InterestOP_June        
 ----end changed 2019-04-08(Ripon) previous    
    
 --start changed 2019-04-08(Ripon) Present portion    
  set @CS_Loan_BalanceCL=@CS_Loan_DepositCL-@CS_Loan_WithdrawalCL+@CS_Loan_InterestOP_June+ @CS_Loan_ApprovedInterestOPT-- +@CS_Loan_WithdrawalOPT      
  set @CS_NL_BalanceCL=@CS_NL_DepositCL-@CS_NL_WithdrawalCL+@CS_NL_InterestOP_June+@CS_NL_ApprovedInterestOPT   --+@CS_NL_WithdrawalOPT     
  set @CS_Total_BalanceCL=@CS_Total_DepositCL-@CS_Total_WithdrawalCL+@CS_Total_InterestOP_June+@CS_Total_ApprovedInterestOPT -- +@CS_Total_WithdrawalOPT      
 --end changed 2019-04-08(Ripon) present    
    
     --start changed 2019-04-09(Ripon)    
  set @CS_Loan_InterestCL=@CS_Loan_InterestCL+@CS_Loan_InterestOPT  
  set @CS_NL_InterestCL=@CS_NL_InterestCL+@CS_NL_InterestOPT  
  set @CS_Total_InterestCL=@CS_Loan_InterestCL+@CS_NL_InterestCL  
  set @GT_InterestCL=@CS_Total_InterestCL+@GS_Total_InterestCL  
  
  set @CS_Loan_WithdrawalOP=@CS_Loan_WithdrawalOP-@CS_Loan_WithdrawalOPT    
 set @CS_NL_WithdrawalOP=@CS_NL_WithdrawalOP-@CS_NL_WithdrawalOPT    
 set @CS_Total_WithdrawalOP=@CS_Total_WithdrawalOP-@CS_Total_WithdrawalOPT    
 if @CS_NL_BalanceOP<0    
 begin    
 set @CS_NL_BalanceOP=0    
 end    
 if @CS_Total_BalanceOP<0    
 begin    
 set @CS_Total_BalanceOP=0    
 end    
  --end changed 2019-04-08(Ripon)    
    
   set @GT_BalanceCL=@CS_Total_BalanceCL+@GS_Total_BalanceCL---@GT_WithdrawalCL+--+@CS_Total_InterestOP_June      
      
        
    --start changed 2019-04-08(Ripon)    
    
    --set @CS_Loan_WithdrawalOP=@CS_Loan_WithdrawalOP-@CS_Loan_WithdrawalOPT    
  if @CS_Loan_WithdrawalOP<0    
  begin    
   set @CS_Loan_WithdrawalOP=0    
  end    
    
-- set @CS_NL_WithdrawalOP=@CS_NL_WithdrawalOP-@CS_NL_WithdrawalOPT    
 if @CS_NL_WithdrawalOP<0    
  begin    
   set @CS_NL_WithdrawalOP=0    
  end    
    
-- set @CS_Total_WithdrawalOP=@CS_Total_WithdrawalOP-@CS_Total_WithdrawalOPT    
 if @CS_Total_WithdrawalOP<0    
  begin    
   set @CS_Total_WithdrawalOP=0    
  end    
 if @CS_NL_BalanceOP<0    
 begin    
 set @CS_NL_BalanceOP=0    
 end    
 if @CS_Total_BalanceOP<0    
 begin    
 set @CS_Total_BalanceOP=0    
 end    
  --end changed 2019-04-08(Ripon)    
    
    
 -- set @CS_Total_InterestCL = @CS_Loan_InterestCL + @CS_NL_InterestCL        
 -- set @GT_InterestCL = @CS_Total_InterestCL + @GS_Total_InterestCL        
 -------------------------------------------------------------------------------------------        
          
 -- ---Changed for Closing Customer Date:2019-01-31(Ripon) Previous Portion       
 --SET @GS_Loan_CustomerCL=@GS_Loan_CustomerOP+@GS_Loan_CustomerCM-@GS_NLRM_DropOut       
 --SET @GS_NL_CustomerCL=@GS_NL_CustomerOP+@GS_NL_CustomerCM-@GS_NLRM_DropOut_Total      
 --SET @GS_Total_CustomerCL=@GS_Loan_CustomerCL+@GS_NL_CustomerCL      
        
  --- ---Changed for Closing Customer Date:2019-04-07(Ripon-Nazrul vai) March Present Portion      
 SET @GS_Loan_CustomerCL=@GS_Loan_CustomerOP+@GS_Loan_CustomerCM-@GS_NLRM_DropOut+@GS_Loan_CustomerOPT        
 SET @GS_NL_CustomerCL=@GS_NL_CustomerOP+@GS_NL_CustomerCM-@GS_NLRM_DropOut_Total +@GS_NL_CustomerOPT       
 SET @GS_Total_CustomerCL=@GS_Loan_CustomerCL+@GS_NL_CustomerCL     
      
  --end  Date:2019-04-07      
  -------------------------------------------------------------------------------        
          
 if (@GT_BalanceCL > @SS_Total_Balance)        
   begin        
    set @SS_Upto_2000_Balance = @SS_Upto_2000_Balance + (@GT_BalanceCL - @SS_Total_Balance);        
    set @SS_Total_Balance = @SS_Total_Balance + (@GT_BalanceCL - @SS_Total_Balance);        
   end        
  else        
   begin        
    if (@SS_Upto_2000_Balance - (@SS_Total_Balance - @GT_BalanceCL) >= 0)        
     begin        
      set @SS_Upto_2000_Balance = @SS_Upto_2000_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
    else if (@SS_2001_5000_Balance - (@SS_Total_Balance - @GT_BalanceCL) >= 0)        
     begin        
      set @SS_2001_5000_Balance = @SS_2001_5000_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
    else if (@SS_5001_10000_Balance - (@SS_Total_Balance - @GT_BalanceCL) >= 0)        
     begin        
      set @SS_5001_10000_Balance = @SS_5001_10000_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
    else if (@SS_10001_20000_Balance - (@SS_Total_Balance - @GT_BalanceCL) >= 0)        
     begin        
      set @SS_10001_20000_Balance = @SS_10001_20000_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
    else if (@SS_20001Above_Balance - (@SS_Total_Balance - @GT_BalanceCL) >= 0)        
     begin        
      set @SS_20001Above_Balance = @SS_20001Above_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
    else        
     begin        
      set @SS_Total_Balance = @SS_Total_Balance - (@SS_Total_Balance - @GT_BalanceCL);        
     end        
   end 
         
  print '@CS_Total_BalanceCL_08' + cast(@CS_Total_BalanceCL as nvarchar(100))        
  print '@CS_NL_ApprovedInterestOPT' + cast(@CS_NL_ApprovedInterestOPT as nvarchar(100))        
  print '@CS_Total_ApprovedInterestOPT' + cast(@CS_Total_ApprovedInterestOPT as nvarchar(100)) 
  
  SET @GS_Total = @GS_Total_DepositOP + @GS_Total_WithdrawalOP + @GS_Total_InterestOP + @GS_Total_FineOP + @GS_Total_BalanceOP + @GS_Total_CustomerOP + @GS_Total_DepositCM + @GS_Total_WithdrawalCM + @GS_Total_InterestCM + @GS_Total_FineCM + @GS_Total_CustomerCM + @GS_Total_DepositCL + @GS_Total_WithdrawalCL + @GS_Total_InterestCL + @GS_Total_FineCL + @GS_Total_BalanceCL + @GS_Total_CustomerCL
  SET @RVS_Total = @RVS_Total_DepositOP + @RVS_Total_WithdrawalOP + @RVS_Total_InterestOP + @RVS_Total_FineOP + @RVS_Total_BalanceOP + @RVS_Total_CustomerOP + @RVS_Total_DepositCM + @RVS_Total_WithdrawalCM + @RVS_Total_InterestCM + @RVS_Total_FineCM + @RVS_Total_CustomerCM + @RVS_Total_DepositCL + @RVS_Total_WithdrawalCL + @RVS_Total_InterestCL + @RVS_Total_FineCL + @RVS_Total_BalanceCL + @RVS_Total_CustomerCL
  SET @CS_Total = @CS_Total_DepositOP + @CS_Total_WithdrawalOP + @CS_Total_InterestOP + @CS_Total_FineOP + @CS_Total_BalanceOP + @CS_Total_CustomerOP + @CS_Total_DepositCM + @CS_Total_WithdrawalCM + @CS_Total_InterestCM + @CS_Total_FineCM + @CS_Total_CustomerCM + @CS_Total_DepositCL + @CS_Total_WithdrawalCL + @CS_Total_InterestCL + @CS_Total_FineCL + @CS_Total_BalanceCL + @CS_Total_CustomerCL
  SET @Grand_Total = @GS_Total + @RVS_Total + @CS_Total
  
  select  @month Month,        
  @year Year,
  @GS_Total GS_Total,
  @RVS_Total RVS_Total,
  @CS_Total CS_Total,
  @Grand_Total Grand_Total,
  @GS_Loan_DepositOP GS_Loan_Deposit_OP,        
  @GS_Loan_WithdrawalOP GS_Loan_Withdrawal_OP,        
  @GS_Loan_InterestOP GS_Loan_Interest_OP,         
  @GS_Loan_FineOP GS_Loan_Fine_OP,        
  @GS_Loan_BalanceOP GS_Loan_Balance_OP,         
  @GS_Loan_CustomerOP GS_Loan_Customer_OP,         
  @RVS_Loan_DepositOP RVS_Loan_Deposit_OP,         
  @RVS_Loan_WithdrawalOP RVS_Loan_Withdrawal_OP,         
  @RVS_Loan_InterestOP RVS_Loan_Interest_OP,         
  @RVS_Loan_FineOP RVS_Loan_Fine_OP,         
  @RVS_Loan_BalanceOP RVS_Loan_Balance_OP,         
  @RVS_Loan_CustomerOP RVS_Loan_Customer_OP,         
  @CS_Loan_DepositOP CS_Loan_Deposit_OP ,        
  @CS_Loan_WithdrawalOP CS_Loan_Withdrawal_OP,         
  @CS_Loan_InterestOP CS_Loan_Interest_OP ,        
  @CS_Loan_InterestOP_June CS_Loan_Interest_OP_June ,        
  @CS_NL_InterestOP_June CS_NL_Interest_OP_June ,        
  @CS_Total_InterestOP_June CS_Total_Interest_OP_June ,       
 
  @CS_Loan_FineOP CS_Loan_Fine_OP ,        
  @CS_Loan_BalanceOP CS_Loan_Balance_OP ,        
  @CS_Loan_CustomerOP CS_Loan_Customer_OP,         
  @GS_NL_DepositOP GS_NL_Deposit_OP ,        
  @GS_NL_WithdrawalOP GS_NL_Withdrawal_OP ,        
  @GS_NL_InterestOP GS_NL_Interest_OP ,        
  @GS_NL_FineOP GS_NL_Fine_OP,         
  @GS_NL_BalanceOP GS_NL_Balance_OP ,        
  @GS_NL_CustomerOP GS_NL_Customer_OP ,        
  @RVS_NL_DepositOP RVS_NL_Deposit_OP ,        
  @RVS_NL_WithdrawalOP RVS_NL_Withdrawal_OP ,        
  @RVS_NL_InterestOP RVS_NL_Interest_OP ,        
  @RVS_NL_FineOP RVS_NL_Fine_OP,         
  @RVS_NL_BalanceOP RVS_NL_Balance_OP ,        
  @RVS_NL_CustomerOP RVS_NL_Customer_OP ,        
  @CS_NL_DepositOP CS_NL_Deposit_OP,         
  @CS_NL_WithdrawalOP CS_NL_Withdrawal_OP ,        
  @CS_NL_InterestOP CS_NL_Interest_OP ,        
  @CS_NL_FineOP CS_NL_Fine_OP ,        
  @CS_NL_BalanceOP CS_NL_Balance_OP ,        
  @CS_NL_CustomerOP CS_NL_Customer_OP,         
  @GS_Total_DepositOP GS_Total_Deposit_OP,         
  @GS_Total_WithdrawalOP GS_Total_Withdrawal_OP ,        
  @GS_Total_InterestOP GS_Total_Interest_OP,         
  @GS_Total_FineOP GS_Total_Fine_OP ,        
  @GS_Total_BalanceOP GS_Total_Balance_OP ,        
  @GS_Total_CustomerOP GS_Total_Customer_OP ,        
  @RVS_Total_DepositOP RVS_Total_Deposit_OP ,        
  @RVS_Total_WithdrawalOP RVS_Total_Withdrawal_OP,         
  @RVS_Total_InterestOP RVS_Total_Interest_OP,         
  @RVS_Total_FineOP RVS_Total_Fine_OP ,        
  @RVS_Total_BalanceOP RVS_Total_Balance_OP ,        
  @RVS_Total_CustomerOP RVS_Total_Customer_OP ,        
  @CS_Total_DepositOP CS_Total_Deposit_OP ,        
  @CS_Total_WithdrawalOP CS_Total_Withdrawal_OP ,        
  @CS_Total_InterestOP CS_Total_Interest_OP ,        
  @CS_Total_FineOP CS_Total_Fine_OP ,        
  @CS_Total_BalanceOP CS_Total_Balance_OP ,        
  @CS_Total_CustomerOP CS_Total_Customer_OP ,        
  @GT_DepositOP GT_Deposit_OP ,        
  @GT_WithdrawalOP GT_Withdrawal_OP,         
  @GT_InterestOP GT_Interest_OP ,        
  @GT_FineOP GT_Fine_OP ,        
  @GT_BalanceOP GT_Balance_OP ,        
  @GT_CustomerOP GT_Customer_OP ,        
  @GS_Loan_DepositCM GS_Loan_Deposit_CM ,        
  @GS_Loan_WithdrawalCM GS_Loan_Withdrawal_CM ,        
  @GS_Loan_InterestCM GS_Loan_Interest_CM ,        
  @GS_Loan_FineCM GS_Loan_Fine_CM ,        
  @GS_Loan_BalanceCM GS_Loan_Balance_CM ,        
  @GS_Loan_CustomerCM GS_Loan_Customer_CM ,        
  @RVS_Loan_DepositCM RVS_Loan_Deposit_CM ,        
  @RVS_Loan_WithdrawalCM RVS_Loan_Withdrawal_CM ,        
  @RVS_Loan_InterestCM RVS_Loan_Interest_CM ,        
  @RVS_Loan_FineCM RVS_Loan_Fine_CM ,        
  @RVS_Loan_BalanceCM RVS_Loan_Balance_CM ,        
  @RVS_Loan_CustomerCM RVS_Loan_Customer_CM ,        
  @CS_Loan_DepositCM CS_Loan_Deposit_CM ,        
  @CS_Loan_WithdrawalCM CS_Loan_Withdrawal_CM ,        
  @CS_Loan_InterestCM CS_Loan_Interest_CM ,        
  @CS_Loan_FineCM CS_Loan_Fine_CM ,        
  @CS_Loan_BalanceCM CS_Loan_Balance_CM ,        
  @CS_Loan_CustomerCM CS_Loan_Customer_CM ,        
  @GS_NL_DepositCM GS_NL_Deposit_CM ,        
  @GS_NL_WithdrawalCM GS_NL_Withdrawal_CM ,        
  @GS_NL_InterestCM GS_NL_Interest_CM ,        
  @GS_NL_FineCM GS_NL_Fine_CM ,        
  @GS_NL_BalanceCM GS_NL_Balance_CM ,        
  @GS_NL_CustomerCM GS_NL_Customer_CM ,        
  @RVS_NL_DepositCM RVS_NL_Deposit_CM ,        
  @RVS_NL_WithdrawalCM RVS_NL_Withdrawal_CM ,        
  @RVS_NL_InterestCM RVS_NL_Interest_CM ,        
  @RVS_NL_FineCM RVS_NL_Fine_CM ,        
  @RVS_NL_BalanceCM RVS_NL_Balance_CM ,        
  @RVS_NL_CustomerCM RVS_NL_Customer_CM ,        
  @CS_NL_DepositCM CS_NL_Deposit_CM ,        
  @CS_NL_WithdrawalCM CS_NL_Withdrawal_CM ,        
  @CS_NL_InterestCM CS_NL_Interest_CM ,        
  @CS_NL_FineCM CS_NL_Fine_CM ,        
  @CS_NL_BalanceCM CS_NL_Balance_CM ,        
  @CS_NL_CustomerCM CS_NL_Customer_CM ,        
  @GS_Total_DepositCM GS_Total_Deposit_CM ,        
  @GS_Total_WithdrawalCM GS_Total_Withdrawal_CM ,        
  @GS_Total_InterestCM GS_Total_Interest_CM ,        
  @GS_Total_FineCM GS_Total_Fine_CM ,    
  @GS_Total_BalanceCM GS_Total_Balance_CM ,        
  @GS_Total_CustomerCM GS_Total_Customer_CM ,        
  @RVS_Total_DepositCM RVS_Total_Deposit_CM ,        
  @RVS_Total_WithdrawalCM RVS_Total_Withdrawal_CM ,        
  @RVS_Total_InterestCM RVS_Total_Interest_CM ,        
  @RVS_Total_FineCM RVS_Total_Fine_CM ,        
  @RVS_Total_BalanceCM RVS_Total_Balance_CM ,        
  @RVS_Total_CustomerCM RVS_Total_Customer_CM ,        
  @CS_Total_DepositCM CS_Total_Deposit_CM ,        
  @CS_Total_WithdrawalCM CS_Total_Withdrawal_CM,         
  @CS_Total_InterestCM CS_Total_Interest_CM ,        
  @CS_Total_FineCM CS_Total_Fine_CM ,        
  @CS_Total_BalanceCM CS_Total_Balance_CM ,        
  @CS_Total_CustomerCM CS_Total_Customer_CM ,        
  @GT_DepositCM GT_Deposit_CM ,        
  @GT_WithdrawalCM GT_Withdrawal_CM ,        
  @GT_InterestCM GT_Interest_CM ,        
  @GT_FineCM GT_Fine_CM ,        
  @GT_BalanceCM GT_Balance_CM ,        
  @GT_CustomerCM GT_Customer_CM ,        
  @GS_Loan_DepositCL GS_Loan_Deposit_CL ,        
  @GS_Loan_WithdrawalCL GS_Loan_Withdrawal_CL ,        
  @GS_Loan_InterestCL GS_Loan_Interest_CL ,        
  @GS_Loan_FineCL GS_Loan_Fine_CL ,        
  @GS_Loan_BalanceCL GS_Loan_Balance_CL,         
  @GS_Loan_CustomerCL GS_Loan_Customer_CL ,        
  @RVS_Loan_DepositCL RVS_Loan_Deposit_CL ,        
  @RVS_Loan_WithdrawalCL RVS_Loan_Withdrawal_CL,         
  @RVS_Loan_InterestCL RVS_Loan_Interest_CL,         
  @RVS_Loan_FineCL RVS_Loan_Fine_CL ,        
  @RVS_Loan_BalanceCL RVS_Loan_Balance_CL ,        
  @RVS_Loan_CustomerCL RVS_Loan_Customer_CL ,        
  @CS_Loan_DepositCL CS_Loan_Deposit_CL ,        
  @CS_Loan_WithdrawalCL CS_Loan_Withdrawal_CL ,        
  @CS_Loan_InterestCL CS_Loan_Interest_CL ,        
  @CS_Loan_FineCL CS_Loan_Fine_CL ,        
  @CS_Loan_BalanceCL CS_Loan_Balance_CL ,        
  @CS_Loan_CustomerCL CS_Loan_Customer_CL,         
  @GS_NL_DepositCL GS_NL_Deposit_CL ,        
  @GS_NL_WithdrawalCL GS_NL_Withdrawal_CL,         
  @GS_NL_InterestCL GS_NL_Interest_CL ,        
  @GS_NL_FineCL GS_NL_Fine_CL ,        
  @GS_NL_BalanceCL GS_NL_Balance_CL ,        
  @GS_NL_CustomerCL GS_NL_Customer_CL,         
  @RVS_NL_DepositCL RVS_NL_Deposit_CL ,        
  @RVS_NL_WithdrawalCL RVS_NL_Withdrawal_CL ,        
  @RVS_NL_InterestCL RVS_NL_Interest_CL ,        
  @RVS_NL_FineCL RVS_NL_Fine_CL ,        
  @RVS_NL_BalanceCL RVS_NL_Balance_CL ,        
  @RVS_NL_CustomerCL RVS_NL_Customer_CL,         
  @CS_NL_DepositCL CS_NL_Deposit_CL,         
  @CS_NL_WithdrawalCL CS_NL_Withdrawal_CL ,        
  @CS_NL_InterestCL CS_NL_Interest_CL ,        
  @CS_NL_FineCL CS_NL_Fine_CL ,        
  @CS_NL_BalanceCL CS_NL_Balance_CL ,        
  @CS_NL_CustomerCL CS_NL_Customer_CL,         
  @GS_Total_DepositCL GS_Total_Deposit_CL ,        
  @GS_Total_WithdrawalCL GS_Total_Withdrawal_CL,         
  @GS_Total_InterestCL GS_Total_Interest_CL ,        
  @GS_Total_FineCL GS_Total_Fine_CL ,        
  @GS_Total_BalanceCL GS_Total_Balance_CL ,        
  @GS_Total_CustomerCL GS_Total_Customer_CL ,        
  @RVS_Total_DepositCL RVS_Total_Deposit_CL ,        
  @RVS_Total_WithdrawalCL RVS_Total_Withdrawal_CL ,        
  @RVS_Total_InterestCL RVS_Total_Interest_CL ,        
  @RVS_Total_FineCL RVS_Total_Fine_CL ,        
  @RVS_Total_BalanceCL RVS_Total_Balance_CL ,        
  @RVS_Total_CustomerCL RVS_Total_Customer_CL,         
  @CS_Total_DepositCL CS_Total_Deposit_CL ,        
  @CS_Total_WithdrawalCL CS_Total_Withdrawal_CL ,        
  @CS_Total_InterestCL CS_Total_Interest_CL,         
  @CS_Total_FineCL CS_Total_Fine_CL ,        
  @CS_Total_BalanceCL CS_Total_Balance_CL ,        
  @CS_Total_CustomerCL CS_Total_Customer_CL ,        
  @GT_DepositCL GT_Deposit_CL ,        
  @GT_WithdrawalCL GT_Withdrawal_CL ,        
  @GT_InterestCL GT_Interest_CL ,        
  @GT_FineCL GT_Fine_CL ,        
  @GT_BalanceCL GT_Balance_CL ,        
  @GT_CustomerCL GT_Customer_CL ,        
  @GS_NLRM_DropOut GS_NLRM_DropOut_P,         
  @CS_NLRM_DropOut CS_NLRM_DropOut_P ,        
  @GS_NLRM_DropOut_Total GS_NLRM_DropOut_Total_P ,        
  @CS_NLRM_DropOut_Total CS_NLRM_DropOut_Total_P,         
  @GT_DropOut_Customer GT_DropOut_Customer_P,        
          
  @SS_Upto_2000_Customer SS_Upto_2000_Customer,         
  @SS_Upto_2000_Balance SS_Upto_2000_Balance,         
  @SS_2001_5000_Customer SS_2001_5000_Customer,         
  @SS_2001_5000_Balance SS_2001_5000_Balance,         
  @SS_5001_10000_Customer SS_5001_10000_Customer,         
  @SS_5001_10000_Balance SS_5001_10000_Balance,         
  @SS_10001_20000_Customer SS_10001_20000_Customer,         
  @SS_10001_20000_Balance SS_10001_20000_Balance,         
  @SS_20001Above_Customer SS_20001Above_Customer,         
  @SS_20001Above_Balance SS_20001Above_Balance,         
  @SS_Total_Customer SS_Total_Customer,         
  @SS_Total_Balance SS_Total_Balance,        
        
  @BranchName BranchName,         
  @BranchAddress BranchAddress         
        
 END 



-- if ( {?GS_Total} ='0')
--THEN 
--TRUE
--ELSE
--FALSE
