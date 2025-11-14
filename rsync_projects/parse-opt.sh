
#!/bin/bash
#
# Example of how to parse short/long options with 'getopt'
#

OPTS=`getopt -o vhdyn --long verbose,dry-run,help,yes,no -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

VERBOSE=false
HELP=false
DRY_RUN=true
NO=false

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -h | --help )    HELP=true; shift ;;
    -d | --dry-run ) DRY_RUN=true; shift ;;
    -y | --yes ) DRY_RUN=false; shift ;;
    -n | --no ) NO=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

TEST=101

if $VERBOSE ; then
    echo VERBOSE=$VERBOSE
    echo HELP=$HELP
    echo DRY_RUN=$DRY_RUN
    echo NO=$NO
else
    echo "in elif"
fi
