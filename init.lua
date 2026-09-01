-- Leader must be set before lazy.setup() runs: lazy resolves the `<leader>` in
-- every spec's `keys` while it builds the lazy-load triggers, so setting it later
-- leaves those triggers bound to the default `\`.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lazy Package Manager Configuration -> Installs package manager by git clone if it doesn’t exist
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "https://github.com/folke/lazy.nvim", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup({
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		branch = "master",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		modes = {
			qflist = {
				win = {
					type = "split",
					position = "right",
					size = 60, -- width in columns
				},
			},
		},

		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		-- setup() runs later in this file, once the installed colorscheme list can
		-- be enumerated. Calling it here as well would just be overwritten.
		"zaldih/themery.nvim",
		lazy = false,
	},
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},
	-- lazy.nvim (always latest stable release)
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon",
				dark_variant = "moon",
				-- Custom: rose-pine paints most identifiers in `text` (#e0def4),
				-- which reads as a wall of white. Pull variables and functions
				-- off `text` and onto palette colours.
				highlight_groups = {
					-- Functions / methods -> gold
					["Function"] = { fg = "gold" },
					["@function"] = { fg = "gold" },
					["@function.call"] = { fg = "gold" },
					["@function.method"] = { fg = "gold" },
					["@function.method.call"] = { fg = "gold" },
					["@function.builtin"] = { fg = "gold", italic = true },
					["@constructor"] = { fg = "gold" },

					-- Variables -> foam
					["Identifier"] = { fg = "foam" },
					["@variable"] = { fg = "foam" },
					["@variable.builtin"] = { fg = "love", italic = true },

					-- Parameters -> rose, so they stand apart from locals
					["@variable.parameter"] = { fg = "rose", italic = true },

					-- Object fields / properties -> iris
					["@variable.member"] = { fg = "iris" },
					["@property"] = { fg = "iris" },
					["@field"] = { fg = "iris" },

					-- LSP semantic tokens override treesitter, so mirror them
					["@lsp.type.function"] = { fg = "gold" },
					["@lsp.type.method"] = { fg = "gold" },
					["@lsp.type.variable"] = { fg = "foam" },
					["@lsp.type.parameter"] = { fg = "rose", italic = true },
					["@lsp.type.property"] = { fg = "iris" },
				},
			})
			vim.cmd.colorscheme("rose-pine-moon")
		end
	},
	{ "vague-theme/vague.nvim" },
	{ "olimorris/onedarkpro.nvim" },
	{
		-- Kept installed so it still shows up in the Themery picker.
		"luisiacc/gruvbox-baby",
		config = function()
			vim.g.gruvbox_baby_function_style = "NONE"
			vim.g.gruvbox_baby_keyword_style = "italic"
			vim.g.gruvbox_baby_telescope_theme = 1
			vim.g.gruvbox_baby_background_color = "dark"
		end
	},
	{ "rebelot/kanagawa.nvim" },
	{ "dapovich/anysphere.nvim" },
	{ "AlexvZyl/nordic.nvim" },
	{ "Mofiqul/vscode.nvim" },
	{ "scottmckendry/cyberdream.nvim" },
	{ "shaunsingh/nord.nvim" },
	{ "olivercederborg/poimandres.nvim" },
	{
		"felipeagc/fleet-theme-nvim",
	},

	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Native fzf sorter: the pure-Lua fallback is slow over a repo this size
			-- (~22k TS + ~17k Ruby files).
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		-- Previously a bare `defaults` key sat here, which is not part of lazy.nvim's
		-- spec format and was silently ignored; the real options were in a top-level
		-- setup() call that forced telescope to load on every startup.
		config = function()
			require('telescope').setup {
				defaults = {
					-- "filename_first" only exists on telescope master, not the pinned
					-- 0.1.8. This function replicates it: show the filename first, then
					-- dim the containing directory, so the filename is always visible
					-- (and never the part that gets truncated when the row is narrow).
					path_display = function(_, path)
						local tail = require("telescope.utils").path_tail(path)
						local dir = vim.fn.fnamemodify(path, ":~:.:h")
						if dir == "." or dir == "" then
							return tail
						end
						local transformed = string.format("%s  %s", tail, dir)
						-- dim everything after the filename (the directory portion)
						return transformed, { { { #tail, #transformed }, "TelescopeResultsComment" } }
					end,
					-- Preview title shows the entry's display (filename-first) instead
					-- of a truncated path, so the filename stays visible over folders.
					dynamic_preview_title = true,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--fixed-strings", -- This will force literal searches by default
					},
					mappings = {
						i = {
							["<C-q>"] = function(bufnr)
								require("telescope.actions").send_to_qflist(bufnr)
								require("trouble").open("qflist")
							end,
						},
						n = {
							["<C-q>"] = function(bufnr)
								require("telescope.actions").send_to_qflist(bufnr)
								require("trouble").open("qflist")
							end,
						},
					},
				},
				extensions = {
					fzf = {},
				},
			}
			-- Must come after setup(); this is what swaps in the native sorter.
			require('telescope').load_extension('fzf')
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree", -- the <leader>e mapping below goes through :Neotree
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		-- These must carry their rhs here rather than being re-declared with
		-- vim.keymap.set further down: lazy deletes the lhs it owns once the plugin
		-- loads, which would take a separately-declared mapping with it.
		keys = {
			{
				"<leader>a",
				function() require("harpoon"):list():add() end,
				desc = "Harpoon add file",
			},
			{
				"<C-e>",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Harpoon quick menu",
			},
		},
		config = function()
			-- Scope each harpoon list to cwd + git branch, so switching branches
			-- switches marks instead of sharing one list across all of them.
			require("harpoon"):setup({
				settings = {
					key = function()
						local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
						if branch == nil or branch == "" then
							return vim.loop.cwd()
						end
						return vim.loop.cwd() .. "-" .. branch
					end,
				},
			})
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			options = {
				theme = 'auto',
				section_separators = '',
				component_separators = '',
			},
			sections = {
				lualine_a = { 'mode' },
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = {},
				lualine_y = { 'progress' },
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		},
	},
	{ 'neovim/nvim-lspconfig',       dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' } },
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'L3MON4D3/LuaSnip',
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup({
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
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				}),
				formatting = {
					format = function(entry, item)
						-- tsserver offers the same symbol from several modules — `useMemo`
						-- comes from both `react` and `storybook/internal/preview-api` with
						-- identical sortText — so without the module in the menu those rows
						-- are indistinguishable and it is easy to auto-import from the
						-- wrong package. typescript-language-server puts the specifier in
						-- `detail` (it does not send labelDetails). After resolve, `detail`
						-- holds a type signature instead, so only surface it while it still
						-- looks like a module path.
						local detail = entry.completion_item.detail
						if detail and detail ~= '' and not detail:find('[%s()]') then
							if #detail > 30 then
								detail = '…' .. detail:sub(-29)
							end
							item.menu = detail
						end
						return item
					end,
				},
			})
		end,
	},
	-- cmp-nvim-lsp stays eager: default_capabilities() is needed at LSP-setup time,
	-- and it is a tiny module that does not pull in cmp itself.
	{ 'hrsh7th/cmp-nvim-lsp' },
	-- The source plugins are listed as *dependencies of cmp* (below), not the other
	-- way round. Depending on cmp would make each source a top-level eager plugin
	-- and drag cmp + LuaSnip into startup with them.
	{ 'hrsh7th/cmp-buffer',       lazy = true },
	{ 'hrsh7th/cmp-path',         lazy = true },
	{ 'saadparwaiz1/cmp_luasnip', lazy = true },
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.0", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		enabled = true,
		lazy = true,    -- pulled in by cmp_luasnip on InsertEnter
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy",
		opts = {
			select = {
				backend = { "telescope", "fzf_lua", "nui", "builtin" },
				builtin = {
					border = "rounded",
					relative = "cursor",
					max_height = 0.4,
					min_height = 4,
				},
			},
		},
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		opts = {
			-- biome is this repo's formatter of record (biome.json at the root and in
			-- frontend/), and prettier is not installed at all — so json/css go to
			-- biome too. eslint_d is gone from this list: nvim-lint already runs it
			-- for diagnostics, and having it here meant every save paid for eslint
			-- twice.
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				css = { "biome" },
				ruby = { "rubocop" },
			},
			default_format_opts = {
				lsp_format = "fallback", -- `lsp_fallback` is the old, deprecated spelling
				stop_after_first = true, -- a list means "run all of them" otherwise
			},
			formatters = {
				rubocop = {
					-- --server keeps a rubocop daemon warm: a cold `rubocop -a` measured
					-- ~2.5s here, which overran the old 1500ms timeout on every Ruby
					-- save. Warm it is ~0.7s. `mise exec -- bundle exec` is required
					-- because the bare `rubocop` shim resolves against the wrong ruby
					-- outside backend/.
					command = "mise",
					args = {
						"exec", "--", "bundle", "exec", "rubocop", "--server",
						"-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME",
					},
					cwd = function(self, ctx)
						return require("conform.util").root_file({ "Gemfile" })(self, ctx)
					end,
					stdin = true,
				},
			},
			format_on_save = {
				timeout_ms = 3000,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = "BufWritePost",
		config = function()
			-- Requires: npm i -g eslint_d (or the mason package)
			require("lint").linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true,
				fast_wrap = {},
			})

			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	},

	{
		'kevinhwang91/nvim-ufo',
		event = "BufReadPost",
		dependencies = { 'kevinhwang91/promise-async' },
		opts = {
			fold_virt_text_handler = nil,   -- keep virtual text normal
			enable_get_fold_virt_text = false, -- optional
			provider_selector = function(_, _, _)
				vim.o.foldcolumn = "0"        -- ensure no fold column when UFO attaches
				return { "treesitter", "indent" }
			end,
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded"
			}
		},
		-- or use config
		-- config = function(_, opts) require'lsp_signature'.setup({you options}) end
	},
	{ 'mfussenegger/nvim-dap', lazy = true },
	{ 'nvim-neotest/nvim-nio', lazy = true },
	{
		-- `requires` is packer's key; lazy.nvim silently ignores it and wants
		-- `dependencies`. These three used to load on every startup because
		-- dapui.setup() was called at the top level — now they wait for a keypress.
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end,          desc = "Toggle DAP UI" },
			{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
			{ "<leader>dc", function() require("dap").continue() end,          desc = "DAP continue" },
		},
		config = function()
			require("dapui").setup()
		end,
	},
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {
			enabled = true,
			message_template = " <author> • <summary> • <date>",
			date_format = "%r",
			virtual_text_column = 1,
		},
	},
	{
		"NeogitOrg/neogit",
		cmd = "Neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			graph_style = "unicode",
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
	}
})
-- Default Editor Settings
-- NOTE: mapleader/maplocalleader are set at the very top of this file, before
-- lazy.setup(), so that `<leader>` in plugin specs' `keys` resolves to <space>.
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.guifont = { "Fira Code", "h12" }
vim.opt.signcolumn = "yes:1"
vim.o.foldcolumn = "0"
vim.opt.showmode = false
vim.opt.tabstop = 2     -- how wide a tab character is
vim.opt.shiftwidth = 2  -- how many spaces to indent
vim.opt.softtabstop = 2 -- how many spaces <Tab> insert
vim.opt.scrolloff = 8
vim.opt.number = true
vim.o.updatetime = 200
vim.o.cursorline = true
vim.opt.ignorecase = true

vim.cmd([[syntax off]])

-- Color Scheme Configuration
vim.cmd.colorscheme("rose-pine-moon")


vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })

require("oil").setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- NOTE: ufo, harpoon and lualine are all set up inside their plugin specs at the
-- top of this file now. Top-level setup() calls here would force each of them to
-- load on every startup, which is what the `event`/`keys` triggers are avoiding.

-- Pane Keymaps
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>s", ":split<CR><C-w>j", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>t", ":term<CR>", { desc = "open terminal" })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Telescope Keymaps
-- Wrapped in functions so pressing the key is what loads telescope. A top-level
-- require("telescope.builtin") here would drag telescope into every startup and
-- defeat the `cmd`/`keys` triggers in its spec.
local function pick(name)
	return function() require("telescope.builtin")[name]() end
end
vim.keymap.set("n", "<leader>ff", pick("git_files"), { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", pick("live_grep"), { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", pick("buffers"), { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", pick("help_tags"), { desc = "Telescope help tags" })
-- NOTE: telescope's setup() now lives in its plugin spec's `config` at the top of
-- this file. Calling it here would load telescope on every startup.


-- NeoTree Keymap (toggle)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file tree" })

-- Neogit Keymaps
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogit status" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "Neogit commit" })
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<CR>", { desc = "Neogit log" })
vim.keymap.set("n", "<leader>gb", "<cmd>Neogit branch<CR>", { desc = "Neogit branch" })
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<CR>", { desc = "Neogit pull" })
vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<CR>", { desc = "Neogit push" })

-- Harpoon: setup() (with the git-branch-scoped list key) and its <leader>a / <C-e>
-- mappings both live in its plugin spec at the top of this file.

-- dapui.setup() moved into the nvim-dap-ui spec; it used to load dap + dapui + nio
-- on every startup even though nothing was mapped to them.

require('mason').setup()
require('mason-lspconfig').setup {
	ensure_installed = { 'lua_ls' },
	-- ruby_lsp is configured by hand below so it runs through the project's own
	-- bundle. Mason's standalone copy would be auto-enabled here and race with it.
	automatic_enable = { exclude = { 'ruby_lsp' } },
}

-- Neovim's built-in default capabilities are narrower than nvim-cmp's: they omit
-- labelDetails, insertReplace and commitCharacters, and leave `documentation` out
-- of resolveSupport so completion docs never load. mason-lspconfig enables servers
-- via vim.lsp.enable(), so the '*' config is the only place to widen them for
-- every server at once.
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
-- nvim-ufo asks the server for folding ranges.
lsp_capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
vim.lsp.config('*', { capabilities = lsp_capabilities })

-- A single tsserver covers ~22k TS files and a 3.9GB node_modules here; the
-- default heap makes it GC-thrash once the whole project graph is loaded.
vim.lsp.config('ts_ls', {
	init_options = { hostInfo = 'neovim', maxTsServerMemory = 8192 },
})

-- ruby-lsp, ruby-lsp-rails and ruby-lsp-rspec already live in backend/Gemfile.
-- bundler and mise both resolve from the *process cwd*, so the server has to be
-- spawned inside the directory holding the Gemfile. nvim's cwd is the monorepo
-- root, where mise pins no ruby at all — bundler then picks up the global ruby
-- and dies with RubyVersionMismatch against backend/.ruby-version.
vim.lsp.config('ruby_lsp', {
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start(
			{ 'mise', 'exec', '--', 'bundle', 'exec', 'ruby-lsp' },
			dispatchers,
			{ cwd = config.root_dir }
		)
	end,
	root_markers = { 'Gemfile' },
})
vim.lsp.enable('ruby_lsp')

vim.diagnostic.config({
	signs = true, -- gutter icons
	float = { border = "rounded" },
	update_in_insert = false,
})

-- NOTE: cmp, conform, nvim-lint and dressing are all configured inside their
-- plugin specs at the top of this file, so they load on InsertEnter / BufWritePre /
-- BufWritePost / VeryLazy instead of on every startup. A top-level require('cmp')
-- here used to pull in cmp *and* LuaSnip (~28ms) before the first keypress.

-- Markdown: auto-wrap with real newlines
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = false -- real newlines
		vim.opt_local.textwidth = 80

		-- Proper word wrapping
		vim.opt_local.formatoptions:append("t") -- auto-wrap while typing
		vim.opt_local.formatoptions:append("b") -- wrap at word boundaries
		vim.opt_local.formatoptions:append("l")
		vim.opt_local.formatoptions:append("n")

		vim.opt_local.formatoptions:remove("a")
		vim.opt_local.formatoptions:remove("2")
	end,
})
-- Run the linter automatically on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

-- NOTE: dressing is configured in its plugin spec (event = "VeryLazy").


vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local bufnr = args.buf
		local opts = { buffer = bufnr }
		-- Wrapped so telescope loads on the first jump, not on first LSP attach.
		vim.keymap.set('n', 'gd', function() require("telescope.builtin").lsp_definitions() end, opts)
		vim.keymap.set('n', 'gi', function() require("telescope.builtin").lsp_implementations() end, opts)
		vim.keymap.set('n', 'gy', function() require("telescope.builtin").lsp_type_definitions() end, opts)
		vim.keymap.set('n', 'gr', function() require("telescope.builtin").lsp_references() end, opts)
		vim.keymap.set('n', 'rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)


		vim.keymap.set('n', '<leader>ca', function()
			vim.lsp.buf.code_action({
				-- These options make it use a floating popup
				apply = false,
				context = {},
			})
		end, { desc = "Show code actions in popup" })

		vim.keymap.set('n', 'K', function()
			local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
			if #line_diagnostics > 0 then
				vim.diagnostic.open_float(nil, { focus = false })
			else
				vim.lsp.buf.hover()
			end
		end, { desc = "Show hover or diagnostics" })
		-- more mappings...
	end
})

-- NOTE: no CursorHold diagnostic float here. It reopened a float on every idle
-- tick and fought the `K` mapping above, which already shows line diagnostics on
-- demand. updatetime stays at the 200ms set near the top of this file.

vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- NOTE: folding capabilities are advertised through the '*' vim.lsp.config above,
-- and ufo is set up once near the top of this file. Re-running ufo.setup() here
-- would silently discard that provider_selector.

vim.opt.winbar = "%{%v:lua.require('oil').get_current_dir()%}"
-- Automatically resize all windows to equal dimensions on VimResized event
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("resize_windows", { clear = true }),
	pattern = "*",
	command = "wincmd =", -- Equivalent to pressing <C-w>=
	desc = "Automatically resize all windows on terminal resize",
})

-- Run the test under the cursor in a vertical split terminal.
--   go   -> `go test -run '^<cword>$'` from the file's own directory
--   ruby -> `stack test <repo-relative-path>:<line>` from the web monorepo root
--   ts(x) -> `rstest run <file> -t <enclosing test>` from the file's Nx project
local function run_test_in_split(dir, cmd)
	vim.cmd("vsplit | vertical resize 80")
	vim.cmd("terminal cd " .. vim.fn.shellescape(dir) .. " && " .. cmd)
end

-- `stack` is a zsh function in .zshrc, but `:terminal` runs `zsh -c` (no .zshrc),
-- so resolve the real binary instead of relying on the function being defined.
local function stack_cli()
	local exe = vim.fn.exepath("stack")
	if exe ~= "" then
		return exe
	end
	return "/opt/homebrew/bin/stack"
end

-- Escape a literal test-name fragment so it survives being spliced into the
-- regex that rstest's `-t` expects.
local function escape_regex(s)
	return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?%{%}%|\\/]", "\\%0"))
end

-- Walk upwards from `lnum` collecting the describe/it/test blocks that enclose
-- it. Indentation is what distinguishes an enclosing block from a sibling that
-- already closed above the cursor: a block only counts if it is indented less
-- than every line between it and the cursor. Returns an anchored regex matching
-- the full ("Outer > inner") test name, or nil if nothing encloses the cursor.
local function enclosing_test_pattern(bufnr, lnum)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, lnum, false)
	local chain, innermost_is_leaf = {}, nil
	local limit = #(lines[#lines] or ""):match("^%s*") + 1

	for i = #lines, 1, -1 do
		local line = lines[i]
		if not line:match("^%s*$") then
			local indent = #line:match("^%s*")
			if indent < limit then
				limit = indent
				-- Also catches the .only / .skip / .concurrent suffixes.
				local kind, name = line:match("^%s*(%a+)[%w%.]*%s*%(%s*['\"`](.-)['\"`]")
				if name and (kind == "it" or kind == "test" or kind == "describe") then
					-- Template literals interpolate at runtime, so keep only the
					-- static prefix and let the rest match loosely.
					local interp = name:find("${", 1, true)
					if interp then
						name = name:sub(1, interp - 1)
					end
					table.insert(chain, 1, escape_regex(name) .. (interp and ".*" or ""))
					if innermost_is_leaf == nil then
						innermost_is_leaf = kind ~= "describe"
					end
				end
			end
		end
	end

	if #chain == 0 then
		return nil
	end
	-- Anchor the tail only for a leaf test; on a describe we want its whole subtree.
	return "^" .. table.concat(chain, " > ") .. (innermost_is_leaf and "$" or "")
end

vim.keymap.set("n", "<leader>gt", function()
	local ft = vim.bo.filetype

	if ft == "go" then
		local test = vim.fn.expand("<cword>")
		run_test_in_split(
			vim.fn.expand("%:p:h"),
			"go test -v -run " .. vim.fn.shellescape("^" .. test .. "$")
		)
		return
	end

	if ft == "ruby" then
		-- stack must be invoked from the monorepo root, with a root-relative path.
		local root = vim.fs.root(0, { "stack.yml", "stackadapt.toml" })
		if not root then
			vim.notify("Not inside the web monorepo — no stack.yml found", vim.log.levels.WARN)
			return
		end
		local rel = vim.fn.expand("%:p"):sub(#root + 2)
		local line = vim.fn.line(".")
		-- On line 1, drop the line number so the whole file's suite runs.
		local target = line == 1 and rel or (rel .. ":" .. line)
		run_test_in_split(root, stack_cli() .. " test " .. vim.fn.shellescape(target))
		return
	end

	if ft == "typescriptreact" or ft == "typescript" then
		local file = vim.fn.expand("%:p")
		local root = vim.fs.root(0, { "stack.yml", "stackadapt.toml" })
		if not root or not file:find(root .. "/frontend/", 1, true) then
			vim.notify("Not a frontend/ file in the web monorepo", vim.log.levels.WARN)
			return
		end
		-- rstest is per-Nx-project: run it from the dir that owns the config,
		-- which is what `nx run <project>:test` does under the hood. Calling it
		-- directly (rather than via `stack test`) keeps the shell quoting on the
		-- `-t` pattern intact, and skips the Nx startup cost.
		local project = vim.fs.root(0, "rstest.config.ts")
		if not project then
			vim.notify("No rstest.config.ts found for this file", vim.log.levels.WARN)
			return
		end
		local cmd = vim.fn.shellescape(root .. "/frontend/node_modules/.bin/rstest")
				.. " run --config rstest.config.ts "
				.. vim.fn.shellescape(file)
		-- On line 1, run the whole file's suite; otherwise narrow to the cursor,
		-- falling back to the whole file when nothing encloses it.
		local line = vim.fn.line(".")
		if line > 1 then
			local pattern = enclosing_test_pattern(0, line)
			if pattern then
				cmd = cmd .. " -t " .. vim.fn.shellescape(pattern)
			end
		end
		run_test_in_split(project, cmd)
		return
	end

	vim.notify("No test runner configured for filetype: " .. (ft == "" and "none" or ft), vim.log.levels.WARN)
end, { desc = "Run test under cursor (go test / stack test / rstest)" })

-- Define a Lua function to copy the file path
local function copy_file_path(args)
	local full_path = vim.fn.expand('%:p') -- Get the full path of the current buffer
	local file_path_to_copy = full_path

	if args.args == "relative" then
		-- Optional: Get path relative to the current working directory
		file_path_to_copy = vim.fn.expand('%')
	elseif args.args == "filename" then
		-- Optional: Get only the filename
		file_path_to_copy = vim.fn.expand('%:t')
	end

	-- Set the '+' register (system clipboard) to the desired path
	vim.fn.setreg('+', file_path_to_copy)

	-- Display a notification
	vim.notify("Copied: " .. file_path_to_copy)
end

-- Create the custom user command :CopyPath
vim.api.nvim_create_user_command("CopyPath", copy_file_path, {
	nargs = "?",                      -- Allows an optional argument (0 or 1 argument)
	complete = function()
		return { "relative", "filename" } -- Autocomplete options for arguments
	end,
	desc = "Copy current file path to clipboard (optional: relative, filename)",
})


-- 1. Get all installed colorschemes via Neovim's command-line completion
local installed_themes = vim.fn.getcompletion("", "color")

-- 2. Format them into the structure required by themery.nvim
local themery_themes = {}
for _, theme in ipairs(installed_themes) do
	table.insert(themery_themes, {
		name = theme,     -- The display name in the menu
		colorscheme = theme -- The internal vim colorscheme name
	})
end

-- 3. Pass the dynamic list into the themery setup function
require("themery").setup({
	themes = themery_themes,
	livePreview = true, -- Apply theme while picking. Default to true.
	-- Add any other custom options below (like backend, persistence, etc.)
})

-- Automatically read file when changed on disk
vim.o.autoread = true

-- Trigger checktime when gaining focus, entering a buffer, or idling
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	command = "if mode() != 'c' | checktime | endif",
})

-- Notify you when a buffer has been reloaded from disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
	pattern = "*",
	command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})
