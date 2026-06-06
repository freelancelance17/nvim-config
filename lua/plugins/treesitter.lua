return {
  "nvim-treesitter/nvim-treesitter",
  -- Pinned to the stable `master` branch. The `main` branch is a ground-up
  -- rewrite with a different API: it does NOT take `ensure_installed` through
  -- setup() and highlight/indent are no longer module options, so the config
  -- below was a near no-op while on `main`. master uses the classic, stable
  -- nvim-treesitter.configs API. (When the main rewrite stabilizes, migrate by
  -- switching to vim.treesitter.start() + require("nvim-treesitter").install().)
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
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
        -- markdown + markdown_inline: needed for treesitter to highlight fenced code
        -- blocks inside LSP hover windows, completion docs, and Noice messages
        "markdown", "markdown_inline",

        -- Neovim internals
        "vim", "vimdoc", "query", "lua",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
