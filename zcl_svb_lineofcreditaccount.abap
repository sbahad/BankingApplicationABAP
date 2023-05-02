CLASS zcl_svb_lineofcreditaccount DEFINITION
  PUBLIC
  INHERITING FROM zcl_svb_bankaccount
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS isoverdraft
        REDEFINITION .
    METHODS performmonthendtransactions
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SVB_LINEOFCREDITACCOUNT IMPLEMENTATION.


  METHOD isoverdraft.
    IF iv_balance < 0.
      eo_ref_Trans = NEW zcl_svb_Transaction( amount = -20 notes = 'Overdraft Fees' transdate = sy-datum ).
    ENDIF.
  ENDMETHOD.


  METHOD performmonthendtransactions.
    DATA: lv_bal     TYPE ty_balance,
          intcharged TYPE ty_balance.
    lv_bal = get_balance( ).
    IF get_balance( ) < 0.
      intcharged = lv_bal  * '.07'.
      makewithdrawl( amount = abs( intcharged ) notes = 'Overdraft Interest' transdate = sy-datum ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.