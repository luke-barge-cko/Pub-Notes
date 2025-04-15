
### Legacy Settlement Current

1. Downloaded files are stored directly in an archive directory
2. The files are located on a file system on the server where the application runs
3. The files remain in the archive location indefinitely (no automatic deletion in this service)
4. Files that fail processing are moved to an "Unprocessed" directory
5. The database keeps track of processed files to avoid re-processing
6. The original files remain on the SFTP server (no deletion from this service). So there does not seem like there should be any issues downloading the file twice
### Options
1. In parallel, implement file-sync to download files onto an S3 bucket.
	- Can deploy on the same server as current Legacy Settlement to avoid IP whitelisting issues, or get another IP address whitelisted from DCI 
	- We can then use the same file-sync to upload outgoing files to DCI
2. If you need the files now, you can start downloading them from the 'archive' directory.  **(suggested)**
	- We will need to allow that file system to be available as a networked file server. 
	- We will still eventually need to implement file-sync to replace the legacy sftp downloader.
3. If there is an issue with downloading files twice (should not be) and you want to use file-sync now, you can replace legacy settlement sftp download with file-sync. 
	- We will need to allow that file system to be available as a networked file server. 
	- Your new settlement loader would then need to download them from that file system. 
	- When you are happy that the new settlement loader is working, then you can start downloading files onto an S3 Bucket instead of the file system.
	- Can deploy on the same server as current Legacy Settlement to avoid IP whitelisting issues, or get another IP address whitelisted from DCI 
## Todo
- Confirm there is no issues with downloading the file twice from the DCI SFTP server 