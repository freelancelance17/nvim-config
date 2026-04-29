return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
opts = {
    ensure_installed = {
      "c_sharp", "python", "lua", "toml", "html", "javascript",
      "typescript", "json", "yaml", "markdown", "markdown_inline",
      "vim", "vimdoc", "bash", "css",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").setup(opts)
  end,
}
