if not require("features").plugins.git then return {} end

return {
  "sindrets/diffview.nvim",
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      -- No `base` override: diff against the git index (default), so the gutter
      -- shows unstaged changes. Setting base to a branch name like "main" breaks
      -- in repos that use "master" (no such ref) — gitsigns can't diff and shows
      -- nothing. Use diffview for branch-relative comparisons instead.
      attach_to_untracked = true,
      -- inline current-line blame (replaces the separate git-blame.nvim)
      current_line_blame = true,
      current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
    },
  },
}
