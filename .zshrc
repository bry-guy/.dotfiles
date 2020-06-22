HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -v
zstyle :compinstall filename '/home/brain/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

## History search using text behind cursor
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

## Match case-insensitive 
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 

# Theming
## Prompt
git_branch() {
	git symbolic-ref --short HEAD 2> /dev/null
}

setopt prompt_subst
PROMPT='%{%F{6}%}$(git_branch)%{%F{none}%} > '

## Title Bar
case ${TERM} in
 alacritty)
	  precmd () {print -Pn "\e]0;$USER@$HOST:$(dirs)\a"}
          ;;
esac

# PATH and ENV variables 
## dotnet
export PATH="/usr/local/share/dotnet:$PATH"
export PATH="/Library/Frameworks/Mono.framework/Versions/Current/Commands:$PATH"

## brew
export PATH="/usr/local/bin:$PATH"

## aws
export PATH="$HOME/Library/Python/3.7/bin:$PATH"

## azcopy
export PATH="/usr/local/bin/azcopy:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk

## Neovim
export EDITOR=/usr/local/bin/nvim
export VISUAL=/usr/local/bin/nvim

## FZF settings
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# c++
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export CPPUTEST_HOME="/usr/local/Cellar/cpputest/3.8"

export PATH="/usr/local/opt/openss/bin:$PATH"

# Sources
## Node/NVM/NPM etc
source /usr/share/nvm/init-nvm.sh

## TODO: Move aliases to `.aliases`
source $HOME/.aliases

# Aliases
alias vim='nvim'
alias grep='rg'
alias ls='ls --color=auto'
alias g='git'

# notes
alias notes='vim /Users/smith.bryan/journal/Notes/notes.md'

## WORK
# az
alias az-int="az account set -s 605e20ca-dc11-4d58-a0c0-88e996c8954e"
alias az-prod="az account set -s 9c2ed2f1-640d-41b1-acf7-4c750f9c97f1"
alias az-prod-2="az account set -s 93d90205-1541-4c9e-8e83-ce02123bd11e"
alias az-prod-codepush="az account set -s 4bf04ea6-eb29-474d-ad66-4e8efc9fd384"

# k8s
PROMPT=$PROMPT'$(kube_ps1) '
alias k="kubectl"
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
