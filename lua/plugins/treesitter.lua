return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
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
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}
