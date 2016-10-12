#!/usr/bin/env bash

################################################################################
# CONFIG
################################################################################
RSYNC_BIN=`which rsync`
SSH_BIN=`which ssh`

HOST=xxx.xxx.xxx.xxx # DEPLOY SERVER HOST
USERNAME=username # SSH USER

# DIST CONFIG
DEST_PATH="/path/to/sync/" # DEST PATH

# INTERNAL CONFIG
SOURCE_PATH="/path/to/sources/" # PATH TO SOURCE

################################################################################
# SCRIPT
################################################################################
if [ ! -d  "$SOURCE_PATH" ];then
    echo "$SOURCE_PATH doesn't exist"
    exit 1
fi;

RSYNC_DESTINATION="$USERNAME@$HOST:$DEST_PATH"
RSYNC_PARAMETERS="--verbose --itemize-changes --stats --progress --compress --recursive --links --delete --checksum"
RSYNC_EXCLUDE=""
if [ -f  "$SOURCE_PATH.rsyncignore" ];then
    RSYNC_EXCLUDE="$RSYNC_EXCLUDE--exclude-from $SOURCE_PATH.rsyncignore "
fi
if [ -f  "$SOURCE_PATH.gitignore" ];then
    RSYNC_EXCLUDE="$RSYNC_EXCLUDE--exclude-from $SOURCE_PATH.gitignore "
fi
RSYNC_CHMOD="--perms --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r"

cd $SOURCE_PATH

$RSYNC_BIN $RSYNC_PARAMETERS $RSYNC_EXCLUDE --dry-run $SOURCE_PATH $RSYNC_DESTINATION || {
    exit 1
}

read -p "PRESS Y TO CONFIRM RSYNC ACTION: " REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    $RSYNC_BIN $RSYNC_PARAMETERS $RSYNC_EXCLUDE $SOURCE_PATH $RSYNC_DESTINATION || {
        exit 1
    }
fi
