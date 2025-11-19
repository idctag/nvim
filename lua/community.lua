---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- MISC
  { import = "astrocommunity.motion.mini-move" },
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.fuzzy-finder.snacks-picker" },
  -- Language packs
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.go" },
  -- { import = "astrocommunity.pack.ruby" },
  -- COMPLETION
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
}
