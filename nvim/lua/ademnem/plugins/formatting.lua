return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>fb",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = { "n", "v" },
			desc = "[F]ormat [B]uffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- disable "format_on_save lsp_fallback" for langs that don't have a standardized coding style
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},

	-- download formatters through mason-tool-installer.nvim in lsp.lua
	--[[
		local registry = require("mason-registry")
		local Package = require("mason-core.package")
		for _, formatters in pairs(opts.formatters_by_ft) do
			for _, f in ipairs(formatters) do
				local package_name, version = Package.Parse(f)
				local pkg = registry.get_package(package_name)
				if not pkg:is_installed() then
					pkg:install({ version = version })
				end
			end
		end
        ]]
	--
}
