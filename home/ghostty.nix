{ lib, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;

    # nixpkgs の ghostty は Linux のみ。macOS は設定だけ管理して本体は公式 .app
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    settings = lib.mkMerge [
      {
        theme = "Moonfly";
        font-family = "JetBrains Mono";

        background-opacity = 0.80;
        background-blur = 50;
      }
      (lib.mkIf pkgs.stdenv.isDarwin {
        macos-option-as-alt = true;
      })
    ];

    enableZshIntegration = true;

    # package = null と併用できない（モジュール側の assertion）
    installVimSyntax = false;
    installBatSyntax = false;
  };
}
