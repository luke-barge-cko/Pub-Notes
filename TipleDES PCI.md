
## Agenda
- High level overview of 3DES encryption and it's problems
- High level overview of how our systems interact utilise 3DES
- Solutions

## Details
#### Discover
- Discover does not interact with the integrationDB, all events published directly to Kinesis 🥳

### DCI
- At this [commit](https://github.com/cko-card-processing/dci-clearing/commit/974000190e27f27935dd0352d4797167a079b72a), `DCI.DataSync` masked the card number and data from these tables was purged soon after
	- Therefore the is not data in the IntegrationDB incoming tables for us that needs to be purged 🥳
- There is data from DCI settlement which is still persisting 3DES encrypted card numbers. It says settlement there, but we are still responsible for this part it seems 🫠
	- This is the [repository](https://github.com/cko-card-processing/checkout-acquiring-clearing)  in question
		- This previously contained both clearing and settlement for DCI. It only contains settlement now. But this is still within our jurisdiction.
		- It takes the settlement files we receive from DCI from `10.16.8.15`  and updates the outgoing table in the IntegrationDB. This used Stored procedures stored in this [repository](https://github.com/cko-card-processing/checkout-tpp-db/tree/develop/TPP/INTEGRATION/dci) 
			- These stored procedures use 3DES encryption 😭
- We do not own the [dci event exporter](https://github.com/cko-card-processing/dci-clearing-event-exporter) (and it doesn't really make any sense for us to do so tbh)
	- Events produced from end up in snowflake ❄️ 
	- It is my opinion that we should not be responsible for the data in this snowflake as it has nothing to do with us.

### Solution
- Change the stored procedures in [repository](https://github.com/cko-card-processing/checkout-tpp-db/tree/develop/TPP/INTEGRATION/dci) 
	- Stop writing card number to the card number fields
		- Possible problems with unknown stakeholders consuming a value and and it being NULL
	- Write masked version of the card numbers
		- More difficult
- Remove the PAN data from the incoming tables in the integration db
	1. Drop the tables and remake with default null (or empty string)
		- Possible problems with unknown stakeholders consuming a value and and it being `NULL`
	2. Update each record with null (or empty string)
		- Possible problems with unknown stakeholders consuming a value and and it being `NULL`
		- This may not work with other schemes because the number of rows is so large that such a query could be problematic
			- Large growth in transaction log (LDF file)
			- Time consuming
			- Tie up database resources and lead to various performance problems.
		- This may not be too much of an issue for us the DCI has a lot fewer transaction than the other schemes
			- We need to look at how rows there are that need to be changed to determine if this is feasible DCI
	3. Update the records with a masked version of the card number
		- We need to look at how rows there are that need to be changed to determine if this is feasible DCI
		- More difficult

### FYIs
- There is no TTL on the tables in integration DB post Aug 2023
	


