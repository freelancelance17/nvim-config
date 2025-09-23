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
vim.wo.wrap = true 
vim.opt.laststatus = 3


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


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  -- Required plugins
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- Load on file open
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects", -- Optional but recommended
  },
  opts = {
    ensure_installed = { 
      "c_sharp", 
      "python", 
      "lua", 
      "toml", 
      "html", 
      "javascript",
      "typescript", -- Common with JS
      "json", 
      "yaml",
      "markdown", 
      "markdown_inline",
      "vim", 
      "vimdoc", -- For vim help files
      "bash",
      "css" -- Useful with HTML
    },
    
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    
    -- Automatically install missing parsers when entering buffer
    auto_install = true,
    
    highlight = {
      enable = true,
      -- Disable vim regex highlighting for better performance
      additional_vim_regex_highlighting = false,
    },
    
    indent = {
      enable = true, -- Better indentation
    },
    },
    
    -- Optional: Text objects (requires nvim-treesitter-textobjects)
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    
    -- -- Optional: Set up folding
    -- vim.opt.foldmethod = "expr"
    -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    -- vim.opt.foldlevelstart = 99 -- Don't fold by default
  end,
},
  {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "codecompanion" }
},
  },
  -- Theme
  'evanleck/vim-svelte',
  "freelancelance17/ursala.nvim",

  -- GIT
  'f-person/git-blame.nvim',
  "Xuyuanp/nerdtree-git-plugin",
  'sindrets/diffview.nvim',

  -- LSP
  "neovim/nvim-lspconfig",
  "anott03/nvim-lspinstall",
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Fuzzy finding
  "nvim-lua/popup.nvim",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  "jremmen/vim-ripgrep",

  -- File tree
  "preservim/nerdtree",
  "ryanoasis/vim-devicons",

  -- Terminal
  "voldikss/vim-floaterm",

  {'hrsh7th/nvim-cmp',
	event = 'InsertEnter',  -- Plugin loaded when insert mode entered
	dependencies = {
		"hrsh7th/cmp-buffer",  -- Completion source for text in current buffer
		"hrsh7th/cmp-path",  -- Completion source for file paths
		{
			"L3MON4D3/LuaSnip",  -- Snippet engine for Lua
			version = "v2.*",  -- Specific version to use
			build = "make install_jsregexp",  -- Advances snippet matching
		},
		"saadparwaiz1/cmp_luasnip",  -- Integration between nvim-cmp and LuaSnip
		"rafamadriz/friendly-snippets",  -- Collection of pre-defined snippets
		"onsails/lspkind.nvim",  -- Adds icons to completion items for better visual context
		"hrsh7th/cmp-nvim-lsp",  -- Enables completion from LSP servers
		"hrsh7th/cmp-nvim-lsp-signature-help",  -- Adds signature help (function arguments) in completion popups
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require('lspkind')

		cmp.setup({
			completion = {
				completeopt = 'menu,menuone,preview',
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)  -- Use LuaSnip for expanding snippets
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<Tab>'] = cmp.mapping.confirm({ select = true }),
				['<Enter>'] = cmp.mapping.confirm({ select = true }),
			}),
			-- Enable completions from above
			sources = cmp.config.sources({
				{ name = 'nvim_lsp_signature_help' },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'path' },
			}),
		})

		require("luasnip.loaders.from_vscode").lazy_load()  -- Load snippets
	end,
  },


  -- Other utilities
  "folke/which-key.nvim",
  {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('github-theme').setup({
      -- ...
    })

    vim.cmd('colorscheme github_dark_high_contrast')
  end,
},

  -- Rust
  "simrat39/rust-tools.nvim",
  "puremourning/vimspector",

  -- Tabs
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Project status
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
  },
  {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  modes = {
    diagnostics = {
      filter = {
        severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN }
      }
    }
  },
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},
  "windwp/nvim-autopairs",
  "tpope/vim-surround",
  'sindrets/diffview.nvim',
  "RRethy/vim-illuminate",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- AI Assistant
  {
    "freelancelance17/parrot.nvim",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("parrot").setup({
        providers = {
          anthropic = {
            api_key = os.getenv("ANTHROPIC_API_KEY"),
          },
        },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup()
    end,
  },

  -- Code outline
  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup()
    end,
  },
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Apply capabilities to both Python LSP servers
vim.lsp.config.pyright = {
	capabilities = capabilities
}

vim.lsp.config.jedi_language_server =  {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Disable definition handling in Jedi
		client.server_capabilities.definitionProvider = false
	end
}

-- LSP SERVER CONFIG
local lspconfig = require'lspconfig'

-- Common on_attach function to be used by both servers
local python_on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
  vim.api.nvim_buf_set_option(bufnr, 'linebreak', true)
  
  -- If this is Pyright, disable its completion in favor of Jedi
  if client.name == "pyright" then
    client.server_capabilities.completionProvider = false
  end
end


local default_config = {
  on_attach = custom_on_attach,
}

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
vim.lsp.config.ruff = {
  settings = {
    ruff = {
      -- Config options for ruff language server
      -- See: https://github.com/charliermarsh/ruff-lsp
      format = {
        args = {"--config", "pyproject.toml"}
      },
      lint = {
        args = {},
      },
      organize_imports = true,
    },
  },
  on_attach = function(client, bufnr)
    -- Optional: Enable formatting on save
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

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
--
-- -- Move to previous/next
key_mapper('n', '<C-left>', '<Cmd>BufferPrevious<CR>')
key_mapper('n', '<C-right>', '<Cmd>BufferNext<CR>')

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
--     vim.cmd('!' .. 'prettier --write ' .. escaped_file)
--     vim.cmd('!' .. 'npx eslint --fix ' .. escaped_file)
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
      '--hidden'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    path_display = { "truncate" },
  },
}

--toggleterm 
require("toggleterm").setup()

vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

-- Split windows
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>s', ':split<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v', '<leader>l', ':\'<\'>Chat explain<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', 'q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>r', 'q', { noremap = true, silent = true })


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
      statusline = 10,
      tabline = 10,
      winbar = 10,
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


-- Apply the chosen colorscheme
--vim.cmd("colorscheme catppuccin-latte")


vim.api.nvim_set_keymap('n', 'q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', 'q', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>r', 'q', { noremap = true, silent = true })
-- Open Diff with main
vim.api.nvim_set_keymap('n', '<C-d>', '<Cmd>DiffviewOpen main<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  'n',
  '<leader>fw',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })<CR>',
  { noremap = true, silent = true }
)

require("aerial").setup({
  -- most have global dependencies installed to work with typescript
  open_automatic = false,
})


vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile"}, {
  pattern = {"*.py", "*.cs"},
  callback = function()
    vim.cmd("AerialOpen!")
  end
})

key_mapper("n", "}", "<cmd>AerialPrev<CR>")
key_mapper("n", "{", "<cmd>AerialNext<CR>")
key_mapper("n", "<leader>\\", "<cmd>colorscheme rose-pine-moon<CR>")

-- setup language servers here
vim.lsp.config.ts_ls = {}
--
vim.lsp.config.csharp_ls.setup={
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  on_attach = function(client, bufnr)
  end,
}

-- require("lspconfig").omnisharp.setup({
--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
--   on_attach = function(client, bufnr)
--   end,
--   cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
--   -- Optional: specify which solution/project files to use
--   -- root_dir = require("lspconfig").util.root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json"),
-- })

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "anthropic",
    },
  },
})

vim.g.maplocalleader = ","
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

