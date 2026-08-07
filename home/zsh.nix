{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    history = {
      size = 100000;
      save = 100000;
      append = true;
      share = true;
      ignoreDups = true;
      extended = true;
    };

    setOptions = [
      "prompt_subst"
      "auto_pushd"
      "pushd_ignore_dups"
    ];

    # .zcompdump が 24 時間以内なら security check を省く
    completionInit = ''
      autoload -Uz compinit
      # glob は匿名関数の引数として渡す: [[ ]] は glob を展開しない
      () {
          if (( $# )); then
              compinit -C
          else
              compinit
          fi
      } ''${ZDOTDIR:-$HOME}/.zcompdump(Nmh-24)
    '';

    shellAliases = {
      sz = "source ~/.zshrc";
    };

    # 数字は initContent 内での順序。510 typeset -U / 520 fpath / 570 compinit
    initContent = lib.mkMerge [
      (lib.mkOrder 550 (builtins.readFile ./zsh/path.zsh))
      (lib.mkOrder 1000 (builtins.readFile ./zsh/prompt.zsh))
      (lib.mkOrder 1050 (builtins.readFile ./zsh/tools.zsh))
    ];
  };

  # bash / fish 側にも展開される
  home.shellAliases = {
    # -G は BSD ls では色付け、GNU ls では別の意味
    ll = if pkgs.stdenv.isDarwin then "ls -lG" else "ls -l --color=auto";
    v = "vim";

    d = "docker";
    dsp = "docker system prune";
    dvp = "docker volume prune";
    dc = "docker compose";
    dcu = "docker compose up";
    dcd = "docker compose down";

    g = "git";
    gst = "git status";
    ga = "git add";
    gcom = "git commit -m";
    gph = "git push origin HEAD";
    gsw = "git switch";
    gswc = "git switch -c";
    gpl = "git pull";
    gdi = "git diff --color";
    glgg = "git log --color --graph --decorate --oneline";
    glgs = "git log --stat --color";
    grb = "git rebase";
    grs = "git reset";
    gsp = "git stash push";
    gsl = "git stash list";
    gsa = "git stash apply";

    tf = "terraform";
  };
}
