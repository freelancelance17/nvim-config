-- Python formatting on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.py",
  callback = function()
    vim.cmd([[!ruff format % ]])
  end,
})

-- Auto save rust files
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = autosave_group,
  pattern = "*.rs",
  callback = function()
    if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Open the IDE panels once at startup, then return focus to the editing window.
-- edgy.nvim (see plugins/layout.lua) handles all placement, sizing, ordering, and
-- pinning — here we just trigger each panel to open.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      local main_win = vim.api.nvim_get_current_win()
      pcall(vim.cmd, "Neotree show")
      pcall(vim.cmd, "Trouble symbols open focus=false")
      pcall(vim.cmd, "Trouble diagnostics open focus=false")
      pcall(vim.cmd, "ToggleTerm")
      if vim.api.nvim_win_is_valid(main_win) then
        vim.api.nvim_set_current_win(main_win)
      end
      -- ToggleTerm runs `startinsert` when it opens; because this whole opener is
      -- async-scheduled, that insert lands after we hand focus back to the editor.
      -- Defer a stopinsert so we always start in normal mode in the main buffer.
      vim.schedule(function() vim.cmd("stopinsert") end)
    end)
  end,
})

-- Word wrap for text files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt",
  callback = function()
    vim.wo.wrap = true
  end,
})

