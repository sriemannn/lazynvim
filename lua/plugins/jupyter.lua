return {
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {
      -- sync_patterns = { ".py:percent" },
      autosync = true,
      handle_url_schemes = true,
    },
  },
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    keys = {
      { "<leader>mi", "<cmd>MoltenInit<CR>", desc = "Initiate Molten Instance", silent = true, mode = "n" },
      {
        "<localleader>e",
        "<cmd>MoltenEvaluateOperator<CR>",
        desc = "evaluate operator",
        silent = true,
        mode = "n",
      },
      {
        "<localleader>os",
        "<cmd>noautocmd MoltenEnterOutput<CR>",
        desc = "open output window",
        silent = true,
        mode = "n",
      },
      { "<localleader>rr", "<cmd>MoltenReevaluateCell<CR>", desc = "re-eval cell", silent = true, mode = "n" },
      { "<localleader>oh", "<cmd>MoltenHideOutput<CR>", desc = "close output window", silent = true, mode = "n" },
      { "<localleader>md", "<cmd>MoltenDelete<CR>", desc = "delete Molten cell", silent = true, mode = "n" },
      {
        "<localleader>mx",
        "<cmd>MoltenOpenInBrowser<CR>",
        desc = "open output in browser",
        silent = true,
        mode = "n",
      },
    },
    init = function()
      -- these re examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_wrap_output = true
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_auto_open_output = true
      -- vim.g.molten_auto_open_html_in_browser = true

      local quarto_cfg = require("quarto.config").config
      quarto_cfg.codeRunner.default_method = "molten"
      -- vim.cmd([[MoltenInit]])
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.textobjects.move.goto_next_start, {
        ["]m"] = { query = "@code_cell.inner", desc = "next code block" },
      })

      vim.list_extend(opts.textobjects.move.goto_previous_start, {
        ["[m"] = { query = "@code_cell.inner", desc = "previous code block" },
      })

      table.insert(opts.textobjects, {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            --- ... other keymaps
            ["im"] = { query = "@code_cell.inner", desc = "in code block" },
            ["am"] = { query = "@code_cell.outer", desc = "around code block" },
          },
        },
      })

      table.insert(opts.textobjects, {
        swap = {
          enable = true,
          swap_next = {
            --- ... other keymap
            ["<leader>sml"] = "@code_cell.outer",
          },
          swap_previous = {
            --- ... other keymap
            ["<leader>smh"] = "@code_cell.outer",
          },
        },
      })
    end,
  },
}
