local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'
  use 'gbprod/cutlass.nvim' -- Change d to delete and add cut functionality
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Set highlight on search
vim.o.hlsearch = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

vim.g.blamer_enabled = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Remap for jumping to start and end of lines
vim.keymap.set({ 'n', 'v' }, 'H', '^')
vim.keymap.set({ 'n', 'v' }, 'L', '$')

-- Remap for select all
vim.keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Remap for splitting buffers
vim.keymap.set('n', 'ss', ':sp<Return>')
vim.keymap.set('n', 'sv', ':vsp<Return>')

-- Remap for split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { noremap = false })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { noremap = false })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { noremap = false })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { noremap = false })

-- Remap for tab navigation
vim.keymap.set('n', '<leader>h', 'gT')
vim.keymap.set('n', '<leader>l', 'gt')

-- Remap for copying to system clipboard
vim.keymap.set('v', '<leader>y', '"*y')
vim.keymap.set('n', '<leader>y', '"*y')
vim.keymap.set('n', '<leader>d', '"*d')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

require('cutlass').setup { cut_key = 'x' }
