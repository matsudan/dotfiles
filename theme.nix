# 配色の単一ソース。flake.nix が extraSpecialArgs で各モジュールへ渡す。
# パレットは tokyonight.nvim の lua/tokyonight/colors/ に準拠
# （night.lua は storm.lua を継承して bg 系だけ上書きしている）。
#
# テーマを差し替えるときはこのファイルと、home/neovim.nix の
# プラグイン指定および setup 呼び出し（プラグイン固有のため一般化できない）を直す。
{
  ghostty = "TokyoNight Night";
  nvimColorscheme = "tokyonight-night";

  palette = {
    bg = "#1a1b26";
    fg = "#c0caf5";
    fgDark = "#a9b1d6";
    red = "#f7768e";
    cyan = "#7dcfff";
    blue = "#7aa2f7";
    blue1 = "#2ac3de";
    blue7 = "#394b70";
    dark3 = "#545c7e";
  };
}
