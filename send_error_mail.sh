#/usr/bin/env bash

ALERT_DEST="youremail@example.com,anotheremail@example.com"


if [ -z "$1" ]; then
    >&2 echo "Usage $0 <command>"
    exit 1
fi

LOG_DIR=$(mktemp -d)
LOG_FILE="$LOG_DIR/error_log"

trap "rm -rf $LOG_DIR" EXIT

$@ > /dev/null 2> $LOG_FILE

if [ $? -ne 0 ]; then
    echo "Une erreur est survenue lors de l'execution du script $@" | mail -a $LOG_FILE -s "Alerte" $ALERT_DEST
fi
