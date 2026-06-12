return {
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").add({
        { "<leader>d", group = "debug" },
        { "<leader>r", group = "rust" },
        { "<leader>f", group = "find" },
        { "<leader>x", group = "diagnostics" },
      })
    end,
  },
  "evanleck/vim-svelte",
  -- needs setup() to register its keymaps; a bare string spec never calls it
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  {
    -- nvim-surround: lua replacement for tpope/vim-surround (dot-repeat,
    -- treesitter-aware, same ys/cs/ds verbs).
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- Reference highlighting/navigation is handled by snacks.words (see
  -- plugins/snacks.lua), replacing RRethy/vim-illuminate.
  -- Commenting (gc / gcc) is provided by Neovim's built-in commenting (0.10+),
  -- so numToStr/Comment.nvim is no longer needed.
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup({})
    end,
  },
  {
    "folke/trouble.nvim",
    -- nvim 0.12: patch deprecated client.request dot-call in the active code path
    build = function()
      local path = vim.fn.stdpath("data") .. "/lazy/trouble.nvim/lua/trouble/sources/lsp.lua"
      local lines = vim.fn.readfile(path)
      local content = table.concat(lines, "\n")
      content = content:gsub(
        "        or client%.request",
        "        or function(_, ...) return client:request(...) end"
      )
      vim.fn.writefile(vim.split(content, "\n"), path)
    end,
    cmd = "Trouble",
    opts = {
      modes = {
        diagnostics = {
          filter = {
            severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN, vim.diagnostic.severity.HINT },
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
}
