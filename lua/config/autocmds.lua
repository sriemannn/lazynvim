-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "tex",
  callback = function()
    vim.o.wrap = true
    vim.o.linebreak = true
    vim.o.spell = true
  end,
})
