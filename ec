#! /bin/bash
if [[ $1 == "" ]]; then
   unamestr=`uname`

   echo -e '\033[92memacsclient\033[0m "FILE" is needed for emacs client.'
   if [[ "$unamestr" == "Linux" ]]; then
       Pemacs=`pgrep emacs`
   elif [[ "$unamestr" == "Darwin" ]]; then
       Pemacs=`pgrep emacs`
   fi
   if ! [[ $Pemacs == "" ]]; then
       echo -e "emacs Daemon is running... on \033[91m$unamestr\033[0m PID:$Pemacs"
   else
       echo -e "Start \033[94memacs --daemon\033[0m"
       emacs --daemon
   fi
   exit
fi

if [[ $1 == "--stop" ]]; then
   emacsclient -e '(kill-emacs)'
   echo -e "\033[92memacs\033[0m Daemon is stop!!!"
   exit
fi

if [[ $1 == "--restart" ]]; then
   emacsclient -e '(kill-emacs)'
   echo -e "\033[92memacs\033[0m Daemon is stop!!!"
   emacs --daemon
   exit
fi

if [[ $1 == "--start" ]]; then
   emacs --daemon
   exit
fi



emacsclient -t $@
