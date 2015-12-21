#!/bin/bash
# createStack.sh
# Version 1.2 (Nov 23 2012)
# Author: Vincent Tassy <photo@tassy.net>
# Site: http://linuxdarkroom.tassy.net
# This script is released under a CC-GNU GPL License

# A bash script to create a stack of all images in a folder
# Results in a Gimp xcf file containing a layer for each image
#	All layers but the bottom one are set to Lighten Only mode
#	This is useful to assemble star trail pictures

# Changelog
#
# Version 1.0
#	first public release
# Version 1.1
#	Make layers invisible by default to minimise processing when first opening the XCF in Gimp
# Version 1.2
#	Take advantage of Gimp 2.8 and add the layers inside a Layer Group

SELF=`basename $0`	# Ouselve
DIR=""
USEKDE=0		# command line invocation by default
STACKFILEPREFIX="STACK"	# Prefix for the generated Gimp file

displayHelp() {
	echo "Create a stack of all images in a folder."
	echo
	echo "Usage: $SELF [OPTION] DIR"
	echo -e "  -k\t\tDisplay progress information with kdialog"
	echo -e "  -h\t\tThis help"
	echo
	echo "Report bugs to <photo@tassy.net>"
}

compareVersions ()
{
  typeset    IFS='.'
  typeset -a v1=( $1 )
  typeset -a v2=( $2 )
  typeset    n diff

  for (( n=0; n<4; n+=1 )); do
    diff=$((v1[n]-v2[n]))
    if [ $diff -ne 0 ] ; then
      [ $diff -le 0 ] && echo '-1' || echo '1'
      return
    fi
  done
  echo  '0'
}

# test params
while getopts kh argument
do
        case $argument in
		k)USEKDE=1;;
                h)displayHelp;exit;;
        esac
done
shift $(($OPTIND-1))
DIR=$1
if [ -z $DIR ]; then
	displayHelp
	exit
fi
if [ ! -d "$DIR" ]; then
	echo "$DIR is not a valid directory"
	displayHelp
	exit
fi
DIR=$(cd "$DIR" && pwd) #transform to absolute path
# Check of the directory contains only one type of files
if [ `find $DIR -maxdepth 1 -type f -exec basename {} \; | sed "s/.*\.//g" | tr '[:lower:]' '[:upper:]' | sort -u | wc -l` != 1 ]; then
	if [ $USEKDE = 1 ]; then
		kdialog --title createHDR --error "Directory contains multiple filetypes"
	else
		echo "Error: Directory contains multiple filetypes"
	fi
	exit
fi

STACKFILE="$STACKFILEPREFIX.xcf"

FILES=(`find $DIR -maxdepth 1 -type f -print | sort`) # List files in the selected directory
filetype=`basename ${FILES[0]} | sed "s/.*\.//g" | tr '[:lower:]' '[:upper:]'` # Get file extension
FILENUMS=${#FILES[@]}
if [ $filetype = "JPG" ] || [ $filetype = "TIF" ]; then
	
	if [ $USEKDE = 1 ]; then
		dbusRef=`kdialog --title "createStack" --progressbar "Stacking $FILENUMS files" 2`
	else
		echo "Stacking $FILENUMS files"
	fi
	SCRIPTFILE=`mktemp --tmpdir createStackScript.XXXXXX`
	GIMPVER=`gimp --version | awk '{ print $NF }'`
	NEWGIMP=$(compareVersions "$GIMPVER" 2.8)
	echo '(define (stack-images)' >$SCRIPTFILE
	echo '(let* ((image (car (gimp-file-load RUN-NONINTERACTIVE "'${FILES[0]}'" "'${FILES[0]}'")))' >>$SCRIPTFILE
	echo '(layer0 (car (gimp-image-get-active-layer image)))' >>$SCRIPTFILE
	if [ $NEWGIMP -ge 0 ]; then 
		echo '(layergroup (car (gimp-layer-group-new image)))' >>$SCRIPTFILE
	fi
	for (( i = 1 ; i < $FILENUMS ; i++ )); do
		if [ $i -eq  $((FILENUMS-1)) ]; then
			echo '(layer'$i' (car (gimp-file-load-layer RUN-NONINTERACTIVE image "'${FILES[$i]}'"))))' >>$SCRIPTFILE
		else
			echo '(layer'$i' (car (gimp-file-load-layer RUN-NONINTERACTIVE image "'${FILES[$i]}'")))' >>$SCRIPTFILE
		fi
	done
	if [ $NEWGIMP -ge 0 ]; then 
		echo '(gimp-image-insert-layer image layergroup 0 -1)' >>$SCRIPTFILE
		echo '(gimp-layer-set-name layergroup "Stars")' >>$SCRIPTFILE
	fi
	for (( i = 1 ; i < $FILENUMS ; i++ )); do
		if [ $NEWGIMP -ge 0 ]; then 
			echo '(gimp-image-insert-layer image layer'$i' layergroup -1)' >>$SCRIPTFILE
		else
			echo '(gimp-image-add-layer image layer'$i' -1)' >>$SCRIPTFILE
		fi
		echo '(gimp-layer-set-mode layer'$i' LIGHTEN-ONLY-MODE)' >>$SCRIPTFILE
		echo '(gimp-drawable-set-visible layer'$i' FALSE)' >>$SCRIPTFILE
	done
	echo '(gimp-xcf-save RUN-NONINTERACTIVE image layer0 "'$DIR/$STACKFILE'" "'$DIR/$STACKFILE'")' >>$SCRIPTFILE
	echo '(gimp-image-delete image)))' >>$SCRIPTFILE
	echo '(stack-images)' >>$SCRIPTFILE
	echo '(gimp-quit 0)' >>$SCRIPTFILE

	gimp -c -d -i -f -s -n -b - < $SCRIPTFILE >/dev/null 2>&1

	if [ $USEKDE = 1 ]; then
		qdbus $dbusRef Set "" "value" 1
	fi
	if [ $USEKDE = 1 ]; then
		qdbus $dbusRef setLabelText "Cleaning up"
	else
		echo "Cleaning up"
	fi
	rm -f $SCRIPTFILE
	if [ $USEKDE = 1 ]; then
		qdbus $dbusRef Set "" "value" 2
		qdbus $dbusRef close
	fi
else
	if [ $USEKDE = 1 ]; then
		kdialog --title createHDR --error "Unsupported file type: $filetype"
	else
		echo "Unsupported file type: $filetype"
	fi
fi
