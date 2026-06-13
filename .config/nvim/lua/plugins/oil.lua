require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "\\", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- vim.cmd.packadd("oil-git")
require("oil-git").setup({
    show_branch = false,
})
