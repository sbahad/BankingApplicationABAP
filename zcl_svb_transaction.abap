CLASS zcl_svb_transaction DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: typ_amt TYPE p LENGTH 12 DECIMALS 2.
    METHODS: get_amount RETURNING VALUE(r_result) TYPE zcl_svb_transaction=>typ_amt,
      get_notes RETURNING VALUE(r_result) TYPE string,
      get_transdate RETURNING VALUE(r_result) TYPE d,
      constructor IMPORTING amount    TYPE typ_amt
                            notes     TYPE string
                            transdate TYPE d.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: amount    TYPE typ_amt,
          notes     TYPE string,
          transdate TYPE d.
ENDCLASS.



CLASS zcl_svb_transaction IMPLEMENTATION.
  METHOD get_amount.
    r_result = me->amount.
  ENDMETHOD.

  METHOD get_notes.
    r_result = me->notes.
  ENDMETHOD.

  METHOD get_transdate.
    r_result = me->transdate.
  ENDMETHOD.

  METHOD constructor.
    me->amount = amount.
    me->notes = notes.
    me->transdate = transdate.


  ENDMETHOD.

ENDCLASS.