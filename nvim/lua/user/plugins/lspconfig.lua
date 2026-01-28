return {
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"intelephense",
					"ts_ls",
					"vue_ls",
					"tailwindcss",
				},
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
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.enable({ "lua_ls", "intelephense", "ts_ls", "vue_ls", "tailwindcss" })

			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
			vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>")
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>")

			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
		end,
	},
}
