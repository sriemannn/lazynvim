-- use({
--     "aserowy/tmux.nvim",
--     config = function() return require("tmux").setup() end
-- })
return {
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      {
        "<C-h>",
        "<Cmd>NvimTmuxNavigateLeft<cr>",
        desc = "Navigate left",
      },
      {
        "<C-j>",
        "<Cmd>NvimTmuxNavigateDown<cr>",
        desc = "Navigate down",
      },
      {
        "<C-k>",
        "<Cmd>NvimTmuxNavigateUp<cr>",
        desc = "Navigate up",
      },
      {
        "<C-l>",
        "<Cmd>NvimTmuxNavigateRight<cr>",
        desc = "Navigate right",
      },
    },
    config = true,
  },
  -- "numToStr/Navigator.nvim",
  -- config = function()
  --   require("Navigator").setup()
  -- end,
  -- keys = function()
  --   local navigator = require("Navigator")
  --   return {
  --     { "C-h", navigator.left(), silent = true, mode = "n" },
  --     { "C-l", navigator.right(), silent = true, mode = "n" },
  --     { "C-k", navigator.up(), silent = true, mode = "n" },
  --     { "C-j", navigator.down(), silent = true, mode = "n" },
  --   }
  -- end,
}
