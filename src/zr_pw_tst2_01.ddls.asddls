@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PW test table 02 - root view'
define root view entity ZR_PW_TST2_01
  as select from zpw_tst2_01
{
  key line_uuid             as LineUuid,

      @EndUserText.label: 'Line ID'
      line_id               as LineId,

      @EndUserText.label: 'Line Text'
      line_txt              as LineTxt,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
