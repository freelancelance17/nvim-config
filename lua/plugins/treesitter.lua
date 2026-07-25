if not require("features").plugins.treesitter then return {} end

return {
  "nvim-treesitter/nvim-treesitter",
  -- MUST stay on `main` for Neovim 0.12: the `master` branch is in maintenance
  -- and its README pins support to Neovim 0.10/0.11 — on 0.12 its query
  -- predicates call a treesitter API that no longer exists, throwing
  -- "attempt to call method 'range' (a nil value)" during markdown injection
  -- parsing (e.g. the code block in an LSP hover float on K). `main` is the
  -- rewrite and uses a different API: install() for parsers and
  -- vim.treesitter.start() for highlighting (no configs.setup/ensure_installed).
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    -- Parsers to keep installed. markdown + markdown_inline are required for
    -- treesitter to highlight fenced code in LSP hover/doc floats and Noice
    -- messages. install() is async and compiles missing parsers in the
    -- background; existing ones are skipped.
    require("nvim-treesitter").install({
      -- Languages
      "c_sharp", "python", "lua", "rust",
      "javascript", "typescript", "tsx",
      "html", "css", "htmldjango",
      "bash",
      -- Config / data formats
      "toml", "json", "yaml",
      "dockerfile", "terraform",
      "requirements",
      -- Git
      "gitcommit", "gitignore", "gitattributes",
      -- Docs / prose
      "markdown", "markdown_inline",
      -- Neovim internals
      "vim", "vimdoc", "query",
    })

    -- On `main`, highlighting is not automatic — enable it per buffer. Neovim
    -- resolves the language from the filetype; pcall guards filetypes with no
    -- installed parser (e.g. during the first async install).
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
