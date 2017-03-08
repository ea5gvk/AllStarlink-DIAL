#/!bin/bash

#
# Host name  setup script
#

# Yes/No function for script interaction

function promptyn ()
{
        echo -n "$1 [y/N]? "
        read ANSWER
    if [ ! -z $ANSWER ]
    then
               if [ $ANSWER = Y ] || [ $ANSWER = y ]
              then
                    ANSWER=Y
            else
                    ANSWER=N
            fi
    else
        ANSWER=N
    fi
}


HNPATH=/etc/hostname

echo ""
echo "***** Host name setup *****"
echo ""
echo "The current hostname is: $(cat $HNPATH)"
echo ""
promptyn "Do you want to change this"

if [ $ANSWER = N ]
then
	exit 0
fi

echo -n "Enter the new host name: "
read HOSTNAME

if [ -z $HOSTNAME ]
then
	echo "Host name not changed"
	exit 0
fi

echo "$HOSTNAME" > $HNPATH
exit 0

