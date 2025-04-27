-- if true then
--   return {}
-- end
--
return {
  { "jmbuhr/otter.nvim", ft = { "markdown", "quarto", "norg" } },
  {
    -- plugins/quarto.lua
    "quarto-dev/quarto-nvim",
    dev = false,
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "quarto", "markdown" },
    opts = {
      codeRunner = {
        enabled = true,
        default_method = "molten",
        -- ft_runners = { python = "molten" },
        never_run = "yaml",
      },
      lspFeatures = {
        -- NOTE: put whatever languages you want here:
        languages = { "r", "python" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      keymap = {
        -- NOTE: setup your own keymaps:
        hover = "K",
        definition = "gd",
        rename = "<leader>rn",
        references = "gr",
        format = "<leader>gf",
      },
    },
    keys = function()
      local runner = require("quarto.runner")
      return {
        { "<localleader>rc", runner.run_cell, desc = "run cell", silent = true, mode = "n" },
        { "<localleader>ra", runner.run_above, desc = "run cell and above", silent = true, mode = "n" },
        { "<localleader>rA", runner.run_all, desc = "run all cells", silent = true, mode = "n" },
        { "<localleader>rl", runner.run_line, desc = "run line", silent = true, mode = "n" },
        { "<localleader>r", runner.run_range, desc = "run visual range", silent = true, mode = "v" },
        {
          "<localleader>RA",
          function()
            runner.run_all(true)
          end,
          desc = "run all code of all languages",
          silent = true,
          mode = "n",
        },
      }
    end,
  },
}
