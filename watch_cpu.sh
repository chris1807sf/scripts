#!/bin/bash
#
# watch_cpu.sh.sh: Show the temp & speed of the CPU cores
#
# opens a new terminal and "watch"-es the temp & speed of the CPU cores every sec
#
# REMARK / DEPENDENCY:
# 	assumption: cpu_tempspeed.sh is available in the same dir as watch_cpu.sh
#

VERBOSE=false

BASENAME_SCRIPT=$(basename $0)
DIRNAME=$(dirname $0)
HOSTNAME=$(hostname)

SCRIPTTORUN=cpu_tempspeed.sh
FULLPATHTOSCRIPT=$DIRNAME/$SCRIPTTORUN

log() { 
    echo -e "$BASENAME_SCRIPT: $1"
}


if $VERBOSE ; then
    log "FULLPATHTOSCRIPT: $FULLPATHTOSCRIPT"
fi

gnome-terminal -- sh -c "bash -c \"watch -n 1 -d '$FULLPATHTOSCRIPT';\""
