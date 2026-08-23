-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.breakindent = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.undofile = true
vim.o.swapfile = false
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

local set_key = vim.keymap.set

-- Keymaps for better default experience
set_key({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Quick write and close
set_key("n", "<leader>w", ":write<CR>")
set_key("n", "<leader>q", ":quit<CR>")

-- Remap for dealing with word wrap
set_key("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set_key("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for jumping to start and end of lines
set_key({ "n", "v" }, "H", "^")
set_key({ "n", "v" }, "L", "$")

-- Remap for select all
set_key("n", "<C-a>", "gg<S-v>G")

-- Remap for splitting buffers
set_key("n", "ss", ":sp<Return>")
set_key("n", "sv", ":vsp<Return>")

-- Remap for split navigation
set_key("n", "<C-h>", "<C-w><C-h>", { noremap = false })
set_key("n", "<C-j>", "<C-w><C-j>", { noremap = false })
set_key("n", "<C-k>", "<C-w><C-k>", { noremap = false })
set_key("n", "<C-l>", "<C-w><C-l>", { noremap = false })

-- Remap for tab navigation
set_key("n", "<leader>h", "gT")
set_key("n", "<leader>l", "gt")

-- Remap for copying to system clipboard
set_key("v", "<leader>y", '"+y')
set_key("n", "<leader>y", '"+y')
set_key("n", "<leader>d", '"+d')

-- Command to format with LSP
set_key("n", "<leader>f", vim.lsp.buf.format, { desc = "Format file" })

-- Diagnostic keymaps
set_key("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = "Go to previous diagnostic message" })
set_key("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = "Go to next diagnostic message" })
set_key("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Automatically reload files if they change on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "rebelot/kanagawa.nvim",
      config = function()
        vim.cmd("colorscheme kanagawa")
      end,
    },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {},
    },
    {
      "saghen/blink.cmp",
      version = "1.*",
      dependencies = { "folke/lazydev.nvim" },
      opts = {
        keymap = {
          preset = "default",
          ["<CR>"] = {
            "accept",
            function()
              return require("mini.pairs").cr()
            end,
            "fallback",
          },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
          ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "lazydev" },
          providers = {
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
          },
        },
        completion = { documentation = { auto_show = true } },
      },
    },
    {
      "williamboman/mason.nvim",
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "clangd",
          "pyright",
          "rust_analyzer",
          "ts_ls",
          "lua_ls",
          "docker_compose_language_service",
          "dockerls",
          "jsonls",
        },
      },
      dependencies = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
      },
    },
    {
      "neovim/nvim-lspconfig",
      lazy = false,
      dependencies = { "j-hui/fidget.nvim", "saghen/blink.cmp" },
      config = function()
        vim.lsp.config("*", {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        -- Per-server settings
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })

        -- Apply capabilities and inlay hints to every server that attaches
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

            local nmap = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
            end

            nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            nmap("K", vim.lsp.buf.hover, "Hover Documentation")
            nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          end,
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
          cond = function()
            return vim.fn.executable("make") == 1
          end,
        },
        "nvim-telescope/telescope-file-browser.nvim",
      },
      config = function()
        require("telescope").setup({
          defaults = {
            mappings = {
              i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
              },
            },
          },
          file_ignore_patterns = {
            -- "test",
            -- "%.test%.",
            -- "%.spec%.",
            -- "__tests__",
          },
          extensions = {
            file_browser = {
              grouped = true,
              hidden = { file_browser = true },
              hijack_netrw = true,
              initial_mode = "normal",
            },
          },
        })
        pcall(require("telescope").load_extension, "fzf")
        pcall(require("telescope").load_extension, "file_browser")

        vim.keymap.set(
          "n",
          "<leader>?",
          require("telescope.builtin").oldfiles,
          { desc = "[?] Find recently opened files" }
        )
        vim.keymap.set(
          "n",
          "<leader><space>",
          require("telescope.builtin").buffers,
          { desc = "[ ] Find existing buffers" }
        )
        vim.keymap.set("n", "<leader>/", function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end, { desc = "[/] Fuzzily search in current buffer]" })

        vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set(
          "n",
          "<leader>sw",
          require("telescope.builtin").grep_string,
          { desc = "[S]earch current [W]ord" }
        )
        vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set(
          "n",
          "<leader>fb",
          require("telescope").extensions.file_browser.file_browser,
          { desc = "[F]ile [B]rowser" }
        )
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      lazy = false,
      config = function()
        require("nvim-treesitter").setup()
        require("nvim-treesitter").install({ "c", "cpp", "python", "typescript", "rust", "lua" })
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(args)
            pcall(vim.treesitter.start, args.buf)
          end,
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      lazy = false,
      config = function()
        require("nvim-treesitter-textobjects").setup({
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>a"] = "@parameter.inner" },
            swap_previous = { ["<leader>A"] = "@parameter.inner" },
          },
        })
      end,
    },
    {
      "akinsho/bufferline.nvim",
      dependencies = "nvim-tree/nvim-web-devicons",
      event = "VimEnter",
      opts = {
        options = {
          separator_style = "slant",
          diagnostics = "nvim_lsp",
        },
      },
    },
    { "gbprod/cutlass.nvim", event = "BufReadPre", opts = { cut_key = "x" } },
    {
      "jedrzejboczar/possession.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cmd = { "SSave", "SLoad", "SDelete", "SList" },
      opts = {
        commands = {
          save = "SSave",
          load = "SLoad",
          delete = "SDelete",
          list = "SList",
        },
      },
    },
    { "echasnovski/mini.pairs", lazy = false, opts = {} },
    {
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      opts = {
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 500 },
      },
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      event = "VimEnter",
      opts = { indent = { char = "┊" } },
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VimEnter",
      opts = {
        options = {
          icons_enabled = false,
          theme = "kanagawa",
          component_separators = "|",
          section_separators = "",
        },
      },
    },
    { "tpope/vim-sleuth", event = "BufReadPre" },
    { "tpope/vim-surround", event = "BufReadPre" },
  },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true, notify = false },
})
