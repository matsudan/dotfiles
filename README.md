# dotfiles

## Bootstrap

```shell
mv ~/.gitconfig ~/.gitconfig.bak
nix run home-manager/release-26.05 -- switch --flake .#mac -b backup
exec zsh -l
```

## Apply changes

```shell
home-manager switch --flake .#mac      # macOS (Apple Silicon)
home-manager switch --flake .#linux    # Linux (x86_64)
```

## Update inputs

```shell
nix flake update
home-manager switch --flake .#mac
```

## Rollback

```shell
home-manager generations
/nix/store/<generation>/activate
```
