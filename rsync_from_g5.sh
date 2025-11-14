#!/bin/bash
#
# to rsync files from external USB disk T9 that were copied into it from the chris-elitedesk PC
#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)
VERBOSE=false
HELP=false
DO_EXECUTE=false #do not execute the tar command

#hostname of machines
HOSTNAME_THINKPAD="chris-thinkpad"
#HOSTNAME_ELITEDESK="chris-elitedesk"
HOSTNAME_G5="chris-g5"

#dirs and files to use
SOURCE_DIR="/media/chris/T9/media/from_g5/"  #slash needed at the end "all content of ../xxx/ dir"
TARGET_DIR="/home/chris/Videos" #"into ../Videos dir"

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

log "--started"


# if there is a $1 then overwrite TARGET_DIR with it
#check if there is a $1 given as input
if [ ! "$1" == "" ] ; then
    log "info: input param \$1 to set the TARGET_DIR is present and will be used."
    TARGET_DIR=$1
else
    log "info: input param \$1 to set the TARGET_DIR is NOT present."
    log "info: will try to use the default for TARGET_DIR."
fi

log "TARGET_DIR = $TARGET_DIR"

#check if the $SOURCE_DIR exists
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR - SOURCE_DIR: $SOURCE_DIR does not exist. Exiting script."; exit 1;
fi

#check if the $TARGET_DIR already exists
if [ ! -d "$TARGET_DIR" ]; then
    log "ERROR - TARGET_DIR: $TARGET_DIR does not exist. Exiting script."; exit 1;
fi

echo -e "exec: rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR"
rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR
