#!/usr/bin/env bash
TARGET="FOLDER"
STARTCOMMIT="xxx"
ENDCOMMIT="HEAD"

for i in $(git diff --name-only $STARTCOMMIT..$ENDCOMMIT)
    do
        # First create the target directory, if it doesn't exist.
        mkdir -p "$TARGET/$(dirname $i)"
        # Then copy over the file.
        cp "$i" "$TARGET/$i"
    done
