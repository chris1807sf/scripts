#! /bin/bash
# rename a set of files at once
# usage:
#	rename.sh $1 $2
# params:
#	$1: string of the beginning of the filename of files to be renamed
#	$2: replace th e$1 by $2 in all files found to be renamed
# example:
#	startingpoint: files in dir: "test v1 _ one.txt" "test v1 _ two.txt"
#	command: rename.sh "test v1 _ " "final v2_"
#	results in files: "final v2_one.txt" "final v2_two.txt"
for f in "$1"*; do mv "$f" "$(echo $f | sed s/^"$1"/"$2"/g)"; done