# 配色の単一ソース。flake.nix が extraSpecialArgs で各モジュールへ渡す。
# パレットは tokyonight.nvim の lua/tokyonight/colors/moon.lua に準拠。
#
# テーマを差し替えるときはこのファイルと、home/neovim.nix の
# プラグイン指定および setup 呼び出し（プラグイン固有のため一般化できない）を直す。
{
  ghostty = "TokyoNight Moon";
  nvimColorscheme = "tokyonight-moon";

  palette = {
    bg = "#222436";
    fg = "#c8d3f5";
    fgDark = "#828bb8";
    red = "#ff757f";
    cyan = "#86e1fc";
    blue = "#82aaff";
    blue1 = "#65bcff";
    blue7 = "#394b70";
    dark3 = "#545c7e";
  };
}
