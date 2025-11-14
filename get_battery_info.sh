#upower will show: 'time to full' if the battery is charging, otherwise it shows: 'time to empty'
#remark: when connecting or de-connecing a power adaptor it takes a while before the 'time to' message appears ...
#        during that think/check/calculate time there is no 'time to' message
upower -i /org/freedesktop/UPower/devices/battery_BAT0|grep -i 'time to'
