-- taken from https://bryankegley.me/posts/nvim-getting-started/
-- VIM TREE:disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.NERDTreeShowHidden = 1
-- SENSIBLE DEFAULTS
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

-- PACKER --
local vim = vim
local execute = vim.api.nvim_command

local fn = vim.fn

-- ensure that packer is installed
local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

cmd('packadd packer.nvim')

local packer = require('packer')
local util = require('packer.util')

packer.init({package_root = util.join_paths(fn.stdpath('data'), 'site', 'pack')})
--- startup and add configure plugins
packer.startup(function()
  local use = use
  -- lsp server
  use 'neovim/nvim-lspconfig' -- https://github.com/neovim/nvim-lspconfig
  -- use 'nvim-lua/completion-nvim' -- https://github.com/nvim-lua/completion-nvim
  use 'anott03/nvim-lspinstall'-- https://github.com/anott03/nvim-lspinstall
  -- more lsp
  use 'williamboman/mason.nvim' -- https://github.com/williamboman/mason.nvim
  use 'williamboman/mason-lspconfig.nvim' -- https://github.com/williamboman/mason-lspconfig.nvim
  -- language processing (TSInstall {language})
  use 'nvim-treesitter/nvim-treesitter'-- https://github.com/nvim-treesitter/nvim-treesitter
  -- fuzzy finding 
  use 'nvim-lua/popup.nvim'-- https://github.com/nvim-lua/popup.nvim
  use 'nvim-lua/plenary.nvim'-- https://github.com/nvim-lua/plenary.nvim
  use 'nvim-lua/telescope.nvim'-- https://github.com/nvim-lua/telescope.nvim
  use 'jremmen/vim-ripgrep'-- https://github.com/jremmen/vim-ripgrep
  -- theme
  -- file tree
  use 'preservim/nerdtree'-- https://github.com/preservim/nerdtree
  use 'nvim-tree/nvim-web-devicons'-- https://github.com/nvim-tree/nvim-web-devicons
  use 'ryanoasis/vim-devicons'-- https://github.com/ryanoasis/vim-devicons
  use 'Xuyuanp/nerdtree-git-plugin'-- https://github.com/Xuyuanp/nerdtree-git-plugin
  -- nvterm
  use 'voldikss/vim-floaterm'-- https://github.com/voldikss/vim-floaterm
  -- auto complete
  use 'hrsh7th/cmp-nvim-lsp'-- https://github.com/hrsh7th/cmp-nvim-lsp
  use 'hrsh7th/cmp-buffer'-- https://github.com/hrsh7th/cmp-buffer
  use 'hrsh7th/cmp-path'-- https://github.com/hrsh7th/cmp-path
  use 'hrsh7th/cmp-cmdline'-- https://github.com/hrsh7th/cmp-cmdline
  use 'hrsh7th/nvim-cmp'-- https://github.com/hrsh7th/nvim-cmp
  use 'hrsh7th/cmp-vsnip'-- https://github.com/hrsh7th/cmp-vsnip
  use 'hrsh7th/vim-vsnip'-- https://github.com/hrsh7th/vim-vsnip
  use 'hrsh7th/cmp-nvim-lua'-- https://github.com/hrsh7th/cmp-nvim-lua
  use 'hrsh7th/cmp-nvim-lsp-signature-help'-- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
  -- other
  use 'folke/which-key.nvim'-- https://github.com/folke/which-key.nvim
  -- rust stuff
  use 'simrat39/rust-tools.nvim'-- https://github.com/simrat39/rust-tools.nvim
  use 'mfussenegger/nvim-dap'-- https://github.com/mfussenegger/nvim-dap
  use 'puremourning/vimspector'-- https://github.com/puremourning/vimspector
  -- tabs 
  use 'romgrk/barbar.nvim'-- https://github.com/romgrk/barbar.nvim
  -- project status stuff
  use {
    "folke/todo-comments.nvim",-- https://github.com/folke/todo-comments.nvim
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
      }
      end
  }
  use 'folke/trouble.nvim'
  use 'windwp/nvim-autopairs'
  use 'tpope/vim-surround' -- https://github.com/tpope/vim-surround
  use 'RRethy/vim-illuminate'
  use 'numToStr/Comment.nvim' -- https://github.com/numToStr/Comment.nvim
  use({
   "freelancelance17/CodeGPT.nvim",
   requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
   },
   config = function()
      require("codegpt.config")
   end
  })
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'hedyhli/outline.nvim'
  use 'folke/tokyonight.nvim'
  use {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        manual_mode = true
      }
    end
  }
  use 'aspeddro/gitui.nvim'
  use {
    "akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end
  }
  end
)

-- TREE SITTER CONFIG
local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = {"python", "lua", "rust", "toml", "html", "javascript"},
  auto_install = true,
  highlight = {
    enable = true,
    addition_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- LSP SERVER CONFIG 
local lspconfig = require'lspconfig'
require'lspconfig'.pyright.setup{} -- https://github.com/neovim/nvim-lspconfig
local default_config = {
  on_attach = custom_on_attach,
}

-- setup language servers here
lspconfig.tsserver.setup(default_config)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')

-- mappings for fuzzy finding
key_mapper('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
key_mapper('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
key_mapper('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_mapper('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')
key_mapper('n', '<leader>fr', '<cmd>Telescope projects<CR>')
key_mapper('n', '<leader>fd', '<cmd>Telescope lsp_definitions<CR>')
key_mapper('n', '<C-t>', '<cmd>ToggleTerm<CR>')
-- mappings for gitui
key_mapper('n', '<leader>g', '<cmd>Gitui<CR>')

-- initiate oceanic next theme
--vim.cmd 'colorscheme OceanicNext'

-- nvim tree
vim.opt.termguicolors = true
key_mapper('n', '\\\\', '<Cmd>NERDTreeFocus<CR>')


-- config for cmp
-- Set up nvim-cmp.
-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
}, {
{ name = 'buffer' },
})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
{ name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
{ name = 'path' }
}, {
{ name = 'cmdline' }
})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['pyright'].setup {
capabilities = capabilities
}

-- setup for rust-tools 
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})

require("mason-lspconfig").setup()

-- Move to previous/next
key_mapper('n', '<C-PageUp>', '<Cmd>BufferPrevious<CR>')
key_mapper('n', '<C-PageDown>', '<Cmd>BufferNext<CR>')
key_mapper('n', '<A-c>', '<Cmd>BufferClose<CR>')

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

--- AUTO COMMANDS FOR FORMATTING ON SAVE -- 
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    vim.cmd([[!black % ]])
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {"*.js", "*.jsx", "*.tsx"},
  callback = function()
    local file = vim.fn.expand('%:p') -- Get the full path of the current file
    local escaped_file = vim.fn.shellescape(file) -- Escape the filename for shell usage
    vim.cmd('!' .. 'prettier --write ' .. escaped_file)
  end,
})

-- start material gruvbox 
-- Important!!
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

-- set word wrap on for text files 
vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.txt set wrap
]], false)

-- open trouble on all python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.cmd("Trouble")
    vim.cmd("Outline")
  end,
})

-- outline 
require("outline").setup({})

-- projects integration with telescope
require("project_nvim").setup({})
require('telescope').load_extension('projects')

-- gitui 
require("gitui").setup()

--toggleterm 
require("toggleterm").setup()

vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

vim.cmd[[colorscheme tokyonight]]
