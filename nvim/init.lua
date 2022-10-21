require "plugins"

vim.o.completeopt = 'menu,menuone,noselect'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.completeopt = 'menu'
vim.o.showcmd = false
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.cmd 'colorscheme sonokai'

if vim.g.neovide then
  -- vim.g.neovide_cursor_trail_legnth = 0
  -- vim.g.neovide_cursor_animation_length = 1
  vim.o.guifont = 'Iosevka:h18'
end

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank() end
})

require('mason').setup{}
require('Comment').setup{}

local luasnip = require('luasnip')
vim.keymap.set({'i', 's'}, '<Tab>', function() if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end end, { silent = true })
vim.keymap.set({'i', 's'}, '<S-Tab>', function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end, {silent = true})

local cmp = require('cmp')
cmp.setup {
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
		 sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    })
}


-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<space>pr', require('telescope').extensions.project.project, opts)
vim.keymap.set('n', '<space><space>', telescope_builtin.buffers, opts)
vim.keymap.set('n', '<space>?', telescope_builtin.oldfiles, opts)
vim.keymap.set('n', '<space>gf', telescope_builtin.git_files, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

	vim.keymap.set('n', '<space>ds', telescope_builtin.lsp_document_symbols, bufopts)
end

local lspconfig = require('lspconfig')
lspconfig['tsserver'].setup{
    on_attach = on_attach,
    flags = lsp_flags
}

lspconfig['bashls'].setup {
	on_attach = on_attach,
	flags = lsp_flags
}

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig['gopls'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
		capabilities = capabilities,
		settings = {
			gopls = {
				usePlaceholders = true
			}
		}
}
lspconfig['rust_analyzer'].setup{
    on_attach = on_attach,
    flags = lsp_flags,
		capabilities = capabilities,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
lspconfig['clojure_lsp'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
}

require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {}
    },
		project = {
			base_dirs = { '~/pro' }
		}
  }
}

require('telescope').load_extension("ui-select")
require('telescope').load_extension('project')

require('lualine').setup {
	options = {
		section_separators = '',
		component_separators = '',
	}
}
