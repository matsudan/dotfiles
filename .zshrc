export PATH=$HOME/bin:/usr/local/bin:$PATH

if [ $SHLVL = 1 ]; then
  tmux
fi

# git
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

# goenv
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# golang
export GOPATH="$HOME/ws/golang"

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
NORM="$%F{white}(*'-')$"
MAGAO="$%F{white}('-')$"

PROMPT="%(?.$NORM.$MAGAO)"

# history
# save dest
export HISTFILE=~/.zsh_history

# number of hist
export SAVEHIST=100000

setopt share_history

setopt hist_ignore_dups

setopt EXTENDED_HISTORY

# grobal alias
alias ll='ls -lG'
alias g='git'
alias v='vim'
