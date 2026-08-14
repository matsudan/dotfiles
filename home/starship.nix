{ lib, ... }:
let
  # Nerd Font のグリフは PUA でエディタや差分表示で壊れやすいためコードポイントから生成
  cp = hex: builtins.fromJSON ''"\u${hex}"'';
  sep = cp "e0b0"; # 右向き三角
  capL = cp "e0b6"; # 左端の丸キャップ
  gitIcon = cp "e0a0"; # git branch

  # TokyoNight Moon のパレット（tokyonight.nvim の lua/tokyonight/colors/moon.lua）
  bg = "#222436";
  fg = "#c8d3f5";
  red = "#ff757f";
  cyan = "#86e1fc";
  blue = "#82aaff";
  blue1 = "#65bcff";
  blue7 = "#394b70";
  dark3 = "#545c7e";
  fgDark = "#828bb8";

  # 左から右へ明るい青→暗い青のグラデーション
  faceBg = cyan;
  faceBgErr = red; # 失敗だけ暖色で目立たせる
  faceFg = bg;
  dirBg = blue;
  dirFg = bg;
  gitBg = dark3;
  gitFg = fg;
  timeBg = blue7;
  timeFg = fg;

  # `)` は starship のフォーマット構文と衝突するのでエスケープが必要
  faceOk = "ξ*'ﾜ'\\)ξ";
  faceErr = "ξ*-~-\\)ξ";
in
{
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;

      format = lib.concatStrings [
        "$character"
        "$directory"
        "$git_branch"
        "$git_status"
        # git_branch / git_status はリポジトリ外で何も描かないため、
        # 境界をモジュール側に置くとセグメントごと消える
        "[${sep}](fg:${gitBg} bg:${timeBg})"
        "$time"
        "$line_break"
        "$cmd_duration"
        "[❯ ](bold ${blue1})"
      ];

      # 終了ステータスで顔文字セグメント差替え
      character = {
        format = "$symbol";
        success_symbol = lib.concatStrings [
          "[${capL}](${faceBg})"
          "[ ${faceOk} ](fg:${faceFg} bg:${faceBg})"
          "[${sep}](fg:${faceBg} bg:${dirBg})"
        ];
        error_symbol = lib.concatStrings [
          "[${capL}](${faceBgErr})"
          "[ ${faceErr} ](fg:${faceFg} bg:${faceBgErr})"
          "[${sep}](fg:${faceBgErr} bg:${dirBg})"
        ];
      };

      directory = {
        style = "fg:${dirFg} bg:${dirBg}";
        format = "[ $path ]($style)[${sep}](fg:${dirBg} bg:${gitBg})";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = true;
      };

      git_branch = {
        symbol = gitIcon;
        style = "fg:${gitFg} bg:${gitBg}";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:${gitFg} bg:${gitBg}";
        format = "([$all_status$ahead_behind ]($style))";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "fg:${timeFg} bg:${timeBg}";
        format = "[ $time ]($style)[${sep}](${timeBg})";
      };

      cmd_duration = {
        min_time = 2000;
        style = "fg:${fgDark}";
        format = "[took $duration ]($style)";
      };
    };
  };
}
