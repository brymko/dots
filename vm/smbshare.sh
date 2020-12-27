#!/bin/bash

set -euf -o pipefail

if [[ $# -lt 5 ]]; then
    echo "Usage: $0 <serverip> <username> <password> <remote path> <local path> "
    echo "For Windows server:
                Create user:        net user <user name> <password> /add
                Add to admins:      net localgroup administrators <user name> /add
                Change NTFS perms:  icacls \"WINDOWS_PATH\" /grant \"<user name>:(OI)(CI)F\" /T /Q /C
                Share folder:       net share <remote path>=WINDOWS_PATH
                Unshare folder:     net share <remote path> /delete"
    exit 1
fi

EGID="$EUID"
SERVERIP="$1"
USERNAME="$2"
PASSWORD="$3"
REMTPATH="$4"
LOCLPATH="$5"

sudo mount.smb3 -v "//$SERVERIP/$REMTPATH" "$LOCLPATH" -o "user=$USERNAME,pass=$PASSWORD,uid=$EUID,gid=$EUID"

