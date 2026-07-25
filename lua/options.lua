vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fillchars = { eob = " " } -- hide the ~ end-of-buffer markers
vim.o.termguicolors = true
-- Colorscheme is applied by the onedark.nvim plugin (see lua/plugins/ui.lua);
-- it must load before being set, so it can't be applied here (pre-lazy).
vim.o.syntax = "on"
vim.o.errorbells = false
-- smartcase only kicks in when ignorecase is set; without it /Foo was still
-- case-sensitive and smartcase was a no-op.
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmode = false
-- Default border for all floating windows (nvim 0.11+). cmp inherits this via
-- cmp.config.window.get_border(), so completion/docs, hover, and signature
-- floats all share the same rounded frame.
vim.o.winborder = "rounded"
-- vim.o (not vim.bo): the buffer-local form only applied to the initial empty
-- buffer, so every file actually opened still created a swapfile.
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
-- vim.o (not vim.wo) so these are the global defaults: vim.wo only set the
-- startup window, and windows created later (plugin panels, new tabs) fell
-- back to the built-in defaults.
vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.wrap = true
vim.opt.laststatus = 3
vim.o.cmdheight = 1
vim.o.updatetime = 2000
-- Don't auto-equalize splits; edgy.nvim (plugins/layout.lua) manages panel sizing.
-- NOTE: we deliberately do NOT set global winwidth/winheight here — those leak into
-- plugin windows (Telescope prompt, terminals) and blow them up to full size.
vim.o.equalalways = false
