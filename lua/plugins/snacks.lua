return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enabled modules
    bigfile = { enabled = true }, -- disable heavy features on huge files
    quickfile = { enabled = true }, -- render the file before plugins finish loading
    indent = { enabled = true }, -- indent guides + current-scope highlight
    words = { enabled = true }, -- LSP reference highlight/nav (replaces vim-illuminate)

    -- Explicitly OFF: not wanted, or would replace/conflict with existing plugins.
    notifier = { enabled = false }, -- keep nvim-notify (via noice)
    input = { enabled = false },
    scroll = { enabled = false },
    dashboard = { enabled = false }, -- would fight the VimEnter IDE-panel opener
    statuscolumn = { enabled = false },
    explorer = { enabled = false }, -- neo-tree owns the file tree (edgy left dock)
    picker = { enabled = false }, -- telescope owns fuzzy finding (+ DAP pickers)
  },
  keys = {
    -- Open current file/selection on the git host in the browser
    { "<leader>go", function() Snacks.gitbrowse() end, mode = { "n", "v" }, desc = "Git: open in browser" },
    -- Jump between LSP references of the symbol under the cursor (snacks.words).
    -- Uses ]r/[r so the standard ]]/[[ section motions stay intact.
    { "]r", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" },
    { "[r", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" },
  },
}
