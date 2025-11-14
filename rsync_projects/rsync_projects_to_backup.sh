#!/bin/bash
#
# Using rsync to make a copy of the ~/projects
#
VERBOSE=false
HELP=false
DRY_RUN=true

#default source dir
SOURCE_DIR_DEFAULT="/home/chris/projects/"
SOURCE_DIR=$SOURCE_DIR_DEFAULT

#default target dir = TARGET_DIR_DEFAULT_FIX_PART appended with $date
TARGET_DIR_DEFAULT_FIX_PART="/home/chris/backups/projects_"

#default target dir
DATE=$(date '+%4Y%m%d') #fetch the YYYYmmdd of today() for the target subdirectory
TARGET_DIR_DEFAULT="$TARGET_DIR_DEFAULT_FIX_PART$DATE"
TARGET_DIR=$TARGET_DIR_DEFAULT

help() {
    echo "$0 usage:"
    echo "executing script without  param: script will do the rsync adding --dry-run"
    echo "executing script with --execute: script will execute rsync without dry-run "
    echo "rsync command: rsync -azvv $SOURCE_DIR $TARGET_DIR"
    echo "               creating a new target-dir $TARGET_DIR if it doesn't exist yet"
    echo "               if the source-dir does not exist the script shows an ERROR and exits."
    echo "               if the target-dir already exists the script shows an ERROR and exits."
    echo "               NO other checks are done ..."
    echo -e "\nScript params:"
    echo      "-h --help: this help"
    echo      "-s <dir> --source <dir>: use the <dir> as the source dir for the rsync"
    echo      "-t <dir> --target <dir>: use the <dir> as the target dir for the rsync"
    echo      "-v --verbose: show more info on script execution"
    echo      "-y --yes -e --execute: run the rsync command without the dry-run param"
    exit 0;
}

OPTS=`getopt -o vhdyes:t: --long verbose,dry-run,help,yes,execute,source:,target: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS" #parses the string returned by getopt and puts them in positional params $1 $2 ...

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )    HELP=true; help; shift ;;
    -d | --dry-run ) DRY_RUN=true; shift ;;
    -y | --yes ) DRY_RUN=false; shift ;;
    -e | --execute ) DRY_RUN=false; shift ;;
    -s | --source ) SOURCE_DIR=$2; shift; shift ;; #Remark: NO error checking in case no $2
    -t | --target ) TARGET_DIR=$2; shift; shift ;; #Remark: NO error checking in case no $2
    -- ) shift; break ;;
    * ) break ;;
  esac
done

#check if the $SOURCE_DIR exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "\nERROR - SOURCE_DIR: $SOURCE_DIR does not exist. Exiting script."; exit 1;
fi

#check if the $TARGET_DIR already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "\nERROR - TARGET_DIR: $TARGET_DIR already exists. Exiting script."; exit 1;
fi


if $DRY_RUN ; then
    DRY_RUN_PARAM="--dry-run"
else
    DRY_RUN_PARAM=""
fi
#echo "DRY_RUN_PARAM: $DRY_RUN_PARAM"

COMMAND="sudo rsync -azvv $DRY_RUN_PARAM $SOURCE_DIR $TARGET_DIR"

if $VERBOSE ; then
    echo "Params:"
    echo VERBOSE=$VERBOSE
    echo HELP=$HELP
    echo DRY_RUN=$DRY_RUN
    echo -e "\nSource directory: $SOURCE_DIR"
    echo -e "Target directory: $TARGET_DIR"
    echo -e "\nCommand: $COMMAND"
else
    echo "Verbose is OFF"
    echo "Command: $COMMAND"
fi

eval $COMMAND

#sudo rsync --dry-run -azvv /home/chris/projects/ /home/chris/backups/projects_$DATE
#sudo rsync -azvv /home/chris/projects/ /home/chris/backups/projects_$DATE
#sudo rsync --exclude={/mnt,/home} -avz / /mnt/data/storage1_1tb/backup_server_os/$DATE