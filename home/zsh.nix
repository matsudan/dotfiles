{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    # 生成先は ~/.zshrc と ~/.zshenv。
    # ~/.zshenv は hm-session-vars.sh を store から直接 source するので、
    # 旧 .zshrc にあった手書きの読み込みブロックは不要になった。
    # 既存の ~/.zshenv（rustup が作った ~/.cargo/env を読む1行）は
    # 上書きされる。中身は下の path.zsh の cargo 行と重複しているので破棄可。

    history = {
      size = 100000;
      save = 100000;
      append = true;
      share = true; # share_history
      ignoreDups = true; # hist_ignore_dups
      extended = true; # extended_history
    };

    setOptions = [
      "prompt_subst"
      "auto_pushd"
      "pushd_ignore_dups"
    ];

    # 既定は `autoload -U compinit && compinit`。
    # .zcompdump が 24 時間以内なら security check を省く旧設定を維持する。
    completionInit = ''
      autoload -Uz compinit
      # glob は匿名関数の引数として渡す必要がある: [[ ]] は glob を展開しない
      () {
          if (( $# )); then
              compinit -C
          else
              compinit
          fi
      } ''${ZDOTDIR:-$HOME}/.zcompdump(Nmh-24)
    '';

    # zsh 固有のエイリアス。シェル共通のものは home.shellAliases 側にある。
    shellAliases = {
      sz = "source ~/.zshrc";
    };

    initContent = lib.mkMerge [
      # 510 typeset -U / 520 NIX_PROFILES fpath の後、570 compinit の前
      (lib.mkOrder 550 (builtins.readFile ./zsh/path.zsh))
      # 950 setOptions, 910 fzf/history の後
      (lib.mkOrder 1000 (builtins.readFile ./zsh/prompt.zsh))
      (lib.mkOrder 1050 (builtins.readFile ./zsh/tools.zsh))
    ];
  };

  # programs.{bash,zsh,fish,nushell}.shellAliases へ展開されるので、
  # Linux で bash を使う場合もこの定義がそのまま効く。
  home.shellAliases = {
    # -G は BSD ls では色付け、GNU ls では別の意味になる
    ll = if pkgs.stdenv.isDarwin then "ls -lG" else "ls -l --color=auto";
    v = "vim";

    # docker
    d = "docker";
    dsp = "docker system prune";
    dvp = "docker volume prune";
    dc = "docker compose";
    dcu = "docker compose up";
    dcd = "docker compose down";

    # git
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

    # terraform
    tf = "terraform";
  };
}
