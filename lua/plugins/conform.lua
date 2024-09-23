return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        default_format_opts = {
            lsp_format = "fallback",
        },
        format_on_save = function(bufnr)
            -- Disable "format_on_save lsp_fallback" for languages that don't
            -- have a well standardized coding style. You can add additional
            -- languages here or re-enable it for the disabled ones.
            local disable_filetypes = { c = true, cpp = true }
            local lsp_format_opt
            if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = "never"
            else
                lsp_format_opt = "fallback"
            end
            return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            html = { "prettier" },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            -- You can use 'stop_after_first' to run the first available formatter from the list
            javascript = { "prettier" },
        },
        formatters = {
            prettier = {
                command = "prettier",
                args = {
                    "--stdin-filepath",
                    "$FILENAME",
                    "--tab-width",
                    "4",
                    "--trailing-comma",
                    "es5",
                },
                stdin = true,
            },
            stylua = {
                prepend_args = {
                    "--config-path",
                    vim.fn.expand("~/.config/stylua/stylua.toml"),
                },
            },
        },
    },
}
