-- Autosave via okuuva/auto-save.nvim (the maintained fork of the abandoned
-- pocco81/auto-save.nvim). Saves are `silent!`, so noice doesn't echo a
-- "...written" message on every save.
--
-- noautocmd stays false on purpose: BufWritePre/Post must still fire so the
-- ruff LSP format-on-save (lua/plugins/lsp.lua) runs and rust-analyzer gets
-- textDocument/didSave — that's what triggers its cargo-check diagnostics, so
-- with autosave the diagnostics panel refreshes whenever you pause typing.
return {
  "okuuva/auto-save.nvim",
  version = "^1",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost" }, -- save instantly when leaving the buffer/nvim
      defer_save = { "InsertLeave", "TextChanged" }, -- debounced save after edits
      cancel_deferred_save = { "InsertEnter" }, -- don't save mid-typing burst
    },
    -- TextChanged fires on every normal-mode edit (dd, p, ...); the debounce is
    -- what keeps that from writing on each keystroke of a change sequence.
    debounce_delay = 1000,
    condition = function(buf)
      -- only real, named file buffers — skip terminals, trouble/neo-tree panels,
      -- and float scratch buffers (their buftype is nonempty or they're unnamed)
      return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) ~= ""
    end,
  },
  keys = {
    { "<leader>as", "<cmd>ASToggle<CR>", desc = "Toggle autosave" },
  },
}
