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
vim.keymap.set("n", "<leader>q", ":bd<CR>", opts)
vim.keymap.set("n", "w", ":w<CR>", opts)
vim.keymap.set("n", "<C-d>", "<Cmd>DiffviewOpen main<CR>", opts)
vim.keymap.set("v", "<leader>l", ":'<'>Chat explain<CR>", opts)

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", opts)
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", opts)
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", opts)
vim.cmd([[cab cc CodeCompanion]])

-- User commands
vim.api.nvim_create_user_command("SurroundHelp", function()
  vim.cmd("%s/\\(.*\\)/'\\1',/")
end, { nargs = 0 })
