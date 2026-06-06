vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.fillchars = { eob = " " } -- hide the ~ end-of-buffer markers
vim.o.termguicolors = true
-- Colorscheme is applied by the onedark.nvim plugin (see lua/plugins/ui.lua);
-- it must load before being set, so it can't be applied here (pre-lazy).
vim.o.syntax = "on"
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
-- Default border for all floating windows (nvim 0.11+). cmp inherits this via
-- cmp.config.window.get_border(), so completion/docs, hover, and signature
-- floats all share the same rounded frame.
vim.o.winborder = "rounded"
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath("config") .. "/undodir"
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt = "menuone,noinsert,noselect"
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = true
vim.opt.laststatus = 3
vim.o.cmdheight = 1
vim.o.updatetime = 2000
-- Don't auto-equalize splits; edgy.nvim (plugins/layout.lua) manages panel sizing.
-- NOTE: we deliberately do NOT set global winwidth/winheight here — those leak into
-- plugin windows (Telescope prompt, terminals) and blow them up to full size.
vim.o.equalalways = false
