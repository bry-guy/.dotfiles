# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/brain/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

# Options

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

# Aliases
alias vim='nvim'
alias grep='rg'
alias ls='ls --color=auto'
alias g='git'

# FZF settings
export FZF_DEFAULT_COMMAND='rg --hidden --files'

# Node/NVM/NPM etc
source /usr/share/nvm/init-nvm.sh
