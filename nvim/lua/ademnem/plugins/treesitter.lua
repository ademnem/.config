return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"lua",
			"luadoc",
			"make",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",

			"css",
			"html",
			"javascript",
			"typescript",
		},

		auto_install = true,

		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
	},
}
