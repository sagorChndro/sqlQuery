Exec spSavingsPortfolioReportHO '2023-08-01','2023-08-31','',''
go
Create PROCEDURE [dbo].[spSavingsPortfolioReportHO]
 @startDate DateTime,@endDate DateTime,@strid nvarchar(max),@reportFilterBy nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;
--PRINT ''
		DECLARE  @startDate1 DateTime,@endDate1 DateTime,@strid1 nvarchar(max),@reportFilterBy1 nvarchar(20)
		SET @startDate1=@startDate
		SET @endDate1=@endDate
		SET @strid1=@strid
		SET @reportFilterBy1=@reportFilterBy

		declare @previousMonthStartDate datetime
		declare @previousMonthEndDate datetime

		set @previousMonthStartDate=DATEADD(MONTH, DATEDIFF(MONTH, 0, @startDate1)-1, 0)
		set @previousMonthEndDate=DATEADD(MONTH, DATEDIFF(MONTH, -1, @endDate1)-1, -1)

		DECLARE @BranchList Table (branchId varchar(10) NOT NULL)
		INSERT INTO @BranchList
		select branchId from func_TempBranchLines(@endDate1) bl
		where (
		            @reportFilterBy1 = 'division'
					AND bl.DivisionId IN (SELECT
					  value
					FROM dbo.fn_Split(@strid1, ',')) OR

		            @reportFilterBy1 = 'zone'
					AND bl.zoneId IN (SELECT
					  value
					FROM dbo.fn_Split(@strid1, ','))
					OR @reportFilterBy1 = 'area'
					AND bl.areaId IN (SELECT
					  value
					FROM dbo.fn_Split(@strid1, ','))
					OR @reportFilterBy1 = 'branch'
					AND bl.branchId IN (SELECT
					  value
					FROM dbo.fn_Split(@strid1, ','))
					OR @reportFilterBy1 = 'branch'
					AND bl.branchId IN (SELECT
					  value
					FROM dbo.fn_Split(@strid1, ','))
					)
			


		DECLARE @GS_Loan_DropCustomerOP  AS NUMERIC(18,0)
	    DECLARE  @GS_NL_DropCustomerOP AS NUMERIC(18,0)
        DECLARE @GS_Loan_DepositOP AS NUMERIC(18,0)
        DECLARE @DropCustomer AS NUMERIC(18,0)
        DECLARE @GS_Loan_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @GS_Loan_InterestOP AS NUMERIC(18,0)
        DECLARE @GS_Loan_FineOP AS NUMERIC(18,0)
        DECLARE @GS_Loan_BalanceOP AS NUMERIC(18,0)
        DECLARE @GS_Loan_CustomerOP AS NUMERIC(18,0)

        DECLARE @GS_NL_DepositOP AS NUMERIC(18,0)
        DECLARE @GS_NL_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @GS_NL_InterestOP AS NUMERIC(18,0)
        DECLARE @GS_NL_FineOP AS NUMERIC(18,0)
        DECLARE @GS_NL_BalanceOP AS NUMERIC(18,0)
        DECLARE @GS_NL_CustomerOP AS NUMERIC(18,0)

        DECLARE @GS_Total_DepositOP AS NUMERIC(18,0)
        DECLARE @GS_Total_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @GS_Total_InterestOP AS NUMERIC(18,0)
        DECLARE @GS_Total_FineOP AS NUMERIC(18,0)
        DECLARE @GS_Total_BalanceOP AS NUMERIC(18,0)
        DECLARE @GS_Total_CustomerOP AS NUMERIC(18,0)

        DECLARE @RVS_Loan_DepositOP AS NUMERIC(18,0)
        DECLARE @RVS_Loan_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @RVS_Loan_InterestOP AS NUMERIC(18,0)
        DECLARE @RVS_Loan_FineOP AS NUMERIC(18,0)
        DECLARE @RVS_Loan_BalanceOP AS NUMERIC(18,0)
        DECLARE @RVS_Loan_CustomerOP AS NUMERIC(18,0)

        DECLARE @RVS_NL_DepositOP AS NUMERIC(18,0)
        DECLARE @RVS_NL_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @RVS_NL_InterestOP AS NUMERIC(18,0)
        DECLARE @RVS_NL_FineOP AS NUMERIC(18,0)
        DECLARE @RVS_NL_BalanceOP AS NUMERIC(18,0)
        DECLARE @RVS_NL_CustomerOP AS NUMERIC(18,0)

        DECLARE @RVS_Total_DepositOP AS NUMERIC(18,0)
        DECLARE @RVS_Total_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @RVS_Total_InterestOP AS NUMERIC(18,0)
        DECLARE @RVS_Total_FineOP AS NUMERIC(18,0)
        DECLARE @RVS_Total_BalanceOP AS NUMERIC(18,0)
        DECLARE @RVS_Total_CustomerOP AS NUMERIC(18,0)

        DECLARE @CS_Loan_DepositOP AS NUMERIC(18,0)
        DECLARE @CS_Loan_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @CS_Loan_InterestOP AS NUMERIC(18,0)
        DECLARE @CS_Loan_FineOP AS NUMERIC(18,0)
        DECLARE @CS_Loan_BalanceOP AS NUMERIC(18,0)
        DECLARE @CS_Loan_CustomerOP AS NUMERIC(18,0)

        DECLARE @CS_NL_DepositOP AS NUMERIC(18,0)
        DECLARE @CS_NL_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @CS_NL_InterestOP AS NUMERIC(18,0)
        DECLARE @CS_NL_FineOP AS NUMERIC(18,0)
        DECLARE @CS_NL_BalanceOP AS NUMERIC(18,0)
        DECLARE @CS_NL_CustomerOP AS NUMERIC(18,0)

        DECLARE @CS_Total_DepositOP AS NUMERIC(18,0)
        DECLARE @CS_Total_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @CS_Total_InterestOP AS NUMERIC(18,0)
        DECLARE @CS_Total_FineOP AS NUMERIC(18,0)
        DECLARE @CS_Total_BalanceOP AS NUMERIC(18,0)
        DECLARE @CS_Total_CustomerOP AS NUMERIC(18,0)

        DECLARE @GT_DepositOP AS NUMERIC(18,0)
        DECLARE @GT_WithdrawalOP AS NUMERIC(18,0)
        DECLARE @GT_InterestOP AS NUMERIC(18,0)
        DECLARE @GT_FineOP AS NUMERIC(18,0)
        DECLARE @GT_BalanceOP AS NUMERIC(18,0)
        DECLARE @GT_CustomerOP AS NUMERIC(18,0)


		--Tranfer Opening
		---------------------------
		DECLARE @GS_Loan_DepositOPT AS NUMERIC(18,0)
        DECLARE @GS_Loan_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @GS_Loan_InterestOPT AS NUMERIC(18,0)
        DECLARE @GS_Loan_FineOPT AS NUMERIC(18,0)
        DECLARE @GS_Loan_BalanceOPT AS NUMERIC(18,0)
        DECLARE @GS_Loan_CustomerOPT AS NUMERIC(18,0)

        DECLARE @GS_NL_DepositOPT AS NUMERIC(18,0)
        DECLARE @GS_NL_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @GS_NL_InterestOPT AS NUMERIC(18,0)
        DECLARE @GS_NL_FineOPT AS NUMERIC(18,0)
        DECLARE @GS_NL_BalanceOPT AS NUMERIC(18,0)
        DECLARE @GS_NL_CustomerOPT AS NUMERIC(18,0)

        DECLARE @GS_Total_DepositOPT AS NUMERIC(18,0)
        DECLARE @GS_Total_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @GS_Total_InterestOPT AS NUMERIC(18,0)
        DECLARE @GS_Total_FineOPT AS NUMERIC(18,0)
        DECLARE @GS_Total_BalanceOPT AS NUMERIC(18,0)
        DECLARE @GS_Total_CustomerOPT AS NUMERIC(18,0)

        DECLARE @RVS_Loan_DepositOPT AS NUMERIC(18,0)
        DECLARE @RVS_Loan_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @RVS_Loan_InterestOPT AS NUMERIC(18,0)
        DECLARE @RVS_Loan_FineOPT AS NUMERIC(18,0)
        DECLARE @RVS_Loan_BalanceOPT AS NUMERIC(18,0)
        DECLARE @RVS_Loan_CustomerOPT AS NUMERIC(18,0)

        DECLARE @RVS_NL_DepositOPT AS NUMERIC(18,0)
        DECLARE @RVS_NL_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @RVS_NL_InterestOPT AS NUMERIC(18,0)
        DECLARE @RVS_NL_FineOPT AS NUMERIC(18,0)
        DECLARE @RVS_NL_BalanceOPT AS NUMERIC(18,0)
        DECLARE @RVS_NL_CustomerOPT AS NUMERIC(18,0)

        DECLARE @RVS_Total_DepositOPT AS NUMERIC(18,0)
        DECLARE @RVS_Total_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @RVS_Total_InterestOPT AS NUMERIC(18,0)
        DECLARE @RVS_Total_FineOPT AS NUMERIC(18,0)
        DECLARE @RVS_Total_BalanceOPT AS NUMERIC(18,0)
        DECLARE @RVS_Total_CustomerOPT AS NUMERIC(18,0)

        DECLARE @CS_Loan_DepositOPT AS NUMERIC(18,0)
        DECLARE @CS_Loan_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @CS_Loan_InterestOPT AS NUMERIC(18,0)
        DECLARE @CS_Loan_FineOPT AS NUMERIC(18,0)
        DECLARE @CS_Loan_BalanceOPT AS NUMERIC(18,0)
        DECLARE @CS_Loan_CustomerOPT AS NUMERIC(18,0)

        DECLARE @CS_NL_DepositOPT AS NUMERIC(18,0)
        DECLARE @CS_NL_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @CS_NL_InterestOPT AS NUMERIC(18,0)
        DECLARE @CS_NL_FineOPT AS NUMERIC(18,0)
        DECLARE @CS_NL_BalanceOPT AS NUMERIC(18,0)
        DECLARE @CS_NL_CustomerOPT AS NUMERIC(18,0)

        DECLARE @CS_Total_DepositOPT AS NUMERIC(18,0)
        DECLARE @CS_Total_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @CS_Total_InterestOPT AS NUMERIC(18,0)
        DECLARE @CS_Total_FineOPT AS NUMERIC(18,0)
        DECLARE @CS_Total_BalanceOPT AS NUMERIC(18,0)
        DECLARE @CS_Total_CustomerOPT AS NUMERIC(18,0)

        DECLARE @GT_DepositOPT AS NUMERIC(18,0)
        DECLARE @GT_WithdrawalOPT AS NUMERIC(18,0)
        DECLARE @GT_InterestOPT AS NUMERIC(18,0)
        DECLARE @GT_FineOPT AS NUMERIC(18,0)
        DECLARE @GT_BalanceOPT AS NUMERIC(18,0)
        DECLARE @GT_CustomerOPT AS NUMERIC(18,0)
		--------------------------------------------------

			--Tranfer Opening
		---------------------------
		DECLARE @GS_Loan_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Loan_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Loan_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Loan_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Loan_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Loan_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @GS_NL_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_NL_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_NL_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_NL_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_NL_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_NL_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @GS_Total_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Total_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Total_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Total_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Total_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @GS_Total_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @RVS_Loan_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Loan_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Loan_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Loan_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Loan_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Loan_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @RVS_NL_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_NL_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_NL_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_NL_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_NL_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_NL_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @RVS_Total_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Total_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Total_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Total_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Total_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @RVS_Total_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @CS_Loan_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Loan_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Loan_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Loan_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Loan_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Loan_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @CS_NL_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_NL_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_NL_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_NL_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_NL_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_NL_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @CS_Total_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Total_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Total_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Total_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Total_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @CS_Total_CustomerOPTAdjust AS NUMERIC(18,0)

        DECLARE @GT_DepositOPTAdjust AS NUMERIC(18,0)
        DECLARE @GT_WithdrawalOPTAdjust AS NUMERIC(18,0)
        DECLARE @GT_InterestOPTAdjust AS NUMERIC(18,0)
        DECLARE @GT_FineOPTAdjust AS NUMERIC(18,0)
        DECLARE @GT_BalanceOPTAdjust AS NUMERIC(18,0)
        DECLARE @GT_CustomerOPTAdjust AS NUMERIC(18,0)
		--------------------------------------------------

		DECLARE @GS_Loan_DepositCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_InterestCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_FineCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_BalanceCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_CustomerCM AS NUMERIC(18,0)
		
        DECLARE @GS_NL_DepositCM AS NUMERIC(18,0)
        DECLARE @GS_NL_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @GS_NL_InterestCM AS NUMERIC(18,0)
        DECLARE @GS_NL_FineCM AS NUMERIC(18,0)
        DECLARE @GS_NL_BalanceCM AS NUMERIC(18,0)
        DECLARE @GS_NL_CustomerCM AS NUMERIC(18,0)
        DECLARE @GS_NL_DropCustomerCM AS NUMERIC(18,0)
        DECLARE @GS_Loan_DropCustomerCM AS NUMERIC(18,0)

        DECLARE @GS_Total_DepositCM AS NUMERIC(18,0)
        DECLARE @GS_Total_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @GS_Total_InterestCM AS NUMERIC(18,0)
        DECLARE @GS_Total_FineCM AS NUMERIC(18,0)
        DECLARE @GS_Total_BalanceCM AS NUMERIC(18,0)
        DECLARE @GS_Total_CustomerCM AS NUMERIC(18,0)
        DECLARE @GS_Total_DropCustomerCM AS NUMERIC(18,0)

        DECLARE @RVS_Loan_DepositCM AS NUMERIC(18,0)
        DECLARE @RVS_Loan_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @RVS_Loan_InterestCM AS NUMERIC(18,0)
        DECLARE @RVS_Loan_FineCM AS NUMERIC(18,0)
        DECLARE @RVS_Loan_BalanceCM AS NUMERIC(18,0)
        DECLARE @RVS_Loan_CustomerCM AS NUMERIC(18,0)

        DECLARE @RVS_NL_DepositCM AS NUMERIC(18,0)
        DECLARE @RVS_NL_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @RVS_NL_InterestCM AS NUMERIC(18,0)
        DECLARE @RVS_NL_FineCM AS NUMERIC(18,0)
        DECLARE @RVS_NL_BalanceCM AS NUMERIC(18,0)
        DECLARE @RVS_NL_CustomerCM AS NUMERIC(18,0)

        DECLARE @RVS_Total_DepositCM AS NUMERIC(18,0)
        DECLARE @RVS_Total_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @RVS_Total_InterestCM AS NUMERIC(18,0)
        DECLARE @RVS_Total_FineCM AS NUMERIC(18,0)
        DECLARE @RVS_Total_BalanceCM AS NUMERIC(18,0)
        DECLARE @RVS_Total_CustomerCM AS NUMERIC(18,0)

        DECLARE @CS_Loan_DepositCM AS NUMERIC(18,0)
        DECLARE @CS_Loan_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @CS_Loan_InterestCM AS NUMERIC(18,0)
        DECLARE @CS_Loan_FineCM AS NUMERIC(18,0)
        DECLARE @CS_Loan_BalanceCM AS NUMERIC(18,0)
        DECLARE @CS_Loan_CustomerCM AS NUMERIC(18,0)

        DECLARE @CS_NL_DepositCM AS NUMERIC(18,0)
        DECLARE @CS_NL_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @CS_NL_InterestCM AS NUMERIC(18,0)
        DECLARE @CS_NL_FineCM AS NUMERIC(18,0)
        DECLARE @CS_NL_BalanceCM AS NUMERIC(18,0)
        DECLARE @CS_NL_CustomerCM AS NUMERIC(18,0)

        DECLARE @CS_Total_DepositCM AS NUMERIC(18,0)
        DECLARE @CS_Total_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @CS_Total_InterestCM AS NUMERIC(18,0)
        DECLARE @CS_Total_FineCM AS NUMERIC(18,0)
        DECLARE @CS_Total_BalanceCM AS NUMERIC(18,0)
        DECLARE @CS_Total_CustomerCM AS NUMERIC(18,0)

        DECLARE @GT_DepositCM AS NUMERIC(18,0)
        DECLARE @GT_WithdrawalCM AS NUMERIC(18,0)
        DECLARE @GT_InterestCM AS NUMERIC(18,0)
        DECLARE @GT_FineCM AS NUMERIC(18,0)
        DECLARE @GT_BalanceCM AS NUMERIC(18,0)
        DECLARE @GT_CustomerCM AS NUMERIC(18,0)

        DECLARE @GS_Loan_DepositCL AS NUMERIC(18,0)
        DECLARE @GS_Loan_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @GS_Loan_InterestCL AS NUMERIC(18,0)
        DECLARE @GS_Loan_FineCL AS NUMERIC(18,0)
        DECLARE @GS_Loan_BalanceCL AS NUMERIC(18,0)
        DECLARE @GS_Loan_CustomerCL AS NUMERIC(18,0)

        DECLARE @GS_NL_DepositCL AS NUMERIC(18,0)
        DECLARE @GS_NL_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @GS_NL_InterestCL AS NUMERIC(18,0)
        DECLARE @GS_NL_FineCL AS NUMERIC(18,0)
        DECLARE @GS_NL_BalanceCL AS NUMERIC(18,0)
        DECLARE @GS_NL_CustomerCL AS NUMERIC(18,0)

        DECLARE @GS_Total_DepositCL AS NUMERIC(18,0)
        DECLARE @GS_Total_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @GS_Total_InterestCL AS NUMERIC(18,0)
        DECLARE @GS_Total_FineCL AS NUMERIC(18,0)
        DECLARE @GS_Total_BalanceCL AS NUMERIC(18,0)
        DECLARE @GS_Total_CustomerCL AS NUMERIC(18,0)

        DECLARE @RVS_Loan_DepositCL AS NUMERIC(18,0)
        DECLARE @RVS_Loan_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @RVS_Loan_InterestCL AS NUMERIC(18,0)
        DECLARE @RVS_Loan_FineCL AS NUMERIC(18,0)
        DECLARE @RVS_Loan_BalanceCL AS NUMERIC(18,0)
        DECLARE @RVS_Loan_CustomerCL AS NUMERIC(18,0)

        DECLARE @RVS_NL_DepositCL AS NUMERIC(18,0)
        DECLARE @RVS_NL_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @RVS_NL_InterestCL AS NUMERIC(18,0)
        DECLARE @RVS_NL_FineCL AS NUMERIC(18,0)
        DECLARE @RVS_NL_BalanceCL AS NUMERIC(18,0)
        DECLARE @RVS_NL_CustomerCL AS NUMERIC(18,0)

        DECLARE @RVS_Total_DepositCL AS NUMERIC(18,0)
        DECLARE @RVS_Total_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @RVS_Total_InterestCL AS NUMERIC(18,0)
        DECLARE @RVS_Total_FineCL AS NUMERIC(18,0)
        DECLARE @RVS_Total_BalanceCL AS NUMERIC(18,0)
        DECLARE @RVS_Total_CustomerCL AS NUMERIC(18,0)

        DECLARE @CS_Loan_DepositCL AS NUMERIC(18,0)
        DECLARE @CS_Loan_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @CS_Loan_InterestCL AS NUMERIC(18,0)
        DECLARE @CS_Loan_FineCL AS NUMERIC(18,0)
        DECLARE @CS_Loan_BalanceCL AS NUMERIC(18,0)
        DECLARE @CS_Loan_CustomerCL AS NUMERIC(18,0)

        DECLARE @CS_NL_DepositCL AS NUMERIC(18,0)
        DECLARE @CS_NL_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @CS_NL_InterestCL AS NUMERIC(18,0)
        DECLARE @CS_NL_FineCL AS NUMERIC(18,0)
        DECLARE @CS_NL_BalanceCL AS NUMERIC(18,0)
        DECLARE @CS_NL_CustomerCL AS NUMERIC(18,0)

        DECLARE @CS_Total_DepositCL AS NUMERIC(18,0)
        DECLARE @CS_Total_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @CS_Total_InterestCL AS NUMERIC(18,0)
        DECLARE @CS_Total_FineCL AS NUMERIC(18,0)
        DECLARE @CS_Total_BalanceCL AS NUMERIC(18,0)
        DECLARE @CS_Total_CustomerCL AS NUMERIC(18,0)

        DECLARE @GT_DepositCL AS NUMERIC(18,0)
        DECLARE @GT_WithdrawalCL AS NUMERIC(18,0)
        DECLARE @GT_InterestCL AS NUMERIC(18,0)
        DECLARE @GT_FineCL AS NUMERIC(18,0)
        DECLARE @GT_BalanceCL AS NUMERIC(18,0)
        DECLARE @GT_CustomerCL AS NUMERIC(18,0)

		DECLARE @productId NVARCHAR(20)
        DECLARE @category NVARCHAR(100)
        DECLARE @Strsql NVARCHAR(MAX)

		set @GS_Loan_DropCustomerOP=0;
		set @GS_NL_DropCustomerOP=0;
		SET @GS_Loan_DepositOP = 0;
		SET @GS_Loan_WithdrawalOP = 0;
		SET @GS_Loan_InterestOP = 0;
		SET @GS_Loan_FineOP = 0;
		SET @GS_Loan_BalanceOP = 0;
		SET @GS_Loan_CustomerOP = 0;

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

		--------Transfer
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
		-----------------

		--------Transfer
		SET @GS_Loan_DepositOPTAdjust = 0;
		SET @GS_Loan_WithdrawalOPTAdjust = 0;
		SET @GS_Loan_InterestOPTAdjust = 0;
		SET @GS_Loan_FineOPTAdjust = 0;
		SET @GS_Loan_BalanceOPTAdjust = 0;
		SET @GS_Loan_CustomerOPTAdjust = 0;

		SET @GS_NL_DepositOPTAdjust = 0;
		SET @GS_NL_WithdrawalOPTAdjust = 0;
		SET @GS_NL_InterestOPTAdjust = 0;
		SET @GS_NL_FineOPTAdjust = 0;
		SET @GS_NL_BalanceOPTAdjust = 0;
		SET @GS_NL_CustomerOPTAdjust = 0;

		SET @GS_Total_DepositOPTAdjust = 0;
		SET @GS_Total_WithdrawalOPTAdjust = 0;
		SET @GS_Total_InterestOPTAdjust = 0;
		SET @GS_Total_FineOPTAdjust = 0;
		SET @GS_Total_BalanceOPTAdjust = 0;
		SET @GS_Total_CustomerOPTAdjust = 0;

		SET @RVS_Loan_DepositOPTAdjust = 0;
		SET @RVS_Loan_WithdrawalOPTAdjust = 0;
		SET @RVS_Loan_InterestOPTAdjust = 0;
		SET @RVS_Loan_FineOPTAdjust = 0;
		SET @RVS_Loan_BalanceOPTAdjust = 0;
		SET @RVS_Loan_CustomerOPTAdjust = 0;

		SET @RVS_NL_DepositOPTAdjust = 0;
		SET @RVS_NL_WithdrawalOPTAdjust = 0;
		SET @RVS_NL_InterestOPTAdjust = 0;
		SET @RVS_NL_FineOPTAdjust = 0;
		SET @RVS_NL_BalanceOPTAdjust = 0;
		SET @RVS_NL_CustomerOPTAdjust = 0;

		SET @RVS_Total_DepositOPTAdjust = 0;
		SET @RVS_Total_WithdrawalOPTAdjust = 0;
		SET @RVS_Total_InterestOPTAdjust = 0;
		SET @RVS_Total_FineOPTAdjust = 0;
		SET @RVS_Total_BalanceOPTAdjust = 0;
		SET @RVS_Total_CustomerOPTAdjust = 0;

		SET @CS_Loan_DepositOPTAdjust = 0;
		SET @CS_Loan_WithdrawalOPTAdjust = 0;
		SET @CS_Loan_InterestOPTAdjust = 0;
		SET @CS_Loan_FineOPTAdjust = 0;
		SET @CS_Loan_BalanceOPTAdjust = 0;
		SET @CS_Loan_CustomerOPTAdjust = 0;

		SET @CS_NL_DepositOPTAdjust = 0;
		SET @CS_NL_WithdrawalOPTAdjust = 0;
		SET @CS_NL_InterestOPTAdjust = 0;
		SET @CS_NL_FineOPTAdjust = 0;
		SET @CS_NL_BalanceOPTAdjust = 0;
		SET @CS_NL_CustomerOPTAdjust = 0;

		SET @CS_Total_DepositOPTAdjust = 0;
		SET @CS_Total_WithdrawalOPTAdjust = 0;
		SET @CS_Total_InterestOPTAdjust = 0;
		SET @CS_Total_FineOPTAdjust = 0;
		SET @CS_Total_BalanceOPTAdjust = 0;
		SET @CS_Total_CustomerOPTAdjust = 0;

		SET @GT_DepositOPTAdjust = 0;
		SET @GT_WithdrawalOPTAdjust = 0;
		SET @GT_InterestOPTAdjust = 0;
		SET @GT_FineOPTAdjust = 0;
		SET @GT_BalanceOPTAdjust = 0;
		SET @GT_CustomerOPTAdjust = 0;
		--------------------------------------

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
		SET @GS_NL_DropCustomerCM = 0;
		SET @GS_Loan_DropCustomerCM = 0;

		SET @GS_Total_DepositCM = 0;
		SET @GS_Total_WithdrawalCM = 0;
		SET @GS_Total_InterestCM = 0;
		SET @GS_Total_FineCM = 0;
		SET @GS_Total_BalanceCM = 0;
		SET @GS_Total_CustomerCM = 0;
		SET @GS_Total_DropCustomerCM = 0;

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

        DECLARE @CustomerCount AS NUMERIC(18,0)
        DECLARE @Deposit AS NUMERIC(18,0)
        DECLARE @Withdrawal AS NUMERIC(18,0)
        DECLARE @Interest AS NUMERIC(18,0)
        DECLARE @Fine AS NUMERIC(18,0)

		declare opening cursor for 
		Select a.savingsProductId,a.category,IsNull(sum(a.customer),0), IsNull(sum(a.Deposit),0), IsNull(sum(a.Withdrawal),0), IsNull(sum(a.Interest),0), IsNull(sum(a.Fine),0)
		From tblSavingsPortfolioOpening a with (nolock) 
		inner join tblBranch b with (nolock) on a.branchId=b.branchId 
		inner join tblSavingsProduct l with (nolock)   on a.SavingsProductId = l.SavingsProductId 
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = a.branchId  
		inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId 
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId
		left outer join tblproject p with (rowlock) on p.projectId = bl.projectId  
		Where year(a.openingDate) = year(@startDate1) And month(a.openingDate) = 1 And day(a.openingDate)=1  
		AND b.branchid in(select * from @BranchList)
		AND bl.reportDate =@endDate1 group by a.savingsProductId,a.category
		OPEN opening 
		FETCH NEXT FROM opening  
		INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine

		WHILE @@FETCH_STATUS = 0 
		begin
			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_CustomerOP=@CustomerCount
						SET @GS_Loan_DepositOP=@Deposit
						SET @GS_Loan_WithdrawalOP=@Withdrawal
						SET @GS_Loan_InterestOP=@Interest
						SET @GS_Loan_FineOP=@Fine
						SET @GS_Loan_BalanceOP=@GS_Loan_DepositOP - @GS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @GS_NL_CustomerOP=@CustomerCount
						SET @GS_NL_DepositOP=@Deposit
						SET @GS_NL_WithdrawalOP=@Withdrawal
						SET @GS_NL_InterestOP=@Interest
						SET @GS_NL_FineOP=@Fine
						SET @GS_NL_BalanceOP=@GS_NL_DepositOP - @GS_NL_WithdrawalOP
					end
			end
			if(@productId='02')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @CS_Loan_CustomerOP=@CustomerCount
						SET @CS_Loan_DepositOP=@Deposit
						SET @CS_Loan_WithdrawalOP=@Withdrawal
						SET @CS_Loan_InterestOP=@Interest
						SET @CS_Loan_FineOP=@Fine
						SET @CS_Loan_BalanceOP=@CS_Loan_DepositOP - @CS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @CS_NL_CustomerOP=@CustomerCount
						SET @CS_NL_DepositOP=@Deposit
						SET @CS_NL_WithdrawalOP=@Withdrawal
						SET @CS_NL_InterestOP=@Interest
						SET @CS_NL_FineOP=@Fine
						SET @CS_NL_BalanceOP=@CS_NL_DepositOP - @CS_NL_WithdrawalOP
					end
			end
			if(@productId='03')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @RVS_Loan_CustomerOP=@CustomerCount
						SET @RVS_Loan_DepositOP=@Deposit
						SET @RVS_Loan_WithdrawalOP=@Withdrawal
						SET @RVS_Loan_InterestOP=@Interest
						SET @RVS_Loan_FineOP=@Fine
						SET @RVS_Loan_BalanceOP=@RVS_Loan_DepositOP - @RVS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @RVS_NL_CustomerOP=@CustomerCount
						SET @RVS_NL_DepositOP=@Deposit
						SET @RVS_NL_WithdrawalOP=@Withdrawal
						SET @RVS_NL_InterestOP=@Interest
						SET @RVS_NL_FineOP=@Fine
						SET @RVS_NL_BalanceOP=@RVS_NL_DepositOP - @RVS_NL_WithdrawalOP
					end
			end
			FETCH NEXT FROM opening  
			INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine
		END
		CLOSE opening 
		DEALLOCATE opening

		-----------------------
--		--Previous_Month DropOut customer
--		---------------------------------------
		 
		declare Previous_Month cursor for
		Select a.savingsProductId,a.category,IsNull(sum(a.noOfDroout),0)
		From tblSavingsPortfolio a with (nolock) 
		inner join tblBranch b with (nolock) on a.branchId=b.branchId inner join tblSavingsProduct l with (nolock)  on a.SavingsProductId = l.SavingsProductId 
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = a.branchId  inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId 
		left outer join tblproject p with (nolock) on p.projectId = bl.projectId  
		Where a.entryDate<=@previousMonthEndDate and
		--year(a.entryDate) = year(@previousMonthStartDate) And month(a.entryDate) = month(@previousMonthStartDate) AND 
		b.branchid in(select * from @BranchList)
		--AND bl.reportDate=@previousMonthEndDate
		--AND bl.reportDate=@previousMonthEndDate
		group by a.savingsProductId,a.category

		open Previous_Month
		fetch next from Previous_Month
		INTO @productId,@category,@DropCustomer

		while @@FETCH_STATUS=0
		begin
			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_DropCustomerOP=@DropCustomer
						print 'There are Loan PrevMonth ' + CAST(@GS_Loan_DropCustomerOP AS NVARCHAR(100))
					end
				else
					begin
					--print ''
							set @GS_NL_DropCustomerOP = @DropCustomer
						print 'There are Loan PrevMonth ' + CAST(@GS_Loan_DropCustomerOP AS NVARCHAR(100))

					end
			end
			fetch next from Previous_Month
			INTO @productId,@category,@DropCustomer
		end
		close Previous_Month
		deallocate Previous_Month




		--Transfer Opening
		------------------------
		declare opening cursor for 
		Select l.SavingsProductId productcode,a.category,IsNull(sum(a.customer),0), IsNull(sum(a.Deposit),0), IsNull(sum(a.Withdrawal),0), IsNull(sum(a.Interest),0), IsNull(sum(a.Fine),0)
		From tblSavingsOpeningTransfer a with (nolock) 
		inner join tblBranch b with (nolock) on a.branch_id=b.id 
		inner join tblSavingsProduct l with (nolock)   on a.productCode = cast(l.SavingsProductId as int)
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = b.branchId  
		inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId 
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId
		left outer join tblproject p with (rowlock) on p.projectId = bl.projectId  
		Where @startDate1>= a.openingDate  	AND 
		b.branchid in(select * from @BranchList)
		AND bl.reportDate =@endDate1 group by l.SavingsProductId,a.category

		OPEN opening 
		FETCH NEXT FROM opening  
		INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine

		WHILE @@FETCH_STATUS = 0 
		begin
			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_CustomerOPT=@CustomerCount
						SET @GS_Loan_DepositOPT=@Deposit
						SET @GS_Loan_WithdrawalOPT=@Withdrawal
						SET @GS_Loan_InterestOPT=@Interest
						SET @GS_Loan_FineOPT=@Fine
						SET @GS_Loan_BalanceOPT=@GS_Loan_DepositOPT - @GS_Loan_WithdrawalOPT
					end
				else
					begin
					--print ''
						SET @GS_NL_CustomerOPT=@CustomerCount
						SET @GS_NL_DepositOPT=@Deposit
						SET @GS_NL_WithdrawalOPT=@Withdrawal
						SET @GS_NL_InterestOPT=@Interest
						SET @GS_NL_FineOPT=@Fine
						SET @GS_NL_BalanceOPT=@GS_NL_DepositOPT - @GS_NL_WithdrawalOPT
					end
			end
			if(@productId='02')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @CS_Loan_CustomerOPT=@CustomerCount
						SET @CS_Loan_DepositOPT=@Deposit
						SET @CS_Loan_WithdrawalOPT=@Withdrawal
						SET @CS_Loan_InterestOPT=@Interest
						SET @CS_Loan_FineOPT=@Fine
						SET @CS_Loan_BalanceOPT=@CS_Loan_DepositOPT - @CS_Loan_WithdrawalOPT
					end
				else
					begin
					--print ''
						SET @CS_NL_CustomerOPT=@CustomerCount
						SET @CS_NL_DepositOPT=@Deposit
						SET @CS_NL_WithdrawalOPT=@Withdrawal
						SET @CS_NL_InterestOPT=@Interest
						SET @CS_NL_FineOPT=@Fine
						SET @CS_NL_BalanceOPT=@CS_NL_DepositOPT - @CS_NL_WithdrawalOPT
					end
			end
			if(@productId='03')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @RVS_Loan_CustomerOPT=@CustomerCount
						SET @RVS_Loan_DepositOPT=@Deposit
						SET @RVS_Loan_WithdrawalOPT=@Withdrawal
						SET @RVS_Loan_InterestOPT=@Interest
						SET @RVS_Loan_FineOPT=@Fine
						SET @RVS_Loan_BalanceOPT=@RVS_Loan_DepositOPT - @RVS_Loan_WithdrawalOPT
					end
				else
					begin
					--print ''
						SET @RVS_NL_CustomerOPT=@CustomerCount
						SET @RVS_NL_DepositOPT=@Deposit
						SET @RVS_NL_WithdrawalOPT=@Withdrawal
						SET @RVS_NL_InterestOPT=@Interest
						--SET @RVS_NL_FineOTP=@Fine
						SET @RVS_NL_BalanceOPT=@RVS_NL_DepositOPT - @RVS_NL_WithdrawalOPT
					end
			end
			FETCH NEXT FROM opening  
			INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine
		END
		CLOSE opening 
		DEALLOCATE opening
		----

		--Transfer Opening Adjust
		-------------------------------
		declare opening cursor for 
		Select l.SavingsProductId productcode,a.category,IsNull(sum(a.customer),0), IsNull(sum(a.Deposit),0), IsNull(sum(a.Withdrawal),0), IsNull(sum(a.Interest),0), IsNull(sum(a.Fine),0)
		From tblSavingsOpeningTransfer_OpeningAdjust a with (nolock) 
		inner join tblBranch b with (nolock) on a.branch_id=b.id 
		inner join tblSavingsProduct l with (nolock)   on a.productCode = cast(l.SavingsProductId as int)
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = b.branchId  
		inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId 
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId
		left outer join tblproject p with (rowlock) on p.projectId = bl.projectId  
		Where @startDate1>= a.openingDate  	AND 
		b.branchid in(select * from @BranchList)
		AND bl.reportDate =@endDate1 group by l.SavingsProductId,a.category

		OPEN opening 
		FETCH NEXT FROM opening  
		INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine

		WHILE @@FETCH_STATUS = 0 
		begin
			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_CustomerOPTAdjust=@CustomerCount
						SET @GS_Loan_DepositOPTAdjust=@Deposit
						SET @GS_Loan_WithdrawalOPTAdjust=@Withdrawal
						SET @GS_Loan_InterestOPTAdjust=@Interest
						SET @GS_Loan_FineOPTAdjust=@Fine
						SET @GS_Loan_BalanceOPTAdjust=@GS_Loan_DepositOPTAdjust - @GS_Loan_WithdrawalOPTAdjust
					end
				else
					begin
					--print ''
						SET @GS_NL_CustomerOPTAdjust=@CustomerCount
						SET @GS_NL_DepositOPTAdjust=@Deposit
						SET @GS_NL_WithdrawalOPTAdjust=@Withdrawal
						SET @GS_NL_InterestOPTAdjust=@Interest
						SET @GS_NL_FineOPTAdjust=@Fine
						SET @GS_NL_BalanceOPTAdjust=@GS_NL_DepositOPTAdjust - @GS_NL_WithdrawalOPTAdjust
					end
			end
			if(@productId='02')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @CS_Loan_CustomerOPTAdjust=@CustomerCount
						SET @CS_Loan_DepositOPTAdjust=@Deposit
						SET @CS_Loan_WithdrawalOPTAdjust=@Withdrawal
						SET @CS_Loan_InterestOPTAdjust=@Interest
						SET @CS_Loan_FineOPTAdjust=@Fine
						SET @CS_Loan_BalanceOPTAdjust=@CS_Loan_DepositOPTAdjust - @CS_Loan_WithdrawalOPTAdjust
					end
				else
					begin
					--print ''
						SET @CS_NL_CustomerOPTAdjust=@CustomerCount
						SET @CS_NL_DepositOPTAdjust=@Deposit
						SET @CS_NL_WithdrawalOPTAdjust=@Withdrawal
						SET @CS_NL_InterestOPTAdjust=@Interest
						SET @CS_NL_FineOPTAdjust=@Fine
						SET @CS_NL_BalanceOPTAdjust=@CS_NL_DepositOPTAdjust - @CS_NL_WithdrawalOPTAdjust
					end
			end
			if(@productId='03')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @RVS_Loan_CustomerOPTAdjust=@CustomerCount
						SET @RVS_Loan_DepositOPTAdjust=@Deposit
						SET @RVS_Loan_WithdrawalOPTAdjust=@Withdrawal
						SET @RVS_Loan_InterestOPTAdjust=@Interest
						SET @RVS_Loan_FineOPTAdjust=@Fine
						SET @RVS_Loan_BalanceOPTAdjust=@RVS_Loan_DepositOPTAdjust - @RVS_Loan_WithdrawalOPTAdjust
					end
				else
					begin
					--print ''
						SET @RVS_NL_CustomerOPTAdjust=@CustomerCount
						SET @RVS_NL_DepositOPTAdjust=@Deposit
						SET @RVS_NL_WithdrawalOPTAdjust=@Withdrawal
						SET @RVS_NL_InterestOPTAdjust=@Interest
						--SET @RVS_NL_FineOTP=@Fine
						SET @RVS_NL_BalanceOPTAdjust=@RVS_NL_DepositOPTAdjust - @RVS_NL_WithdrawalOPTAdjust
					end
			end
			FETCH NEXT FROM opening  
			INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine
		END
		CLOSE opening 
		DEALLOCATE opening
		----




		declare other_month_opening cursor for
		Select a.savingsProductId, a.category, IsNull(sum(a.customer),0), IsNull(sum(a.Deposit),0), IsNull(sum(a.Withdrawal),0), IsNull(sum(a.Interest),0), IsNull(sum(a.Fine),0)
		From tblSavingsPortfolio a with (nolock) 
		inner join tblBranch b with (nolock) on a.branchId=b.branchId 
		inner join tblSavingsProduct l with (nolock)  on a.SavingsProductId = l.SavingsProductId 
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = a.branchId  
		inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z on z.ZoneId=bl.ZoneId 
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId
		left outer join tblproject p with (nolock) on p.projectId = bl.projectId  
		Where year(a.entryDate) = year(@startDate1) And month(a.entryDate) < month(@startDate1)
		AND b.branchid in(select * from @BranchList)
		AND bl.reportDate=@endDate1 group by a.savingsProductId,a.category

		OPEN other_month_opening 
		FETCH NEXT FROM other_month_opening  
		INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine

		WHILE @@FETCH_STATUS = 0 
		begin

			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_CustomerOP=@GS_Loan_CustomerOP+@CustomerCount
						SET @GS_Loan_DepositOP=@GS_Loan_DepositOP+@Deposit
						SET @GS_Loan_WithdrawalOP=@GS_Loan_WithdrawalOP+@Withdrawal
						SET @GS_Loan_InterestOP=@GS_Loan_InterestOP+@Interest
						SET @GS_Loan_FineOP=@GS_Loan_FineOP+@Fine
						SET @GS_Loan_BalanceOP=@GS_Loan_DepositOP - @GS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @GS_NL_CustomerOP=@GS_NL_CustomerOP+@CustomerCount
						SET @GS_NL_DepositOP=@GS_NL_DepositOP+@Deposit
						SET @GS_NL_WithdrawalOP=@GS_NL_WithdrawalOP+@Withdrawal
						SET @GS_NL_InterestOP=@GS_NL_InterestOP+@Interest
						SET @GS_NL_FineOP=@GS_NL_FineOP+@Fine
						SET @GS_NL_BalanceOP=@GS_NL_DepositOP - @GS_NL_WithdrawalOP
					end
			end
			if(@productId='02')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @CS_Loan_CustomerOP=@CS_Loan_CustomerOP+@CustomerCount
						SET @CS_Loan_DepositOP=@CS_Loan_DepositOP+@Deposit
						SET @CS_Loan_WithdrawalOP=@CS_Loan_WithdrawalOP+@Withdrawal
						SET @CS_Loan_InterestOP=@CS_Loan_InterestOP+@Interest
						SET @CS_Loan_FineOP=@CS_Loan_FineOP+@Fine
						SET @CS_Loan_BalanceOP=@CS_Loan_DepositOP - @CS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @CS_NL_CustomerOP=@CS_NL_CustomerOP+@CustomerCount
						SET @CS_NL_DepositOP=@CS_NL_DepositOP+@Deposit
						SET @CS_NL_WithdrawalOP=@CS_NL_WithdrawalOP+@Withdrawal
						SET @CS_NL_InterestOP=@CS_NL_InterestOP+@Interest
						SET @CS_NL_FineOP=@CS_NL_FineOP+@Fine
						SET @CS_NL_BalanceOP=@CS_NL_DepositOP - @CS_NL_WithdrawalOP
					end
			end
			if(@productId='03')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @RVS_Loan_CustomerOP=@RVS_Loan_CustomerOP+@CustomerCount
						SET @RVS_Loan_DepositOP=@RVS_Loan_DepositOP+@Deposit
						SET @RVS_Loan_WithdrawalOP=@RVS_Loan_WithdrawalOP+@Withdrawal
						SET @RVS_Loan_InterestOP=@RVS_Loan_InterestOP+@Interest
						SET @RVS_Loan_FineOP=@RVS_Loan_FineOP+@Fine
						SET @RVS_Loan_BalanceOP=@RVS_Loan_DepositOP - @RVS_Loan_WithdrawalOP
					end
				else
					begin
					--print ''
						SET @RVS_NL_CustomerOP=@RVS_NL_CustomerOP+@CustomerCount
						SET @RVS_NL_DepositOP=@RVS_NL_DepositOP+@Deposit
						SET @RVS_NL_WithdrawalOP=@RVS_NL_WithdrawalOP+@Withdrawal
						SET @RVS_NL_InterestOP=@RVS_NL_InterestOP+@Interest
						SET @RVS_NL_FineOP=@RVS_NL_FineOP+@Fine
						SET @RVS_NL_BalanceOP=@RVS_NL_DepositOP - @RVS_NL_WithdrawalOP
					end
			end

			FETCH NEXT FROM other_month_opening  
			INTO @productId,@category,@CustomerCount,@Deposit,@Withdrawal,@Interest,@Fine
		END
		CLOSE other_month_opening 
		DEALLOCATE other_month_opening


		DECLARE @GS_NLRM_DropOut AS NUMERIC(18,0)
		DECLARE @GS_NLRM_DropOut_Total AS NUMERIC(18,0)
		DECLARE @CS_NLRM_DropOut AS NUMERIC(18,0)
		DECLARE @CS_NLRM_DropOut_Total AS NUMERIC(18,0)
		DECLARE @GT_DropOut_Customer AS NUMERIC(18,0)

		set @GS_NLRM_DropOut=0
		set @GS_NLRM_DropOut_Total=0
		set @CS_NLRM_DropOut=0
		set @CS_NLRM_DropOut_Total=0
		set @GT_DropOut_Customer=0

		set @GT_DropOut_Customer = @GS_NLRM_DropOut_Total + @CS_NLRM_DropOut_Total;

        set @GS_Total_CustomerOP = @GS_Loan_CustomerOP + @GS_NL_CustomerOP;
        set @GS_Total_DepositOP = @GS_Loan_DepositOP + @GS_NL_DepositOP;
        set @GS_Total_WithdrawalOP = @GS_NL_WithdrawalOP + @GS_Loan_WithdrawalOP;
        set @GS_Total_InterestOP = @GS_NL_InterestOP + @GS_Loan_InterestOP;
        set @GS_Total_FineOP = @GS_NL_FineOP + @GS_Loan_FineOP;
        set @GS_Total_BalanceOP = @GS_NL_BalanceOP + @GS_Loan_BalanceOP;

        set @RVS_Total_CustomerOP = @RVS_NL_CustomerOP + @RVS_Loan_CustomerOP;
        set @RVS_Total_DepositOP = @RVS_NL_DepositOP + @RVS_Loan_DepositOP;
        set @RVS_Total_WithdrawalOP = @RVS_NL_WithdrawalOP + @RVS_Loan_WithdrawalOP;
        set @RVS_Total_InterestOP = @RVS_NL_InterestOP + @RVS_Loan_InterestOP;
        set @RVS_Total_FineOP = @RVS_NL_FineOP + @RVS_Loan_FineOP;
        set @RVS_Total_BalanceOP = @RVS_NL_BalanceOP + @RVS_Loan_BalanceOP;

        set @CS_Total_CustomerOP = @CS_NL_CustomerOP + @CS_Loan_CustomerOP;
        set @CS_Total_DepositOP = @CS_NL_DepositOP + @CS_Loan_DepositOP;
        set @CS_Total_WithdrawalOP = @CS_NL_WithdrawalOP + @CS_Loan_WithdrawalOP;
        set @CS_Total_InterestOP = @CS_NL_InterestOP + @CS_Loan_InterestOP;
        set @CS_Total_FineOP = @CS_NL_FineOP + @CS_Loan_FineOP;
        set @CS_Total_BalanceOP = @CS_NL_BalanceOP + @CS_Loan_BalanceOP;

        set @GT_CustomerOP = @GS_Total_CustomerOP + @RVS_Total_CustomerOP + @CS_Total_CustomerOP;
        set @GT_DepositOP = @GS_Total_DepositOP + @RVS_Total_DepositOP + @CS_Total_DepositOP;
        set @GT_WithdrawalOP = @GS_Total_WithdrawalOP + @RVS_Total_WithdrawalOP + @CS_Total_WithdrawalOP;
        set @GT_InterestOP = @GS_Total_InterestOP + @RVS_Total_InterestOP + @CS_Total_InterestOP;
        set @GT_FineOP = @GS_Total_FineOP + @RVS_Total_FineOP + @CS_Total_FineOP;
        set @GT_BalanceOP = @GS_Total_BalanceOP + @RVS_Total_BalanceOP + @CS_Total_BalanceOP;

		----Transfer------
		set @GS_Total_CustomerOPT = @GS_Loan_CustomerOPT + @GS_NL_CustomerOPT;
        set @GS_Total_DepositOPT = @GS_Loan_DepositOPT + @GS_NL_DepositOPT;
        set @GS_Total_WithdrawalOPT = @GS_NL_WithdrawalOPT + @GS_Loan_WithdrawalOPT;
        set @GS_Total_InterestOPT = @GS_NL_InterestOPT + @GS_Loan_InterestOPT;
        set @GS_Total_FineOPT = @GS_NL_FineOPT + @GS_Loan_FineOPT;
        set @GS_Total_BalanceOPT = @GS_NL_BalanceOPT + @GS_Loan_BalanceOPT;

        set @RVS_Total_CustomerOPT = @RVS_NL_CustomerOPT + @RVS_Loan_CustomerOPT;
        set @RVS_Total_DepositOPT = @RVS_NL_DepositOPT + @RVS_Loan_DepositOPT;
        set @RVS_Total_WithdrawalOPT = @RVS_NL_WithdrawalOPT + @RVS_Loan_WithdrawalOPT;
        set @RVS_Total_InterestOPT = @RVS_NL_InterestOPT + @RVS_Loan_InterestOPT;
        set @RVS_Total_FineOPT = @RVS_NL_FineOPT + @RVS_Loan_FineOPT;
        set @RVS_Total_BalanceOPT = @RVS_NL_BalanceOPT + @RVS_Loan_BalanceOPT;

        set @CS_Total_CustomerOPT = @CS_NL_CustomerOPT + @CS_Loan_CustomerOPT;
        set @CS_Total_DepositOPT = @CS_NL_DepositOPT + @CS_Loan_DepositOPT;
        set @CS_Total_WithdrawalOPT = @CS_NL_WithdrawalOPT + @CS_Loan_WithdrawalOPT;
        set @CS_Total_InterestOPT = @CS_NL_InterestOPT + @CS_Loan_InterestOPT;
        set @CS_Total_FineOPT = @CS_NL_FineOPT + @CS_Loan_FineOPT;
        set @CS_Total_BalanceOPT = @CS_NL_BalanceOPT + @CS_Loan_BalanceOPT;

        set @GT_CustomerOPT = @GS_Total_CustomerOPT + @RVS_Total_CustomerOPT + @CS_Total_CustomerOPT;
        set @GT_DepositOPT = @GS_Total_DepositOPT + @RVS_Total_DepositOPT + @CS_Total_DepositOPT;
        set @GT_WithdrawalOPT = @GS_Total_WithdrawalOPT + @RVS_Total_WithdrawalOPT + @CS_Total_WithdrawalOPT;
        set @GT_InterestOPT = @GS_Total_InterestOPT + @RVS_Total_InterestOPT + @CS_Total_InterestOPT;
        set @GT_FineOPT = @GS_Total_FineOPT + @RVS_Total_FineOPT + @CS_Total_FineOPT;
        set @GT_BalanceOPT = @GS_Total_BalanceOPT + @RVS_Total_BalanceOPT + @CS_Total_BalanceOPT;
		-----------------------

		----Transfer------
		set @GS_Total_CustomerOPTAdjust = @GS_Loan_CustomerOPTAdjust + @GS_NL_CustomerOPTAdjust;
        set @GS_Total_DepositOPTAdjust = @GS_Loan_DepositOPTAdjust + @GS_NL_DepositOPTAdjust;
        set @GS_Total_WithdrawalOPTAdjust = @GS_NL_WithdrawalOPTAdjust + @GS_Loan_WithdrawalOPTAdjust;
        set @GS_Total_InterestOPTAdjust = @GS_NL_InterestOPTAdjust + @GS_Loan_InterestOPTAdjust;
        set @GS_Total_FineOPTAdjust = @GS_NL_FineOPTAdjust + @GS_Loan_FineOPTAdjust;
        set @GS_Total_BalanceOPTAdjust = @GS_NL_BalanceOPTAdjust + @GS_Loan_BalanceOPTAdjust;

        set @RVS_Total_CustomerOPTAdjust = @RVS_NL_CustomerOPTAdjust + @RVS_Loan_CustomerOPTAdjust;
        set @RVS_Total_DepositOPTAdjust = @RVS_NL_DepositOPTAdjust + @RVS_Loan_DepositOPTAdjust;
        set @RVS_Total_WithdrawalOPTAdjust = @RVS_NL_WithdrawalOPTAdjust + @RVS_Loan_WithdrawalOPTAdjust;
        set @RVS_Total_InterestOPTAdjust = @RVS_NL_InterestOPTAdjust + @RVS_Loan_InterestOPTAdjust;
        set @RVS_Total_FineOPTAdjust = @RVS_NL_FineOPTAdjust + @RVS_Loan_FineOPTAdjust;
        set @RVS_Total_BalanceOPTAdjust = @RVS_NL_BalanceOPTAdjust + @RVS_Loan_BalanceOPTAdjust;

        set @CS_Total_CustomerOPTAdjust = @CS_NL_CustomerOPTAdjust + @CS_Loan_CustomerOPTAdjust;
        set @CS_Total_DepositOPTAdjust = @CS_NL_DepositOPTAdjust + @CS_Loan_DepositOPTAdjust;
        set @CS_Total_WithdrawalOPTAdjust = @CS_NL_WithdrawalOPTAdjust + @CS_Loan_WithdrawalOPTAdjust;
        set @CS_Total_InterestOPTAdjust = @CS_NL_InterestOPTAdjust + @CS_Loan_InterestOPTAdjust;
        set @CS_Total_FineOPTAdjust = @CS_NL_FineOPTAdjust + @CS_Loan_FineOPTAdjust;
        set @CS_Total_BalanceOPTAdjust = @CS_NL_BalanceOPTAdjust + @CS_Loan_BalanceOPTAdjust;

        set @GT_CustomerOPTAdjust = @GS_Total_CustomerOPTAdjust + @RVS_Total_CustomerOPTAdjust + @CS_Total_CustomerOPTAdjust;
        set @GT_DepositOPTAdjust = @GS_Total_DepositOPTAdjust + @RVS_Total_DepositOPTAdjust + @CS_Total_DepositOPTAdjust;
        set @GT_WithdrawalOPTAdjust = @GS_Total_WithdrawalOPTAdjust + @RVS_Total_WithdrawalOPTAdjust + @CS_Total_WithdrawalOPTAdjust;
        set @GT_InterestOPTAdjust = @GS_Total_InterestOPTAdjust + @RVS_Total_InterestOPTAdjust + @CS_Total_InterestOPTAdjust;
        set @GT_FineOPTAdjust = @GS_Total_FineOPTAdjust + @RVS_Total_FineOPTAdjust + @CS_Total_FineOPTAdjust;
        set @GT_BalanceOPTAdjust = @GS_Total_BalanceOPTAdjust + @RVS_Total_BalanceOPTAdjust + @CS_Total_BalanceOPTAdjust;
		-----------------------


		declare current_month cursor for
		Select a.savingsProductId,a.category,IsNull(sum(a.customer),0),IsNull(sum(a.noOfDroout),0), IsNull(sum(a.Deposit),0), IsNull(sum(a.Withdrawal),0),IsNull(sum(a.Interest),0), IsNull(sum(a.Fine),0)  
		From tblSavingsPortfolio a with (nolock) 
		inner join tblBranch b with (nolock) on a.branchId=b.branchId inner join tblSavingsProduct l with (nolock)  on a.SavingsProductId = l.SavingsProductId 
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = a.branchId  inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId 
		left outer join tblproject p with (nolock) on p.projectId = bl.projectId  
		Where year(a.entryDate) = year(@startDate1) And month(a.entryDate) = month(@startDate1) AND 
		b.branchid in(select * from @BranchList)
		AND bl.reportDate=@endDate1
		group by a.savingsProductId,a.category

		open current_month
		fetch next from current_month
		INTO @productId,@category,@CustomerCount,@DropCustomer,@Deposit,@Withdrawal,@Interest,@Fine

		while @@FETCH_STATUS=0
		begin
			if(@productId='01')
			begin
			--print '' 
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
						SET @GS_Loan_CustomerCM=@CustomerCount
						SET @GS_Loan_DropCustomerCM=@DropCustomer
						SET @GS_Loan_DepositCM=@Deposit
						SET @GS_Loan_WithdrawalCM=@Withdrawal
						SET @GS_Loan_InterestCM=@Interest
						SET @GS_Loan_FineCM=@Fine
						SET @GS_Loan_BalanceCM=@GS_Loan_DepositCM - @GS_Loan_WithdrawalCM
					end
				else
					begin
					--print ''
							set @GS_NL_CustomerCM = @CustomerCount
							set @GS_NL_DropCustomerCM = @DropCustomer
							set @GS_NL_DepositCM = @Deposit
							set @GS_NL_WithdrawalCM = @Withdrawal
							set @GS_NL_InterestCM = @Interest
							set @GS_NL_FineCM = @Fine
							set @GS_NL_BalanceCM = @GS_NL_DepositCM - @GS_NL_WithdrawalCM;
					end
			end
			if(@productId='02')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
							set @CS_Loan_CustomerCM = @CustomerCount
							set @CS_Loan_DepositCM = @Deposit
							set @CS_Loan_WithdrawalCM = @Withdrawal
							set @CS_Loan_InterestCM = @Interest
							set @CS_Loan_FineCM = @Fine
							set @CS_Loan_BalanceCM = @CS_Loan_DepositCM - @CS_Loan_WithdrawalCM;
					end
				else
					begin
					--print ''
							set @CS_NL_CustomerCM = @CustomerCount
							set @CS_NL_DepositCM = @Deposit
							set @CS_NL_WithdrawalCM = @Withdrawal
							set @CS_NL_InterestCM = @Interest
							set @CS_NL_FineCM = @Fine
							set @CS_NL_BalanceCM = @CS_NL_DepositCM - @CS_NL_WithdrawalCM;
					end
			end
			if(@productId='03')
			begin
			--print ''
				if(@category='Having Loan During Reporting Month')
					begin
					--print ''
							set @RVS_Loan_CustomerCM = @CustomerCount
							set @RVS_Loan_DepositCM = @Deposit
							set @RVS_Loan_WithdrawalCM = @Withdrawal
							set @RVS_Loan_InterestCM = @Interest
							set @RVS_Loan_FineCM = @Fine
							set @RVS_Loan_BalanceCM = @RVS_Loan_DepositCM - @RVS_Loan_WithdrawalCM;
					end
				else
					begin
					--print ''
							set @RVS_NL_CustomerCM = @CustomerCount
							set @RVS_NL_DepositCM = @Deposit
							set @RVS_NL_WithdrawalCM = @Withdrawal
							set @RVS_NL_InterestCM = @Interest
							set @RVS_NL_FineCM = @Fine
							set @RVS_NL_BalanceCM = @RVS_NL_DepositCM - @RVS_NL_WithdrawalCM;
					end
			end
			fetch next from current_month
			INTO @productId,@category,@CustomerCount,@DropCustomer,@Deposit,@Withdrawal,@Interest,@Fine
		end
		close current_month
		deallocate current_month
		
	

		SET @GS_Total_CustomerCM = @GS_Loan_CustomerCM + @GS_NL_CustomerCM;
        SET @GS_Total_DepositCM = @GS_Loan_DepositCM + @GS_NL_DepositCM;
        SET @GS_Total_WithdrawalCM = @GS_NL_WithdrawalCM + @GS_Loan_WithdrawalCM;
        SET @GS_Total_InterestCM = @GS_NL_InterestCM + @GS_Loan_InterestCM;
        SET @GS_Total_FineCM = @GS_NL_FineCM + @GS_Loan_FineCM;
        SET @GS_Total_BalanceCM = @GS_NL_BalanceCM + @GS_Loan_BalanceCM;

        SET @RVS_Total_CustomerCM = @RVS_NL_CustomerCM + @RVS_Loan_CustomerCM;
        SET @RVS_Total_DepositCM = @RVS_NL_DepositCM + @RVS_Loan_DepositCM;
        SET @RVS_Total_WithdrawalCM = @RVS_NL_WithdrawalCM + @RVS_Loan_WithdrawalCM;
        SET @RVS_Total_InterestCM = @RVS_NL_InterestCM + @RVS_Loan_InterestCM;
        SET @RVS_Total_FineCM = @RVS_NL_FineCM + @RVS_Loan_FineCM;
        SET @RVS_Total_BalanceCM = @RVS_NL_BalanceCM + @RVS_Loan_BalanceCM;

        SET @CS_Total_CustomerCM = @CS_NL_CustomerCM + @CS_Loan_CustomerCM;
        SET @CS_Total_DepositCM = @CS_NL_DepositCM + @CS_Loan_DepositCM;
        SET @CS_Total_WithdrawalCM = @CS_NL_WithdrawalCM + @CS_Loan_WithdrawalCM;
        SET @CS_Total_InterestCM = @CS_NL_InterestCM + @CS_Loan_InterestCM;
        SET @CS_Total_FineCM = @CS_NL_FineCM + @CS_Loan_FineCM;
        SET @CS_Total_BalanceCM = @CS_NL_BalanceCM + @CS_Loan_BalanceCM;


        SET @GT_CustomerCM = @GS_Total_CustomerCM + @RVS_Total_CustomerCM + @CS_Total_CustomerCM;
        SET @GT_DepositCM = @GS_Total_DepositCM + @RVS_Total_DepositCM + @CS_Total_DepositCM;
        SET @GT_WithdrawalCM = @GS_Total_WithdrawalCM + @RVS_Total_WithdrawalCM + @CS_Total_WithdrawalCM;
        SET @GT_InterestCM = @GS_Total_InterestCM + @RVS_Total_InterestCM + @CS_Total_InterestCM;
        SET @GT_FineCM = @GS_Total_FineCM + @RVS_Total_FineCM + @CS_Total_FineCM;
        SET @GT_BalanceCM = @GS_Total_BalanceCM + @RVS_Total_BalanceCM + @CS_Total_BalanceCM;

        --Set Closing Balance
		----------------------------------
		print '@month value is' + cast(month(@startDate1)as nvarchar)
		--print '@GS_Loan_CustomerCM value is' + cast(@GS_Loan_CustomerCM as nvarchar)
		
		---changed---
		--SET @GS_Loan_CustomerCL = @GS_Loan_CustomerOP + @GS_Loan_CustomerCM + @GS_Loan_CustomerOPT

        SET @GS_Loan_CustomerCL = @GS_Loan_CustomerOP + @GS_Loan_CustomerCM + @GS_Loan_CustomerOPT-@GS_Loan_DropCustomerOP;

        SET @GS_Loan_DepositCL = @GS_Loan_DepositOP + @GS_Loan_DepositCM+@GS_Loan_DepositOPT;
        SET @GS_Loan_WithdrawalCL = @GS_Loan_WithdrawalOP + @GS_Loan_WithdrawalCM+@GS_Loan_WithdrawalOPT;
        SET @GS_Loan_InterestCL = @GS_Loan_InterestOP + @GS_Loan_InterestCM+@GS_Loan_InterestOPT;
        SET @GS_Loan_FineCL = @GS_Loan_FineOP + @GS_Loan_FineCM+@GS_Loan_FineOPT;


		--if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		--SET @GS_Loan_BalanceCL = @GS_Loan_BalanceOP + @GS_Loan_BalanceCM+@GS_Loan_BalanceOPT+@GS_Loan_InterestCM-@GS_Loan_FineCM;
		--end
		--else
		--begin

		--SET @GS_Loan_BalanceCL = @GS_Loan_BalanceOP + @GS_Loan_BalanceCM+@GS_Loan_BalanceOPT;
		
		
		--end
        SET @GS_Loan_BalanceCL = @GS_Loan_BalanceOP + @GS_Loan_BalanceCM+@GS_Loan_BalanceOPT;
        
	----changed------
		--SET @GS_Total_CustomerCL = @GS_Total_CustomerOP + @GS_Total_CustomerCM+@GS_Total_CustomerOPT
        SET @GS_Total_CustomerCL = @GS_Total_CustomerOP + @GS_Total_CustomerCM+@GS_Total_CustomerOPT-@GS_Loan_DropCustomerOP-@GS_NL_DropCustomerOP;
        SET @GS_NL_CustomerCL = @GS_Total_CustomerCL - @GS_Loan_CustomerCL;
        SET @GS_NL_DepositCL = @GS_NL_DepositOP + @GS_NL_DepositCM+@GS_NL_DepositOPT;
        SET @GS_NL_WithdrawalCL = @GS_NL_WithdrawalOP + @GS_NL_WithdrawalCM + @GS_NL_WithdrawalOPT;
        SET @GS_NL_InterestCL = @GS_NL_InterestOP + @GS_NL_InterestCM + @GS_NL_InterestOPT;
        SET @GS_NL_FineCL = @GS_NL_FineOP + @GS_NL_FineCM + @GS_NL_FineOPT;

		--if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		-- SET @GS_NL_BalanceCL = @GS_NL_BalanceOP + @GS_NL_BalanceCM + @GS_NL_BalanceOPT - @GS_NL_FineCM+ @GS_NL_InterestCM;
		--end
		--else
		--begin
		 
		--SET @GS_NL_BalanceCL = @GS_NL_BalanceOP + @GS_NL_BalanceCM + @GS_NL_BalanceOPT;
		--end

		SET @GS_NL_BalanceCL = @GS_NL_BalanceOP + @GS_NL_BalanceCM + @GS_NL_BalanceOPT;



       

        SET @GS_Total_DepositCL = @GS_Total_DepositOP + @GS_Total_DepositCM + @GS_Total_DepositOPT;
        SET @GS_Total_WithdrawalCL = @GS_Total_WithdrawalOP + @GS_Total_WithdrawalCM + @GS_Total_WithdrawalOPT;
        SET @GS_Total_InterestCL = @GS_Total_InterestOP + @GS_Total_InterestCM + @GS_Total_InterestOPT;
        SET @GS_Total_FineCL = @GS_Total_FineOP + @GS_Total_FineCM + @GS_Total_FineOPT;


		--if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		-- SET @GS_Total_BalanceCL = @GS_Total_BalanceOP + @GS_Total_BalanceCM + @GS_Total_BalanceOPT -@GS_Total_FineCM+@GS_Total_InterestCM;
		--end
		--else
		--begin
		  
		--SET @GS_Total_BalanceCL = @GS_Total_BalanceOP + @GS_Total_BalanceCM + @GS_Total_BalanceOPT;
		--end
		SET @GS_Total_BalanceCL = @GS_Total_BalanceOP + @GS_Total_BalanceCM + @GS_Total_BalanceOPT;

       

        SET @RVS_Loan_CustomerCL = @RVS_Loan_CustomerOP + @RVS_Loan_CustomerCM + @RVS_Loan_CustomerOPT;
        SET @RVS_Loan_DepositCL = @RVS_Loan_DepositOP + @RVS_Loan_DepositCM + @RVS_Loan_DepositOPT;
        SET @RVS_Loan_WithdrawalCL = @RVS_Loan_WithdrawalOP + @RVS_Loan_WithdrawalCM + @RVS_Loan_WithdrawalOPT;
        SET @RVS_Loan_InterestCL = @RVS_Loan_InterestOP + @RVS_Loan_InterestCM + @RVS_Loan_InterestOPT;
        SET @RVS_Loan_FineCL = @RVS_Loan_FineOP + @RVS_Loan_FineCM + @RVS_Loan_FineOPT;


		
		if(month(@startDate1)=6 and  year(@startDate1)>2017)
		begin 
		SET @RVS_Loan_BalanceCL = @RVS_Loan_BalanceOP + @RVS_Loan_BalanceCM + @RVS_Loan_BalanceOPT-@RVS_Loan_FineCM+@RVS_Loan_InterestCM;
		end
		else
		begin
		 
		 SET @RVS_Loan_BalanceCL = @RVS_Loan_BalanceOP + @RVS_Loan_BalanceCM + @RVS_Loan_BalanceOPT;
		end

        

        SET @RVS_Total_CustomerCL = @RVS_Total_CustomerOP + @RVS_Total_CustomerCM + @RVS_Total_CustomerOPT;
        SET @RVS_NL_CustomerCL = @RVS_Total_CustomerCL - @RVS_Loan_CustomerCL;
        SET @RVS_NL_DepositCL = @RVS_NL_DepositOP + @RVS_NL_DepositCM + @RVS_NL_DepositOPT;
        SET @RVS_NL_WithdrawalCL = @RVS_NL_WithdrawalOP + @RVS_NL_WithdrawalCM + @RVS_NL_WithdrawalOPT;
        SET @RVS_NL_InterestCL = @RVS_NL_InterestOP + @RVS_NL_InterestCM + @RVS_NL_InterestOPT;
        SET @RVS_NL_FineCL = @RVS_NL_FineOP + @RVS_NL_FineCM + @RVS_NL_FineOPT;

		if(month(@startDate1)=6 and  year(@startDate1)>2017)
		begin 
		  
		  SET @RVS_NL_BalanceCL = @RVS_NL_BalanceOP + @RVS_NL_BalanceCM + @RVS_NL_BalanceOPT-@RVS_NL_FineCM+@RVS_NL_InterestCM;
		end
		else
		begin
		  SET @RVS_NL_BalanceCL = @RVS_NL_BalanceOP + @RVS_NL_BalanceCM + @RVS_NL_BalanceOPT;
		
		end



       

        SET @RVS_Total_DepositCL = @RVS_Total_DepositOP + @RVS_Total_DepositCM + @RVS_Total_DepositOPT;
        SET @RVS_Total_WithdrawalCL = @RVS_Total_WithdrawalOP + @RVS_Total_WithdrawalCM + @RVS_Total_WithdrawalOPT;
        SET @RVS_Total_InterestCL = @RVS_Total_InterestOP + @RVS_Total_InterestCM + @RVS_Total_InterestOPT;
        SET @RVS_Total_FineCL = @RVS_Total_FineOP + @RVS_Total_FineCM + @RVS_Total_FineOPT;





		--	if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 

		-- SET @RVS_Total_BalanceCL = @RVS_Total_BalanceOP + @RVS_Total_BalanceCM + @RVS_Total_BalanceOPT-@RVS_Total_FineCM+@RVS_Total_InterestCM;
		  
		--end
		--else
		--begin
		  
		--SET @RVS_Total_BalanceCL = @RVS_Total_BalanceOP + @RVS_Total_BalanceCM + @RVS_Total_BalanceOPT;
		--end
       
	   SET @RVS_Total_BalanceCL = @RVS_Total_BalanceOP + @RVS_Total_BalanceCM + @RVS_Total_BalanceOPT;

        SET @CS_Loan_CustomerCL = @CS_Loan_CustomerOP + @CS_Loan_CustomerCM + @CS_Loan_CustomerOPT;
        SET @CS_Loan_DepositCL = @CS_Loan_DepositOP + @CS_Loan_DepositCM + @CS_Loan_DepositOPT;
        SET @CS_Loan_WithdrawalCL = @CS_Loan_WithdrawalOP + @CS_Loan_WithdrawalCM + @CS_Loan_WithdrawalOPT;
        SET @CS_Loan_InterestCL = @CS_Loan_InterestOP + @CS_Loan_InterestCM + @CS_Loan_InterestOPT;
        SET @CS_Loan_FineCL = @CS_Loan_FineOP + @CS_Loan_FineCM + @CS_Loan_FineOPT;

		--		if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		 
		-- SET @CS_Loan_BalanceCL = @CS_Loan_BalanceOP + @CS_Loan_BalanceCM + @CS_Loan_BalanceOPT-@CS_Loan_FineCM+@CS_Loan_InterestCM;
		--end
		--else
		--begin
		  
		--   SET @CS_Loan_BalanceCL = @CS_Loan_BalanceOP + @CS_Loan_BalanceCM + @CS_Loan_BalanceOPT;
		
		--end


		SET @CS_Loan_BalanceCL = @CS_Loan_BalanceOP + @CS_Loan_BalanceCM + @CS_Loan_BalanceOPT;

        
        SET @CS_Total_CustomerCL = @CS_Total_CustomerOP + @CS_Total_CustomerCM + @CS_Total_CustomerOPT;
        SET @CS_NL_CustomerCL = @CS_Total_CustomerCL - @CS_Loan_CustomerCL;
        SET @CS_NL_DepositCL = @CS_NL_DepositOP + @CS_NL_DepositCM + @CS_NL_DepositOPT;
        SET @CS_NL_WithdrawalCL = @CS_NL_WithdrawalOP + @CS_NL_WithdrawalCM + @CS_NL_WithdrawalOPT;
        SET @CS_NL_InterestCL = @CS_NL_InterestOP + @CS_NL_InterestCM + @CS_NL_InterestOPT;
        SET @CS_NL_FineCL = @CS_NL_FineOP + @CS_NL_FineCM + @CS_NL_FineOPT;

		--			if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		
		-- SET @CS_NL_BalanceCL = @CS_NL_BalanceOP + @CS_NL_BalanceCM + @CS_NL_BalanceOPT-@CS_NL_FineCM+@CS_NL_InterestCM;
		--end
		--else
		--begin
		
		--SET @CS_NL_BalanceCL = @CS_NL_BalanceOP + @CS_NL_BalanceCM + @CS_NL_BalanceOPT;
		--end
		SET @CS_NL_BalanceCL = @CS_NL_BalanceOP + @CS_NL_BalanceCM + @CS_NL_BalanceOPT;
        

        SET @CS_Total_DepositCL = @CS_Total_DepositOP + @CS_Total_DepositCM + @CS_Total_DepositOPT;
        SET @CS_Total_WithdrawalCL = @CS_Total_WithdrawalOP + @CS_Total_WithdrawalCM + @CS_Total_WithdrawalOPT;
        SET @CS_Total_InterestCL = @CS_Total_InterestOP + @CS_Total_InterestCM + @CS_Total_InterestOPT;
        SET @CS_Total_FineCL = @CS_Total_FineOP + @CS_Total_FineCM + @CS_Total_FineOPT;

		--			if(month(@startDate1)=6 and  year(@startDate1)>2017)
		--begin 
		--SET @CS_Total_BalanceCL = @CS_Total_BalanceOP + @CS_Total_BalanceCM + @CS_Total_BalanceOPT-@CS_Total_FineCM+@CS_Total_InterestCM;

		--end
		--else
		--begin
		
		--SET @CS_Total_BalanceCL = @CS_Total_BalanceOP + @CS_Total_BalanceCM + @CS_Total_BalanceOPT;
		--end

		SET @CS_Total_BalanceCL = @CS_Total_BalanceOP + @CS_Total_BalanceCM + @CS_Total_BalanceOPT;


        

        SET @GT_CustomerCL = @GT_CustomerOP + @GT_CustomerCM + @GT_CustomerOPT ;
        SET @GT_DepositCL = @GT_DepositOP + @GT_DepositCM + @GT_DepositOPT;
        SET @GT_WithdrawalCL = @GT_WithdrawalOP + @GT_WithdrawalCM + @GT_WithdrawalOPT;
        SET @GT_InterestCL = @GT_InterestOP + @GT_InterestCM + @GT_InterestOPT;
        SET @GT_FineCL = @GT_FineOP + @GT_FineCM + @GT_FineOPT;
        SET @GT_BalanceCL = @GT_BalanceOP + @GT_BalanceCM + @GT_BalanceOPT;

		--Opening Adjust for Transfer
		----------------------------------
	    SET @GS_Loan_CustomerOP = @GS_Loan_CustomerOP + @GS_Loan_CustomerOPTAdjust;
        SET @GS_Loan_DepositOP = @GS_Loan_DepositOP+@GS_Loan_DepositOPTAdjust;
        SET @GS_Loan_WithdrawalOP = @GS_Loan_WithdrawalOP + @GS_Loan_WithdrawalOPTAdjust;
        SET @GS_Loan_InterestOP = @GS_Loan_InterestOP + @GS_Loan_InterestOPTAdjust;
        SET @GS_Loan_FineOP = @GS_Loan_FineOP + @GS_Loan_FineOPTAdjust;
        SET @GS_Loan_BalanceOP = @GS_Loan_BalanceOP + @GS_Loan_BalanceOPTAdjust;

        SET @GS_Total_CustomerOP = @GS_Total_CustomerOP + @GS_Total_CustomerOPTAdjust;
        --SET @GS_NL_CustomerCL = @GS_Total_CustomerCL - @GS_Loan_CustomerCL;
        SET @GS_NL_DepositOP = @GS_NL_DepositOP + @GS_NL_DepositOPTAdjust;
        SET @GS_NL_WithdrawalOP = @GS_NL_WithdrawalOP + @GS_NL_WithdrawalOPTAdjust;
        SET @GS_NL_InterestOP = @GS_NL_InterestOP + @GS_NL_InterestOPTAdjust;
        SET @GS_NL_FineOP = @GS_NL_FineOP + @GS_NL_FineOPTAdjust;
        SET @GS_NL_BalanceOP = @GS_NL_BalanceOP + @GS_NL_BalanceOPTAdjust;

        SET @GS_Total_DepositOP = @GS_Total_DepositOP + @GS_Total_DepositOPTAdjust;
        SET @GS_Total_WithdrawalOP = @GS_Total_WithdrawalOP + @GS_Total_WithdrawalOPTAdjust;
        SET @GS_Total_InterestOP = @GS_Total_InterestOP + @GS_Total_InterestOPTAdjust;
        SET @GS_Total_FineOP = @GS_Total_FineOP + @GS_Total_FineOPTAdjust;
        SET @GS_Total_BalanceOP = @GS_Total_BalanceOP + @GS_Total_BalanceOPTAdjust;

        SET @RVS_Loan_CustomerOP = @RVS_Loan_CustomerOP + @RVS_Loan_CustomerOPTAdjust;
        SET @RVS_Loan_DepositOP = @RVS_Loan_DepositOP + @RVS_Loan_DepositOPTAdjust;
        SET @RVS_Loan_WithdrawalOP = @RVS_Loan_WithdrawalOP + @RVS_Loan_WithdrawalOPTAdjust;
        SET @RVS_Loan_InterestOP = @RVS_Loan_InterestOP + @RVS_Loan_InterestOPTAdjust;
        SET @RVS_Loan_FineOP = @RVS_Loan_FineOP + @RVS_Loan_FineOPTAdjust;
        SET @RVS_Loan_BalanceOP = @RVS_Loan_BalanceOP + @RVS_Loan_BalanceOPTAdjust;

        SET @RVS_Total_CustomerOP = @RVS_Total_CustomerOP + @RVS_Total_CustomerOPTAdjust;
        --SET @RVS_NL_CustomerCL = @RVS_Total_CustomerCL - @RVS_Loan_CustomerCL;
        SET @RVS_NL_DepositOP = @RVS_NL_DepositOP + @RVS_NL_DepositOPTAdjust;
        SET @RVS_NL_WithdrawalOP = @RVS_NL_WithdrawalOP + @RVS_NL_WithdrawalOPTAdjust;
        SET @RVS_NL_InterestOP = @RVS_NL_InterestOP + @RVS_NL_InterestOPTAdjust;
        SET @RVS_NL_FineOP = @RVS_NL_FineOP + @RVS_NL_FineOPTAdjust;
        SET @RVS_NL_BalanceOP = @RVS_NL_BalanceOP + @RVS_NL_BalanceOPTAdjust;

        SET @RVS_Total_DepositOP = @RVS_Total_DepositOP + @RVS_Total_DepositOPTAdjust;
        SET @RVS_Total_WithdrawalOP = @RVS_Total_WithdrawalOP + @RVS_Total_WithdrawalOPTAdjust;
        SET @RVS_Total_InterestOP = @RVS_Total_InterestOP + @RVS_Total_InterestOPTAdjust;
        SET @RVS_Total_FineOP = @RVS_Total_FineOP + @RVS_Total_FineOPTAdjust;
        SET @RVS_Total_BalanceOP = @RVS_Total_BalanceOP + @RVS_Total_BalanceOPTAdjust;

        SET @CS_Loan_CustomerOP = @CS_Loan_CustomerOP + @CS_Loan_CustomerOPTAdjust;
        SET @CS_Loan_DepositOP = @CS_Loan_DepositOP + @CS_Loan_DepositOPTAdjust;
        SET @CS_Loan_WithdrawalOP = @CS_Loan_WithdrawalOP + @CS_Loan_WithdrawalOPTAdjust;
        SET @CS_Loan_InterestOP = @CS_Loan_InterestOP + @CS_Loan_InterestOPTAdjust;
        SET @CS_Loan_FineOP = @CS_Loan_FineOP +  @CS_Loan_FineOPTAdjust;
        SET @CS_Loan_BalanceOP = @CS_Loan_BalanceOP + @CS_Loan_BalanceOPTAdjust;

        SET @CS_Total_CustomerOP = @CS_Total_CustomerOP + @CS_Total_CustomerOPTAdjust;
        --SET @CS_NL_CustomerCL = @CS_Total_CustomerCL - @CS_Loan_CustomerCL;
        SET @CS_NL_DepositOP = @CS_NL_DepositOP + @CS_NL_DepositOPTAdjust;
        SET @CS_NL_WithdrawalOP = @CS_NL_WithdrawalOP + @CS_NL_WithdrawalOPTAdjust;
        SET @CS_NL_InterestOP = @CS_NL_InterestOP + @CS_NL_InterestOPTAdjust;
        SET @CS_NL_FineOP = @CS_NL_FineOP + @CS_NL_FineOPTAdjust;
        SET @CS_NL_BalanceOP = @CS_NL_BalanceOP + @CS_NL_BalanceOPTAdjust;

        SET @CS_Total_DepositOP = @CS_Total_DepositOP + @CS_Total_DepositOPTAdjust;
        SET @CS_Total_WithdrawalOP = @CS_Total_WithdrawalOP + @CS_Total_WithdrawalOPTAdjust;
        SET @CS_Total_InterestOP = @CS_Total_InterestOP + @CS_Total_InterestOPTAdjust;
        SET @CS_Total_FineOP = @CS_Total_FineOP + @CS_Total_FineOPTAdjust;
        SET @CS_Total_BalanceOP = @CS_Total_BalanceOP + @CS_Total_BalanceOPTAdjust;

        SET @GT_CustomerOP = @GT_CustomerOP + @GT_CustomerOPTAdjust;
        SET @GT_DepositOP = @GT_DepositOP + @GT_DepositOPTAdjust;
        SET @GT_WithdrawalOP = @GT_WithdrawalOP + @GT_WithdrawalOPTAdjust;
        SET @GT_InterestOP = @GT_InterestOP + @GT_InterestOPTAdjust;
        SET @GT_FineOP = @GT_FineOP + @GT_FineOPTAdjust;
        SET @GT_BalanceOP = @GT_BalanceOP + @GT_BalanceOPTAdjust;
		----------------------------------------------------------------------


		DECLARE @SS_Upto_2000_Customer AS NUMERIC(18,0);
        DECLARE @SS_Upto_2000_Balance AS NUMERIC(18,0);
        DECLARE @SS_2001_5000_Customer AS NUMERIC(18,0);
        DECLARE @SS_2001_5000_Balance AS NUMERIC(18,0);
        DECLARE @SS_5001_10000_Customer AS NUMERIC(18,0);
        DECLARE @SS_5001_10000_Balance AS NUMERIC(18,0);
        DECLARE @SS_10001_20000_Customer AS NUMERIC(18,0);
        DECLARE @SS_10001_20000_Balance AS NUMERIC(18,0);
        DECLARE @SS_20001Above_Customer AS NUMERIC(18,0);
        DECLARE @SS_20001Above_Balance AS NUMERIC(18,0);
        DECLARE @SS_Total_Customer AS NUMERIC(18,0);
        DECLARE @SS_Total_Balance AS NUMERIC(18,0);

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
			--Changed---
		set @GS_Loan_CustomerOP=@GS_Loan_CustomerOP-@GS_Loan_DropCustomerOP
		set @GS_NL_CustomerOP=@GS_NL_CustomerOP-@GS_NL_DropCustomerOP
		set @GS_Total_CustomerOP=@GS_Loan_CustomerOP+@GS_NL_CustomerOP

		SELECT @SS_Upto_2000_Customer=IsNull(sum(a.deposit2000Cust),0), @SS_Upto_2000_Balance=IsNull(sum(a.deposit2000Bal),0), @SS_2001_5000_Customer=IsNull(sum(a.deposit2001_5000Cust),0) 
		,@SS_2001_5000_Balance=IsNull(sum(a.deposit2001_5000Bal),0), @SS_5001_10000_Customer=IsNull(sum(a.deposit5001_10000Cust),0),
		@SS_5001_10000_Balance=IsNull(sum(a.deposit5001_10000Bal),0),@SS_10001_20000_Customer=IsNull(sum(deposit10001_20000Cust),0), 
		@SS_10001_20000_Balance=IsNull(sum(a.deposit10001_20000Bal),0), @SS_20001Above_Customer=IsNull(sum(a.deposit20001_AboveCust),0),
		@SS_20001Above_Balance=IsNull(sum(a.deposit20001_AboveBal),0) from tblSavingsPortfolioSize a 
		inner join tblBranch b on a.branchId=b.branchId  
		inner join func_TempBranchLines(@endDate1) bl on bl.branchId = a.branchId  
		inner join tblArea ar with (nolock) on ar.areaId = bl.areaId  
		inner join tblSubZone s with (nolock) on s.subZoneId=bl.subZoneId 
		inner join tblZone z with (nolock) on z.ZoneId=bl.ZoneId
		left join tblDivision d with (nolock) on d.divisionId=bl.DivisionId 
		left outer join tblproject p with (nolock) on p.projectId = bl.projectId  
		Where year(a.entryDate) = year(@startDate1) And month(a.entryDate) = month(@startDate1) AND 
		b.branchid in(select * from @BranchList)
		AND bl.reportDate=@endDate1
		
        SET @SS_Total_Customer = @SS_Upto_2000_Customer + @SS_2001_5000_Customer + @SS_5001_10000_Customer + @SS_10001_20000_Customer + @SS_20001Above_Customer;
        SET @SS_Total_Balance = @SS_Upto_2000_Balance + @SS_2001_5000_Balance + @SS_5001_10000_Balance + @SS_10001_20000_Balance + @SS_20001Above_Balance;

	--Begin Changed by Ripon (Date:2019-02-04)
		set @GS_Total_DropCustomerCM=@GS_Loan_DropCustomerCM+@GS_NL_DropCustomerCM
		if @SS_Upto_2000_Customer>@GS_Total_DropCustomerCM
		set @SS_Upto_2000_Customer=@SS_Upto_2000_Customer-@GS_Total_DropCustomerCM
		else if @SS_2001_5000_Customer>@GS_Total_DropCustomerCM
		set @SS_2001_5000_Customer=@SS_2001_5000_Customer-@GS_Total_DropCustomerCM
		else if @SS_5001_10000_Customer>@GS_Total_DropCustomerCM
		set @SS_5001_10000_Customer=@SS_5001_10000_Customer-@GS_Total_DropCustomerCM
		else if @SS_10001_20000_Customer>@GS_Total_DropCustomerCM
		set @SS_10001_20000_Customer=@SS_10001_20000_Customer-@GS_Total_DropCustomerCM
		else
		set @SS_20001Above_Customer=@SS_20001Above_Customer-@GS_Total_DropCustomerCM
		--end Changed

		select 
		month(@startDate1) Month,
        year(@startDate1) Year,
        @GS_Loan_DepositOP GS_Loan_Deposit_OP,
        @GS_Loan_WithdrawalOP GS_Loan_Withdrawal_OP,
        @GS_Loan_InterestOP GS_Loan_Interest_OP,
        @GS_Loan_FineOP GS_Loan_Fine_OP,
        @GS_Loan_BalanceOP GS_Loan_Balance_OP, 
        @GS_Loan_CustomerOP GS_Loan_Customer_OP, 
       @GS_Loan_DropCustomerOP GS_Loan_DropCustomer_OP, 
        @GS_NL_DropCustomerOP GS_NL_DropCustomer_OP, 
        @RVS_Loan_DepositOP RVS_Loan_Deposit_OP, 
        @RVS_Loan_WithdrawalOP RVS_Loan_Withdrawal_OP, 
        @RVS_Loan_InterestOP RVS_Loan_Interest_OP, 
        @RVS_Loan_FineOP RVS_Loan_Fine_OP, 
        @RVS_Loan_BalanceOP RVS_Loan_Balance_OP, 
        @RVS_Loan_CustomerOP RVS_Loan_Customer_OP, 
        @CS_Loan_DepositOP CS_Loan_Deposit_OP, 
        @CS_Loan_WithdrawalOP CS_Loan_Withdrawal_OP, 
        @CS_Loan_InterestOP CS_Loan_Interest_OP, 
        @CS_Loan_FineOP CS_Loan_Fine_OP, 
        @CS_Loan_BalanceOP CS_Loan_Balance_OP, 
        @CS_Loan_CustomerOP CS_Loan_Customer_OP, 
        @GS_NL_DepositOP GS_NL_Deposit_OP, 
        @GS_NL_WithdrawalOP GS_NL_Withdrawal_OP, 
        @GS_NL_InterestOP GS_NL_Interest_OP, 
        @GS_NL_FineOP GS_NL_Fine_OP, 
        @GS_NL_BalanceOP GS_NL_Balance_OP, 
        @GS_NL_CustomerOP GS_NL_Customer_OP, 
        @RVS_NL_DepositOP RVS_NL_Deposit_OP, 
        @RVS_NL_WithdrawalOP RVS_NL_Withdrawal_OP, 
        @RVS_NL_InterestOP RVS_NL_Interest_OP, 
        @RVS_NL_FineOP RVS_NL_Fine_OP, 
        @RVS_NL_BalanceOP RVS_NL_Balance_OP, 
        @RVS_NL_CustomerOP RVS_NL_Customer_OP, 
        @CS_NL_DepositOP CS_NL_Deposit_OP, 
        @CS_NL_WithdrawalOP CS_NL_Withdrawal_OP, 
        @CS_NL_InterestOP CS_NL_Interest_OP, 
        @CS_NL_FineOP CS_NL_Fine_OP, 
        @CS_NL_BalanceOP CS_NL_Balance_OP, 
        @CS_NL_CustomerOP CS_NL_Customer_OP, 
        @GS_Total_DepositOP GS_Total_Deposit_OP, 
        @GS_Total_WithdrawalOP GS_Total_Withdrawal_OP, 
        @GS_Total_InterestOP GS_Total_Interest_OP, 
        @GS_Total_FineOP GS_Total_Fine_OP, 
        @GS_Total_BalanceOP GS_Total_Balance_OP, 
        @GS_Total_CustomerOP GS_Total_Customer_OP, 
        @RVS_Total_DepositOP RVS_Total_Deposit_OP, 
        @RVS_Total_WithdrawalOP RVS_Total_Withdrawal_OP, 
        @RVS_Total_InterestOP RVS_Total_Interest_OP, 
        @RVS_Total_FineOP RVS_Total_Fine_OP, 
        @RVS_Total_BalanceOP RVS_Total_Balance_OP, 
        @RVS_Total_CustomerOP RVS_Total_Customer_OP, 
        @CS_Total_DepositOP CS_Total_Deposit_OP, 
        @CS_Total_WithdrawalOP CS_Total_Withdrawal_OP, 
        @CS_Total_InterestOP CS_Total_Interest_OP, 
        @CS_Total_FineOP CS_Total_Fine_OP, 
        @CS_Total_BalanceOP CS_Total_Balance_OP, 
        @CS_Total_CustomerOP CS_Total_Customer_OP, 
        @GT_DepositOP GT_Deposit_OP, 
        @GT_WithdrawalOP GT_Withdrawal_OP, 
        @GT_InterestOP GT_Interest_OP, 
        @GT_FineOP GT_Fine_OP, 
        @GT_BalanceOP GT_Balance_OP, 
        @GT_CustomerOP GT_Customer_OP, 
        @GS_Loan_DepositCM GS_Loan_Deposit_CM, 
        @GS_Loan_WithdrawalCM GS_Loan_Withdrawal_CM, 
        @GS_Loan_InterestCM GS_Loan_Interest_CM, 
        @GS_Loan_FineCM GS_Loan_Fine_CM, 
        @GS_Loan_BalanceCM GS_Loan_Balance_CM, 
        @GS_Loan_CustomerCM GS_Loan_Customer_CM, 
        @RVS_Loan_DepositCM RVS_Loan_Deposit_CM, 
        @RVS_Loan_WithdrawalCM RVS_Loan_Withdrawal_CM, 
        @RVS_Loan_InterestCM RVS_Loan_Interest_CM, 
        @RVS_Loan_FineCM RVS_Loan_Fine_CM, 
        @RVS_Loan_BalanceCM RVS_Loan_Balance_CM, 
        @RVS_Loan_CustomerCM RVS_Loan_Customer_CM, 
        @CS_Loan_DepositCM CS_Loan_Deposit_CM, 
        @CS_Loan_WithdrawalCM CS_Loan_Withdrawal_CM, 
        @CS_Loan_InterestCM CS_Loan_Interest_CM, 
        @CS_Loan_FineCM CS_Loan_Fine_CM, 
        @CS_Loan_BalanceCM CS_Loan_Balance_CM, 
        @CS_Loan_CustomerCM CS_Loan_Customer_CM, 
        @GS_NL_DepositCM GS_NL_Deposit_CM, 
        @GS_NL_WithdrawalCM GS_NL_Withdrawal_CM, 
        @GS_NL_InterestCM GS_NL_Interest_CM, 
        @GS_NL_FineCM GS_NL_Fine_CM, 
        @GS_NL_BalanceCM GS_NL_Balance_CM, 
        @GS_NL_CustomerCM GS_NL_Customer_CM, 
        @GS_NL_DropCustomerCM GS_NL_DropCustomer_CM, 
        @GS_Loan_DropCustomerCM GS_Loan_DropCustomer_CM, 
        @RVS_NL_DepositCM RVS_NL_Deposit_CM, 
        @RVS_NL_WithdrawalCM RVS_NL_Withdrawal_CM, 
        @RVS_NL_InterestCM RVS_NL_Interest_CM, 
        @RVS_NL_FineCM RVS_NL_Fine_CM, 
        @RVS_NL_BalanceCM RVS_NL_Balance_CM, 
        @RVS_NL_CustomerCM RVS_NL_Customer_CM,
        @CS_NL_DepositCM CS_NL_Deposit_CM, 
        @CS_NL_WithdrawalCM CS_NL_Withdrawal_CM, 
        @CS_NL_InterestCM CS_NL_Interest_CM, 
        @CS_NL_FineCM CS_NL_Fine_CM, 
        @CS_NL_BalanceCM CS_NL_Balance_CM, 
        @CS_NL_CustomerCM CS_NL_Customer_CM, 
        @GS_Total_DepositCM GS_Total_Deposit_CM, 
        @GS_Total_WithdrawalCM GS_Total_Withdrawal_CM, 
        @GS_Total_InterestCM GS_Total_Interest_CM, 
        @GS_Total_FineCM GS_Total_Fine_CM, 
        @GS_Total_BalanceCM GS_Total_Balance_CM, 
        @GS_Total_CustomerCM GS_Total_Customer_CM, 
        @RVS_Total_DepositCM RVS_Total_Deposit_CM, 
        @RVS_Total_WithdrawalCM RVS_Total_Withdrawal_CM, 
        @RVS_Total_InterestCM RVS_Total_Interest_CM, 
        @RVS_Total_FineCM RVS_Total_Fine_CM, 
        @RVS_Total_BalanceCM RVS_Total_Balance_CM, 
        @RVS_Total_CustomerCM RVS_Total_Customer_CM, 
        @CS_Total_DepositCM CS_Total_Deposit_CM, 
        @CS_Total_WithdrawalCM CS_Total_Withdrawal_CM, 
        @CS_Total_InterestCM CS_Total_Interest_CM, 
        @CS_Total_FineCM CS_Total_Fine_CM, 
        @CS_Total_BalanceCM CS_Total_Balance_CM, 
        @CS_Total_CustomerCM CS_Total_Customer_CM, 
        @GT_DepositCM GT_Deposit_CM, 
        @GT_WithdrawalCM GT_Withdrawal_CM, 
        @GT_InterestCM GT_Interest_CM, 
        @GT_FineCM GT_Fine_CM, 
        @GT_BalanceCM GT_Balance_CM, 
        @GT_CustomerCM GT_Customer_CM, 
        @GS_Loan_DepositCL GS_Loan_Deposit_CL, 
        @GS_Loan_WithdrawalCL GS_Loan_Withdrawal_CL, 
        @GS_Loan_InterestCL GS_Loan_Interest_CL, 
        @GS_Loan_FineCL GS_Loan_Fine_CL, 
        @GS_Loan_BalanceCL GS_Loan_Balance_CL, 
        @GS_Loan_CustomerCL GS_Loan_Customer_CL, 
        @RVS_Loan_DepositCL RVS_Loan_Deposit_CL, 
        @RVS_Loan_WithdrawalCL RVS_Loan_Withdrawal_CL, 
        @RVS_Loan_InterestCL RVS_Loan_Interest_CL, 
        @RVS_Loan_FineCL RVS_Loan_Fine_CL, 
        @RVS_Loan_BalanceCL RVS_Loan_Balance_CL, 
        @RVS_Loan_CustomerCL RVS_Loan_Customer_CL, 
        @CS_Loan_DepositCL CS_Loan_Deposit_CL, 
        @CS_Loan_WithdrawalCL CS_Loan_Withdrawal_CL, 
        @CS_Loan_InterestCL CS_Loan_Interest_CL, 
        @CS_Loan_FineCL CS_Loan_Fine_CL, 
        @CS_Loan_BalanceCL CS_Loan_Balance_CL, 
        @CS_Loan_CustomerCL CS_Loan_Customer_CL, 
        @GS_NL_DepositCL GS_NL_Deposit_CL, 
        @GS_NL_WithdrawalCL GS_NL_Withdrawal_CL, 
        @GS_NL_InterestCL GS_NL_Interest_CL, 
        @GS_NL_FineCL GS_NL_Fine_CL, 
        @GS_NL_BalanceCL GS_NL_Balance_CL, 
        @GS_NL_CustomerCL GS_NL_Customer_CL, 
        @RVS_NL_DepositCL RVS_NL_Deposit_CL, 
        @RVS_NL_WithdrawalCL RVS_NL_Withdrawal_CL, 
        @RVS_NL_InterestCL RVS_NL_Interest_CL, 
        @RVS_NL_FineCL RVS_NL_Fine_CL, 
        @RVS_NL_BalanceCL RVS_NL_Balance_CL, 
        @RVS_NL_CustomerCL RVS_NL_Customer_CL, 
        @CS_NL_DepositCL CS_NL_Deposit_CL, 
        @CS_NL_WithdrawalCL CS_NL_Withdrawal_CL, 
        @CS_NL_InterestCL CS_NL_Interest_CL, 
        @CS_NL_FineCL CS_NL_Fine_CL, 
        @CS_NL_BalanceCL CS_NL_Balance_CL, 
        @CS_NL_CustomerCL CS_NL_Customer_CL, 
        @GS_Total_DepositCL GS_Total_Deposit_CL, 
        @GS_Total_WithdrawalCL GS_Total_Withdrawal_CL, 
        @GS_Total_InterestCL GS_Total_Interest_CL, 
        @GS_Total_FineCL GS_Total_Fine_CL, 
        @GS_Total_BalanceCL GS_Total_Balance_CL, 
        @GS_Total_CustomerCL GS_Total_Customer_CL, 
        @RVS_Total_DepositCL RVS_Total_Deposit_CL, 
        @RVS_Total_WithdrawalCL RVS_Total_Withdrawal_CL, 
        @RVS_Total_InterestCL RVS_Total_Interest_CL, 
        @RVS_Total_FineCL RVS_Total_Fine_CL, 
        @RVS_Total_BalanceCL RVS_Total_Balance_CL, 
        @RVS_Total_CustomerCL RVS_Total_Customer_CL, 
        @CS_Total_DepositCL CS_Total_Deposit_CL, 
        @CS_Total_WithdrawalCL CS_Total_Withdrawal_CL, 
        @CS_Total_InterestCL CS_Total_Interest_CL, 
        @CS_Total_FineCL CS_Total_Fine_CL, 
        @CS_Total_BalanceCL CS_Total_Balance_CL, 
        @CS_Total_CustomerCL CS_Total_Customer_CL, 
        @GT_DepositCL GT_Deposit_CL, 
        @GT_WithdrawalCL GT_Withdrawal_CL, 
        @GT_InterestCL GT_Interest_CL, 
        @GT_FineCL GT_Fine_CL, 
        @GT_BalanceCL GT_Balance_CL, 
        @GT_CustomerCL GT_Customer_CL, 
		
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
        @SS_Total_Balance SS_Total_Balance


END
