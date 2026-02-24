return {
  -- 1. CLEANUP: Ensure Biome binary is installed
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- We just ensure the binary exists. We don't configure logic here.
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
    end,
  },

  -- 2. DISABLE: Remove Biome from null-ls (It is not needed, Biome is an LSP)
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- If you had logic adding biome here, DELETE IT.
      -- We want to prevent null-ls from attaching to Biome.
      if opts.handlers then
        -- This is the "handler" trick, but used correctly:
        -- we ensure null-ls NEVER tries to run biome, because we use Conform/LSP instead.
        opts.handlers.biome = function() end
      end
    end,
  },

  -- 3. LSP: Fix Linting Overlap (Red Squiggles)
  -- This ensures Biome LSP only starts if biome.json exists
  {
    "AstroNvim/astrolsp",
    opts = {
      config = {
        biome = {
          root_dir = require("lspconfig.util").root_pattern("biome.json", "biome.jsonc"),
        },
      },
    },
  },

  -- 4. CONFORM: Fix Formatting Overlap (Format on Save)
  -- This ensures Biome only formats if biome.json exists
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters = opts.formatters or {}

      local function has_formatter(ft)
        if not ft or ft == "" then return false end
        local entries = opts.formatters_by_ft[ft]
        if type(entries) == "table" and next(entries) then return true end
        for part in ft:gmatch("[^.]+") do
          entries = opts.formatters_by_ft[part]
          if type(entries) == "table" and next(entries) then return true end
        end
        entries = opts.formatters_by_ft._
        return type(entries) == "table" and next(entries) ~= nil
      end

      opts.format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if not has_formatter(ft) then return end
        return {
          timeout_ms = 500,
          lsp_format = "never",
        }
      end

      -- Define Biome with a condition check
      local function biome_condition(_, ctx)
        return vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.filename, upward = true })[1]
      end

      opts.formatters.biome = {
        require_cwd = true,
        condition = biome_condition,
      }

      opts.formatters["biome-check"] = {
        inherit = true,
        require_cwd = true,
        condition = biome_condition,
      }

      -- Add Biome to your filetypes
      local format_only = { "json", "jsonc" }
      for _, ft in ipairs(format_only) do
        opts.formatters_by_ft[ft] = { "biome" }
      end

      local organize_imports = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
      for _, ft in ipairs(organize_imports) do
        opts.formatters_by_ft[ft] = {
          "biome-check",
          "biome",
          stop_after_first = false,
        }
      end
    end,
  },
}
