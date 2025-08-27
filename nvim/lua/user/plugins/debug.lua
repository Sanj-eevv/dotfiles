return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mfussenegger/nvim-dap" },
        opts = {
            ensure_installed = { "php-debug-adapter" },
            automatic_installation = true,
            handlers = {
                function(config)
                    require("mason-nvim-dap").default_setup(config)
                end,
                php = function(config)
                    local dap = require("dap")
                    dap.adapters.php = {
                        type = "executable",
                        command = "node",
                        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" }
                    }
                    dap.configurations.php = {
                        {
                            type = "php",
                            request = "launch",
                            name = "Listen for Xdebug",
                            port = 9003,
                            pathMappings = {
                            },
                        },
                        {
                            type = "php",
                            request = "launch",
                            name = "Launch current script",
                            program = "${file}",
                            cwd = "${fileDirname}",
                            runtimeArgs = { "-dxdebug.start_with_request=yes" },
                            env = {
                                XDEBUG_MODE = "debug,develop",
                                XDEBUG_CONFIG = "client_port=9003",
                            },
                        },
                    }
                end,
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "jay-babu/mason-nvim-dap.nvim",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { "<F5>",       function() require("dap").continue() end,                                desc = "Debug: Continue" },
            { "<leader>dn", function() require("dap").step_over() end,                               desc = "Debug: Next (Step Over)" },
            { "<leader>di", function() require("dap").step_into() end,                               desc = "Debug: Into (Step Into)" },
            { "<leader>do", function() require("dap").step_out() end,                                desc = "Debug: Out (Step Out)" },
            { "<leader>db", function() require("dap").toggle_breakpoint() end,                       desc = "Toggle Breakpoint" },
            { "<leader>dr", function() require("dap").repl.open() end,                               desc = "Open REPL" },
            { "<leader>du", function() require("dapui").toggle() end,                                desc = "Toggle DAP UI" },
            { "<leader>dt", function() require("dapui").toggle() end,                                desc = "Toggle DAP UI" },
            { "<leader>dx", function() require("dap").terminate() end,                               desc = "Debug: Terminate Session" },
            { "<leader>dd", function() require("dap").disconnect({ terminateDebuggee = false }) end, desc = "Debug: Disconnect (keep process)" },
        },
        config = function()
            local signs = {
                DapBreakpoint          = "🔴",
                DapBreakpointCondition = "🟡",
                DapLogPoint            = "💬",
                DapStopped             = "▶️",
                DapBreakpointRejected  = "❌",
            }
            for name, text in pairs(signs) do
                vim.fn.sign_define(name, { text = text, texthl = "", linehl = "", numhl = "" })
            end
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
            controls = { enabled = true },
            layouts = {
                {
                    elements = { "breakpoints", "watches" },
                    position = "left",
                    size = 40,
                },
                {
                    elements = { "scopes" },
                    position = "right",
                    size = 40,
                },
                {
                    elements = { "stacks" },
                    position = "bottom",
                    size = 10,
                },
            },
            floating = { border = "rounded", mappings = { close = { "q", "<Esc>" } } },
        },
        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                show_stop_reason = true,
                only_first_definition = false,
                all_references = true,
                virt_text_pos = 'eol',
                all_frames = false,
            })
        end
    },
}
