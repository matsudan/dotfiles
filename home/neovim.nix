{
  lib,
  pkgs,
  theme,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = [
      pkgs.ruff
      pkgs.ripgrep
    ];

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      gitsigns-nvim
      neo-tree-nvim
      nui-nvim
      plenary-nvim
      nvim-web-devicons
      fzf-lua
      lualine-nvim
      (nvim-treesitter.withPlugins (parsers: [
        parsers.markdown
        parsers.markdown_inline
      ]))
      render-markdown-nvim
    ];

    initLua = ''
      vim.opt.termguicolors = true

      local p = ${lib.generators.toLua { } theme.palette}
      local blend = require("catppuccin.utils.colors").blend
      -- 灰色の段階は mocha と同じ比率で作る
      local function gray(alpha)
        return blend(p.fg, p.bg, alpha)
      end

      require("catppuccin").setup({
        -- Ghostty の background-opacity を通す
        transparent_background = true,
        float = { transparent = true },
        term_colors = true,
        color_overrides = {
          all = {
            rosewater = p.fgDark,
            flamingo = p.red,
            pink = p.magenta,
            mauve = p.magenta,
            red = p.red,
            maroon = p.red,
            peach = p.orange,
            yellow = p.yellow,
            green = p.green,
            teal = p.cyan,
            sky = p.cyan,
            sapphire = p.cyan,
            blue = p.blue,
            lavender = p.blue,

            text = p.fg,
            subtext1 = gray(0.89),
            subtext0 = gray(0.78),
            overlay2 = gray(0.67),
            overlay1 = gray(0.55),
            overlay0 = gray(0.45),
            surface2 = gray(0.33),
            surface1 = gray(0.22),
            surface0 = gray(0.11),
            base = p.bg,
            mantle = blend(p.bg, "#000000", 0.8),
            crust = blend(p.bg, "#000000", 0.57),
          },
        },
      })
      vim.cmd.colorscheme("${theme.nvimColorscheme}")

      require("lualine").setup()

      require("fzf-lua").setup()

      -- herdr の prefix が ctrl+b なので、<C-b> などは使わず <leader> 起点にする
      vim.g.mapleader = " "
      vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find files" })
      vim.keymap.set("n", "<leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fg", "<Cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fr", "<Cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })

      require("neo-tree").setup({
        filesystem = {
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
            hide_ignored = false,
          },
        },
      })

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
