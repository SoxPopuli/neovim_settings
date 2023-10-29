local plugins = {}

local priv = {}
plugins.priv = plugins

AutopairsConfigSet = false

local configPath = vim.fn.stdpath("config")
local dataPath = vim.fn.stdpath("data")

local packerPath = dataPath .. [[/site/pack/packer/start/packer.nvim]]
packerPath = packerPath:gsub([[\]], [[\\]]) -- Escape path separators on Windows

function plugins.CheckPackerExists()
	if vim.fn.glob(packerPath) == "" then
		return false
	else
		return true
	end
end

function plugins.InstallPacker()
	local repo = "https://github.com/wbthomason/packer.nvim"
	vim.cmd([[!mkdir -pv ]] .. packerPath)
	vim.cmd([[!git clone --depth 1 ]] .. repo .. " " .. packerPath)
	vim.cmd([[packadd packer.nvim]])
end

local function packerStartup(use)
	use({ "nvim-lualine/lualine.nvim" })

	use({
		"j-hui/fidget.nvim",
		branch = "legacy",
		config = function()
			require("fidget").setup({
				text = { spinner = "bouncing_ball" }
			})
		end,
	})

	use("wbthomason/packer.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-repeat")

	use({ "preservim/nerdcommenter" })

	use({ "dracula/vim", as = "dracula" })
	use({ "catppuccin/nvim", as = "catppuccin" })

	use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

	-- LSP plugins
	use {
		{ "neovim/nvim-lspconfig" },
		{ "williamboman/mason.nvim",          run = ":masonupdate" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "simrat39/rust-tools.nvim" },
	}

	use({ "L3MON4D3/LuaSnip" })
	use({ "saadparwaiz1/cmp_luasnip" })

	use {
		'ionide/Ionide-vim',
		config = function()
			vim.g['fsharp#backend'] = 'disable'
			vim.g['fsharp#lsp_auto_setup'] = 0
			vim.g['fsharp#lsp_codelens'] = 0
			vim.g['fsharp#use_recommended_server_config'] = 0
		end
	}

	use({ "simrat39/inlay-hints.nvim" })
	-- use { 'lvimuser/lsp-inlayhints.nvim' }

	use({ "hrsh7th/nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp-signature-help" })

	use({
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", function()
				vim.cmd.UndotreeToggle()
			end)
		end,
	})

	use({
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>g", function()
				vim.cmd.Git()
			end)
		end,
	})

	-- Debugger protocol support
	use({ "mfussenegger/nvim-dap" })
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function ()
			local tsUpdate = require("nvim-treesitter.install").update({ with_sync = true })
			tsUpdate()
		end,
	})

	use({ "HiPhish/rainbow-delimiters.nvim", requires = { "nvim-treesitter/nvim-treesitter" } })
	--use({ "~/Code/lua/rainbow-delimiters.nvim", requires = { "nvim-treesitter/nvim-treesitter" } })

	use({ 'SoxPopuli/fsharp-tools.nvim' })

	-- Outline view: LSP / Treesitter driven
	use({ "stevearc/aerial.nvim" })

	-- Better Syntax Support
	use({ "sheerun/vim-polyglot" })
	-- File Explorer
	use({ "nvim-tree/nvim-tree.lua" })

	-- Auto pairs for '(' '[' '{'
	use({
		"windwp/nvim-autopairs",
		requires = "hrsh7th/nvim-cmp",
	})
	-- If you want insert `(` after select function or method item

	-- tmux integration
	use({ "aserowy/tmux.nvim" })

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.fantomas,
					null_ls.builtins.formatting.prettier,
				},
			})
		end,
	})

	-- Async linting
	use('mfussenegger/nvim-lint')

	use({
		'lukas-reineke/indent-blankline.nvim',
		tag = 'v2.20.8',
	})

	use({
		'ldelossa/gh.nvim',
		requires = { { 'ldelossa/litee.nvim' } }
	})


	use {
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use({ 'nvim-telescope/telescope-ui-select.nvim', requires = { 'nvim-telescope/telescope.nvim' } })

	use({'nvim-tree/nvim-web-devicons'})

	use({ 'johmsalas/text-case.nvim', requires = { 'nvim-telescope/telescope.nvim'  } })

	use({ 'rescript-lang/vim-rescript' })

	-- Keep at end - downloads updates
	if plugins.CheckPackerExists() then
		require("packer").sync()
	end
end

function plugins.startup()
	require("packer").startup({
		packerStartup,
		config = {
			display = {
				open_fn = require("packer.util").float,
			},
		},
	})
end

return plugins
