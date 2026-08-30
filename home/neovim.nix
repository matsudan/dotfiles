{ pkgs, theme, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      gitsigns-nvim
    ];

    initLua = ''
      vim.opt.termguicolors = true

      -- transparent = true で背景色を設定させず Ghostty の background-opacity を通す
      require("tokyonight").setup({
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
      vim.cmd.colorscheme("${theme.nvimColorscheme}")

      vim.opt.fileencoding = "utf-8"
      vim.opt.ambiwidth = "double"

      -- インデント
      vim.opt.expandtab = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.smartindent = true

      -- 検索
      vim.opt.ignorecase = true
      vim.opt.smartcase = true

      -- 表示
      vim.opt.number = true
      vim.opt.cursorline = true
      vim.opt.showmatch = true

      vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"

      -- Esc Esc でハイライト解除
      vim.keymap.set("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { silent = true })

      -- 折り返し行を見た目どおりに移動
      vim.keymap.set("n", "j", "gj")
      vim.keymap.set("n", "k", "gk")
      vim.keymap.set("n", "<Down>", "gj")
      vim.keymap.set("n", "<Up>", "gk")

      vim.opt.signcolumn = "yes"

      -- git の変更をサインカラムにバー表示
      require("gitsigns").setup({
        signs = {
          add          = { text = "│" },
          change       = { text = "│" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
          untracked    = { text = "┆" },
        },
        current_line_blame = true,
      })
    '';
  };
}
