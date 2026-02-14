-- Python formatting on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    vim.cmd([[!ruff format % ]])
  end,
})

-- Word wrap for text files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  callback = function()
    vim.wo.wrap = true
  end,
})

-- Float diagnostics on cursor hold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})
