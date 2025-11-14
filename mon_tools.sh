#!/bin/bash
#
# lauch a couple of system monitor scripts and tools
#
BASENAME_SCRIPT=$(basename $0)
SCRIPTS_DIR=~/projects/scripts

echo -e "$BASENAME_SCRIPT: launching monitor tools"

${SCRIPTS_DIR}/watch_cpu.sh
#/usr/bin/gnome-system-monitor &

nohup gnome-system-monitor &> /dev/null & 

btop

exit 0