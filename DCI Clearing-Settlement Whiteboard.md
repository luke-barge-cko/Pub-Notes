
## Current Problems
- There is some ambiguity about who owns the settlement processor _settlement processor_
- The current settlement processor is difficult to test. It cannot be run locally because it is a windows only .net application. The current settlement processor is also responsible for downloading the files from DCI SFTP server. We also do not currently have access to the filesystem on the settlement processor so we cannot test this on QA also.
## Proposed Solutions
### Solution 1
- The solution allows us the remove the DCI.DataSync project
- Testing here is greatly simplified as we can test the settlement part by uploading settlement files to s3
- The solution achieves this separation from IntegrationDB
- Problem: More work than solution 2
### Solution 2
- Simpler solution because it more closely matches the current system.
- Testing here is greatly simplified as we can test the settlement part by uploading settlement files to s3
- Problem: Still interacts with IntegrationDB
### Misc
- In my opinion our team should own the settlement processor. The problem with our team on not owning the settlement part is that it would require the settlement team to either interact with our mysql clearing db or the settlement processor continues to interact with the IntegrationDB. Although, this could potentially be encapsulated through APIs. 
- If we own the settlement event exporter, it creates a more decoupled architecture as it allows the only interface between settlement and clearing to be through kineses events. 

