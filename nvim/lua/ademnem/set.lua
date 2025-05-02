-- Set Options File

local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd

-- Cursor
set.guicursor = "n:blinkon0"

-- Line Numbers
set.nu = true
-- set.relativenumber = true

-- Line Wrap
set.wrap = false
vim.api.nvim_create_user_command("ToggleTextWrap", function()
	vim.wo.wrap = not vim.wo.wrap
	print("TextWrap = " .. (vim.wo.wrap and "ON" or "OFF"))
end, {})

-- Tabs and Indentations
set.shiftwidth = 4 -- spaces per tab (when shifting)
set.tabstop = 4 -- spaces per tab
set.softtabstop = 4
set.expandtab = true
set.smartindent = true

-- Screen Splits
set.splitbelow = true -- open horizontal splits below current window
set.splitright = true -- open vertical splits to the right of the current window

-- Undos and Backups
set.swapfile = false
set.backup = false
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- Search Files
set.hlsearch = false
set.incsearch = true

-- Colors
set.termguicolors = true

-- Fast Update Time
set.updatetime = 50

-- Remove New Line Comments
autocmd({ "BufEnter", "BufNewFile" }, {
	callback = function()
		vim.o.showtabline = 0
	end,
	desc = "Disable Tabline",
})

autocmd("BufEnter", {
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
	desc = "Disable New Line Comment",
})
