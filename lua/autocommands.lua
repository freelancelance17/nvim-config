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
  -- nested = true so the programmatic :write below fires BufWritePost, which is
  -- what sends the LSP textDocument/didSave that triggers rust-analyzer's
  -- checkOnSave (clippy) — i.e. the diagnostics rescan. Without this, autosave
  -- writes the file but diagnostics only refresh on a manual :w.
  nested = true,
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

-- Make the docked diagnostics panel follow the cursor.
-- Trouble has a built-in `follow` (move the panel to the current line's
-- diagnostic), but edgy.nvim relocates Trouble's window with win_splitmove, which
-- desyncs Trouble's internal view tracking (same root cause noted in lsp.lua) — so
-- its follow autocmd either stops firing or targets a stale window handle. We
-- re-drive it ourselves: on cursor move in a real file window, point the
-- diagnostics view at the window edgy is actually displaying it in, then call
-- Trouble's own follow().
local function follow_diagnostics()
  -- the window edgy is currently showing the docked diagnostics panel in
  local diag_win
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local t = vim.w[w].trouble
    if t and t.mode == "diagnostics" then
      diag_win = w
      break
    end
  end
  if not diag_win then
    return
  end

  local ok, View = pcall(require, "trouble.view")
  if not ok or not View._views then
    return
  end
  -- Iterate the raw view registry, NOT View.get(): get() filters out views whose
  -- window isn't valid, and edgy's desync is exactly what makes win:valid() false —
  -- so get() would return nothing for the very view we need to repair.
  for view, _ in pairs(View._views) do
    if view.opts and view.opts.mode == "diagnostics" and view.win then
      -- repair the window handle edgy desynced, then let Trouble do the follow
      view.win.win = diag_win
      pcall(function()
        view:follow()
      end)
    end
  end
end

local follow_timer = nil
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("DiagnosticsFollowCursor", { clear = true }),
  callback = function()
    -- ignore moves inside floats and special windows (trouble, neo-tree, term)
    local win = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      return
    end
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype ~= "" or vim.w[win].trouble then
      return
    end
    -- debounce: CursorMoved fires rapidly; follow() scans all diagnostics
    if follow_timer then
      follow_timer:stop()
    end
    follow_timer = vim.defer_fn(follow_diagnostics, 80)
  end,
})

