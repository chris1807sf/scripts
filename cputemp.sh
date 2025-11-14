#!/bin/bash
#
# cputemp.sh: Show the temperature of the CPU's
#
# opens a new terminal and "watch"-es the temp of the CPU's every sec [lines with 'Core' and with 'CPU']
#
gnome-terminal -- sh -c "bash -c \"watch -n 1 -d 'sensors|grep -e Core -e CPU';\""
