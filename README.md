# dotfiles

## setup

```shell
# 初回のみ
home-manager switch --flake .#mac      # macOS (Apple Silicon)
home-manager switch --flake .#linux    # Linux (x86_64)

./setup.sh                             # .vimrc リンク
```

home-manager 未導入の場合

```shell
nix run home-manager/release-26.05 -- switch --flake .#mac -b backup
```

## 更新

```shell
nix flake update
home-manager switch --flake .#mac
```
