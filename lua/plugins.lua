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

local function treesitterUpdate()
	local tsUpdate = require("nvim-treesitter.install").update({ with_sync = true })
	tsUpdate()
end

local function treesitterConfig()
	vim.o.foldlevel = 16

	vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
		group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
		callback = function()
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	})

	-- require('tsConfig')
end

function priv.HopConfig()
	local hop = require("hop")
	hop.setup({ keys = "etovxqpdygfblzhckisuran" })

	local directions = require("hop.hint").HintDirection
	vim.keymap.set("n", "<leader>f", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
	end, { remap = false })
	vim.keymap.set("n", "<leader>F", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
	end, { remap = false })
	vim.keymap.set("n", "<leader>t", function()
		hop.hint_char1({
			direction = directions.AFTER_CURSOR,
			current_line_only = true,
			hint_offset = -1,
		})
	end, { remap = false })
	vim.keymap.set("n", "<leader>T", function()
		hop.hint_char1({
			direction = directions.BEFORE_CURSOR,
			current_line_only = true,
			hint_offset = 1,
		})
	end, { remap = false })

	vim.keymap.set("n", "<leader>s", function()
		hop.hint_char1({ direction = nil, current_line_only = false })
	end, { remap = false })
	vim.keymap.set("n", "<leader><leader>f", function()
		hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false }, { remap = false })
	end)
	vim.keymap.set("n", "<leader><leader>F", function()
		hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = false }, { remap = false })
	end)
	vim.keymap.set("n", "<leader><leader>t", function()
		hop.hint_char1({
			direction = directions.AFTER_CURSOR,
			current_line_only = false,
			hint_offset = -1,
		})
	end, { remap = false })
	vim.keymap.set("n", "<leader><leader>T", function()
		hop.hint_char1({
			direction = directions.BEFORE_CURSOR,
			current_line_only = false,
			hint_offset = 1,
		})
	end, { remap = false })
end

function FzfGit()
	local hasGitIgnore = vim.fn.glob(".gitignore") ~= ""

	local srcCmd = nil -- nil command uses default file search
	if hasGitIgnore then
		srcCmd = "git ls-files"
	end

	local windowSize = { width = 0.9, height = 0.6 }
	vim.call("fzf#run", {
		source = srcCmd,
		sink = "e",
		window = windowSize,
	})
end

function AutopairsConfig(npairs)
	--local has_npairs, npairs               = pcall(require, 'nvim-autopairs')
	local has_cmp_autopairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
	local has_cmp, cmp = pcall(require, "cmp")
	local has_Rule, Rule = pcall(require, "nvim-autopairs.rule")
	local has_cond, cond = pcall(require, "nvim-autopairs.conds")

	if not (has_cmp_autopairs and has_cmp and has_Rule and has_cond) then
		return
	end

	if not AutopairsConfigSet then
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		AutopairsConfigSet = true
	end

	-- Add space between brackets
	local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
	npairs.add_rules({
		Rule(" ", " "):with_pair(function(opts)
			local pair = opts.line:sub(opts.col - 1, opts.col)
			return vim.tbl_contains({
				brackets[1][1] .. brackets[1][2],
				brackets[2][1] .. brackets[2][2],
				brackets[3][1] .. brackets[3][2],
			}, pair)
		end),
	})
	for _, bracket in pairs(brackets) do
		npairs.add_rules({
			Rule(bracket[1] .. " ", " " .. bracket[2])
				:with_pair(function()
					return false
				end)
				:with_move(function(opts)
					return opts.prev_char:match(".%" .. bracket[2]) ~= nil
				end)
				:use_key(bracket[2]),
		})
	end
end

function priv.LuaSnipConfig()
	local luasnip = require("luasnip")
	vim.keymap.set("s", "<Tab>", function()
		if luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		else
			return "<Tab>"
		end
	end, { expr = true })

	vim.keymap.set("i", "<Tab>", function()
		if luasnip.jumpable() then
			luasnip.jump(1)
		else
			return "<Tab>"
		end
	end, { expr = true })

	vim.keymap.set("i", "<S-Tab>", function()
		if luasnip.jumpable() then
			luasnip.jump(-1)
		else
			return "<C-d>"
		end
	end, { expr = true })
end

function priv.NvimTreeConfig()
	local has_tree, tree = pcall(require, "nvim-tree")
	local has_api, api = pcall(require, "nvim-tree.api")

	if not (has_tree and has_api) then
		return
	end

	tree.setup({
		sort_by = "case_sensitive",
		renderer = {
			group_empty = true,
			icons = {
				webdev_colors = true,
				git_placement = "before",
				modified_placement = "after",
				padding = " ",
				symlink_arrow = " ➛ ",
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
					modified = true,
				},
				glyphs = {
					default = "◆",
					symlink = "◇",
					bookmark = "▣",
					modified = "●",
					folder = {
						arrow_closed = " ",
						arrow_open = " ",
						default = "▶",
						open = "▼",
						empty = "▷",
						empty_open = "▽",
						symlink = "▶",
						symlink_open = "▼",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "␣",
						ignored = "◌",
					},
				},
			},
		},
	})

	vim.keymap.set("n", "<leader>z", function()
		--Open tree if not focused, close if focused
		if vim.bo.filetype == "NvimTree" then
			api.tree.close()
		else
			api.tree.open()
		end
	end)
	vim.keymap.set("n", "<leader>x", function()
		api.tree.close()
	end)
end

local function packerStartup(use)
	local vscode = vim.g.vscode == 1

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

	use({ "L3MON4D3/LuaSnip", config = priv.LuaSnipConfig() })
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

	use({
		"phaazon/hop.nvim",
		branch = "v2",
		config = priv.HopConfig,
	})

	-- Treesitter
	use({ "HiPhish/nvim-ts-rainbow2" })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = treesitterUpdate,
		config = treesitterConfig,
	})

	use({
		'~/Code/lua/fsharp-tools.nvim'
	})

	-- Outline view: LSP / Treesitter driven
	use({
		"stevearc/aerial.nvim",
		config = function()
			local aerial = require("aerial")
			aerial.setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "<M-n>", function()
						aerial.next(1)
					end, { buffer = bufnr, nowait = true })
					vim.keymap.set("n", "<M-b>", function()
						aerial.prev(1)
					end, { buffer = bufnr, nowait = true })
				end,
				--filter_kind = false,
			})

			vim.keymap.set("n", "<Leader>a", function()
				aerial.toggle({
					focus = true,
					direction = "right",
				})
			end)
		end,
	})

	-- Better Syntax Support
	use({ "sheerun/vim-polyglot" })
	-- File Explorer
	use({
		"nvim-tree/nvim-tree.lua",
		config = priv.NvimTreeConfig(),
	})

	-- Auto pairs for '(' '[' '{'
	use({
		"windwp/nvim-autopairs",
		requires = "hrsh7th/nvim-cmp",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				disable_in_visualblock = true,
				fast_wrap = {},
			})
			AutopairsConfig(npairs)
		end,
	})
	-- If you want insert `(` after select function or method item

	use({
		"junegunn/fzf",
		run = ":call fzf#install()",
		config = function()
			vim.keymap.set("n", "<M-p>", "<cmd>FZF<cr>")
			vim.keymap.set("n", "<C-p>", FzfGit)
		end,
	})

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
					-- null_ls.builtins.formatting.stylua,
					-- null_ls.builtins.diagnostics.eslint,
					-- null_ls.builtins.completion.spell,
				},
			})
		end,
	})

	use({
		'lukas-reineke/indent-blankline.nvim',
		config = function()
			require('indent_blankline').setup({
				-- enabled = false,
				show_current_context = false,
				show_current_context_start = false,
				char_blankline = '┆',
			})

			vim.keymap.set('n', '<leader>id', function()
				vim.cmd('IndentBlanklineDisable')
				vim.cmd('IndentBlanklineDisable!')
			end)
			vim.keymap.set('n', '<leader>ie', function()
				vim.cmd('IndentBlanklineEnable')
				vim.cmd('IndentBlanklineEnable!')
			end)
			vim.keymap.set('n', '<leader>it', function()
				vim.cmd('IndentBlanklineToggle')
				vim.cmd('IndentBlanklineToggle!')
			end)
			vim.keymap.set('n', '<leader>il', function() vim.cmd('IndentBlanklineToggle') end)
			vim.keymap.set('n', '<leader>ir', function() vim.cmd('IndentBlanklineRefresh') end)
		end
	})

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
