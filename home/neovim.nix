{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
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
      vim.cmd.colorscheme("tokyonight-moon")

      vim.opt.fileencoding = "utf-8"
      vim.opt.ambiwidth = "double"

      -- インデント
      vim.opt.expandtab = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.autoindent = true
      vim.opt.smartindent = true

      -- 検索
      vim.opt.incsearch = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true

      -- 表示
      vim.opt.number = true
      vim.opt.cursorline = true
      vim.opt.showmatch = true
      vim.opt.laststatus = 2
      vim.opt.wildmenu = true

      vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"
      vim.opt.backspace = "indent,eol,start"
      vim.opt.hidden = true
      vim.opt.history = 5000
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"

      -- Esc Esc でハイライト解除
      vim.keymap.set("n", "<Esc><Esc>", "<Cmd>nohlsearch<CR>", { silent = true })

      -- 折り返し行を見た目どおりに移動
      vim.keymap.set("n", "j", "gj")
      vim.keymap.set("n", "k", "gk")
      vim.keymap.set("n", "<Down>", "gj")
      vim.keymap.set("n", "<Up>", "gk")
    '';
  };
}
