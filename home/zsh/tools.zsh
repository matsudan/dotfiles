# gcloud の補完が bash 形式の complete を使う
autoload -Uz bashcompinit && bashcompinit

if (( $+commands[op] )); then
    eval "$(op completion zsh)"; compdef _op op
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PROMPT は starship が描画する（home/starship.nix）
function command_not_found_handler {
    # Raw ANSI, not %F: print -P would treat the backtick in the face as
    # command substitution while prompt_subst is set
    local blue=$'\e[34m' red=$'\e[31m' reset=$'\e[0m'
    print -r -- "${blue}ξ*'-\`)ξ${reset} ${red}$0${reset} それは知らないですわぁ"
    return 127
}
