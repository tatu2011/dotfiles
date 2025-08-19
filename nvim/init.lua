-- Basic config
require("core.mappings")
require("core.plugins")
vim.opt.number = true        -- Включает нумерацию строк


require("autoclose").setup()
require'lspconfig'.pyright.setup{}
require("plugins.treesitter")
require('plugins.cmp')

local lspconfig = require('lspconfig')


lspconfig.clangd.setup {
  capabilities = capabilities,
}
