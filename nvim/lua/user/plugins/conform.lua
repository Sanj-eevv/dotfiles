return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				local conform = require("conform")
				local bufnr = vim.api.nvim_get_current_buf()
				local formatters, use_lsp = conform.list_formatters_to_run(bufnr)
				local names = {}
				for _, info in ipairs(formatters) do
					table.insert(names, info.name)
				end
				if use_lsp then
					table.insert(names, "lsp")
				end
				if #formatters > 0 then
					print("Formatter(s) used: " .. table.concat(names, ", "))
					conform.format({
						async = true,
					})
				else
					print("No formatter configured for this file type.")
				end
			end,
			mode = "",
			desc = "Format current file",
		},
	},
	opts = {
		formatters_by_ft = {
			php = { "pint", lsp_format = "fallback" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			javascriptreact = { "prettierd" },
			vue = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			json = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			blade = { "blade-formatter" },
			lua = { "stylua" },
			tailwind = { "prettierd" },
		},
	},
}
