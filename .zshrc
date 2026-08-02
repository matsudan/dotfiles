# Must precede all PATH modifications to dedupe as entries are added
typeset -U path PATH

setopt prompt_subst

# homebrew: sets the base PATH/MANPATH, so keep it before the entries below
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# golang
if [[ $OSTYPE == linux* ]]; then
    path=($path /usr/local/go/bin)
fi

# rust
path=($HOME/.cargo/bin $path)

# user-local binaries (uv, etc.)
path=($HOME/.local/bin $path)

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
    suffix='%f'
    if [[ $1 -eq 0 ]]
    then
        color='%F{cyan}'
        face="ξ*'ﾜ')ξ"
    else
        color='%F{magenta}'
        face="ξ*-~-)ξ"
    fi
    echo ${color}${face}${suffix}
}

function command_not_found_handler {
    # Raw ANSI, not %F: print -P would treat the backtick in the face as
    # command substitution while prompt_subst is set
    local blue=$'\e[34m' red=$'\e[31m' reset=$'\e[0m'
    print -r -- "${blue}ξ*'-\`)ξ${reset} ${red}$0${reset} それは知らないですわぁ"
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
# -G colorizes on BSD ls but means something else on GNU ls
if [[ $OSTYPE == darwin* ]]; then
    alias ll='ls -lG'
else
    alias ll='ls -l --color=auto'
fi
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

autoload -Uz compinit
# Skip the security check when .zcompdump is under 24h old.
# The glob must be an anonymous function argument: [[ ]] does not expand globs.
() {
    if (( $# )); then
        compinit -C
    else
        compinit
    fi
} ${ZDOTDIR:-$HOME}/.zcompdump(Nmh-24)

# Required by the gcloud completion script, which uses bash-style complete
autoload -Uz bashcompinit && bashcompinit

setopt auto_pushd
setopt pushd_ignore_dups

# Set up fzf key bindings and fuzzy completion
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

# op
if (( $+commands[op] )); then
    eval "$(op completion zsh)"; compdef _op op
fi

# gcloud cli
# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
