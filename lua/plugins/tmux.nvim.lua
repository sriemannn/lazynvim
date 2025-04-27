-- use({
--     "aserowy/tmux.nvim",
--     config = function() return require("tmux").setup() end
-- })
return { {
  "aserowy/tmux.nvim",
  config = function()
    return require("tmux").setup()
  end,
} }
