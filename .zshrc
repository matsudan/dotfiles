export PATH=$HOME/bin:/usr/local/bin:$PATH

# if [ $SHLVL = 1 ]; then
#   tmux
# fi

# git
export PATH="/usr/local/bin:${PATH}"
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'

# nvm
if [[ -s $HOME/.nvm/nvm.sh ]];
then source $HOME/.nvm/nvm.sh; fi

# golang
export GOPATH="$HOME/go"

# rust
export PATH=$HOME/.cargo/bin:$PATH

# embulk
export PATH="$HOME/.embulk/bin:$PATH"

# stack
export PATH=~/.local/bin:$PATH

# gnu-getopt
export PATH=/usr/local/opt/gnu-getopt/bin:$PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# saml2aws
export PATH="$GOPATH/bin:$PATH"

function s2a(){
    saml2aws login --skip-prompt --profile=$@
    eval $(saml2aws script --profile=$@)
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

# color
autoload -U colors; colors

# prompt setting
PROMPT=$'`command_status_check $?`:$ '

function command_status_check {
    local color face suffix
    suffix='%{'${reset_color}'%}'
    if [ $1 = 0 ]
    then
        color='%{'${fg[cyan]}'%}'
        face="ξ*'ワ')ξ"
    else
        color='%{'${fg[magenta]}'%}'
        face="ξ*-~-)ξ"
    fi
    echo ${color}${face}${suffix}
}

function command_not_found_handler {
    echo "${fg[blue]}ξ*'-\`)ξ$reset_color ${fg[red]}$0$reset_color それは知らないですわぁ"
    return 127
}

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt share_history
setopt hist_ignore_dups
setopt extended_history

# alias
alias ll='ls -lG'
alias v='vim'

## docker
alias d='docker'
alias dsp='docker system prune'
alias dvp='docker volume prune'
alias dc='docker compose'
alias dcu='docker compose up'

## git
alias g='git'
alias gst='git status'
alias ga='git add'
alias gcom='git commit -m'
alias gph='git push origin HEAD'
alias gsw='git switch'
alias gswc='git switch -c'
alias gpl='git pull'
alias gdi='git diff --color'
alias gds='git diff --color --staged'
alias glgg='git log --color --graph --decorate --oneline'
alias glgs='git log --stat --color'

## zsh
alias vz='vim ~/dotfiles/.zshrc'
alias rz='rm ~/.zshrc && sh ~/dotfiles/setup.sh'
alias sz='source ~/.zshrc'

autoload -U compinit
compinit
autoload bashcompinit && bashcompinit
source ~/.bash_completion.d/breeze-complete

setopt auto_pushd
setopt pushd_ignore_dups

# Starship
# eval "$(starship init zsh)"

# peco
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

typeset -U PATH
