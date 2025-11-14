#!/bin/bash
#
# lauch a couple of programs related to using handbrake with DVD disks
#
# usage of zenit and trap: https://www.reddit.com/r/linux4noobs/comments/16i1pcf/how_can_i_make_a_gui_prompt_to_input_the_sudo/
#
BASENAME_SCRIPT=$(basename $0)
SCRIPTS_DIR=~/projects/scripts

MYUSER=$(whoami)
MYSESSION=$(tty | cut -d"/" -f3-)

fatal() {
    echo "FATAL ERROR: $@"
    exit 1
  }
 
trap 'sudo -k' EXIT  # -k: clear cached credentials of the current session: avoiding that sudo with the typed-in passward is still valid (if < 15min)

echo -e "$BASENAME_SCRIPT: launching applications related to DVD disks"
echo "MYUSER: $MYUSER"
echo "MYSESSION: $MYSESSION"

gnome-terminal -- sh -c "bash -c \"btop\""
#pid="$!"
#echo "PID of btop: $pid"

#gnome-terminal -- sh -c "bash -c \"zenity --password | sudo -S -- dmesg -wH\""
zenity --title="password for dmesg" --password | sudo -Sv || fatal "Unable to sudo" #sudo -S: takes password from sdin; -v: put credentials in cache and don't execute a command as sudo

gnome-terminal -- handbrake
#nohup gnome-system-monitor &> /dev/null & 
#nohup handbrake &> /dev/null & 

sudo -- dmesg -wH #use the credentials in the cache (default: credentials kept in the cache for 15min)

#when stopping dmesg --> kill the terminal process
echo -e "About to kill the terminal process."
pkill -9 -t $MYSESSION

exit