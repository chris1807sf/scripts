#!/bin/bash
#
# return the last-1 filename of "ls -1tr"

BASENAME_SCRIPT=$(basename $0)

FROM_LAST=2 #set to 2 to get the one-before-last filename

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

# if there is a $1 then overwrite FROM_LAST with it
#check if there is a $1 given as input
if [ ! "$1" == "" ] ; then
    FROM_LAST=$1
fi

# "ls -1tr" will return a list with only the filenames (-1) sorted by modified time (-t) in reverse order (-r)
# tail & head usage: "tail -n 2" will return the last 2 lines. With "head -n 1" the single top line of these two is returned.
# use quotes "" around the $() to still return as one string even if it contains spaces
echo "$(ls -1tr | tail -n $FROM_LAST | head -n 1)"
