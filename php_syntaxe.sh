#!/bin/sh
PROJECT=$(dirname "$0")
FILES=`find $PROJECT -name "*\\.php"`

# Determine if a file list is passed
SFILES=${SFILES:-$FILES}

echo "Checking PHP Lint..."
for FILE in $SFILES
do
    php -l -d display_errors=0 $PROJECT/$FILE > /dev/null
    FILES="$FILES $PROJECT/$FILE"
done
exit $?
