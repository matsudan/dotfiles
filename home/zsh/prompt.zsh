# PROMPT は starship が描画 （home/starship.nix）
function command_not_found_handler {
    # Raw ANSI, not %F: print -P would treat the backtick in the face as
    # command substitution while prompt_subst is set
    local blue=$'\e[34m' red=$'\e[31m' reset=$'\e[0m'
    print -r -- "${blue}ξ*'-\`)ξ${reset} ${red}$0${reset} それは知らないですわぁ"
    return 127
}
