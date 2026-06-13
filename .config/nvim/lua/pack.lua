vim.pack.add({
	"https://github.com/stevearc/oil.nvim", -- not configured
    "https://github.com/malewicz1337/oil-git.nvim",

	"https://github.com/windwp/nvim-autopairs", -- not configured

	"https://github.com/nvim-tree/nvim-web-devicons", -- not configured

	"https://github.com/nvim-lualine/lualine.nvim", -- not configured

	"https://github.com/goolord/alpha-nvim",

	"https://github.com/lewis6991/gitsigns.nvim", -- not configured

	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim", -- not configured

	"https://github.com/stevearc/conform.nvim", -- not configured

	"https://github.com/folke/which-key.nvim", -- not configured

	"https://github.com/akinsho/toggleterm.nvim", -- not configured

	"https://github.com/NMAC427/guess-indent.nvim",

	"https://github.com/lukas-reineke/indent-blankline.nvim",

	"https://github.com/romgrk/barbar.nvim",

	"https://github.com/nvim-mini/mini.nvim",

	-- LSP CONFIGURATION
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	"https://github.com/j-hui/fidget.nvim",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/neovim/nvim-lspconfig",
})

require("plugins.oil")
require("plugins.treesitter")
require("plugins.autopairs")
require("plugins.web-devicons")
require("plugins.lualine")
require("plugins.alpha")
require("plugins.gitsigns")
require("plugins.telescope")
require("plugins.conform")
require("plugins.which-key")
require("plugins.toggleterm")
require("plugins.autocomplete")
require("plugins.guess-indent")
require("plugins.ibl")
require("plugins.barbar")
require("plugins.mini")

require("plugins.mason")
