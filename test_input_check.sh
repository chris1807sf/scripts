read -p "Press enter to continue"

if [ ! "$?" == 0 ] ; then
    echo "return is not 0"
    exit
else
    echo "return is 0"
fi

echo "continuing ..."