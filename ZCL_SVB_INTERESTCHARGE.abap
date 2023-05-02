class ZCL_SVB_INTERESTCHARGE definition
  public
  inheriting from ZCL_SVB_BANKACCOUNT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !NAME type STRING
      !INITIALBALANCE type TY_BALANCE
    raising
      CX_DEMO_CONSTRUCTOR .

  methods PERFORMMONTHENDTRANSACTIONS
    redefinition .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SVB_INTERESTCHARGE IMPLEMENTATION.


  METHOD constructor.
    super->constructor( name = name initialbalance = initialbalance overdraftamount = 0 ).
  ENDMETHOD.


  METHOD performmonthendtransactions.
    DATA interest TYPE ty_balance.
    DATA(lv_bal) = get_balance( ).

    IF lv_bal > 500.
      interest = lv_bal * '.07'.
      makedeposit( EXPORTING amount = interest notes = 'Interest Paid' transdate = sy-datum ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.