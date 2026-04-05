#!/bin/bash
#
# sync && umount /media/chris/T9_2
#
# version: v1
#
# history
# 05/04/2026: v1: initial version

#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)
VERBOSE=false
HELP=false
DO_EXECUTE=false

#hostname of machines
HOSTNAME_THINKPAD="chris-thinkpad"
HOSTNAME_ELITEDESK="chris-elitedesk"
HOSTNAME_G5="chris-g5"
HOSTNAME_L15="l15"
HOSTNAME_P520C="p520c"

DEFAULT_TARGET_USB_DISK="T9_2"
TARGET_USB_DISK="$DEFAULT_TARGET_USB_DISK"

TARGET_MOUNT_PATH="/media/$USER/$TARGET_USB_DISK" #expecting: /media/chris/T9_2 as mount path under Ubuntu 24.04, for user chris, and usb disk with label T9_2, that got auto-mounted

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

log "--started"

#check if the $TARGET_MOUNT_PATH exists
if [ ! -d "$TARGET_MOUNT_PATH" ]; then
    log "ERROR - TARGET_MOUNT_PATH: $TARGET_MOUNT_PATH does not exist. Exiting script."; exit 1;
fi

log "exec: sync && umount $TARGET_MOUNT_PATH"
sync && umount "$TARGET_MOUNT_PATH"