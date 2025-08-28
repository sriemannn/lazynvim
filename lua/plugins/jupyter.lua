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
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
            ["]b"] = "@code_cell.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
            ["[b"] = "@code_cell.inner",
          },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
        select = {
          enable = true,
          lookahead = true, -- you can change this if you want
          keymaps = {
            --- ... other keymaps
            ["ib"] = { query = "@code_cell.inner", desc = "in block" },
            ["ab"] = { query = "@code_cell.outer", desc = "around block" },
          },
        },
        swap = { -- Swap only works with code blocks that are under the same
          -- markdown header
          enable = true,
          swap_next = {
            --- ... other keymap
            ["<leader>sbl"] = "@code_cell.outer",
          },
          swap_previous = {
            --- ... other keymap
            ["<leader>sbh"] = "@code_cell.outer",
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.textobjects.move, { enable = true, set_jumps = false })
  --
  --     vim.list_extend(opts.textobjects.move.goto_next_start, {
  --       ["]b"] = { query = "@code_cell.inner", desc = "next code block" },
  --     })
  --
  --     vim.list_extend(opts.textobjects.move.goto_previous_start, {
  --       ["[b"] = { query = "@code_cell.inner", desc = "previous code block" },
  --     })
  --
  --     table.insert(opts.textobjects, {
  --       select = {
  --         enable = true,
  --         lookahead = true,
  --         keymaps = {
  --           --- ... other keymaps
  --           ["ib"] = { query = "@code_cell.inner", desc = "in code block" },
  --           ["ab"] = { query = "@code_cell.outer", desc = "around code block" },
  --         },
  --       },
  --     })
  --
  --     table.insert(opts.textobjects, {
  --       swap = {
  --         enable = true,
  --         swap_next = {
  --           --- ... other keymap
  --           ["<leader>sbl"] = "@code_cell.outer",
  --         },
  --         swap_previous = {
  --           --- ... other keymap
  --           ["<leader>sbh"] = "@code_cell.outer",
  --         },
  --       },
  --     })
  --   end,
  -- },
}
