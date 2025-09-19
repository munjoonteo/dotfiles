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
    { "gbprod/cutlass.nvim", opts = { cut_key = "x" } },
    { "numToStr/Comment.nvim", keys = { "gc", "gcc" }, opts = {} },
    { "tpope/vim-surround" },
  },
})
