local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if vim.fn.isdirectory(lazypath) == 0 then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = 'menu,menuone'
vim.o.showmode = false

require('lazy').setup('plugins')

-- LSP
vim.api.nvim_create_autocmd('LspAttach', { 
	group = vim.api.nvim_create_augroup('LSP', {}),
	desc = 'LSP configuration',
	callback = function(args) 
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, silent = true })
		vim.keymap.set('n', '<leader>o', require('telescope.builtin').lsp_document_symbols, { buffer = args.buf, silent = true })
	end,
})
