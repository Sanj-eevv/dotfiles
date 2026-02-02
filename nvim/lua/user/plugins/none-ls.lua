return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = true,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					"stylua",
					"blade-formatter",
					"pint",
					"eslint_d",
					"prettierd",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls-extras.nvim" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.blade_formatter,
					null_ls.builtins.formatting.pint,
					require("none-ls.diagnostics.eslint_d"),
					require("none-ls.code_actions.eslint_d"),
					null_ls.builtins.formatting.prettierd,
					null_ls.builtins.completion.tags,
					null_ls.builtins.diagnostics.todo_comments,
					null_ls.builtins.diagnostics.trail_space,
					null_ls.builtins.formatting.shfmt,
				},
			})
		end,
	},
}
