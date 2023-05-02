CLASS zcl_svb_giftcardaccount DEFINITION
  PUBLIC
  INHERITING FROM zcl_svb_bankaccount
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        !name             TYPE string
        !initialbalance   TYPE ty_balance
        !monthlyrefillamt TYPE ty_balance
      RAISING
        cx_demo_constructor .

    METHODS performmonthendtransactions
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA monthlyrefill TYPE ty_balance .
ENDCLASS.



CLASS ZCL_SVB_GIFTCARDACCOUNT IMPLEMENTATION.


  METHOD constructor.
    super->constructor( name = name initialbalance = initialbalance ).
    me->monthlyrefill = monthlyrefillamt.
  ENDMETHOD.


  METHOD performmonthendtransactions.
    IF me->monthlyrefill > 0.
      makedeposit( EXPORTING amount = me->monthlyrefill transdate = sy-datum notes = 'Monthly Refill Amount' ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.