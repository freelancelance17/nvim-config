return {
  "nvim-lua/popup.nvim",
  "jremmen/vim-ripgrep",
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fs", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope projects<CR>", desc = "Projects" },
      { "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
      { "<leader>fu", function() require("telescope.builtin").lsp_references() end, desc = "LSP references" },
      { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end, desc = "Grep word under cursor" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
          },
          prompt_prefix = "> ",
          selection_caret = "> ",
          path_display = { "truncate" },
        },
      })
    end,
  },
}
