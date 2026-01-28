return {
	"zbirenbaum/copilot.lua",
	dependencies = {
		"copilotlsp-nvim/copilot-lsp", -- optional for NES functionality
	},
	suggestion = { enabled = false },
	panel = { enabled = false },
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({})
	end,
}
