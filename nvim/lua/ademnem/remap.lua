vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--[[ REMAPS ]]
--
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>vs", vim.cmd.vs)
vim.keymap.set("n", "<leader>hs", vim.cmd.sp)

-- "* or "+ for copy into clipboard?

--[[ TERMINAL ]]
--
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})
vim.keymap.set("n", "<leader>ts", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 10)
end)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

--[[ VISUAL EFFECTS ]]
--
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
