#! /bin/bash
function kwine {
    echo "Kill wine-server"
    kill -9 `ps -A|/bin/grep exe` > /dev/null 2>&1
    kill -9 `ps -A|/bin/grep wineserver` >/dev/null 2>&1
}

function gwine {
   cd ~/
   ls -al |grep --color=always .wine
}

function dirwine {
   cd ~/
   ls -d1l --color=auto .wine*
}

if [[ $1 == "kill" ||  $1 == "k" ]]; then
    kwine
    exit
fi 

if [[ -L ~/.wine ]]; then
    echo -e -n "wine shortcut for env::\033[93m"
    cat ~/.wine/ID
    echo -e -n "\033[0m"
    if [[ $1 == "" ]]; then
	echo -e "------\033[93m%<\033[0m---------------------------"
	dirwine
	exit
    fi
fi

if [[ ! -L ~/.wine && -d ~/.wine ]]; then
    echo -e "\033[94m -> Unknown wine environment...\033[0m ~/.wine "
   exit
fi

if [[ $1 == "--help" || $1 == "ls" ]]; then
   echo -e "Vaild options [\033[91mcc \033[92mbaidu \033[93mwin32 32 \033[94m--unlink,k,ls\033[0m] for switch wine Env."
   echo "-----------+------------%-<-------------------------------------------------------"
   dirwine
   exit
fi 

if [[ $1 == "--unlink" || $1 == "u" ]]; then
    kwine
    if [[ -L ~/.wine ]]; then
	unlink ~/.wine
	echo -e "\033[93mWine Env is Removed!\033[0m"
    fi
    exit
fi

if [[ $1 == "new" ]]; then
       echo "create .wine_xx env"
       kwine
       if [[ -L ~/.wine ]]; then
	   unlink ~/.wine
	   echo -e "\033[93mWine Env is Removed!  Create .wine_xx\033[0m"
       fi
       env WINEARCH=win32 WINEPREFIX=~/.wine_xx winetricks
       touch ~/.wine_xx/xx
       echo "xx" > ~/.wine_xx/ID
       exit	
fi


if [[ $1 == "cc" ]]; then
    if [[ -f ~/.wine/cc ]]; then
	echo "already in env(cc)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_cc ~/.wine
	echo -e "wine env(\033[92mcc\033[0m) is Created!"
	dirwine
    fi
    exit
fi

if [[ $1 == "ps" ]]; then
    if [[ -f ~/.wine/ps ]]; then
	echo "already in env(ps7)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_ps ~/.wine
	echo -e "wine env(\033[92mps\033[0m) is Created!"
	dirwine
    fi
    exit
fi




if [[ $1 == "baidu" ]]; then
    if [[ -f ~/.wine/baidu ]]; then
	echo "already in env(baiduYun)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_baidu ~/.wine
	echo -e "wine env(\033[92mbaidu\033[0m) is Created!"
	dirwine
    fi
    exit
fi

if [[ $1 == "win32" ]]; then
    if [[ -f ~/.wine/win32 ]]; then
	echo "already in env(win32)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_win32 ~/.wine
	echo -e "wine env(\033[92mwin32\033[0m) is Created!"
	dirwine
    fi
    exit
fi

if [[ $1 == "32" ]]; then
    if [[ -f ~/.wine/32 ]]; then
	echo "already in env(win32)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_32 ~/.wine
	echo -e "wine env(\033[92m32\033[0m) is Created!"
	dirwine
    fi
    exit
fi


if [[ $1 == "xx" ]]; then
    if [[ -f ~/.wine/xx ]]; then
	echo "already in env(win_xx)"
	exit
    else
	kwine
	if [[ -L ~/.wine ]]; then
	    unlink ~/.wine
	fi
	ln -s ~/.wine_xx ~/.wine
	echo -e "wine env(\033[92mxx\033[0m) is Created!"
	dirwine
    fi
    exit
fi


if [[ -f ~/.wine/cc ]]; then
    echo -e "Now wine running with env(\033[91mcc\033[0m)"
fi

if [[ -f ~/.wine/baidu ]]; then
    echo -e "Now wine running with env(\033[91mBaidu\033[92mYun\033[0m)"
fi

echo -e "\033[92m----%<------ empty .wine environment ----\033[0m"
echo "Pls switch to following wineEnv.."

cd ~/
ls -al |grep --color=always .wine
#kill `ps -A|/bin/grep exe` > /dev/null 2>&1
#kill `ps -A|/bin/grep wineserver` >/dev/null 2>&1
