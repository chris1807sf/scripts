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
DATE_STAMP=$(date '+%4Y%m%d_%H%M%S') #fetch the YYYYmmdd_HHMMSS for now
LOG_FILE=$HOME/temp/${BASENAME_SCRIPT}_${DATE_STAMP}.log


#execute the copy
rsync -rtv --modify-window=2 --info=progress2 --no-inc-recursive --log-file="$LOG_FILE" /media/chris/T9_2/ /media/chris/Elements/

#do a check that all got copied
#rsync -rtv --itemize-changes --dry-run --modify-window=2 --info=progress2 --no-inc-recursive --log-file="$LOG_FILE" /media/chris/T9_2/ /media/chris/Elements/
