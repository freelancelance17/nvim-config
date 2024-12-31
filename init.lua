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


local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')
local util = require('packer.util')

packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

packer.startup(function()
  local use = use
  use 'rose-pine/neovim'
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
    "frankroeder/parrot.nvim",
    requires = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim'},
    config = function()
      require("parrot").setup({
        providers = {
          anthropic = {
            api_key = os.getenv("ANTHROPIC_API_KEY"),
          },
        },
      })
    end,
  })

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use 'folke/tokyonight.nvim'
  use {
    "akinsho/toggleterm.nvim", tag = '*', config = function()
      require("toggleterm").setup()
  end
  }
  use({
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  })

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

require'lspconfig'.pyright.setup{
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
    vim.api.nvim_buf_set_option(bufnr, 'linebreak', true)
  end,
}

local default_config = {
  on_attach = custom_on_attach,
}

-- setup language servers here
require'lspconfig'.ts_ls.setup{}

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
    { name = 'pyright' },                           -- Python LSP source
    { name = 'ruff' },                              -- Python linter source
    { name = 'jedi' },                              -- Python autocompletion source

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
--
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})
-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 2000 
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

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

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = {"*.js", "*.jsx", "*.tsx"},
--   callback = function()
--     local file = vim.fn.expand('%:p') -- Get the full path of the current file
--     local escaped_file = vim.fn.shellescape(file) -- Escape the filename for shell usage
--     --vim.cmd('!' .. 'prettier --write ' .. escaped_file)
--   end,
-- })

-- Important!!
if vim.fn.has('termguicolors') == 1 then
  vim.o.termguicolors = true
end

-- set word wrap on for text files 
vim.api.nvim_exec([[
  autocmd BufRead,BufNewFile *.txt set wrap
]], false)


require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '-L'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "truncate" },
  },
}

--toggleterm 
require("toggleterm").setup()

vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

vim.cmd[[colorscheme tokyonight]]


-- Split windows
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<leader>l', ':\'<\'>Chat explain<CR>', { noremap = true, silent = true })

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
        -- Add more settings as needed
    end,
})

-- start material gruvbox 
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.zimbu = {
  install_info = {
    url = "~/dev/random/tree-sitter-latex", -- local path or git repo
    files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "main", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
  filetype = "zu", -- if filetype does not match the parser name
}

vim.api.nvim_set_keymap('n', 'q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', 'q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>r', 'q', { noremap = true, silent = true })

local dap = require('dap')
dap.adapters.python = {
  type = 'executable';
  command = os.getenv('HOME')..'/.pyenv/shims/python'; -- Adjust as necessary
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      return '/Users/lanceknickerbocker/.pyenv/shims/python' -- Adjust to the path of your Python interpreter
    end;
  },
}

vim.api.nvim_set_keymap('n', '<leader>fu', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', { noremap = true, silent = true })

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path=1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Alias for an existing command
vim.api.nvim_create_user_command(
    'SurroundHelp',
    function()
        vim.cmd("%s/\\(.*\\)/'\\1',/")
    end,
    { nargs = 0 } -- nargs = 0 indicates this command does not take any arguments
)

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
-- Get all available colorschemes
local colorschemes = vim.fn.getcompletion('', 'color')

-- Seed the random generator for randomness
math.randomseed(os.time())

-- Choose a random colorscheme from the list
local random_colorscheme = colorschemes[math.random(#colorschemes)]

-- Apply the chosen colorscheme
vim.cmd("colorscheme " .. random_colorscheme)

-- Print the selected colorscheme to the command line
print("Randomly selected colorscheme: " .. random_colorscheme)
vim.api.nvim_set_keymap('n', 'q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', 'q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>r', 'q', { noremap = true, silent = true })

-- Get all available colorschemes
local colorschemes = vim.fn.getcompletion('', 'color')

-- Seed the random generator for randomness
math.randomseed(os.time())

-- Choose a random colorscheme from the list
local random_colorscheme = colorschemes[math.random(#colorschemes)]

-- Apply the chosen colorscheme
vim.cmd("colorscheme " .. random_colorscheme)

-- Print the selected colorscheme to the command line

vim.api.nvim_set_keymap(
  'n',
  '<leader>fw',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
  { noremap = true, silent = true }
)

require("aerial").setup({
  open_automatic = true,
})


vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = {"*.py", "*.tsx", "*.jsx"},
  callback = function()
    vim.cmd("AerialOpen")
  end
})

key_mapper("n", "{", "<cmd>AerialPrev<CR>")
key_mapper("n", "}", "<cmd>AerialNext<CR>")
