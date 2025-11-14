#!/bin/sh
#
# open a new terminal and CD to the same dir 
#
# ToDo: extend to check for presence of $1. If so, change to $1 instead of $pwd
#

TARGET_DIR=""

#check if there is a $1 given as input
if [ ! "$1" == "" ] ; then
    echo "param 1 is present"
    TARGET_DIR=$1
else
	echo "param 1 is NOT present"
	TARGET_DIR=$PWD
fi

echo -e "Opening term and cd to ++ $TARGET_DIR ++"

gnome-terminal -- sh -c "cd $TARGET_DIR; bash"