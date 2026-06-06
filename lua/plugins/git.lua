return {
  "sindrets/diffview.nvim",
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      base = "main",
      attach_to_untracked = true,
      -- inline current-line blame (replaces the separate git-blame.nvim)
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
    },
  },
}
