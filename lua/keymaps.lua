local opts = { noremap = true, silent = true }

-- Window management
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", opts)
vim.keymap.set("n", "<leader>s", ":split<CR>", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

-- Misc
-- Snacks.bufdelete closes the buffer while keeping the window layout intact
-- (plain :bd can collapse edgy docks/splits). Snacks loads at startup, so it's
-- available by the time this is pressed.
vim.keymap.set("n", "<leader>q", function() Snacks.bufdelete() end, opts)
-- Save on <leader>w (the bare `w` is left as the word-motion it should be)
vim.keymap.set("n", "<leader>w", ":w<CR>", opts)
-- Diffview on <leader>gd (was <C-d>, which clobbered the half-page-down motion).
-- No "main" arg: that ref doesn't exist in master-based repos; default diffs
-- the working tree against the index/HEAD.
vim.keymap.set("n", "<leader>gd", "<Cmd>DiffviewOpen<CR>", opts)

-- User commands
vim.api.nvim_create_user_command("SurroundHelp", function()
  vim.cmd("%s/\\(.*\\)/'\\1',/")
end, { nargs = 0 })
