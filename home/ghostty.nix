{ lib, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;

    # nixpkgs の ghostty は meta.platforms が Linux のみ
    # aarch64-darwin では meta.available = false
    # macOS では package = null にして設定だけを管理し本体は.appを利用
    # Linux では nixpkgs から入れる。
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    settings = lib.mkMerge [
      {
        theme = "Moonfly";
        font-family = "JetBrains Mono";

        background-opacity = 0.90;
        background-blur = 50;
      }
      (lib.mkIf pkgs.stdenv.isDarwin {
        macos-option-as-alt = true;
      })
    ];

    enableZshIntegration = true;

    # 以下は package = null と併用できない（モジュール側の assertion）。
    # macOSは .app を使うので無効
    installVimSyntax = false;
    installBatSyntax = false;
  };
}
