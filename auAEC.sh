#! /bin/bash
figlet "auAEC"
#figlet "MinOut,SpkIn"
adbTCP="-s 192.168.0.16:5555 "

function auAEC0 {
#  export ylim=5000
#  au -p1
  adb $adbTCP pull /sdcard/MicIn.pcm
  adb $adbTCP pull /sdcard/MicOut.pcm
  adb $adbTCP pull /sdcard/speakerIn.pcm
  adb $adbTCP pull /sdcard/speakerOut.pcm
  
  au -cv MicIn.pcm micin.wav
  au -cv MicOut.pcm mout.wav
  au -cv speakerIn.pcm sin.wav
  au -cv speakerOut.pcm sout.wav
  rm *.pcm
  au mout.wav sin.wav
}

function auAEC0_dut {
  # test device like TAB
  adb $adbTCP pull /sdcard/MicIn.pcm
  adb $adbTCP pull /sdcard/MicOut.pcm
  adb $adbTCP pull /sdcard/speakerIn.pcm
  adb $adbTCP pull /sdcard/speakerOut.pcm
  
  au -cv MicIn.pcm micin.wav
  au -cv MicOut.pcm mout.wav
  au -cv speakerIn.pcm sin.wav
  au -cv speakerOut.pcm sout.wav
  rm *.pcm
  au micin.wav mout.wav sin.wav sout.wav
}


function auAEC_EP1T {
  figlet "EP1T"
  adb shell input tap 272 794  # More
  sleep 0.5
  adb shell input tap 1100 719   # Quit 
  sleep 5
  adb shell am start -n com.radvision.beehd/.gui.MainAct
  sleep 10
  adb shell input tap 300 650  # CALL
  echo "Call 11798"
  sleep 3
  echo "Playback man speech 10s"
  au -pl /opt/raw/eng_m1.wav > /dev/null 2>&1
  sleep 1
  adb shell input tap 272 794  # More
  sleep 0.5
  adb shell input tap 90 719   # Close 
  adbTCP=""
  auAEC0
}

function auAEC { # MIO
  figlet "MIO"
  adb shell input tap 1888 1065  # More
  sleep 0.5
  adb shell input tap 1670 998   # Quit 
  sleep 5
  adb shell am start -n com.radvision.beehd/.gui.MainAct
  sleep 10
  adb shell input tap 444 888  # CALL
  echo "Call 11798"
  sleep 3
  echo "Playback man speech 10s"
  au -pl /opt/raw/eng_m1.wav > /dev/null 2>&1
  sleep 1
  adb shell input tap 1888 1065  # More
  sleep 0.5
  adb shell input tap 188 1000   # Close 
  adbTCP=""
  auAEC0
}

function auAEC_test { # MIO
#  figlet "MIO TEST -- EP1T"
  figlet "1 EP1T"
#  adbTCP="-s 192.168.0.27:5555 "
  # start EP1T
#  adb $adbTCP shell input tap 272 794  # More
#  sleep 0.5
#  adb $adbTCP shell input tap 1100 719   # Quit 
#  sleep 5
#  adb $adbTCP shell am start -n com.radvision.beehd/.gui.MainAct
  sleep 2  

  figlet "MIO"
  adbTCP="-s 192.168.0.16:5555 "  
  adb $adbTCP shell input tap 444 888  # CALL
  echo "Call DUT"
  sleep 3
  echo "Playback man speech 10s"
#  au -pl /opt/raw/eng_m1.wav > /dev/null 2>&1
  au -pl /opt/raw/sweep > /dev/null 2>&1
  sleep 2
  sleep 1
  adb $adbTCP shell input tap 1888 1065  # More
  sleep 0.5
  adb $adbTCP shell input tap 188 1000   # Close

  figlet "pull EP1T"
#  adbTCP="-s 0157A6280A013013"
  adbTCP="-s 192.168.0.27:5555 "
  auAEC0_dut
}

function auAEC_sel {
  if [[ $args == "mio" ]]; then
     auAEC
     exit
  fi

  if [[ $args == "test" ]]; then
     auAEC_test
     exit
  fi

  if [[ $args == "ep1t" ]]; then
     auAEC_EP1T
     exit
  fi
}


if [[ $1 == "-h" || $1 == "--help" ]]; then
   echo "auAEC v0.1"
   echo "     mio     -- MIO as reference platform"
   echo "     ep1t    -- EP1T"
   echo "     test    -- TEST mode without restart"
   echo "     "
   exit
fi

echo "                       "
echo "          +---------------+                   +---+     /         "
echo -e " micIn -->|               |-- \033[91mmicOut\033[0m-- spkIn--|   |--+ spkOut D         "
echo "          |     SBACP     |                   | D |  |  \       "
echo -e "          |      \033[92mAEC\033[0m      |                   | U |  |        "             
echo "          |               |                   | T |  |          "                            
echo -e "spkOut <--|               |-- \033[91mSpeakIn\033[0m--micOut-|   |--+ micIn i         "          
echo "          +---------------+                   +---+ "
echo " ref tinymix 24 mic 64 spk ..., "
echo "                       "

declare -a arr=(mio ep1t test)

args=$1
for i in ${arr[@]}
do
  if [[ $i == $args ]]; then
    while true; do
      read -p "Do you want to process ?(Y/n)" yn
             case $yn in
               [Yy]* ) auAEC_sel;exit;;
               [Nn]* ) exit;;
                   * ) exit;;
             esac
    done
#    echo "Founded"
  fi  
done
