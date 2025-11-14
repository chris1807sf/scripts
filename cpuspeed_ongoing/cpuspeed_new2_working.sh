#!/bin/bash
#
# cpuspeed.sh.sh: Show the speed of the CPU cores
#
# opens a new terminal and "watch"-es the speed of the CPU cores every sec
#
#CMD="watch -n 1 'cat /proc/cpuinfo|grep MHz'"
#CMD="cat /proc/cpuinfo|grep MHz| awk -F ':' '{ sum += '$2' } END { printf(\"Average %.2f MHz\n\", sum/NR) }'"

CMD=`cat command`
echo -e "CMD:${CMD}"

#echo "  test"|sed 's/^[[:blank:]]*//'  #trim leading spaces

#CMD="cat /proc/cpuinfo|grep MHz| awk -F ':' '{printf(\"being: %.2f\",\$2)}'"
#echo -e "CMD: $CMD"
gnome-terminal -- sh -c "bash -c \"${CMD};bash\""
#gnome-terminal -- sh -c "bash -c \"`cat command`;bash\""