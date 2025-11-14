#!/bin/bash
#
# return the last-1 filename of "ls -1tr"
#
# version:
# v1: 14/11/2025 - script created

BASENAME_SCRIPT=$(basename $0)

log() {
    echo -e "$BASENAME_SCRIPT, $1"
}

before_last() {
    FROM_LAST_DEFAULT=2 #set to 2 to get the one-before-last filename
    FROM_LAST=2 #set to 2 to get the one-before-last filename

    # if there is a $1 then overwrite FROM_LAST
    if [ ! "$1" == "" ] ; then
        #log "\$1: $1"
        INPUT_PARAM=$1
        # check if FROM_LAST starts with a "."
        if [ ${INPUT_PARAM:0:1} == "." ] ; then
            # count the number of "." characters
            #log "is starting with ."
            only_dots="${INPUT_PARAM//[^.]}"
            cnt_dots="${#only_dots}"
            # to determine the resulting FROM_LAST:
            #   .: one "." equals to one-before last = same as if no param is given being FROM_LAST_DEFAULT
            #   ..: two '.' equals to one-one-before = FROM_LAST_DEFAULT + 1;
            #   overall: FROM_LAST = (#'.' - 1) + FROM_LAST_DEFAULT
            FROM_LAST=$((cnt_dots - 1 + FROM_LAST_DEFAULT))
            #log "cnt_dots: $cnt_dots"
            #log "FROM_LAST based on #dots: $FROM_LAST"
        elif [ -n "$INPUT_PARAM" ] && [ "$INPUT_PARAM" -eq "$INPUT_PARAM" ] 2>/dev/null; then
            #log "is a number"
            # INPUT_PARAM is a number
            # in the above test, the second expresion is to exclude for instance 22.0
            # Redirection of standard error is there to hide the "integer expression expected" message that bash prints out in case we do not have a number.
            # from: https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash

            # to determine the resulting FROM_LAST:
            #   1: equals to one-before last = same as if no param is given being FROM_LAST_DEFAULT
            #   2: two '.' equals to one-one-before = FROM_LAST_DEFAULT + 1;
            #   overall: FROM_LAST = (FROM_LAST - 1) + FROM_LAST_DEFAULT
            FROM_LAST=$((INPUT_PARAM - 1 + FROM_LAST_DEFAULT))
            #log "FROM_LAST based on number given as input: $FROM_LAST"
            #echo "FROM_LAST: $FROM_LAST"
        else
            log "input param does not start with a dot nor is it a number. Will exit."
            exit
        fi
    fi

    # "ls -1tr" will return a list with only the filenames (-1) sorted by modified time (-t) in reverse order (-r)
    # tail & head usage: "tail -n 2" will return the last 2 lines. With "head -n 1" the single top line of these two is returned.
    # use quotes "" around the $() to still return as one string even if it contains spaces
    #log "resulting FROM_LAST: $FROM_LAST"
    echo "$(ls -1tr | tail -n $FROM_LAST | head -n 1)"
}

# commented out calling the before_last function, to source it .bashrc
#before_last $1
