local highlight = {
    "RainbowCyan",
}

vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#61AFEF"})

require("ibl").setup { scope = { highlight = highlight } }
