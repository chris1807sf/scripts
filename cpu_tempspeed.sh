#!/bin/bash
sensors|grep -e Core -e CPU
cat /proc/cpuinfo|grep MHz
