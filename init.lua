vim.o.breakindent = true
vim.o.completeopt = 'menuone,noselect'
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = 'a'
vim.o.swapfile = false
vim.o.undofile = true

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.o.winborder = 'rounded'
vim.o.termguicolors = true

vim.g.blamer_enabled = true

--  Setting leader must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local set_key = vim.keymap.set

-- Better default experience
set_key({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Quick write and close
set_key('n', '<leader>w', ':write<CR>')
set_key('n', '<leader>q', ':quit<CR>')

-- Dealing with word wrap
set_key('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set_key('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Jumping to start and end of lines
set_key({ 'n', 'v' }, 'H', '^')
set_key({ 'n', 'v' }, 'L', '$')

-- Select all
set_key('n', '<C-a>', 'gg<S-v>G')

-- Splitting buffers
set_key('n', 'ss', ':sp<Return>')
set_key('n', 'sv', ':vsp<Return>')

-- Split navigation
set_key('n', '<C-h>', '<C-w><C-h>', { noremap = false })
set_key('n', '<C-j>', '<C-w><C-j>', { noremap = false })
set_key('n', '<C-k>', '<C-w><C-k>', { noremap = false })
set_key('n', '<C-l>', '<C-w><C-l>', { noremap = false })

-- Tab navigation
set_key('n', '<leader>h', 'gT')
set_key('n', '<leader>l', 'gt')

-- Copying to system clipboard
set_key('v', '<leader>y', '"*y')
set_key('n', '<leader>y', '"*y')
set_key('n', '<leader>d', '"*d')

-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Automatically reload files if they change on disk
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Core dependencies
vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    { src = 'https://github.com/nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons' },
})

vim.pack.add({
  { src = 'https://github.com/rebelot/kanagawa.nvim' },                             -- Theme
  { src = 'https://github.com/akinsho/bufferline.nvim' },                           -- Pretty tabs in buffer line
  { src = 'https://github.com/apzelos/blamer.nvim' },                               -- git blame
  { src = 'https://github.com/gbprod/cutlass.nvim' },                               -- Change d to delete and add cut functionality
  { src = 'https://github.com/hrsh7th/nvim-cmp' },                                  -- Autocompletion
  { src = 'https://github.com/j-hui/fidget.nvim' },                                 -- Status updates
  { src = 'https://github.com/jedrzejboczar/possession.nvim' },                     -- Session Manager
  { src = 'https://github.com/jiangmiao/auto-pairs' },                              -- Automatically close brackets, quotes etc.
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },                           -- Show which lines were changed/added/deleted in a buffer
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },               -- Show indentation for all lines
  { src = 'https://github.com/neovim/nvim-lspconfig' },                             -- LSP Configuration & Plugins
  { src = 'https://github.com/numToStr/Comment.nvim' },                             -- "gc" to comment visual regions/lines
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },                         -- Configure status line
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },                     -- Fuzzy Finder
  { src = 'https://github.com/nvim-telescope/telescope-file-browser.nvim' },        -- File Browser
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = "main" }, -- Highlight, edit, and navigate code
  { src = 'nvim-treesitter/nvim-treesitter-textobjects' },                          -- Additional text objects via treesitter
  { src = 'https://github.com/tpope/vim-sleuth' },                                  -- Automatically set tab width etc.
  { src = 'https://github.com/tpope/vim-surround' },                                -- Deal with quotes/brackets/parenthesies better
})

vim.cmd("colorscheme kanagawa")

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'kanagawa',
    component_separators = '|',
    section_separators = '',
  }
}

require('Comment').setup()

require("ibl").setup { indent = { char = '┊' } }

require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    file_browser = {
      grouped = true,
      hidden = { file_browser = true },
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      initial_mode = "normal",
    },
  },
}

pcall(require('telescope').load_extension, 'file_browser')

set_key('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
set_key('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

set_key('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
set_key('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
set_key('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
set_key('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
set_key('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
set_key('n', '<leader>fb', require "telescope".extensions.file_browser.file_browser, { desc = '[F]ile [B]rowser' })

-- [[ Configure Treesitter ]]
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'python', 'typescript', 'rust', 'lua' },
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
}

set_key('n', '<leader>e', vim.diagnostic.open_float)

-- LSP settings
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { desc = desc })
end

nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
nmap('<leader>fm', vim.lsp.buf.format, '[F]or[m]at')

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
local servers = {
  clangd = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {},
  lua_ls = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = "~/lua-5.4.4",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
  docker_compose_language_service = {},
  dockerls = {},
  jsonls = {},
}

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      vim.lsp.config(server_name, {
        capabilities = capabilities,
        settings = servers[server_name],
      })
    end,
  }
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require('bufferline').setup {
  options = {
    separator_style = 'slant',
    diagnostics = 'nvim_lsp'
  }
}

require('cutlass').setup { cut_key = 'x' }

require('possession').setup {
  commands = {
    save = 'SSave',
    load = 'SLoad',
    delete = 'SDelete',
    list = 'SList',
  }
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
