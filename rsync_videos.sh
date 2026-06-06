#!/bin/bash
#
# rsync new and/or changed video files from ~/Videos to external USB drive T9_2
#
# see: https://unix.stackexchange.com/questions/203846/how-to-sync-two-folders-with-command-line-tools
#
# version: v2.4
#
# history
# 2025:       v1: initial version
# 02/08/2025: v2: added default TARGET dir based on HOSTNAME
# 09/08/2025: v2.1: added chris-g5 as HOSTNAME
# 10/11/2025: v2.2: added l15 as HOSTNAME
# 03/01/2026: v2.3: changed to use T9_2 USB disk (2TB) by default instead of T9
# 31/01/2026: V2.4: added p520c as HOSTNAME
# 06/06/2026: V2.5: added parsing commandline options, including -n|--no-umount to skip unmounting T9_2 && removed setting TARGET_DIR to the first commandline option ($1)
#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)
VERBOSE=false
HELP=false
NO_UMOUNT=false #do umount at the end
DO_EXECUTE=false #do not execute the tar command

#hostname of machines
HOSTNAME_THINKPAD="chris-thinkpad"
HOSTNAME_ELITEDESK="chris-elitedesk"
HOSTNAME_G5="chris-g5"
HOSTNAME_L15="l15"
HOSTNAME_P520C="p520c"

#dirs and files to use
SOURCE_DIR="/home/chris/Videos/" #slash needed at the end "all content of ../xxx/ dir"
#TARGET_DIR="/media/chris/T9/media/movies" #"into ../movies dir"

DEFAULT_TARGET_USB_DISK="T9_2"
TARGET_USB_DISK="$DEFAULT_TARGET_USB_DISK"

TARGET_MOUNT_PATH="/media/$USER/$TARGET_USB_DISK" #expecting: /media/chris/T9_2 as mount path under Ubuntu 24.04, for user chris, and usb disk with label T9_2, that got auto-mounted


DEFAULT_TARGET_DIR_FOR_THINKPAD="/media/chris/$TARGET_USB_DISK/media/movies"
DEFAULT_TARGET_DIR_FOR_ELITEDESK="/media/chris/$TARGET_USB_DISK/media/from_elitedesk"
DEFAULT_TARGET_DIR_FOR_G5="/media/chris/$TARGET_USB_DISK/media/from_g5"
DEFAULT_TARGET_DIR_FOR_L15="/media/chris/$TARGET_USB_DISK/media/from_l15"
DEFAULT_TARGET_DIR_FOR_P520C="/media/chris/$TARGET_USB_DISK/media/from_p520c"

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

help() {
    echo -e "\n$0 usage:"
    echo -e "\t$0 [-v|--verbose -h|--help -n|--no-umount]"
    echo -e "\nTo sync all files from ~/Videos to $TARGET_USB_DISK USB disk."
    echo -e "\nBy default the USB disk will be unmounted after the rsync finished."
    echo -e "Give as option -n|--no-umount to NOT unmount the usb disk after the rsync."
}

log "--started"

OPTS=`getopt -o vhn --long verbose,help,no-umount -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then log "Failed parsing options." >&2 ; help ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS" #parses the string returned by getopt and puts them in positional params $1 $2 ...

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )    HELP=true; help ; exit 0 ;;
    -n | --no-umount )    NO_UMOUNT=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done



#Determine TARGET_DIR based on HOSTNAME
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
elif [ $HOSTNAME == $HOSTNAME_P520C ]; then
    TARGET_DIR=$DEFAULT_TARGET_DIR_FOR_P520C
else
    log "ERROR - hostname unknown. Exiting script.";
    exit 1;
fi


log "TARGET_DIR = $TARGET_DIR"

#check if the $TARGET_DIR exists
if [ ! -d "$TARGET_DIR" ]; then
    log "ERROR - TARGET_DIR: $TARGET_DIR does not exist. Exiting script."; exit 1;
fi

log "exec: rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR"
rsync -avuh --partial --progress $SOURCE_DIR $TARGET_DIR

#check if the $TARGET_MOUNT_PATH exists
if [ ! -d "$TARGET_MOUNT_PATH" ]; then
    log "ERROR - TARGET_MOUNT_PATH: $TARGET_MOUNT_PATH does not exist. Exiting script."; exit 1;
fi

#do sync
log "exec: sync"
sync

#do umount if NO_UMOUNT is set to false
if ! $NO_UMOUNT ; then
    log "NO_UMOUNT is false"
    log "exec: umount $TARGET_MOUNT_PATH"
    umount "$TARGET_MOUNT_PATH"
else
    log "NO_UMOUNT is true, will NOT umount the USB disk"
fi

log "-- Done --"

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
