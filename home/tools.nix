{ pkgs, ... }:
{
  home.packages = [
    # nix 版は component updater が無効。追加するときはここに書いて switch
    (pkgs.google-cloud-sdk.withExtraComponents [
      pkgs.google-cloud-sdk.components.gcloud-crc32c
    ])
  ];

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
