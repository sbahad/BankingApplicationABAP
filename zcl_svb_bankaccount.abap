CLASS zcl_svb_bankaccount DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_balance TYPE p LENGTH 12 DECIMALS 2 .
    TYPES:
      ty_trans_Tab TYPE STANDARD TABLE OF string .
    TYPES ty_ref_trans TYPE REF TO zcl_svb_transaction .

    METHODS constructor
      IMPORTING
        !name            TYPE string
        !initialbalance  TYPE ty_balance
        !overdraftamount TYPE ty_balance OPTIONAL
      RAISING
        cx_demo_constructor .
    METHODS get_owner
      FINAL
      RETURNING
        VALUE(r_result) TYPE string .
    METHODS set_owner
      FINAL
      IMPORTING
        !i_owner TYPE string .
    METHODS get_balance
      FINAL
      RETURNING
        VALUE(r_result) TYPE ty_balance .
    METHODS get_number
      FINAL
      RETURNING
        VALUE(r_result) TYPE i .
    METHODS makedeposit
      FINAL
      IMPORTING
        !amount    TYPE ty_balance
        !transdate TYPE d
        !notes     TYPE string
      RAISING
        cx_demo_constructor .
    METHODS makewithdrawl
      FINAL
      IMPORTING
        !amount    TYPE ty_balance
        !transdate TYPE d
        !notes     TYPE string
      RAISING
        cx_demo_constructor .
    METHODS getaccounthistory
      FINAL
      EXPORTING
        !et_trans TYPE ty_trans_tab .
    METHODS performmonthendtransactions .
    METHODS isoverdraft
      IMPORTING
        !iv_balance   TYPE ty_balance
      EXPORTING
        !eo_ref_trans TYPE REF TO zcl_svb_transaction
      RAISING
        cx_demo_constructor .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      account_seed TYPE i VALUE '100010110'.
    DATA: owner           TYPE string,
          number          TYPE string,
          balance         TYPE ty_balance,
          overdraftamount TYPE ty_balance.



    DATA: transactions TYPE STANDARD TABLE OF ty_ref_trans.

ENDCLASS.



CLASS zcl_svb_bankaccount IMPLEMENTATION.


  METHOD get_owner.
    r_result = me->owner.
  ENDMETHOD.


  METHOD set_owner.
    me->owner = i_owner.
  ENDMETHOD.


  METHOD get_balance.
    r_result = 0.
    LOOP AT transactions ASSIGNING FIELD-SYMBOL(<transactions>).
      r_result = r_result + <transactions>->get_amount( ).
    ENDLOOP.


  ENDMETHOD.


  METHOD get_number.
    r_result = me->number.
  ENDMETHOD.


  METHOD makedeposit.
    IF amount < 0.
      RAISE EXCEPTION TYPE cx_demo_constructor
        EXPORTING
          textid  = cx_demo_constructor=>cx_demo_constructor
          my_text = 'Amount cannot be less than 0'.
    ENDIF.
    DATA(lo_trans) = NEW zcl_svb_transaction(  amount = amount  notes = notes transdate = transdate ) .
    APPEND lo_Trans TO transactions.
  ENDMETHOD.


  METHOD constructor.
    account_seed = account_Seed + 1.
    me->owner = name.
    me->number = account_seed.
    me->overdraftamount = overdraftamount.
    IF initialbalance > 0.
      makedeposit( EXPORTING amount = initialbalance notes = 'Initial Deposit' transdate = sy-datum ).
    ENDIF.
  ENDMETHOD.


  METHOD getaccounthistory.

    APPEND |Account name: { get_owner( ) } , { get_number( ) }| TO et_trans.
    LOOP AT transactions ASSIGNING FIELD-SYMBOL(<transactions>).
      APPEND |{ <transactions>->get_transdate( ) }, { <transactions>->get_notes( ) }, { <transactions>->get_amount( ) } | TO et_Trans.
    ENDLOOP.
    APPEND |Closing Balance: { get_balance( ) } | TO et_trans.


  ENDMETHOD.


  METHOD isoverdraft.
    IF iv_balance < 0.
      RAISE EXCEPTION TYPE cx_demo_constructor
        EXPORTING
          textid  = cx_demo_constructor=>cx_demo_constructor
          my_text = 'Balance cannot be -ve'.
    ENDIF.
  ENDMETHOD.


  METHOD MakeWithDrawl.
    IF amount < 0.
      RAISE EXCEPTION TYPE cx_demo_constructor
        EXPORTING
          textid  = cx_demo_constructor=>cx_demo_constructor
          my_text = 'Amount cannot be less than 0'.
    ENDIF.
    isoverdraft( EXPORTING iv_balance   = get_balance( ) - amount + overdraftamount
                 IMPORTING eo_ref_trans = DATA(lo_over_draft)
                          ).
    DATA(lo_trans) = NEW zcl_svb_transaction(  amount = - amount  notes = notes transdate = transdate ) .
    APPEND lo_Trans TO transactions.
    IF lo_over_draft IS BOUND.
      APPEND lo_over_draft TO  transactions.
    ENDIF.
  ENDMETHOD.


  METHOD performmonthendtransactions.
  ENDMETHOD.
ENDCLASS.