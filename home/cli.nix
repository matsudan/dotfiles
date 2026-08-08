{ config, pkgs, ... }:
{
  home.packages = [
    # nix 版は component updater が無効。追加するときはここに書いて switch
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gcloud-crc32c
    ])

    pkgs.herdr
  ];

  # herdr 自身が config.toml を書き換えるため store へのリンクにできない。
  # リポジトリの絶対パスを焼き込んでいるので clone 先を変えたら修正
  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/ws/matsudan/dotfiles/home/herdr/config.toml";

  programs.jq.enable = true;

  programs.fd.enable = true;

  programs.fzf = {
    enable = true;
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.lazygit.enable = true;

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

  programs.awscli.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.uv = {
    enable = true;
    settings = {
      python-preference = "managed";
    };
  };
}
