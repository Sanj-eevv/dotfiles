local servers = { "lua_ls", "intelephense", "ts_ls", "vue_ls", "tailwindcss", "bashls", "harper_ls" }

return {
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = servers,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy",
		dependencies = {
			"b0o/schemastore.nvim",
			"saghen/blink.cmp",
		},
		opts = {
			servers = {
				harper_ls = {
					settings = {
						harper = {
							linters = {
								sentence_capitalization = false,
								spell_check = true,
								repeated_words = true,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			for server, server_opts in pairs(opts.servers or {}) do
				vim.lsp.config(server, server_opts)
			end

			vim.lsp.enable(servers)

			vim.lsp.inlay_hint.enable(true)

			-- Navigation
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to definition" })
			vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to implementation" })
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "Go to references" })

			-- Actions
			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

			-- Inlay hints toggle
			vim.keymap.set("n", "<leader>uh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle inlay hints" })
		end,
	},
}
