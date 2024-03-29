export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH="/usr/local/bin:${PATH}"
setopt prompt_subst

# homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# golang
case `uname` in
  Linux)
    export PATH=$PATH:/usr/local/go/bin
  ;;
esac

# rust
export PATH=$HOME/.cargo/bin:$PATH

# stack
export PATH=~/.local/bin:$PATH

# gnu-getopt
export PATH=/usr/local/opt/gnu-getopt/bin:$PATH

# rye
source "$HOME/.rye/env"

# saml2aws
eval "$(saml2aws --completion-script-zsh)"
# alias s2a="function(){eval $( $(command saml2aws) script --shell=bash --profile=$@);}"

# color
autoload -U colors; colors

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

COLOR_DEF=$'%f'
COLOR_GIT=$'%F{39}'

# prompt setting
local p_cdir="%B%F{cyan}[%(5~|.../%2~|%~)]%f%b"
PROMPT=$p_cdir$'`command_status_check $?`${COLOR_GIT}$(parse_git_branch)${COLOR_DEF} $ '

function command_status_check {
    local color face suffix
    suffix='%{'${reset_color}'%}'
    if [ $1 = 0 ]
    then
        color='%{'${fg[cyan]}'%}'
        face="ξ*'ﾜ')ξ"
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
alias dcd='docker compose down'

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
alias grb='git rebase'
alias grs='git reset'
alias gss='git stash save'
alias gsl='git stash list'
alias gsa='git stash apply'

## terraform
alias tf='terraform'

## zsh
alias sz='source ~/.zshrc'

autoload -U compinit
compinit
autoload bashcompinit && bashcompinit

setopt auto_pushd
setopt pushd_ignore_dups

# peco
function peco-history-selection() {
    BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-history-selection
bindkey '^r' peco-history-selection

typeset -U PATH

# op
eval "$(op completion zsh)"; compdef _op op

# gcloud cli
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/matsuda/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/matsuda/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/matsuda/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/matsuda/google-cloud-sdk/completion.zsh.inc'; fi
