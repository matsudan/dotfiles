# プロンプト。home-manager の initContent で order 1000 に置かれる。
# prompt_subst は programs.zsh.setOptions (order 950) で有効化済み。

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

COLOR_DEF=$'%f'
COLOR_GIT=$'%F{39}'

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
