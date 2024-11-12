*&---------------------------------------------------------------------*
*& Report YGCB_006_05
*&---------------------------------------------------------------------*
*& ALV com FORMs
*&---------------------------------------------------------------------*

REPORT ygcb_006_05.

TABLES: sflight.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_carrid TYPE s_carr_id OBLIGATORY.
  SELECT-OPTIONS: s_connid FOR sflight-connid,
                  s_fldate FOR sflight-fldate.
SELECTION-SCREEN END OF BLOCK b1.

DATA: gt_voos TYPE TABLE OF sflight.

FORM get_voos.

  SELECT *
    FROM sflight
    INTO TABLE gt_voos
    WHERE carrid EQ p_carrid
    AND connid IN s_connid
    AND fldate IN s_fldate.

  IF gt_voos[] IS INITIAL.
    PERFORM display_message USING 'Não foi encontrados dados'.
  ENDIF.

ENDFORM.

FORM display_alv.
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table = DATA(lo_alv)
    CHANGING
      t_table = gt_voos
  ).

  " Ativar a Toolbar dp ALV
  DATA(lo_functions) = lo_alv->get_functions( ).
  lo_functions->set_all( ).

  lo_alv->display( ).
ENDFORM.

FORM display_message USING iv_msg TYPE string.
  MESSAGE iv_msg TYPE 'E'.
ENDFORM.

START-OF-SELECTION.
  PERFORM get_voos.

END-OF-SELECTION.
  PERFORM display_alv.