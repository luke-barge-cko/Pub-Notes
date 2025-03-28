#!/bin/bash

remote_server="10.17.43.165"
remote_port="3389" # Default RDP port, change if needed
remote_username="cko\\luke.barge"
local_file_path="/Users/luke.barge/Documents/test.txt" #example: /Users/yourusername/Documents/myfile.txt
remote_destination_path="C:\\remote_folder\\"

# Check if local file exists
if [[ ! -f "$local_file_path" ]]; then
  echo "Error: Local file not found: $local_file_path"
  exit 1
fi

# Get directory and filename
local_drive=$(dirname "$local_file_path")
local_file=$(basename "$local_file_path")

# Execute the RDP command with proper escaping
xfreerdp +drives /u:"$remote_username" /v:"$remote_server:$remote_port" /clipboard /cert:ignore /cmd:"cmd.exe /c copy \\\\tsclient\\share\\$local_file $remote_destination_path"

if [ $? -eq 0 ]; then
  echo "File transfer initiated. Please enter your password in the RDP window."
else
  echo "Error transferring file."
fi
