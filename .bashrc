#! /bin/bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

shopt -s checkwinsize
ulimit -S -n 1024

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

PS1='\[\033[01;31m\]lePC\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]:\$ '
#export PATH=$PATH:/opt/arm-2010q1/bin:~/bin
export PATH=~/bin:/opt/app/crisp/bin:$PATH
export PATH=$PATH:/opt/sdk/tools:/opt/ndk-r10e


export EDITOR="vim"
#export EDITOR="nfte"
#export VISUAL="nfte"
export NDK_CCACHE=ccache
export USE_CCACHE=1
#export BC_ENV_ARGS=~/.bcrc
export GRPATH=/opt/app/grief/macros
export GRHELP=/opt/app/grief/help

# to change the output directory to another file system
# export OUT_DIR_COMMON_BASE=/////

#GREP_OPTIONS="--color=always"
#GREP_COLORS="ms=01;37:mc=01;37:sl=:cx=01;30:fn=35:ln=32:bn=32:se=36"

#export GRIN_ARGS="-C 2"


# Source the git bash completion file
#if [ -f ~/.git-completion ]; then
#    source ~/.git-completion
#    GIT_PS1_SHOWDIRTYSTATE=true
#    PS1="\$(__git_ps1 '(%s) ')$PS1"
#fi

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

set bell-style none

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='ls -al'
    alias ll='ls -ahl'
    alias cls='clear'
    alias mc='mc -a'
    alias e='emacs -nw'
    alias blueg='/opt/app/bluegriffon/bluegriffon > /tmp/bg 2>&1 &'
    alias eps='/opt/app/epsilon/bin/epsilonc'
    alias dfs='du -ch|tail'
    alias f='nfte'
    alias ida='/opt/app/idapro/idal' 
    alias vless='/usr/share/vim/vimcurrent/macros/less.sh'
    alias grep='grep --color=always -n'
    alias cardhu='cd /work/UI1/out/target/product/cardhu'
    alias m8d='/opt/android-ndk-r8d/ndk-build'  
    alias m8='/opt/android-ndk-r8e/ndk-build'  
    alias m9='/opt/android-ndk-r9/ndk-build'  
    alias m7='/opt/android-ndk-r7c/ndk-build'
    alias ecl='/opt/adt/eclipse/eclipse > /tmp/eclipse 2>&1 &'
    alias gvm='/work/vm/genymotion/genymotion 2>&1 &'
fi

function mktar() { echo "tar in progess....."; tar czf "${1%%/}.tgz" "${1%%/}/"; ls ${1%%/}.tgz -alh;}
#function hex2dec { awk 'BEGIN { printf "%d\n",0x$1}'; }
#function dec2hex { awk 'BEGIN { printf "%x\n",$1}'; }
function ff() { find . -type f -iname '*'$*'*'; }
function fexe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;; }

#export DISPLAY=192.168.1.180:0.0

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#fi

if [ -f ~/enviro ]; then
     . ~/enviro
fi     

function logcat
{
   clear; adb logcat -c; /usr/local/bin/logcat
}

function d2hex () {
    bc <<<"obase=16;print \"0x\", $1, \"\n\""
#    bc <<<"obase=2;print \"0b\", $1, \"\n\""
}

function hex2dec () {
    in1=${1^^}
    in1=${in1##0X}
    bc <<<"ibase=16;${in1}"
}

function hex2bin () {
   echo $((16#$1)) | gawk ' {
   for(i=lshift(1,31);i;i=rshift(i,1))
   printf "%d%s", (and($1,i) > 0), ++c%4==0?" ":"";
   printf"\n"; }'
}

notdigit ()
{
    [ $# -eq 1 ] || return 0
    case $1 in
      *[!0-9]*|"") return 0;;
      *) return 1;;
    esac
}

function v()
{
    if [[ $1 == "0" ]]; then
      vgrep -v
      return
    fi
    
    if [[ $1 == "?" || $1 == "--help" ]]; then
      echo -e "vWrapper v0.1 for \033[93mgrepsel/\033[91mvgrep/\033[92mgrin\033[0m hybrid mode for \033[095mvim\033[0m"
      echo "  v =            -- grepsel in vim view"
      echo "  v 0            -- vgrep -v show vgrep history"
      echo "  v              -- grin in vim view"
      echo -e "  v [\033[93m1-9\033[0m].*      -- grin in vim view go line"
      echo -e "  v \033[90mpattern\033[0m      -- grin pattern"
      return
    fi
    

    if [[ $1 == "" ]]; then
      vim +Vlist
    else 
      if [[ $1 == "=" ]]; then
        if [[ -f ~/legrep.grp ]]; then
           vim +Glist
        else
           echo "Empty legrep.grp"
        fi 
        return
      fi
    
      if notdigit $1
      then
        grin --fte $1 > ~/fte.grp
        vgrep -v
        return
      else
        ln=$1
        vim +Vlist +$ln
      fi
    fi
}


function gocd () {
    if [[ -z "$1" ]]; then
        echo "Usage: godir <regex>"
        return
    fi
    T=$(gettop)
    if [[ ! -f $T/dofiles ]]; then
        echo -n "Creating index..."
#        (cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > dofiles)
        echo "this function need add manually"
        echo " Done"
        echo ""
    fi
    local lines
    lines=($(\grep "$1" $T/dofiles | sed -e 's/\/[^/]*$//' | sort | uniq))
    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi
    local pathname
    local choice
    if [[ ${#lines[@]} > 1 ]]; then
        while [[ -z "$pathname" ]]; do
            local index=1
            local line
            for line in ${lines[@]}; do
                printf "%6s %s\n" "[$index]" $line
                index=$(($index + 1))
            done
            echo
            echo -n "Select one: "
            unset choice
            read choice
            if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                echo "Invalid choice"
                continue
            fi
            pathname=${lines[$(($choice-1))]}
        done
    else
        pathname=${lines[0]}
    fi
    cd $T/$pathname
}

function ctags_android()
{
    time ctags -R --exclude=*.java --exclude=*.js --exclude=*.so  \
    --exclude=prebuilts \
    --exclude=prebuilt \
    --exclude=u-boot \
    --exclude=x-loader \
    --exclude=ndk \
    --exclude=build \
    --exclude=.repo \
    --exclude=sdk \
    --exclude=gdk \
    --exclude=out 
    
#    find . -path ./Documentation -prune -o -print > indexme
#     find . -name "*.aidl" -o -name "*.cc" -o -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" -o -name "*.mk"   
}

function ctags_emacs()
{
    ctags -e -R --extra=+fq --exclude=db --exclude=.repo  --exclude=.git --exclude=public -f TAGS
}

function sag()
{
    if [[ -z "$1" ]]; then
        echo "sag <regex>"
        return
    fi
  sack -ag $@
}

function gdiff() {
	git diff --no-ext-diff -w "$@"
}

function d32() {
        diff -u "$@" | cdiff00 -s 
}

function d33() {
        diff -u "$@" | cdiff | less -R
}

source "$HOME/dirMarks.sh"
export ANDROID_HOME=/opt/sdk
export LD_LIBRARY_PATH=/usr/local/lib


