return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        -- Creates table for default LSP and cmp lsp capabilities
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ruff",
                "lua_ls",
                "pyright",
            },
            handlers = {
                function(server_name) -- default handler
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

            }
        })

        require("lspconfig").pyright.setup {
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { '*' },
              },
            },
          },
        }

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' }
            }, {
                { name = 'buffer' },
            })
        })
        vim.diagnostic.config({
            float = {
                style = "minimal",
                border = "rounded",
                source = "always",
            },
        })
       vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client == nil then
              return
            end
            if client.name == 'ruff' then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end,
          desc = 'LSP: Disable hover capability from Ruff',
        })
    end
}




