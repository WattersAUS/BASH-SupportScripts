#!/bin/sh

HOMED="/var/sites/s/shiny-ideas.tech/"

debugMessage() {
    echo "[ "`date '+%Y-%m-%d %H:%S'`" ] DEBUG: "$1
    return
}

errorMessage() {
    echo "[ "`date '+%Y-%m-%d %H:%S'`" ] ERROR: "$1
    return
}

processDirectory() {
    debugMessage "Processing directory ("$1") for backup..."

    if [ ! -d $1 ]; then
        errorMessage "Failed to find directory ("$WRKSP") to process..."
        exit 1
    fi
    debugMessage "Found ("$1") directory..."

    NEWDIR=$1"_"`date +%Y%m%d`
    if ! mv $1 $NEWDIR; then
        errorMessage "Failed moving ("$1") directory to ("$NEWDIR")..."
        exit 1
    fi
    debugMessage "Moved ("$1") directory to ("$NEWDIR"), ready for compression..."

    if ! tar czvf $NEWDIR".tar.gz" $NEWDIR; then
        errorMessage "ERROR: Failed to compress  ("$NEWDIR")..."
        exit 1
    fi
    debugMessage "Compressed ("$NEWDIR") to ("$NEWDIR".tar.gz)..."

    if ! mkdir $1 2>/dev/null; then
        errorMessage "ERROR: Failed to create new ("$1")..."
        exit 1
    fi
    debugMessage "Created new ("$1") directory..."

    if ! rm -rf $NEWDIR 2>/dev/null; then
        errorMessage "ERROR: Failed to remove old directory ("$NEWDIR")..."
        exit 1
    fi
    debugMessage "Removed old directory ("$NEWDIR") after compression..."
    return
}

if [ ! cd $HOMED ]; then
    errorMessage "Failed to find HOME ("$HOMED") directory..."
    exit 1
fi
debugMessage "Changed to Home Directory ("$HOMED") successfully..."

for var in "$@"
do
    processDirectory "$var"
done

exit 0
