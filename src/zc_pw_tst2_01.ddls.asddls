@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PW test table 02 - projection'
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_PW_TST2_01
  provider contract transactional_query
  as projection on ZR_PW_TST2_01
{
  key LineUuid,

      @Search.defaultSearchElement: true
      LineId,

      @Search.defaultSearchElement: true
      LineTxt,

      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
