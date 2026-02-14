return {
  "folke/which-key.nvim",
  "evanleck/vim-svelte",
  "windwp/nvim-autopairs",
  "tpope/vim-surround",
  "RRethy/vim-illuminate",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      modes = {
        diagnostics = {
          filter = {
            severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN },
          },
        },
      },
      open_no_results = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false win.position=right win.size=0.25<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      { "}", "<cmd>Trouble symbols prev jump=true<cr>", desc = "Previous symbol" },
      { "{", "<cmd>Trouble symbols next jump=true<cr>", desc = "Next symbol" },
    },
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      require("aerial").setup({
        open_automatic = false,
      })
    end,
  },
}
