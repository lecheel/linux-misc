#! /bin/bash
if [[ $1 == "" ]]; then
   echo "lesgin xxx.apk"
   exit
fi
if [ -f $1 ]; then
  figlet "signAPK"
  fname=$1
  fname=${fname%.*}_signed.apk
  java -classpath /opt/app/sign/testsign.jar testsign $1 $fname
else
  echo "Oops!!!"
fi
