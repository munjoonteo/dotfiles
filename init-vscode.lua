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
vim.cmd("colorscheme kanagawa")

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

require('cutlass').setup { cut_key = 'x' }
