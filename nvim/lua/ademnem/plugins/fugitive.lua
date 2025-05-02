return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{ "<leader>gs", vim.cmd.Git, desc = "Git" },
		--[[ 
        Keymappings in Fugitive
        - s = stage
        - u = unstage
        - U = unstage everything
        - X = discard changes under the cursor 
        - dd = diff split
        - dv = diff split but always vertical split
        - cc = create commit
        - ca = amend last commit and edit message
        - ce = amend last commit without editting
        - cw = reword last commit
        ]]
		--
	},
}
