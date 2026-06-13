vim.pack.add({ "https://github.com/kaicataldo/material.vim" })

vim.g.material_theme_style = "palenight"

-- barbar colors
vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#000000" })

vim.cmd.colorscheme("material")
