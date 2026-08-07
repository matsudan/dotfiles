{ config, pkgs, ... }:
{
  # ---- google-cloud-sdk ------------------------------------------------
  # nix パッケージは component updater を無効化
  #       ("disable_updater": true / disable_update_check = true)。
  #       `gcloud components install` は使えないので、コンポーネントを
  #       増やすときはこのリストに足して switch
  home.packages = [
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gcloud-crc32c
    ])

    # ---- herdr ---------------------------------------------------------
    pkgs.herdr
  ];

  # herdr の設定: ~/.config/herdr/config.toml
  #
  # mkOutOfStoreSymlink で作業ツリーの実ファイルへリンク。
  # herdr による修正内容はリポジトリのファイルに反映されるので git diff で確認してコミット。switch 不要。
  #
  # リポジトリの絶対パス。clone 先を変える場合や Linux 側でパスが違う場合はパス修正必要
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/ws/matsudan/dotfiles/home/herdr/config.toml";

  # ---- jq --------------------------------------------------------------
  programs.jq.enable = true;

  # ---- fd --------------------------------------------------------------
  programs.fd.enable = true;

  # ---- fzf -------------------------------------------------------------
  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # ---- gh --------------------------------------------------------------
  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view --web";
        prc = "pr create --fill";
      };
    };
  };

  # ---- awscli ----------------------------------------------------------
  programs.awscli.enable = true;

  # ---- direnv ----------------------------------------------------------
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
    silent = true;
  };

  # ---- uv --------------------------------------------------------------
  programs.uv = {
    enable = true;
    settings = {
      python-preference = "managed";
    };
  };
}
