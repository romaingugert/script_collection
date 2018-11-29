#!/usr/bin/env bash

RETRY_COUNT=5
DELAY=3

while getopts ":c:d:" opt; do
    case ${opt} in
        d )
            DELAY=$OPTARG
            ;;
        c )
            RETRY_COUNT=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            echo "Usage $0 <command>"
            echo "Options"
            echo "    -c Number of times to retry (default=$RETRY_COUNT)"
            echo "    -d Specifies the amount of time (in seconds) to wait between successive retries (default=$DELAY sec.). This can be zero."
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))


LOG_DIR=$(mktemp -d)
LOG_FILE="$LOG_DIR/error_log"
trap "rm -rf $LOG_DIR" EXIT

ATTEMPT_NUM=1

until $@ > /dev/null 2> $LOG_FILE
do
    if [ $ATTEMPT_NUM -lt $RETRY_COUNT ]
    then
        echo "Attempt $ATTEMPT_NUM failed! Trying again in $DELAY seconds..."
        sleep $DELAY
    else
        echo "Attempt $ATTEMPT_NUM failed and there are no more attempts left!" 1>&2
        echo "Errors:" 1>&2
        cat $LOG_FILE 1>&2
        exit 1
    fi
    ATTEMPT_NUM=$(expr $ATTEMPT_NUM + 1)
done
