CLASS lhc_testline DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validatelinetxt FOR VALIDATE ON SAVE
      IMPORTING keys FOR TestLine~validateLineTxt.

ENDCLASS.

CLASS lhc_testline IMPLEMENTATION.

  METHOD validatelinetxt.
    READ ENTITIES OF zr_pw_tst2_01 IN LOCAL MODE
      ENTITY TestLine
        FIELDS ( LineTxt ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_lines).

    LOOP AT lt_lines INTO DATA(ls_line).
      " with draft, messages are state messages: clear the previous result of this validation first
      APPEND VALUE #( %tky        = ls_line-%tky
                      %state_area = 'VALIDATE_LINETXT' ) TO reported-testline.

      " CS (contains string) is case-insensitive: boss, Boss, BOSS ...
      IF ls_line-LineTxt CS 'boss'.
        APPEND VALUE #( %tky = ls_line-%tky ) TO failed-testline.

        APPEND VALUE #( %tky             = ls_line-%tky
                        %state_area      = 'VALIDATE_LINETXT'
                        %msg             = new_message_with_text(
                                             severity = if_abap_behv_message=>severity-error
                                             text     = 'Line Text must not contain "boss"' )
                        %element-LineTxt = if_abap_behv=>mk-on ) TO reported-testline.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
