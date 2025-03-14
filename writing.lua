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

-- Set up relevant options for Markdown editing
local opt = vim.opt

-- Set text width to 80 characters (common width for Markdown documents)
opt.textwidth = 80
--opt.colorcolumn = "+1"  -- Highlight the column after text width

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
vim.api.nvim_set_keymap('n', '<leader>p', ':set spell!<CR>', { noremap = true, silent = true })

-- File type specific settings
vim.cmd [[
  augroup markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
    autocmd FileType markdown setlocal textwidth=85
    autocmd FileType markdown setlocal colorcolumn=+1
    autocmd FileType markdown setlocal scrolloff=999
  augroup END
]]

-- FloaTerm configuration
key_mapper('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
key_mapper('n', "t", ":FloatermToggle myfloat<CR>")
key_mapper('t', "<Esc>", "<C-\\><C-n>:q<CR>")

-- Move to previous/next
key_mapper('n', '<C-Left>', '<Cmd>BufferPrevious<CR>')
key_mapper('n', '<C-Right>', '<Cmd>BufferNext<CR>')
key_mapper('n', '<A-c>', '<Cmd>BufferClose<CR>')

-- Function to run your commands
local function run_commands_on_save()
  vim.cmd('echo "Saving Markdown file..."')
  vim.cmd('terminal ./check.sh ' .. vim.fn.expand('%'))
  -- Add more commands as needed
end

vim.o.termguicolors = true
vim.o.syntax = 'on'
vim.o.errorbells = false
vim.o.smartcase = true
vim.o.showmode = false
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt='menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false


-- KEY MAPPINGS

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

-- PLUGIN SETTINGS --

-- LAZY --
local vim = vim
local fn = vim.fn

-- Ensure that lazy.nvim is installed
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy
require("lazy").setup({
  -- lsp server
  "nvim-lua/popup.nvim", -- https://github.com/nvim-lua/popup.nvim
  "nvim-lua/plenary.nvim", -- https://github.com/nvim-lua/plenary.nvim
  "nvim-lua/telescope.nvim", -- https://github.com/nvim-lua/telescope.nvim
  "jremmen/vim-ripgrep", -- https://github.com/jremmen/vim-ripgrep
  "preservim/nerdtree", -- https://github.com/preservim/nerdtree
  "nvim-tree/nvim-web-devicons", -- https://github.com/nvim-tree/nvim-web-devicons
  "ryanoasis/vim-devicons", -- https://github.com/ryanoasis/vim-devicons
  "Xuyuanp/nerdtree-git-plugin", -- https://github.com/Xuyuanp/nerdtree-git-plugin
  "voldikss/vim-floaterm", -- https://github.com/voldikss/vim-floaterm
  "folke/which-key.nvim", -- https://github.com/folke/which-key.nvim
  "folke/zen-mode.nvim",
  -- rust stuff
  "romgrk/barbar.nvim", -- https://github.com/romgrk/barbar.nvim
  "numToStr/Comment.nvim", -- https://github.com/numToStr/Comment.nvim
  "sainnhe/everforest",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }
  },
  "hedyhli/outline.nvim",
  "folke/tokyonight.nvim",
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        manual_mode = true
      }
    end
  },
  {
    "akinsho/toggleterm.nvim", 
    version = "*", 
    config = function()
      require("toggleterm").setup()
    end
  }
})

-- mappings for fuzzy finding
key_mapper('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
key_mapper('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
key_mapper('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_mapper('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
key_mapper('n', '<leader>fr', '<cmd>Telescope projects<CR>')
key_mapper('n', '<leader>fd', '<cmd>Telescope lsp_definitions<CR>')
key_mapper('n', '<C-t>', '<cmd>ToggleTerm<CR>')
-- mappings for gitui

-- nvim tree
vim.opt.termguicolors = true
key_mapper('n', '\\\\', '<Cmd>NERDTreeFocus<CR>')

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

require'barbar'.setup {
  animation = true,
  sidebar_filetypes = {
    NvimTree = true
  }
}

-- FloaTerm configuration
key_mapper('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
key_mapper('n', "t", ":FloatermToggle myfloat<CR>")
key_mapper('t', "<Esc>", "<C-\\><C-n>:q<CR>")

-- Comment setup
require('Comment').setup()

-- Important!!
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

--toggleterm 
require("toggleterm").setup()

-- Split windows
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })

-- Resize windows
vim.api.nvim_set_keymap('n', '<leader>+', ':resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>-', ':resize -2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader><', ':vertical resize -2<CR>', { noremap = true, silent = true })

-- Navigate between windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- set autocmds for md files, wordwrap
vim.api.nvim_create_augroup('MarkdownSettings', { clear = true })

-- Define the autocmds for the MarkdownSettings group
vim.api.nvim_create_autocmd('FileType', {
    group = 'MarkdownSettings',
    pattern = 'markdown',
    callback = function()
        -- Set various options here
        vim.opt_local.wrap = true
        vim.opt_local.textwidth = 80
        vim.opt_local.wrapmargin = 20
        --vim.opt_local.foldcolumn = '6'
        -- Add more settings as needed
    end,
})

vim.api.nvim_set_keymap('n', 'q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', 'q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>r', 'q', { noremap = true, silent = true })

function search_current_word()
  local word = vim.fn.expand('<cword>')  -- Get the word under the cursor
  require('telescope.builtin').grep_string({
    search = word,
    use_regex = false,  -- Set to true if you want to use regex
  })
end

-- Map the custom function to a key binding, e.g., <leader>fw
vim.api.nvim_set_keymap(
  'n', '<leader>fw', ':lua search_current_word()<CR>',
  { noremap = true, silent = true }
)
-- Define a function to format the current buffer using Prettier
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  command = "silent !prettier --write %",
})

vim.opt.complete = {}
vim.opt.completeopt = {}

-- Disable insert mode completion
vim.opt.infercase = false
vim.opt.wildmenu = false

-- Disable omnifunc completion
vim.opt.omnifunc = ""

vim.opt.linespace = 10         -- Sets additional pixels between lines
vim.opt.number = false        -- Disable line numbers
vim.opt.relativenumber = false -- Disable relative line numbers

vim.cmd("colorscheme everforest")
