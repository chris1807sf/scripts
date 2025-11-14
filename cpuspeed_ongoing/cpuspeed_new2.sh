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


#Full command
#watch -n 1 'cat /proc/cpuinfo|grep MHz| awk -F ':' '{ sum += \$2 } END { printf(\"Average %.2f MHz\n\", sum/NR) }'
# partial: cat /proc/cpuinfo|grep MHz| awk -F ':' '{ sum += $2 } END { printf("Average %.2f MHz\n", sum/NR) }'
# adding watch:
#watch -n 1 \"cat /proc/cpuinfo|grep MHz| awk -F ':' '{ sum += \$2 } END { printf(\"Average %.2f MHz\n\", sum/NR) }'\"



#Simple awk
#                cat /proc/cpuinfo|grep MHz| awk -F ': ' '{print \$2}'
#Simple awk with watch --> working!
#   watch -n 1 \"cat /proc/cpuinfo|grep MHz| awk -F ': ' '{print \$\"2\"}'\"
#interpreted as:
#   cat /proc/cpuinfo|grep MHz| awk -F ': ' '{print $2}'


#gnome-terminal -- sh -c "bash -c \"watch -n 1 'cat /proc/cpuinfo|grep MHz';\""
#gnome-terminal -- sh -c "bash -c \"${CMD};bash\"" #this is working
gnome-terminal -- sh -c "bash -c \"${CMD};bash\"" #this is working
