#!/bin/bash
if [[ $1 == "" ]]; then
    echo "be careful modify old and new first"
    exit
fi

promptyn () {
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}



if promptyn "let's go Y/n?"; then
    OLD="org.linphone"
    NEW="com.quanta.livehd_v2"
    DPATH="*.java"
    BPATH="bak"
    TFILE="/tmp/out.tmp.$$"
    [ ! -d $BPATH ] && mkdir -p $BPATH || :
    for f in $DPATH
    do
	if [ -f $f -a -r $f ]; then
#	    /bin/cp -f $f $BPATH
	    sed "s/$OLD/$NEW/g" "$f" > $TFILE && mv $TFILE "$f"
	else
	    echo "Error: Cannot read $f"
	fi
    done
    /bin/rm $TFILE

else
    echo "no"
fi

exit

# find . -type f -print0 | xargs -0 sed -i 's/org\.linphone/com\.quanta\.livehd_v2/g'
# find . -type f -print0 | xargs -0 sed -i 's/org_linphone/com_quanta_livehd_v2/g'
# find . -type f -print0 | xargs -0 sed -i 's/org_linphone/com_quanta_livehd_v2/g'

