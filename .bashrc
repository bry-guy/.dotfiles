# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

GIT_PS1_SHOWDIRTYSTATE=true
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#PATH
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/share/dotnet:$PATH"
export PATH="/Library/Frameworks/Mono.framework/Versions/Current/Commands:$PATH"

#vim >> vi
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

#nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
export NODE_PATH=`which node`

#android
export ANDROID_HOME=/Users/smith.bryan/Library/Android/sdk

#alias git to g with autocomplete enabled
alias g='git'
complete -o default -o nospace -F _git g
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

#aws
export PATH="~/Library/Python/3.7/bin:$PATH"

#factorio
export PATH="~/Library/Application Support/Steam/steamapps/common/Factorio/factorio.app/Contents/MacOS:$PATH"

#azcopy
export PATH="/usr/local/bin/azcopy:$PATH"

# WORK STUFF ONLY HERE
alias nuget="mono /usr/local/bin/nuget.exe"

# force new line
###
# Configure PS1 by using the old value but ensuring it starts on a new line.
###
 __configure_prompt() {
   PS1=""
 
   if [ "$(__get_terminal_column)" != 0 ]; then
     PS1="\n"
   fi

   PS1+="$PS1_WITHOUT_PREPENDED_NEWLINE"
 }

# Get the current terminal column value.
#
# From https://stackoverflow.com/a/2575525/549363.
#
 __get_terminal_column() {
  exec < /dev/tty
  local oldstty=$(stty -g)
  stty raw -echo min 0
  echo -en "\033[6n" > /dev/tty
  local pos
  IFS=';' read -r -d R -a pos
  stty $oldstty
  echo "$((${pos[1]} - 1))"
}

# Save the current PS1 for later.
PS1_WITHOUT_PREPENDED_NEWLINE="$PS1"

# Use our prompt configuration function, preserving whatever existing
# PROMPT_COMMAND might be configured.
PROMPT_COMMAND="__configure_prompt;$PROMPT_COMMAND"

# did
alias did="echo '' >> ~/vimwiki/did.md && vim -c ':$' +'r!date' /Users/smith.bryan/vimwiki/did.md"

# neovim
alias vim=nvim
alias vimplugins="vim /Users/smith.bryan/.config/nvim/init.vim"

# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

## find in file
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

## kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

## find directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

## find all directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

## cd to selected parent directory
fdp() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$DIR"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# Install or open the webpage for the selected application 
# using brew cask search as input source
# and display a info quickview window for the currently marked application
install() {
    local token
    token=$(brew search --casks | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(I)nstall or open the (h)omepage of $token"
        read input
        if [ $input = "i" ] || [ $input = "I" ]; then
            brew cask install $token
        fi
        if [ $input = "h" ] || [ $input = "H" ]; then
            brew cask home $token
        fi
    fi
}

# Uninstall or open the webpage for the selected application 
# using brew list as input source (all brew cask installed applications) 
# and display a info quickview window for the currently marked application
uninstall() {
    local token
    token=$(brew cask list | fzf-tmux --query="$1" +m --preview 'brew cask info {}')

    if [ "x$token" != "x" ]
    then
        echo "(U)ninstall or open the (h)omepage of $token"
        read input
        if [ $input = "u" ] || [ $input = "U" ]; then
            brew cask uninstall $token
        fi
        if [ $input = "h" ] || [ $token = "h" ]; then
            brew cask home $token
        fi
    fi
}

# ripgrep
alias grep=rg

# notes
alias notes='vim /Users/smith.bryan/journal/Notes/notes.md'

# az
alias az-int="az account set -s 605e20ca-dc11-4d58-a0c0-88e996c8954e"
alias az-prod="az account set -s 9c2ed2f1-640d-41b1-acf7-4c750f9c97f1"
alias az-prod-2="az account set -s 93d90205-1541-4c9e-8e83-ce02123bd11e"
alias az-prod-codepush="az account set -s 4bf04ea6-eb29-474d-ad66-4e8efc9fd384"

# k8s
alias k="kubectl"
PROMPT=$PROMPT'$(kube_ps1) '
alias k-core-int="kubectl config use-context core-integration"
alias k-dist-int="kubectl config use-context distribution-integration"
alias k-diag-search-int="kubectl config use-context diag-search-integration"
alias k-diag-int="kubectl config use-context diagnostics-integration"
alias k-onees-int="kubectl config use-context onees-int-disco-east-us"
alias k-core-prod="kubectl config use-context core-prod-east-us2"
alias k-core2-prod="kubectl config use-context core2-prod-east-us"
alias k-dist-prod="kubectl config use-context distribution-prod-east-us2-distrib"
alias k-diag-prod="kubectl config use-context diagnostics-prod-east-us2"
alias k-diag-apple-prod="kubectl config use-context diag-apple-prod-east-us2"
alias k-diag2-apple-prod="kubectl config use-context diag2-apple-prod-east-us-diag"
alias k-diag-search-prod="kubectl config use-context diag-search-prod-east-us2"
alias k-codepush-prod="kubectl config use-context codepush-prod-east-us2-codepush"
alias k-dashboard="~/appcenter/deployment/deployment/Scripts/Bash/open-kubernetes.sh"

# c++
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CPPUTEST_HOME="/usr/local/Cellar/cpputest/3.8"

export PATH="/usr/local/opt/openss/bin:$PATH"

# show and switch to branches interactively
function b() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --layout=reverse) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
