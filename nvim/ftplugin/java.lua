local jdtls = require('jdtls')
local root_markers = {'gradlew', '.git'}
local root_dir = require('jdtls.setup').find_root(root_markers)
local home = os.getenv('HOME')
local workspace_dir = home .. "/.local/cache/nvim-jdtls/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local config = {
	cmd = {
		'jdtls',
		'--jvm-arg=-javaagent:' .. vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar',
		'-data', workspace_dir,
	},
	capabilities = capabilities,
	root_dir = root_dir,
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = 'fernflower' },
			configuration = {
				runtimes = {
					{ name = "JavaSE-11", path = "/usr/lib/jvm/java-1.11.0-openjdk-amd64" },
					{ name = "JavaSE-17", path = "/usr/lib/jvm/java-1.17.0-openjdk-amd64" }
				}
			}
		}
	},
	init_options = {
		bundles = {}
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
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
	end
}


jdtls.start_or_attach(config)
require('jdtls.setup').add_commands()
