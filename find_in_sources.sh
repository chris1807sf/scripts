#!/bin/bash
# find a string in all sourcefiles
grep --include=\*.{c,h} -rnw '.' -e "%1"
