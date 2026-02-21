vim.loader.enable()
vim.pack.add({
	{ src = 'https://github.com/vim-scripts/a.vim' },
	{ src = 'https://github.com/numToStr/Comment.nvim' },
	{ src = 'https://github.com/nvim-tree/nvim-tree.lua' },
	{ src = 'https://github.com/tpope/vim-fugitive' },
	{ src = 'https://github.com/nvim-lua/plenary.nvim' },
	{ src = 'https://github.com/nvim-telescope/telescope.nvim' },
	{ src = 'https://github.com/mg979/vim-visual-multi' },
	{ src = 'https://github.com/akinsho/toggleterm.nvim' },
	{ src = 'https://github.com/vim-scripts/a.vim' },
	{ src = 'https://github.com/Shatur/neovim-ayu' },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/Saghen/blink.compat' },
	{ src = 'https://github.com/saghen/blink.cmp' },
	{ src = 'https://github.com/Civitasv/cmake-tools.nvim' },
})
local function nvim_tree_keybinds(bufnr)
	local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
	api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
	vim.keymap.set('n', '<S-l>', '<C-W>l', opts("Move to right window"))
end
require('nvim-tree').setup({
	on_attach = nvim_tree_keybinds,
})

require('toggleterm').setup({
	direction = 'float'
})

require('blink.cmp').setup({
	keymap = {
		preset = 'cmdline' ,
		['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
		['<CR>'] = {'accept', 'fallback'},
		['<Tab>'] = false, -- Tab is handled below in keybinds
	},
	completion = { menu = { auto_show = true } },
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
	sources = {
		default = { "lsp", "path", "buffer" }
	},
})

vim.lsp.config("clangd", {
	cmd = { "clangd" },
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.enable("clangd")
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN]  = "",
			[vim.diagnostic.severity.INFO]  = "",
			[vim.diagnostic.severity.HINT]  = "󰌵",
		},
	},
})

require("cmake-tools").setup({
	cmake_build_directory = "build",
	cmake_generate_options = {
		"-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
		"-DCMAKE_INSTALL_PREFIX=" .. os.getenv("HOME") .. "/.local",
	},
	cmake_build_options = {
		"--parallel 8",
	},
	cmake_show_console = "always",
})

-- General settings
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = { "utf-8" }
vim.opt.fileformats = { "unix", "dos" }

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.opt.number = true           -- set nu
vim.opt.autoread = true
vim.opt.scrolloff = 7           -- set so=7
vim.opt.hidden = true           -- allow buffer switching without saving
vim.opt.startofline = false

vim.opt.wildmode = { "longest:full", "full" }
vim.opt.smartindent = true

-- Undo history
local undodir = vim.fn.expand("~/.vim_undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p", "0700")
end

vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.history = 1000

-- Tabs/Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Colours and search highlighting
vim.opt.termguicolors = true
vim.cmd("colorscheme ayu")
vim.cmd("syntax enable")

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.api.nvim_set_hl(0, "IncSearch", {
	italic = true,
	fg = "#303030",
	bg = "#cd8b60",
})

vim.g.mapleader = ','

-- Trim excess whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd([[%s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
})

local keybind = vim.keymap.set
-- Keybinds
keybind('n', '<C-Space>', require('telescope.builtin').buffers)
keybind('n', '<leader>sa', require('telescope.builtin').live_grep)
keybind('n', '<leader>ss', require('telescope.builtin').grep_string)
keybind('n', '<leader>f', require('telescope.builtin').find_files)
keybind('n', '<leader>nt', ':NvimTreeToggle<CR>')
keybind('n', '<leader>a', ':A<CR>')
keybind({'n', 'v', 'x'}, '<leader>c<Space>', 'gcc<ESC>', {remap = true})
keybind('n', ';', ':')

-- Make sure tab indents unless there's something to autocomplete
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end

  local current_line = vim.api.nvim_get_current_line()
  return not current_line:sub(1, col):match("^%s*$")
end
keybind("i", "<Tab>", function()
  local cmp = require("blink.cmp")

  if cmp.is_visible() then
	  cmp.select_next()
  elseif has_words_before() then
    cmp.show_and_insert()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true),"n",true)
  end
end, { silent = true })

-- Split management
keybind('n', '<S-t>', '<C-W>v')
keybind('n', '<S-x>', '<C-W>c')
keybind('n', '<S-h>', '<C-W>h')
keybind('n', '<S-j>', '<C-W>j')
keybind('n', '<S-k>', '<C-W>k')
keybind('n', '<S-l>', '<C-W>l')

-- Movement through long lines
keybind('n', 'j', 'gj')
keybind('n', 'k', 'gk')
keybind('v', 'j', 'gj')
keybind('v', 'k', 'gk')

-- Swap page up/down
keybind('n', '<C-b>', '<C-f>')
keybind('n', '<C-f>', '<C-b>')

keybind({'n', 't'}, '<C-d>', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')
keybind('n', '<C-k>', vim.diagnostic.open_float)

-- Commands
local command = vim.api.nvim_create_user_command
keybind('c', 'w!!', 'w !sudo tee % > /dev/null')
keybind('c', 'W', 'w')
command('C', 'let @/=""', {})
