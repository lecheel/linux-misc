#! /bin/bash
figlet "auAEC"
#figlet "MinOut,SpkIn"

function auAEC0 {
#  export ylim=5000
  au -p1
  au -cv MicIn.pcm micin.wav
  au -cv MicOut.pcm mout.wav
  au -cv speakerIn.pcm sin.wav
  au -cv speakerOut.pcm sout.wav
  rm *.pcm
  au mout.wav sin.wav
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
  auAEC0
}

function auAEC_test { # MIO
  figlet "MIO TEST"
  adb shell input tap 444 888  # CALL
  echo "Call 11798"
  sleep 3
  echo "Playback man speech 10s"
  au -pl /opt/raw/eng_m1.wav > /dev/null 2>&1
  sleep 2
  auAEC0
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
echo "          +---------------+            +---+     /         "
echo -e " minIn -->|               |-- \033[91mmicOut\033[0m --|   |--+ D         "
echo "          |     SBACP     |            | D |  |  \       "
echo -e "          |      \033[92mAEC\033[0m      |            | U |  |        "             
echo "          |               |            | T |  |          "                            
echo -e "spkOut <--|               |-- \033[91mSpeakIn\033[0m--|   |--+ i         "          
echo "          +---------------+            +---+ "
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
