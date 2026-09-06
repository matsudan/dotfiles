{ pkgs, theme, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = [ pkgs.ruff ];

    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      gitsigns-nvim
      neo-tree-nvim
      nui-nvim
      plenary-nvim
      nvim-web-devicons
      (nvim-treesitter.withPlugins (parsers: [
        parsers.markdown
        parsers.markdown_inline
      ]))
      render-markdown-nvim
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

      require("render-markdown").setup({
        -- ambiwidth=double では既定の Nerd Font サインが幅超過になる
        sign = { enabled = false },
      })

      vim.lsp.enable("ruff")

      local ruff_format_group = vim.api.nvim_create_augroup("ruff_format_on_save", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = ruff_format_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil or client.name ~= "ruff" then
            return
          end

          vim.api.nvim_clear_autocmds({
            group = ruff_format_group,
            event = "BufWritePre",
            buffer = args.buf,
          })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = ruff_format_group,
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({
                bufnr = args.buf,
                async = false,
                filter = function(format_client)
                  return format_client.id == client.id
                end,
              })
            end,
          })
        end,
      })
    '';
  };

  xdg.configFile."nvim/lsp/ruff.lua".text = ''
    return {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
      init_options = {
        settings = {},
      },
    }
  '';
}
