#!/bin/bash
#
# tar a subset of directories and files in /home/chris 
#
# typical usage: tar_homr.sh  && echo "exit code is $?"
#
BASENAME_SCRIPT=$(basename $0)
HOSTNAME=$(hostname)
VERBOSE=false
HELP=false
DO_EXECUTE=false #do not execute the tar command

#dirs and files to tar
# By using the -C option. the files in the tar can be kept relative: without the full path
TAR_SOURCE_DIR_LIST="Desktop Documents Downloads pico projects .config .local" #relative to TAR_SOURCE_DIR
TAR_SOURCE_FILES_LIST=".bash_aliases .bash_history .bash_logout .bashrc .profile" #relative to TAR_SOURCE_DIR
TAR_SOURCE_LIST="$TAR_SOURCE_DIR_LIST $TAR_SOURCE_FILES_LIST"
TAR_SOURCE_DIR="/home/chris" #to be used with -C in the tar command.

#default target dir for the tar
TAR_TARGET_DIR="/home/chris/backups/"

#default tar-file-name & flags
DATE=$(date '+%4Y%m%d') #fetch the YYYYmmdd of today()
TAR_FILE_NAME="${HOSTNAME}_home_${DATE}.tar.gz"
TAR_DEFAULT_FLAGS="cz"
TAR_FLAGS=$TAR_DEFAULT_FLAGS
TAR_VERBOSE_FLAG="v"

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

help() {
    echo -e "\n$0 usage:"
    echo -e "\t./tar_home.sh [-v|--verbose -h|--help]"
    echo -e "\nto create a .tar.gz in $TAR_TARGET_DIR with a subset of files and dirs from $TAR_SOURCE_DIR"
    echo "dirs and files that will tar-ed, relative to $TAR_SOURCE_DIR:"
    echo -e "\tdirs: $TAR_SOURCE_DIR_LIST"
    echo -e "\tfiles: $TAR_SOURCE_FILES_LIST"
    echo -e "\nRemark: file-names in the tar are kept \"relative\": no hard file-path"
    echo -e "Reminder: to see contents of generated tar: tar -tvf tar_filename"
}

OPTS=`getopt -o vh --long verbose,help -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then log "Failed parsing options." >&2 ; help ; exit 1 ; fi

#echo "$OPTS"
eval set -- "$OPTS" #parses the string returned by getopt and puts them in positional params $1 $2 ...

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )    HELP=true; help ; exit 0 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done


#check if the $TARGET_DIR already exists
if [ ! -d "$TAR_TARGET_DIR" ]; then
    log "\nERROR - TARGET_DIR: $TAR_TARGET_DIR does not exist. Exiting script."; exit 1;
fi


TAR_COMMAND="tar $TAR_FLAGS -C $TAR_SOURCE_DIR -f $TAR_TARGET_DIR$TAR_FILE_NAME $TAR_SOURCE_LIST"

if $VERBOSE ; then
    TAR_FLAGS="$TAR_VERBOSE_FLAG$TAR_FLAGS"
    TAR_COMMAND="tar $TAR_FLAGS -C $TAR_SOURCE_DIR -f $TAR_TARGET_DIR$TAR_FILE_NAME $TAR_SOURCE_LIST"
    echo "------"
    echo "Verbose is ON"
    echo "BASENAME_SCRIPT: $BASENAME_SCRIPT"
    echo "hostname: $HOSTNAME"
    echo "Params:"
    echo -e "\tVERBOSE=$VERBOSE"
    echo -e "\tHELP=$HELP"
    echo -e "tar-target-dir: $TAR_TARGET_DIR"
	echo -e "tar-file-name: $TAR_FILE_NAME"
    echo -e "\ntar-command: $TAR_COMMAND"
    echo "------"
else
    log "Verbose is OFF"
fi

TAR_EXECUTED=$($TAR_COMMAND)
TAR_EXIT_CODE=$?
if $VERBOSE ; then #if VERBOSE is true, then show what tar command printed out
    echo "output tar_executed: $TAR_EXECUTED"
    echo "<end tar>"
fi

#check TAR_EXIT_CODE
if [ $TAR_EXIT_CODE != 0 ] ; then
    log "Error during tar: $TAR_EXIT_CODE"
else
    log "tar done. Generated file: $TAR_TARGET_DIR$TAR_FILE_NAME"
fi


log "all done."
exit $TAR_EXIT_CODE