Select * from  func_DueRegisterNewFormat('069e35ae-40a1-44ed-96d1-1e4509e5c143',1,'3/1/2023 12:00:00 AM','3/31/2023 12:00:00 AM',1,3,null,1011) where (OpeningCurrentDue = 0 and OpeningMaturedDue = 0) and (currentDue <> 0 or maturedDue <> 0) order by customerID

select * from func_RealizableRealized_new ('069e35ae-40a1-44ed-96d1-1e4509e5c143','3/1/2023 12:00:00 AM','3/31/2023 12:00:00 AM', 1 ,3,1011) WHERE newDue <> 0

--Admission_Bangla.rpt
--Due Register New Format_Ban.rpt
--Loan Disbursement Bangla.rpt
--Loan Fully Paid_Bangla.rpt
--Member Cancellation_Bangla.rpt
--Realizable_Realized_summary_Ban.rpt
--Savings Interest_Bangla.rpt
--Savings Refund With Voluntary_Bangla.rpt
--GroupWiseSavings_Bangla.rpt
--MemberTransactionSavings_Bangla.rpt
--MonthlyLoanInformationSC_Bangla.rpt
--MonthlySavingInformation_Bangla.rpt

--Due Closing
--{viw_MonthlyLoanInformation.DueClosing}-({viw_MonthlyLoanInformation.DueOpening}-{viw_MonthlyLoanInformation.FullRecoveryAmount})