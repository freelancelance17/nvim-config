-- Claude Code IDE integration via coder/claudecode.nvim. The plugin runs the same
-- WebSocket/MCP server the VS Code extension does and writes a lock file under
-- ~/.claude/ide/, so a `claude` session (inside nvim, or started outside and
-- attached with `/ide`) sees nvim as its IDE: proposed edits open here as diff
-- splits instead of in the agent view, and Claude can read the current
-- selection, open buffers, and LSP diagnostics.
--
-- Accepting a diff = `:w` in the proposed buffer (or <leader>aa). Autosave can't
-- accept one behind your back: the proposed buffer is buftype=acwrite, and the
-- auto-save condition (lua/plugins/autosave.lua) only writes buftype == "".
if not require("features").plugins.claude then return {} end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" }, -- terminal provider for the Claude split
  config = true,
  -- Load right after startup, not on first <leader>a*: the IDE server (and its
  -- ~/.claude/ide lock file) only exists once the plugin loads, so a `claude`
  -- started in another terminal would otherwise find no nvim to auto-connect to.
  event = "VeryLazy",
  -- `cmd` stubs make :ClaudeCode* exist before any <leader>a* key loads the plugin.
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    -- <leader>a is shared: <leader>af is LSP code action (lsp.lua) and normal-mode
    -- <leader>as is ASToggle (autosave.lua), so the upstream focus key moves to
    -- <leader>ao. Send-selection stays on <leader>as because it's visual-only.
    { "<leader>a", nil, desc = "Claude / actions" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>ao", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    -- Buffer-local to neo-tree, so it only shadows ASToggle inside the tree.
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file to Claude", ft = { "neo-tree" } },
    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
  },
}
