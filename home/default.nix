{ pkgs, username, ... }:
{
  imports = [
    ./ghostty.nix
    ./git.nix
    ./herdr.nix
    ./neovim.nix
    ./starship.nix
    ./tools.nix
    ./yazi.nix
    ./zsh.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    PAGER = "less";
    LESS = "-FRX";
  };
}
