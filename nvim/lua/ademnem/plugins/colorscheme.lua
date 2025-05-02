return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000, -- default priority is 50
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
