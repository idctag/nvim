---@type LazySpec
return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      local root_has_biome = vim.fs.find("biome.json", { upward = true })[1] ~= nil
      if root_has_biome then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      local root_has_biome = vim.fs.find("biome.json", { upward = true })[1] ~= nil
      if root_has_biome then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local root_has_biome = vim.fs.find("biome.json", { upward = true })[1] ~= nil
      if root_has_biome then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "biome" })
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local root_has_biome = vim.fs.find("biome.json", { upward = true })[1] ~= nil
      if not root_has_biome then return end

      if not opts.formatters_by_ft then opts.formatters_by_ft = {} end

      local supported_ft = {
        "astro",
        "css",
        "graphql",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
      }

      for _, ft in ipairs(supported_ft) do
        opts.formatters_by_ft[ft] = { "biome" }
      end
    end,
  },
}
