{ config, pkgs, ... }:
{
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/ws/matsudan/dotfiles/home/herdr/config.toml";
}
