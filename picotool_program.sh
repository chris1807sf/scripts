#!/bin/bash
#
# call picotool to load an UF2 file to pico board
# expecting exactly one param was given as input: file-name of an UF2 file
# will chech that the file is an UF2 file what implicitly checks that the file exists.
# 
# ... will avoid the picotool to take actions unneeded (including reboot the device due to -f being used)
#
BASENAME_SCRIPT=$(basename $0)
#echo -e "$BASENAME_SCRIPT: executing \"sudo picotool load\""

# check that exactly one param was given as input --> file-name of file to be programmed
if [ $# != 1 ] ; then
	echo -e "$BASENAME_SCRIPT: One input param expected: file-name of UF2 file to load to pico-board.\n...Stopped." >&2
	exit 1
else
	LOAD_FILENAME=$1
	#check if the file is an UF2 file, by checking that file-cmd returns a string containg UF2
	if [[ $(file $LOAD_FILENAME) = *UF2* ]] ; then 
		echo -e "$BASENAME_SCRIPT: file $LOAD_FILENAME is an UF2 file --> will call picotool to load to pico-board"
		sudo picotool load -v -x "$1" -f
		exit 0
	else
		echo -e "$BASENAME_SCRIPT: file $LOAD_FILENAME does not exist or is not an UF2 file.\n...Stopped."
		exit 1
	fi
fi
