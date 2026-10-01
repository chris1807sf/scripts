#! /bin/bash
#copy 2TB from SSD USB3 to HDD USB3 both in exfat
#using screen to keep the work happening in the back
#create a named session 'backup'
#	screen -S backup
#Excute rsync command
#Put in the back = Detach
#	Ctrl+A, then press D
#List sessions
#	screen -ls
#re-attach screen
#	screen -r backup
#
#
BASENAME_SCRIPT=$(basename $0)

rsync -rtv --modify-window=2 --info=progress2 --no-inc-recursive --log-file="$HOME/temp/$BASENAME_SCRIPT.log" /media/chris/T9_2/ /media/chris/Elements/


