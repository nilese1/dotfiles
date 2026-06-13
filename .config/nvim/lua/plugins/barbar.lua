vim.g.barbar_auto_setup = false
local opts = { noremap = true, silent = true }

-- Move to previous/next
vim.api.nvim_set_keymap("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
vim.api.nvim_set_keymap("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)

-- Re-order to previous/next
vim.api.nvim_set_keymap("n", "<Tab-<>", "<Cmd>BufferMovePrevious<CR>", opts)
vim.api.nvim_set_keymap("n", "<Tab->>", "<Cmd>BufferMoveNext<CR>", opts)

-- Close buffer
vim.api.nvim_set_keymap("n", "<leader>x", "<Cmd>BufferClose<CR>", opts)

require("barbar").setup({
	animation = true,
	insert_at_start = true,
	icons = {
		button = "",
	},
})

vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#cdd6f4", bg = "#1e1e2e", bold = true })
vim.api.nvim_set_hl(0, "BufferCurrentMod", { fg = "#cdd6f4", bg = "#1e1e2e", bold = true })
vim.api.nvim_set_hl(0, "BufferCurrentSign",   { fg = "#89b4fa", bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "BufferCurrentIcon",   { bg = "#1e1e2e" })
