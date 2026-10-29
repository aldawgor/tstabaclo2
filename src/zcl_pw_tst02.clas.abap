CLASS zcl_pw_tst02 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    "! Replaces the content of ZPW_TST2_01 with 10 test records (via RAP business object)
    "! @parameter rv_count | Number of created records (0 on error)
    METHODS init_data
      RETURNING
        VALUE(rv_count) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_pw_tst02 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA(lv_count) = init_data( ).
    IF lv_count > 0.
      out->write( |Created { lv_count } records in ZPW_TST2_01.| ).
    ELSE.
      out->write( |INIT_DATA failed, nothing was saved.| ).
    ENDIF.
  ENDMETHOD.


  METHOD init_data.
    " data is written through the RAP business object (EML), so the framework
    " assigns UUIDs, fills administrative fields and runs the validation
    SELECT LineUuid FROM zr_pw_tst2_01 INTO TABLE @DATA(lt_old).

    " open drafts (e.g. unsaved edits from Fiori) are discarded first;
    " draft actions always work on drafts, so their keys have no %is_draft
    SELECT lineuuid FROM zpw_tst2_01_d INTO TABLE @DATA(lt_drafts).

    IF lt_drafts IS NOT INITIAL.
      MODIFY ENTITIES OF zr_pw_tst2_01
        ENTITY TestLine
          EXECUTE Discard FROM VALUE #( FOR ls_draft IN lt_drafts
                                        ( LineUuid = ls_draft-lineuuid ) )
        FAILED DATA(ls_discard_failed).

      IF ls_discard_failed IS NOT INITIAL.
        ROLLBACK ENTITIES.
        RETURN.
      ENDIF.
    ENDIF.

    " active instances: EML without %is_draft works on active data
    MODIFY ENTITIES OF zr_pw_tst2_01
      ENTITY TestLine
        DELETE FROM VALUE #( FOR ls_old IN lt_old ( LineUuid = ls_old-LineUuid ) )
        CREATE FIELDS ( LineId LineTxt ) WITH VALUE #(
          ( %cid = 'L01' LineId = 'LINE001' LineTxt = 'Alpha' )
          ( %cid = 'L02' LineId = 'LINE002' LineTxt = 'Beta' )
          ( %cid = 'L03' LineId = 'LINE003' LineTxt = 'Gamma' )
          ( %cid = 'L04' LineId = 'LINE004' LineTxt = 'Delta' )
          ( %cid = 'L05' LineId = 'LINE005' LineTxt = 'Epsilon' )
          ( %cid = 'L06' LineId = 'LINE006' LineTxt = 'Zeta' )
          ( %cid = 'L07' LineId = 'LINE007' LineTxt = 'Eta' )
          ( %cid = 'L08' LineId = 'LINE008' LineTxt = 'Theta' )
          ( %cid = 'L09' LineId = 'LINE009' LineTxt = 'Iota' )
          ( %cid = 'L10' LineId = 'LINE010' LineTxt = 'Kappa' ) )
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed).

    IF ls_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RETURN.
    ENDIF.

    COMMIT ENTITIES RESPONSE OF zr_pw_tst2_01
      FAILED DATA(ls_commit_failed).

    IF ls_commit_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RETURN.
    ENDIF.

    rv_count = lines( ls_mapped-testline ).
  ENDMETHOD.
ENDCLASS.
