# PATH 構築。home-manager の initContent で order 550 に置かれる。
#   510: typeset -U path cdpath fpath manpath  (home-manager)
#   520: NIX_PROFILES を走査して fpath へ追加   (home-manager)
#   550: path.zsh
#   570: compinit
# したがって dedupe は既に有効になっている前提で書ける。

# homebrew: ベースの PATH/MANPATH を張るので以降の追加より先に置く
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

# user-local binaries
path=($HOME/.local/bin $path)

# nix / home-manager
# /etc/zshrc が nix-daemon.sh 経由で nix プロファイルを入れるが、上の
# `brew shellenv` がその後に homebrew を前置して勝ってしまう。ここで
# 入れ直して、home-manager へ移したツールが brew 版より優先されるようにする。
# 逆順に並べてあるので、最後に前置される user profile が先頭に来る。
# 重複は 510 の typeset -U が排除。
for _nix_dir in /nix/var/nix/profiles/default/bin $HOME/.nix-profile/bin; do
    [[ -d $_nix_dir ]] && path=($_nix_dir $path)
done
unset _nix_dir
