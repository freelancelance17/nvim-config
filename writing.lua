vim.g.mapleader = ' '
--instatiate keymapper
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

-- Create an augroup named 'ColorschemeSetup' to encapsulate the autocommand
vim.api.nvim_create_augroup('ColorschemeSetup', { clear = true })

-- Define the autocommand for setting the colorscheme
vim.api.nvim_create_autocmd('VimEnter', {
    group = 'ColorschemeSetup',  -- Attach to the 'ColorschemeSetup' augroup
    pattern = '*',               -- Apply to all files
    callback = function()
        -- Set the colorscheme to 'tokyonight'
        vim.cmd('colorscheme industry')
    end
})-- init.lua

-- Ensure you have the following line at the beginning to set up packer
-- if you plan to use it for plugin management
-- vim.cmd [[packadd packer.nvim]]

-- Set up relevant options for Markdown editing
local opt = vim.opt

-- Enable line numbers
opt.number = true

-- Enable relative line numbers
opt.relativenumber = true

-- Set text width to 80 characters (common width for Markdown documents)
opt.textwidth = 80
opt.colorcolumn = "+1"  -- Highlight the column after text width

-- Enable word wrap
opt.wrap = true
opt.linebreak = true  -- Wrap lines at convenient points (e.g., spaces)

-- Set margins
opt.scrolloff = 8  -- Minimum lines to keep above and below the cursor
opt.sidescrolloff = 8  -- Minimum columns to keep to the left and right of the cursor

-- Enable spell checking and set language to English
opt.spell = true
opt.spelllang = 'en'

-- Set up some basic key mappings for convenience
vim.api.nvim_set_keymap('n', '<leader>w', ':set wrap!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':set spell!<CR>', { noremap = true, silent = true })

-- File type specific settings
vim.cmd [[
  augroup markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal textwidth=85
    autocmd FileType markdown setlocal colorcolumn=+1
  augroup END
]]

-- Define the session file name
local session_file = vim.fn.getcwd() .. "/session.vim"

-- Function to save the session
local function save_session()
  vim.cmd("mksession! " .. session_file)
end

-- Function to load the session
local function load_session()
  if vim.fn.filereadable(session_file) == 1 then
    vim.cmd("source " .. session_file)
  end
end

-- Set up an autocommand to save the session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    save_session()
  end,
})

-- Load the session if it exists when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    load_session()
  end,
})

-- FloaTerm configuration
key_mapper('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
key_mapper('n', "t", ":FloatermToggle myfloat<CR>")
key_mapper('t', "<Esc>", "<C-\\><C-n>:q<CR>")

-- Move to previous/next
key_mapper('n', '<C-PageUp>', '<Cmd>BufferPrevious<CR>')
key_mapper('n', '<C-PageDown>', '<Cmd>BufferNext<CR>')
key_mapper('n', '<A-c>', '<Cmd>BufferClose<CR>')


