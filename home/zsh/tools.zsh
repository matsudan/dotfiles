# gcloud の補完が bash 形式の complete を使う
autoload -Uz bashcompinit && bashcompinit

if (( $+commands[op] )); then
    eval "$(op completion zsh)"; compdef _op op
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
