--@diagnostic disable: undefined-doc-name, undefined-field
return {

	-- LSP Downloads Manager
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {},
	},
	-- documentation = ':h mason-lspconfig-automatic-server-setup'
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {},
	},

	-- NeoVim LSP Config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason.nvim",
			"mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			-- configure LSPs
			vim.lsp.config["luals"] = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", "luarc.jsonc" },
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						runtime = {
							version = "LuaJIT",
						},
					},
				},
			}

			-- enable LSPs
			vim.lsp.enable("luals")

			vim.api.nvim_create_autocmd({ "LspAttach" }, {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local tb = require("telescope.builtin")
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					map("<leader>gr", tb.lsp_references, "[G]oto [R]eferences")
					map("<leader>gd", tb.lsp_definitions, "[G]oto [D]efinitions")
					map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration") -- header for C
					map("<leader>gS", tb.lsp_document_symbols, "[G]et [S]ymbols")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
							end,
						})
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local servers = {
				clangd = {},
				cssls = {},
				html = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				ts_ls = {},
			}
			local formatters = {
				stylua = {},
				prettier = {},
				prettierd = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, vim.tbl_keys(formatters or {}))

			-- I can extend this list to include formatters and linters but that is handled separately
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				ensure_installed = {}, -- downloaded through mason-tool-installer
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
