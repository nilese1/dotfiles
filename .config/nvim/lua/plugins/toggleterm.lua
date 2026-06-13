require("toggleterm").setup({
	size = 10, -- default height/width
	open_mapping = [[<leader>h]], -- key to toggle terminal
	direction = "horizontal", -- or "vertical" | "float"
	autochdir = true,
	insert_mappings = false,
	terminal_mappings = false,
})
