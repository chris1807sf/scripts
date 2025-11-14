#!/bin/bash
#
# cpuspeed.sh.sh: Show the speed of the CPU cores
#
# opens a new terminal and "watch"-es the speed of the CPU cores every sec
#
gnome-terminal -- sh -c "bash -c \"watch -n 1 -d 'cat /proc/cpuinfo|grep MHz';\""
