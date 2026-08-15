{ lib, pkgs, theme, ... }:
{
  programs.ghostty = {
    enable = true;

    # nixpkgs の ghostty は Linux のみ。macOS は設定だけ管理して本体は公式 .app
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    settings = lib.mkMerge [
      {
        theme = theme.ghostty;
        font-family = "JetBrains Mono";
        font-size = 14;

        adjust-cell-height = 5;

        background-opacity = 0.88;
        background-blur = 50;

        window-padding-x = 10;
        window-padding-y = 10;
        window-padding-balance = true;
      }
      (lib.mkIf pkgs.stdenv.isDarwin {
        macos-option-as-alt = true;
        macos-titlebar-style = "transparent";
      })
    ];
  };
}
