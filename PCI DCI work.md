
## Stored Procedures

| Stored Procedures                                             | Links | Notes                                                                                                                                                            | Action(s)        | Issue                   |
| ------------------------------------------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------- | ----------------------- |
| [dci].[AddCardProductCardNumber]                              |       | Seems unused. Was it previously used? If it was previously used, was it inserting CardNumber as plain text.                                                      | Delete this      | Plain text              |
| [dci].[GetAllCardProductCardNumberTemp]                       |       | Is currently being used in Clearing Acquired project. The returned card number is operated on, so it needs to not be NULL. Seems like empty string would be okay | Return blank PAN | 3DES decryption         |
| [dci].[GetCardProductCardNumberByFingerPrint]                 |       | cca project, NULL or empty string                                                                                                                                | Return blank PAN | 3DES decryption         |
| [dci].[GetCardProductCardNumberById]                          |       | cca project                                                                                                                                                      |                  | 3DES decryption         |
| [dci].[GetCardProductCardNumberTempById]                      |       | cca project                                                                                                                                                      |                  | 3DES decryption         |
| [dci].[GetCFChargeRecordById]                                 |       | cca project                                                                                                                                                      |                  | 3DES decryption         |
| [dci].[GetDciDetailById]                                      |       | cca project                                                                                                                                                      |                  | 3DES decryption         |
| [dci].[GetDciDetailByReferenceIdAndNetworkReferenceId]        |       |                                                                                                                                                                  |                  | Reads both card numbers |
| [dci].[GetDciDetailByReferenceId]<br>                         |       |                                                                                                                                                                  |                  | Reads both card numbers |
| [dci].[GetDciDetailFiltered]                                  |       |                                                                                                                                                                  |                  | Reads both card numbers |
| CREATE PROCEDURE [dci].[GetDciSettlementChargeRecordById]     |       |                                                                                                                                                                  |                  | 3DES decryption         |
| CREATE PROCEDURE [dci].[GetDciSettlementChargeRecordFiltered] |       |                                                                                                                                                                  |                  | 3DES decryption         |
| [dci].[GetDFFOriginalInterchangeDetailRecordById]             |       |                                                                                                                                                                  |                  | 3DES encryption         |
| [dci].[upsertcardproductcardnumber]                           |       |                                                                                                                                                                  |                  | 3DES encryption         |
| [dci].[upsertcardproductcardnumbertemp]                       |       |                                                                                                                                                                  |                  | 3DES encryption         |
| [dci].[upsertcfchargerecord]                                  |       |                                                                                                                                                                  |                  | 3DES encryption         |
| [dci].[UpSertDciDetail]                                       |       | Used in DCI Clearing                                                                                                                                             |                  | 3DES encryption         |
| [dci].[UpSertDciSettlementChargeRecord]                       |       |                                                                                                                                                                  |                  | 3DES encryption         |
| [dci].[UpSertDFFOriginalInterchangeDetailRecord]              |       |                                                                                                                                                                  |                  | 3DES encryption         |


## Integration DB


| TABLE | ACTION(S) |
| ----- | --------- |
|       |           |


## Snowflake

