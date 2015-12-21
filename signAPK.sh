#! /bin/bash
if [[ $1 == "" ]]; then
   echo "signAPK xxx.apk"
   exit
fi
if [ -f $1 ]; then
  figlet "signAPK Release"
  fname=$1
  fname=${fname%.*}_signed.apk
  jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore /opt/mykey/leapp1.keystore $1 lechee
fi
