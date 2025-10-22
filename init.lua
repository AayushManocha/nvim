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
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "javascript", "typescript", "tsx", "python", "html", "css", "ruby" },
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
	{ "luisiacc/gruvbox-baby" },
	{ "EdenEast/nightfox.nvim" },
	{ 'embark-theme/vim', lazy = false, priority = 1000, name = 'embark' },
	{'rose-pine/neovim', name="rose-pine"},
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
	{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
	{'neovim/nvim-lspconfig', dependencies = { 'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim'}},
	{'hrsh7th/nvim-cmp', config = {}},
	{'hrsh7th/cmp-nvim-lsp'},
	{
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp"
},
	{ 'stevearc/dressing.nvim' },
	{"stevearc/conform.nvim"},
	{"mfussenegger/nvim-lint"},
})
-- Default Editor Settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.g.have_nerd_font = true
vim.opt.guifont = { "Fira Code", "h12" }
vim.opt.signcolumn = "yes:1"
vim.opt.showmode = false
vim.opt.tabstop = 2        -- how wide a tab character is
vim.opt.shiftwidth = 2     -- how many spaces to indent
vim.opt.softtabstop = 2    -- how many spaces <Tab> insert
vim.opt.scrolloff = 8

-- Color Scheme Configuration
vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "italic"
vim.g.gruvbox_baby_telescope_theme = 1
vim.g.gruvbox_baby_background_color = "dark"

vim.cmd("colorscheme gruvbox-baby")

require('lualine').setup {
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
}

-- Pane Keymaps
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Move to left split" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Move to right split" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Move to bottom split" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Move to top split" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>s", ":split<CR><C-w>j", { desc = "Horizontal split" })
vim.keymap.set("n", "<leader>v", ":vsplit<CR><C-w>l", { desc = "Vertical split" })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Telescope Keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>gr", builtin.live_grep, { desc = "Telescope help tags" })

-- NeoTree Keymap (toggle)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file tree" })

--
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Configure Mason
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {'lua_ls' },  -- example LSPs
}

vim.diagnostic.config({
  signs = true,          -- gutter icons
  float = { border = "rounded" },
  update_in_insert = false,
})

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
    { name = 'buffer' },
    { name = 'path' },
  }),
})

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
  },
  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 500,
  },
})

-- 🕵️ 3. Linter: ESLint via nvim-lint
-- Requires: npm i -g eslint_d
require("lint").linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}

-- Run the linter automatically on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

require('dressing').setup({
  select = {
    backend = { "telescope", "fzf_lua", "nui", "builtin" },
    builtin = {
      border = "rounded",
      relative = "cursor",
      max_height = 0.4,
      min_height = 4,
    },
  },
})


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
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

vim.o.updatetime = 400
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Helper to shorten function calls
-- Autoclose Pairs Custom Script
local bracket_pairs = {
	["("] = ")",
	["["] = "]",
	["{"] = "}",
	["'"] = "'",
	['"'] = '"',
	["<"] = ">",
	["%"] = "%",
}

for open_char, close_char in pairs(bracket_pairs) do
	vim.keymap.set("i", open_char, open_char .. close_char .. "<Left>")
end

vim.keymap.set("n", "<leader>gt", function()
  local test = vim.fn.expand("<cword>")
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("vsplit | vertical resize 80 | terminal cd " .. dir .. " && go test -v -run '^" .. test .. "$'")
end, { desc = "Run Go test under cursor (in vertical split terminal)" })
