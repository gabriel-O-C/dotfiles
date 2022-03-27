--vim configs

local exec  = vim.api.nvim_exec -- execute Vimscript
local set   = vim.opt           -- global options
local cmd   = vim.cmd           -- execute Vim commands
-- local fn    = vim.fn            -- call Vim functions
-- local g     = vim.g             -- global variables
-- local b     = vim.bo            -- buffer-scoped options
-- local w     = vim.wo            -- windows-scoped options

cmd('autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=grey') --to Show whitespace, MUST be inserted BEFORE the colorscheme command
--cmd('colorscheme rvcs')
set.guifont		      = 'Droid Sans Mono Nerd 12'
set.termguicolors   = true      -- Enable GUI colors for the terminal to get truecolor
set.list            = false      -- show whitespace
set.syntax = 'on'
set.listchars = {
         nbsp       = '⦸',      -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
         extends    = '»',      -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
         precedes   = '«',      -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
         tab        = '▷─',     -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
         trail      = '•',      -- BULLET (U+2022, UTF-8: E2 80 A2)
         space      = ' ',
}
set.fillchars = {
        diff        = '∙',      -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
        eob         = ' ',      -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
        fold        = '·',      -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
        vert        = ' ',      -- remove ugly vertical lines on window division
}
set.clipboard       = set.clipboard + "unnamedplus" --copy & paste
set.wrap            = false         -- don't automatically wrap on load
set.showmatch       = true 	        -- show the matching part of the pair for [] {} and ()
set.cursorline      = true 	        -- highlight current line
set.number          = true          -- show line numbers
set.relativenumber  = true	        -- show relative line number
set.incsearch       = true 	        -- incremental search
set.hlsearch        = true 	        -- highlighted search results
set.ignorecase      = true 	        -- ignore case sensetive while searching
set.smartcase       = true
set.scrolloff       = 1             -- when scrolling, keep cursor 1 lines away from screen border
set.sidescrolloff   = 2             -- keep 30 columns visible left and right of the cursor at all times
set.backspace       = 'indent,start,eol' -- make backspace behave like normal again
--set.mouse = "a"  		-- turn on mouse interaction
set.updatetime      = 500              -- CursorHold interval
set.softtabstop     = 2
set.shiftwidth      = 2             -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
set.tabstop         = 2             -- spaces per tab
set.smarttab        = true          -- <tab>/<BS> indent/dedent in leading whitespace
set.autoindent      = true          -- maintain indent of current line
set.expandtab       = false         -- don't expand tabs into spaces
set.shiftround      = true
set.splitbelow      = true      -- open horizontal splits below current window
set.splitright      = true      -- open vertical splits to the right of the current window
set.laststatus      = 2         -- always show status line
-- set.colorcolumn = "79"        -- vertical word limit line


set.hidden          = true      -- allows you to hide buffers with unsaved changes without being prompted
set.inccommand      = 'split'   -- live preview of :s results
set.shell           = 'bash'     -- shell to use for `!`, `:!`, `system()` etc.
-- highlight on yank
exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=500, on_visual=true}
  augroup end
]], false)

-- jump to the last position when reopening a file
cmd([[
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

-- patterns to ignore during file-navigation
set.wildignore  = set.wildignore + '*.o,*.rej,*.so'
-- remove whitespace on save
cmd([[au BufWritePre * :%s/\s\+$//e]])
-- faster scrolling
set.lazyredraw = true
-- don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])
-- completion options
set.completeopt = 'menuone,noselect,noinsert'


-- 2 spaces for selected filetypes
cmd([[ autocmd FileType xml,html,xhtml,css,scssjavascript,lua,dart setlocal shiftwidth=2 tabstop=2 ]])
-- json
cmd([[ au BufEnter *.json set ai expandtab shiftwidth=2 tabstop=2 sta fo=croql ]])

require('lualine').setup {
}
-- Lua
require('onedark').setup {
    style = 'darker'
}
require('onedark').load()


--If you want to automatically ensure that packer.nvim is installed on any machine you clone your configuration to,
--add the following snippet (which is due to @Iron-E) somewhere in your config before your first usage of packer:
local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end


return require('packer').startup{function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use { -- A collection of common configurations for Neovim's built-in language server client
        'neovim/nvim-lspconfig',
        config = [[ require('plugins/lspconfig') ]]
}use {
        'williamboman/nvim-lsp-installer',
        config = [[ require('plugins/lsp_installer_nvim') ]]
}use { -- vscode-like pictograms for neovim lsp completion items Topics
        'onsails/lspkind-nvim',
        config = [[ require('plugins/lspkind') ]]
}use { -- Utility functions for getting diagnostic status and progress messages from LSP servers, for use in the Neovim statusline
        'nvim-lua/lsp-status.nvim',
        config = [[ require('plugins/lspstatus') ]]
}
use { -- A completion plugin for neovim coded in Lua.
        'hrsh7th/nvim-cmp',
        requires = {
          "hrsh7th/cmp-nvim-lsp",           -- nvim-cmp source for neovim builtin LSP client
          "hrsh7th/cmp-nvim-lua",           -- nvim-cmp source for nvim lua
          "hrsh7th/cmp-buffer",             -- nvim-cmp source for buffer words.
          "hrsh7th/cmp-path",               -- nvim-cmp source for filesystem paths.
          "hrsh7th/cmp-calc",               -- nvim-cmp source for math calculation.
          "saadparwaiz1/cmp_luasnip",       -- luasnip completion source for nvim-cmp
        },
        config = [[ require('plugins/cmp') ]],
  }use { -- Snippet Engine for Neovim written in Lua.
        'L3MON4D3/LuaSnip',
        requires = {
          "rafamadriz/friendly-snippets",   -- Snippets collection for a set of different programming languages for faster development.
        },
        config = [[ require('plugins/luasnip') ]],
  }
  use { -- Nvim Treesitter configurations and abstraction layer
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = [[ require('plugins/treesitter') ]]
}

  use { -- A super powerful autopairs for Neovim. It support multiple character.
       'windwp/nvim-autopairs',
       config = [[ require('plugins/autopairs') ]]
 }

  use { --  colorscheme for (neo)vim written in lua specially made for roshnivim
       'shaeinst/roshnivim-cs',
  }
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
use 'kyazdani42/nvim-web-devicons'
-- Using Packer
use 'navarasu/onedark.nvim'
use 'marko-cerovac/material.nvim'
use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use 'nvim-lua/plenary.nvim'
use 'p00f/nvim-ts-rainbow'
-- Lua
use {
  "folke/todo-comments.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("todo-comments").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
end, config = {
  -- Move to lua dir so impatient.nvim can cache it
  compile_path = vim.fn.stdpath('config')..'/plugin/packer_compiled.lua'

  }
}
