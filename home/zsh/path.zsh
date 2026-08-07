# brew shellenv がベースの PATH を張るので以降の追加より先に置く
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

if [[ $OSTYPE == linux* ]]; then
    path=($path /usr/local/go/bin)
fi

path=($HOME/.cargo/bin $path)
path=($HOME/.local/bin $path)

# nix パスは /etc/zshrc が先に入れているが、brew / cargo / local の前置で
# 後ろへ回るので入れ直して最優先にする。
# 逆順に並べているのは最後に前置される user profile を先頭にするため
for _nix_dir in /nix/var/nix/profiles/default/bin $HOME/.nix-profile/bin; do
    [[ -d $_nix_dir ]] && path=($_nix_dir $path)
done
unset _nix_dir
