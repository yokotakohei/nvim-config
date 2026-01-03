return {
  "zbirenbaum/copilot-cmp",
  dependencies = { "copilot.lua" },
  lazy = true,
  config = function()
    require("copilot_cmp").setup()
  end,
}
