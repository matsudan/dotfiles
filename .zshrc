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
zstyle ':vcs_info:git:*' formats '%b'

# nvm
if [[ -s /Users/hj3249/.nvm/nvm.sh ]];
then source /Users/hj3249/.nvm/nvm.sh; fi

# golang
export GOPATH="$HOME/ws/golang"

# rust
export PATH=$HOME/.cargo/bin:$PATH

# embulk
export PATH="$HOME/.embulk/bin:$PATH"

# stack
export PATH=~/.local/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hj3249/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hj3249/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hj3249/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hj3249/google-cloud-sdk/completion.zsh.inc'; fi

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
# save dest
export HISTFILE=~/.zsh_history

# number of hist
export SAVEHIST=100000

setopt share_history

setopt hist_ignore_dups

setopt EXTENDED_HISTORY

# global alias
alias sz='source ~/.zshrc'
alias ll='ls -lG'
alias v='vim'

## git
alias g='git'
alias gst='git status'
alias ga='git add'
alias gcom='git commit -m'
alias gph='git push origin HEAD'
alias gsw='git switch'
alias gswc='git switch -c'
alias gpl='git pull'

## xmd
alias xmd='xmd_darwin_amd64'
