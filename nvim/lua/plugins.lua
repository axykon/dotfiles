-- local fn = vim.fn
-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
--   vim.cmd [[packadd packer.nvim]]
-- end
-- 
-- return require('packer').startup(function(use)
--  use 'wbthomason/packer.nvim'
--  use 'arcticicestudio/nord-vim'
--  use 'williamboman/mason.nvim'
--  use 'neovim/nvim-lspconfig'
--  use 'mfussenegger/nvim-jdtls'
--  use 'sainnhe/sonokai'
--  use 'aymericbeaumet/vim-symlink'
--  use 'tpope/vim-vinegar'
--  use 'tpope/vim-fugitive'
--  use 'tpope/vim-rhubarb'
--  use 'junegunn/gv.vim'
--  use 'numToStr/Comment.nvim'
--  use 'vim-test/vim-test'
--  use 'ghifarit53/tokyonight-vim'
--  use 'hrsh7th/cmp-nvim-lsp'
--  use 'hrsh7th/nvim-cmp'
--  use 'L3MON4D3/LuaSnip'
--  use 'saadparwaiz1/cmp_luasnip'
--  use 'sainnhe/edge'
--  use 'towolf/vim-helm'
--  use 'tanvirtin/monokai.nvim'
--  use 'airblade/vim-rooter'
--  use 'jbyuki/venn.nvim'
--  use 'nvim-telescope/telescope-ui-select.nvim'
--  use {
--      'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = 'nvim-lua/plenary.nvim'
--  }
--  use 'nvim-telescope/telescope-project.nvim'
--  use 'nvim-treesitter/nvim-treesitter'
--  use 'sainnhe/everforest'
--  use 'sainnhe/gruvbox-material'
--  use {
--      'nvim-lualine/lualine.nvim',
--      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
--  }
--   -- Automatically set up your configuration after cloning packer.nvim
--   -- Put this at the end after all plugins
--   if packer_bootstrap then
--     require('packer').sync()
--   end
-- end)
--
return {
  {
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { {'nvim-lua/plenary.nvim'}, {'nvim-tree/nvim-web-devicons'} },
    lazy = false,
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader><space>', builtin.buffers, {})
      vim.keymap.set('n', '<leader>?', builtin.oldfiles, {})
	  vim.keymap.set('n', '<leader>g', builtin.git_files)
    end
  },
  {
    'TimUntersberger/neogit',
    dependencies = {{ 'nvim-lua/plenary.nvim' }},
  },
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    config = function()
		require('mason').setup() 
		require('mason-lspconfig').setup()
	end,
	lazy = false,
  },
  {
	  'williamboman/mason-lspconfig.nvim',
	  lazy = false,
  },
  {
	  'neovim/nvim-lspconfig',
	  lazy = false,
	  config = function()
		  require('lspconfig').gopls.setup {}
	  end,
  },
  {
	  'mfussenegger/nvim-jdtls',
  },
  {
	  'weirongxu/plantuml-previewer.vim',
	  dependencies = {{'tyru/open-browser.vim'}},
	  config = function()
		  vim.g['plantuml_previewer#plantuml_jar_path'] = vim.fn.expand('~/.local/lib/java/plantuml.jar')
		  vim.g['plantuml_previewer#save_format'] = 'svg'
	  end,
  },
  {
	  'nvim-lualine/lualine.nvim',
	  dependencies = {{ 'nvim-tree/nvim-web-devicons' }},
	  config = function()
		  require('lualine').setup()
	  end
  },
  'tpope/vim-fugitive',
}
