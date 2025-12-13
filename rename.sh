#! /bin/bash
#for f in fgh*; do mv "$f" "$(echo $f | sed 's/^fgh/jkl/g')"; done
#for f in "$1"*; do echo "$(echo $f | sed 's/^"$1"/"$2"/g')"; done
for f in "$1"*; do mv "$f" "$(echo $f | sed s/^"$1"/"$2"/g)"; done