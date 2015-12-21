#! /bin/bash
unamestr=`uname`
if [[ "$unamestr" == "Linux" ]]; then
    Pemacs=`ps -aux|grep emacs`
elif [[ "$unamestr" == "Darwin" ]]; then
    Pemacs=`pgrep emacs`
fi

if ! [[ $Pemacs == "" ]]; then
    echo -e "emacs Daemon is running... on \033[91m$unamestr\033[0m \033[92m$Pemacs\033[0m"
    if [[ $1 == "--stop" ]]; then
	kill -9 $Pemacs
	exit
    elif [[ $1 == "--restart" ]]; then
	kill -9 $Pemacs
	emacs --daemon
	exit
    fi
else
    emacs --daemon
    exit
fi

emacsclient -t $@
