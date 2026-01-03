#!/bin/bash
#
# rsync new and/or changed video files from ~/Videos to external USB drive T9_2
#
# see: https://unix.stackexchange.com/questions/203846/how-to-sync-two-folders-with-command-line-tools
#
# version: v2.3
#
# history
# 2025:       v1: initial version
# 02/08/2025: v2: added default TARGET dir based on HOSTNAME
# 09/08/2025: v2.1: added chris-g5 as HOSTNAME
# 10/11/2025: v2.2: added l15 as HOSTNAME
# 03/01/2026: v2.3: changed to use T9_2 USB disk (2TB) by default instead of T9
#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)
VERBOSE=false
HELP=false
DO_EXECUTE=false #do not execute the tar command

#hostname of machines
HOSTNAME_THINKPAD="chris-thinkpad"
HOSTNAME_ELITEDESK="chris-elitedesk"
HOSTNAME_G5="chris-g5"
HOSTNAME_L15="l15"

#dirs and files to use
SOURCE_DIR="/home/chris/Videos/" #slash needed at the end "all content of ../xxx/ dir"
#TARGET_DIR="/media/chris/T9/media/movies" #"into ../movies dir"

DEFAULT_TARGET_USB_DISK="T9_2"
TARGET_USB_DISK="$DEFAULT_TARGET_USB_DISK"

DEFAULT_TARGET_DIR_FOR_THINKPAD="/media/chris/$TARGET_USB_DISK/media/movies"
DEFAULT_TARGET_DIR_FOR_ELITEDESK="/media/chris/$TARGET_USB_DISK/media/from_elitedesk"
DEFAULT_TARGET_DIR_FOR_G5="/media/chris/$TARGET_USB_DISK/media/from_g5"
DEFAULT_TARGET_DIR_FOR_L15="/media/chris/$TARGET_USB_DISK/media/from_l15"

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
    log "info: will try to determine TARGET_DIR based on the HOSTNAME."
    log "info: HOSTNAME seen is: $HOSTNAME"
    if [ $HOSTNAME == $HOSTNAME_THINKPAD ]; then
        TARGET_DIR=$DEFAULT_TARGET_DIR_FOR_THINKPAD
    elif [ $HOSTNAME == $HOSTNAME_ELITEDESK ]; then
        TARGET_DIR=$DEFAULT_TARGET_DIR_FOR_ELITEDESK
    elif [ $HOSTNAME == $HOSTNAME_G5 ]; then
        TARGET_DIR=$DEFAULT_TARGET_DIR_FOR_G5
    elif [ $HOSTNAME == $HOSTNAME_L15 ]; then
        TARGET_DIR=$DEFAULT_TARGET_DIR_FOR_L15
    else
        log "ERROR - hostname unknown. Exiting script.";
        exit 1;
    fi
fi

log "TARGET_DIR = $TARGET_DIR"

#check if the $TARGET_DIR already exists
if [ ! -d "$TARGET_DIR" ]; then
    log "ERROR - TARGET_DIR: $TARGET_DIR does not exist. Exiting script."; exit 1;
fi

log "exec: rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR"
rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR


# More Info:
#
# This puts folder A into folder B:
#
# rsync -avu --delete "/home/user/A" "/home/user/B"
#
# If you want the contents of folders A and B to be the same, put /home/user/A/ (with the slash)
# as the source. This takes not the folder A but all of its content and puts it into folder B. Like this:
#
# rsync -avu --delete "/home/user/A/" "/home/user/B"
#
#     -a archive mode; equals -rlptgoD (no -H, -A, -X)
#     -v run verbosely
#     -u only copy files with a newer modification time (or size difference if the times are equal)
#     -h human readable
#     --progress
#     --partial
#     --delete delete the files in target folder that do not exist in the source
#
# Manpage: https://download.samba.org/pub/rsync/rsync.html
#
# From tldr rsync:
#  archive, display verbose and human-readable progress, and keep partially transferred files if interrupted:
#   rsync -avhP|--compress --verbose --human-readable --partial --progress path/to/source path/to/destination
