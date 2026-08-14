{ lib, ... }:
let
  # Nerd Font のグリフは PUA でエディタや差分表示で壊れやすいためコードポイントから生成
  cp = hex: builtins.fromJSON ''"\u${hex}"'';
  sep = cp "e0b0"; # 右向き三角
  capL = cp "e0b6"; # 左端の丸キャップ
  gitIcon = cp "e0a0"; # git branch

  # moonfly のパレット
  black = "#080808";
  grey89 = "#e4e4e4";
  crimson = "#ff5189";
  coral = "#f09479";
  khaki = "#c6c684";
  turquoise = "#79dac8";
  blue = "#80a0ff";
  violet = "#cf87e8";
  bay = "#4d5d8d";

  faceBg = turquoise;
  faceBgErr = crimson;
  faceFg = black;
  dirBg = violet;
  dirFg = black;
  gitBg = coral;
  gitFg = black;
  timeBg = bay;
  timeFg = grey89;

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
        "[❯ ](bold ${blue})"
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
        style = "fg:${khaki}";
        format = "[took $duration ]($style)";
      };
    };
  };
}
