# nix 管理外のツール連携。home-manager の initContent で order 1050 に置かれる。
# compinit (570) の後なので compdef が使える。
# fzf は programs.fzf.enableZshIntegration が order 910 に出すのでここには無い。
# gcloud の補完は order 520 が NIX_PROFILES の site-functions を fpath へ
# 入れるため、_gcloud が自動で見つかる。

# gcloud の補完スクリプトは bash 形式の `complete` を使う。スクリプト自身も
# bashcompinit を呼ぶが、他の bash 形式の補完がここでの設定に依存しうる。
autoload -Uz bashcompinit && bashcompinit

# 1Password CLI
if (( $+commands[op] )); then
    eval "$(op completion zsh)"; compdef _op op
fi

# nvm (プロジェクトごとの node バージョン管理なので nix へは移していない)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
