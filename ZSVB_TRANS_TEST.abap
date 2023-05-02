*&---------------------------------------------------------------------*
*& Report ZSVB_TRANS_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsvb_trans_test.
"define table containing references to bank account
"List<BankAccount> listbankAc = new List<BankAccount>();

TYPES: lo_ref_bank_account TYPE REF TO zcl_svb_bankaccount.
DATA: lt_bank_ac TYPE STANDARD TABLE OF lo_ref_bank_account.

TRY.
    DATA(lo_Ref) = NEW zcl_svb_bankaccount( initialbalance = 2000 name = 'Sanjay' overdraftamount = 0 ).
    lo_Ref->makewithdrawl( EXPORTING amount = 1000 notes = 'Withdrawl for buying furniture' transdate = sy-datum ).
    lo_Ref->MakeDeposit( EXPORTING amount = 500 notes = 'Deposit' transdate = sy-datum ).
    lo_Ref->getaccounthistory( IMPORTING et_trans = DATA(et_trans) ).
    LOOP AT et_Trans ASSIGNING FIELD-SYMBOL(<et_trans>).
      WRITE: / <et_trans>.
    ENDLOOP.


    DATA(lo_Ref1) = NEW zcl_svb_bankaccount( initialbalance = 1000 name = 'Sanjay1' overdraftamount = 0 ).
    lo_Ref1->makewithdrawl( EXPORTING amount = 1000 notes = 'Withdrawl for buying grocery' transdate = sy-datum ).
    lo_Ref1->MakeDeposit( EXPORTING amount = 500 notes = 'Deposit' transdate = sy-datum ).
    lo_Ref1->makewithdrawl( EXPORTING amount = 100 notes = 'Withdrawl2 ' transdate = sy-datum ).
    lo_Ref1->getaccounthistory( IMPORTING et_trans = DATA(et_trans1) ).
    LOOP AT et_Trans1 ASSIGNING FIELD-SYMBOL(<et_trans1>).
      WRITE: / <et_trans1>.
    ENDLOOP.


  CATCH cx_demo_constructor INTO DATA(lo_excep).
    WRITE: / lo_excep->get_text( ).
ENDTRY.



TRY.
    DATA(lo_giftcard) = NEW zcl_svb_giftcardaccount( initialbalance = 100 name = 'gift card' monthlyrefillamt = 50 ).
    lo_giftcard->makewithdrawl( EXPORTING amount = 20 notes = 'Withdrawl for buying coffee' transdate = sy-datum ).
    lo_giftcard->makewithdrawl( EXPORTING amount = 50 notes = 'Withdrawl for buying grocery' transdate = sy-datum ).
    lo_giftcard->MakeDeposit( EXPORTING amount = 27 notes = 'Deposit' transdate = sy-datum ).
    APPEND lo_giftcard TO lt_bank_ac.
  CATCH cx_demo_constructor INTO DATA(lo_excep1).
    WRITE: / lo_excep1->get_text( ).
ENDTRY.
TRY.
    DATA(lo_InterestCharge) = NEW zcl_svb_interestcharge( initialbalance = 1000 name = 'Interest A/c'  ).
    lo_InterestCharge->MakeDeposit( EXPORTING amount = 750 notes = 'Save some money' transdate = sy-datum ).
    lo_InterestCharge->MakeDeposit( EXPORTING amount = 1250 notes = 'Save more money' transdate = sy-datum ).
    lo_InterestCharge->makewithdrawl( EXPORTING amount = 250 notes = 'Withdrawl for utility bills' transdate = sy-datum ).
    APPEND lo_InterestCharge TO lt_bank_ac.
  CATCH cx_demo_constructor INTO DATA(lo_excep2).
    WRITE: / lo_excep2->get_text( ).
ENDTRY.
TRY.
    DATA(lo_LineOfCreditAccount) = NEW zcl_svb_lineofcreditaccount( initialbalance = 0 name = 'Line of credit a/c' overdraftamount = 500 ).
    lo_LineOfCreditAccount->makewithdrawl( EXPORTING amount = 1000 notes = 'Take out monthly advance' transdate = sy-datum ).
    lo_LineOfCreditAccount->MakeDeposit( EXPORTING amount = 50 notes = 'Deposit small amount' transdate = sy-datum ).
    lo_LineOfCreditAccount->makewithdrawl( EXPORTING amount = 5000 notes = 'Take out for emergency repairs' transdate = sy-datum ).
    lo_LineOfCreditAccount->MakeDeposit( EXPORTING amount = 150 notes = 'Save more money' transdate = sy-datum ).
    APPEND lo_LineOfCreditAccount TO lt_bank_ac.
  CATCH cx_demo_constructor INTO DATA(lo_excep3).
    WRITE: / lo_excep3->get_text( ).
ENDTRY.

*foreach (var credit in listbankAc)
*{
*    credit.PerformMonthEndTransactions();
*    Console.WriteLine(credit.GetAccountHistory());
*}

LOOP AT lt_bank_ac INTO DATA(lo_bank_ac).
  lo_bank_ac->performmonthendtransactions( ).
  lo_bank_ac->getaccounthistory( IMPORTING et_trans = DATA(et_trans2) ).
  LOOP AT et_Trans2 ASSIGNING FIELD-SYMBOL(<et_trans2>).
    WRITE: / <et_trans2>.
  ENDLOOP.
  CLEAR et_trans2.
ENDLOOP.