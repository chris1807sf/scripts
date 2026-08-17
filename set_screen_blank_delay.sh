#!/bin/bash
#
# use gsettings to set the idle-time for blanking the screen 
# uses: gsettings set org.gnome.desktop.session idle-delay $IDLE_TIME
# tested on Ubuntu 24.04
#
# takes one parameter as input: number of seconds to be set for idle-delay
# if no input param is given, then 0 is used. What means: do not blank teh screen
#
# to read the idle-time use: gsettings get org.gnome.desktop.session idle-delay

BASENAME_SCRIPT=$(basename $0)

IDLE_TIME=0 #0 means: do not blank the screen

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

is_uint32() { #check that value is a valid uint32, being >=0 and <="max_uint32 = 2**32 - 1"
    local val="$1"

    #  check that all chars are digits, #see: https://unix.stackexchange.com/questions/151654/checking-if-an-input-number-is-an-integer
    #  check that number of digits is less than 10 --> to handle 64-bit overflow, and max_uint32 needs 10 digits
    #  check that it is smaller then max_uint32 = 2**32 - 1
    if [[ $val == +([[:digit:]]) && ${#val} -le 10 ]] && (( val <= (2**32 - 1) )); then
        return 0 # valid uint32
    else
        return 1 # not valid
    fi
}

#if there is a $1 then overwrite IDLE_TIME with it. IDLE_TIME must be a uint32
if [ ! "$1" == "" ] ; then
    IDLE_TIME=$1    
    #check if $1 is a valid uint32
    if ! is_uint32 "$IDLE_TIME"; then
        log "ERROR: IDLE_TIME is not a valid uint32"
        exit 1
    fi 
fi

#set the IDLE_TIME
gsettings set org.gnome.desktop.session idle-delay $IDLE_TIME

#check the return code of gsettings
gsettings_result=$? #result is 0 if it went fine. result is >0 if not ok

if [[ $gsettings_result > 0 ]] ; then
  log "failed to set idle_time. gsettings returned: $gsettings_result"
  exit $gsettings_result
else #gsettings ok
  log "IDLE_TIME set to $IDLE_TIME"
fi
