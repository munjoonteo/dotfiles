-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.blamer_enabled = true
vim.o.breakindent = true
vim.o.completeopt = "menuone,noselect"
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
set_key("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
set_key("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
set_key("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
set_key("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })


-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
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
      "folke/neodev.nvim",
      lazy = false,
      config = function()
        require("neodev").setup()
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
          },
        })
      end
    },
    {
      "neovim/nvim-lspconfig",
      event = "BufReadPre",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
      },
      config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason").setup()

        local servers = {
          clangd = {},
          pyright = {},
          rust_analyzer = {},
          ts_ls = {},
          lua_ls = {
            settings = {
              Lua = {
                runtime = {
                  version = "LuaJIT",
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          },
          docker_compose_language_service = {},
          dockerls = {},
          jsonls = {},
        }

        require("mason-lspconfig").setup({
          ensure_installed = vim.tbl_keys(servers),
          handlers = {
            function(server_name)
              require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                settings = servers[server_name],
              })
            end,
          }
        })

        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { desc = desc })
        end

        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
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

        vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles,
          { desc = "[?] Find recently opened files" })
        vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers,
          { desc = "[ ] Find existing buffers" })
        vim.keymap.set("n", "<leader>/", function()
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end, { desc = "[/] Fuzzily search in current buffer]" })

        vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
        vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
        vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
        vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
        vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
        vim.keymap.set("n", "<leader>fb", require("telescope").extensions.file_browser.file_browser,
          { desc = "[F]ile [B]rowser" })
      end
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "c", "cpp", "python", "typescript", "rust", "lua" },
          highlight = { enable = true },
          indent = { enable = true, disable = { "python" } },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "<c-space>",
              node_incremental = "<c-space>",
              scope_incremental = "<c-s>",
              node_decremental = "<c-backspace>",
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
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
              set_jumps = true, -- Whether to set jumps in the jumplist
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
              swap_next = {
                ["<leader>a"] = "@parameter.inner",
              },
              swap_previous = {
                ["<leader>A"] = "@parameter.inner",
              }
            },
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
    { "apzelos/blamer.nvim", event = "BufReadPre" },
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
    { "jiangmiao/auto-pairs", event = "InsertEnter" },
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
      }
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "VimEnter", opts = { indent = { char = "┊" } } },
    { "numToStr/Comment.nvim", keys = { "gc", "gcc" }, opts = {} },
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
        }
      }
    },
    { "tpope/vim-sleuth", event = "BufReadPre" },
    { "tpope/vim-surround", event = "BufReadPre" }
  },
  install = { colorscheme = { "kanagawa" } },
  checker = { enabled = true, notify = false },
})
