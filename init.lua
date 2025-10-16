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
	{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{ 'neoclide/coc.nvim',           branch = "release" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	}
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

-- Color Scheme Configuration
vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "italic"
vim.g.gruvbox_baby_telescope_theme = 1
vim.g.gruvbox_baby_background_color = "dark"

vim.cmd("colorscheme gruvbox-baby")

require('lualine').setup {
	options = {
		theme = "gruvbox-baby",
	}
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

-- NeoTree Keymap (toggle)
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file tree" })

--
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Sensible keymaps for CoC.nvim
-- Helper to shorten function calls
local keymap = vim.keymap.set
local opts = { silent = true, noremap = true }
-- === Completion ===
vim.cmd([[
  inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"
]])
-- === Diagnostics ===
keymap("n", "[g", "<Plug>(coc-diagnostic-prev)", opts)
keymap("n", "]g", "<Plug>(coc-diagnostic-next)", opts)
keymap("n", "<leader>d", ":<C-u>CocDiagnostic<CR>", { silent = true })
-- === Go-To Navigation ===
keymap("n", "gd", "<Plug>(coc-definition)", opts)
keymap("n", "gy", "<Plug>(coc-type-definition)", opts)
keymap("n", "gi", "<Plug>(coc-implementation)", opts)
keymap("n", "gr", "<Plug>(coc-references)", opts)
-- === Code Actions & Refactoring ===
keymap("n", "<leader>rn", "<Plug>(coc-rename)", opts)
keymap("n", "<leader>ca", "<Plug>(coc-codeaction)", opts)
keymap("x", "<leader>ca", "<Plug>(coc-codeaction-selected)", opts)
-- keymap("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)
-- === Formatting ===
keymap("n", "<leader>f", "<Plug>(coc-format)", opts)
keymap("x", "<leader>f", "<Plug>(coc-format-selected)", opts)
-- === Hover & Signature Help ===
keymap("n", "K", function()
	vim.fn.CocActionAsync('doHover')
end, opts)
keymap("i", "<C-Space>", "coc#refresh()", { silent = true, expr = true })
-- === Workspace / Lists ===
keymap("n", "<leader>ws", ":CocList -I symbols<CR>", opts)
keymap("n", "<leader>cl", ":CocList<CR>", opts)
-- === Auto-highlighting ===
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.fn.CocActionAsync("highlight")
	end,
})
-- === Optional: Signature help on placeholder jump ===
vim.api.nvim_create_autocmd("User", {
	pattern = "CocJumpPlaceholder",
	callback = function()
		vim.fn.CocActionAsync("showSignatureHelp")
	end,
})
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
