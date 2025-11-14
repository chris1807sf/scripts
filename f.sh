#!/bin/bash
#
# start firefox from the cmd to do a google search, and passes the params as search string
# concatenates all input params and adds a "+" between them
#
# typical usage: ./f.sh what is the current weather

#make a string of all the input
SEARCH_STRING=""

for var in "$@"
do
    SEARCH_STRING+="$var"+ #concatenate and add a "+" between the arguments
done

echo -e "search: $SEARCH_STRING"
firefox https://google.com/search?q="$SEARCH_STRING" 2> /dev/null #call firefox with the search and get rid of the errors