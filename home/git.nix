{ ... }:
{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "matsudan";
        email = "daaamatsun@gmail.com";
      };

      url."ssh://git@github.com/".insteadOf = "https://github.com/";

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autosquash = true;
      rerere.enabled = true;
      diff.colorMoved = "default";
    };

    ignores = [
      ".DS_Store"
      ".idea/"
      ".venv/"
      "*.swp"
    ];
  };

  programs.lazygit.enable = true;
}
