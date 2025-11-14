#!/bin/bash
#
# usage of zenit and trap: https://www.reddit.com/r/linux4noobs/comments/16i1pcf/how_can_i_make_a_gui_prompt_to_input_the_sudo/
#
#

#const
BASENAME_SCRIPT=$(basename $0)
SCRIPTS_DIR=~/projects/scripts

MYUSER=$(whoami)
MYSESSION=$(tty | cut -d"/" -f3-)

#config params
SLEEP_SEC_BEFORE_NEXT_TRY=5
MAX_LOOPS=99

#config for logging
LOG_DEBUG=0 LOG_INFO=1 LOG_WARNING=2 LOG_ERROR=3 LOG_NONE=4
LOG_LEVEL_STR=("DEBUG" "INFO" "WARNING" "ERROR" "NONE")
LOG_MIN_LEVEL=$LOG_INFO

#used during processing: NOT const ... NOR config params ...
current_conn_status_ok=false
previous_conn_status_ok=false
sent_status_communication=false #indicates if a status_comm was done during the current loop
loop_ctr=0
zenity_text=""
zenity_icon=""

#DEBUG
#set -xv                                                  # turn on debugging

log() {
    req_log_level=$1
    req_log_level_str=${LOG_LEVEL_STR[$req_log_level]}
    message=$2
    if [[ "$req_log_level" -ge "$LOG_MIN_LEVEL" ]] ; then
        echo -e "$BASENAME_SCRIPT, $req_log_level_str, $message"
    fi
}

send_zenity_notif() {
    zenity_text=$1
    zenity_icon=$2
    $(zenity --notification --text="$zenity_text" --icon="$zenity_icon")
    sent_status_communication=true
}

log $LOG_INFO "--started"

while true; do
  sent_status_communication=false #reset this flag for the current loop
  loop_ctr=$((loop_ctr+1))

  #ping -c 1 google.com
  ping -q -c 1 google.com > /dev/null 2>&1;
  ping_result=$? #result is 0 if the ping went fine. result is >0 if not ok
  log $LOG_DEBUG "ping_result: $ping_result"

  if [[ $ping_result > 0 ]] ; then
      log $LOG_INFO "connection is not ok"
      zenity_text="internet connection is NOT working. try: $loop_ctr"
      zenity_icon="error"
      current_conn_status_ok=false
      if [[ $previous_conn_status_ok == true ]] ; then
          log $LOG_DEBUG "[ previous_conn_status_ok == true ], now NOK --> sending notif"
          send_zenity_notif "$zenity_text" "$zenity_icon"
      else
          log $LOG_DEBUG "[ previous_conn_status_ok == false ], now still NOK --> NOT sending notif as nothing changed"
      fi
  else #ping was successfull
      log $LOG_INFO "connection is ok"
      current_conn_status_ok=true
      log $LOG_DEBUG "current_conn_status_ok: $current_conn_status_ok"
      if [[ $previous_conn_status_ok == true ]] ; then
          log $LOG_DEBUG "[ previous_conn_status_ok == true ], now OK --> NOT sending notif as nothing changed."
      else
          log $LOG_DEBUG "[ previous_conn_status_ok == false ], now OK --> sending notif"
          zenity_text="internet connection is working. try: $loop_ctr"
          zenity_icon="info"
          send_zenity_notif "$zenity_text" "$zenity_icon"
      fi
  fi

log $LOG_DEBUG "before checking for loop_ctr == 1, loop_ctr: $loop_ctr"
log $LOG_DEBUG "sent_status_communication: $sent_status_communication"
if [[ $loop_ctr == 1 ]] && [[ $sent_status_communication == false ]] ; then
    log $LOG_DEBUG "loop_ctr = 1"
    log $LOG_DEBUG "zenity_text: $zenity_text"
    send_zenity_notif "$zenity_text" "$zenity_icon"
fi

previous_conn_status_ok=$current_conn_status_ok #update orevious with what is now current, for the next loop for the next loop

if [[ $loop_ctr > $MAX_LOOPS ]] ; then
    log $LOG_DEBUG "[ loop_ctr > 2]. Exit 0"
    exit 0
fi

sleep $SLEEP_SEC_BEFORE_NEXT_TRY

done
