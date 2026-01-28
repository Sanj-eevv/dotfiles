return {
	"saghen/blink.cmp",
	dependencies = {
		{
			"giuxtaposition/blink-cmp-copilot",
		},
		"rafamadriz/friendly-snippets",
	},
	version = "1.*",
	opts = {
		keymap = { preset = "super-tab" },
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = { documentation = { auto_show = true }, ghost_text = { enabled = true } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = { enabled = true },
	},
	opts_extend = { "sources.default" },
}
