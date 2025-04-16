### Legacy Settlement Current

1. Downloaded files are stored directly in an archive directory
2. The files are located on a file system on the server where the application runs
3. The files remain in the archive location indefinitely (no automatic deletion in this service)
4. Files that fail processing are moved to an "Unprocessed" directory
5. The database keeps track of processed files to avoid re-processing
6. The original files remain on the SFTP server (no deletion from this service). So there does not seem like there should be any issues downloading the file twice
### Options
1. **Concurrent File-Sync and Legacy SFTP:** Run file-sync to download files to an S3 bucket while the current SFTP downloader remains active.
	1. **Deployment Option 1 (Discouraged):** Deploy file-sync on the current Legacy Settlement EC2 instance, leveraging the existing IP whitelist.
		- _Alternative:_ Consider replacing the current legacy SFTP downloader with file-sync for downloads to both the archive and S3.
	2. **Deployment Option 2 (Recommended):** Request a new IP whitelist from DCI and deploy file-sync on ECS.

*Our team will own and manage the file-sync implementation, so we can work closely on it's implementation.*

**Key Constraint:** Direct download from the archive directory is not possible because:
- It's a locally attached volume, restricting access to a single server.
- It's not a network-accessible file system.

**_High Level, it's basically this for file sync_**:  
1. Create config repository like this [https://github.com/cko-card-processing/file-sync-jcn-configuration](https://github.com/cko-card-processing/file-sync-jcn-configuration)
2. Use IAC to create ECS service like [https://github.com/cko-card-processing/file-sync/tree/main/iac/components/200-jcn-file-sync](https://github.com/cko-card-processing/file-sync/tree/main/iac/components/200-jcn-file-sync)
3. Modify file-sync deployment to deploy a version of file-sync for DCI into ECS  [https://github.com/cko-card-processing/file-sync/blob/main/.github/workflows/main_branch.yml#L30](https://github.com/cko-card-processing/file-sync/blob/main/.github/workflows/main_branch.yml#L30) 
4. Create Octopus deployment for DCI file-sync (Deployment of containers into ECS)
5. Create Harness/Octopus deployment for DCI file-sync config (Move config file into S3 bucket so it ca be loaded into DCI file-sync and restart ECS)