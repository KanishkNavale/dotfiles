" Plugins (using vim-plug)
call plug#begin('~/.vim/plugged')

" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }

" File Explorer
Plug 'preservim/nerdtree'

call plug#end()

" Basic Settings
set nocompatible            " Disable compatibility with older versions of Vim
filetype off                " Disable filetype detection temporarily
syntax enable               " Enable syntax highlighting
syntax on                   " Turn on syntax highlighting
set termguicolors           " Enable true color support (required for Dracula)

" Set the color scheme
colorscheme dracula

" Enable transparency
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE

" Filetype plugins
filetype plugin indent on   " Enable filetype-specific plugins and indentation

" Line Numbers
set number                  " Show line numbers
set relativenumber          " Show relative line numbers

" Indentation
set tabstop=4               " Number of spaces for a tab
set shiftwidth=4            " Number of spaces for indentation
set expandtab               " Use spaces instead of tabs
set autoindent              " Automatically indent new lines
set smartindent             " Smarter auto-indentation

" Search Settings
set hlsearch                " Highlight search results
set incsearch               " Show incremental search results
set ignorecase              " Ignore case in search patterns
set smartcase               " Override ignorecase if search contains uppercase

" UI Enhancements
set cursorline              " Highlight the current line
set wrap                    " Enable text wrapping
set scrolloff=5             " Keep 5 lines visible above/below the cursor
set sidescrolloff=8         " Keep 8 columns visible on the sides
set showcmd                 " Show command in bottom bar
set cmdheight=2             " More space for displaying messages
set wildmenu                " Enable command-line completion
set showmatch               " Highlight matching parentheses
set laststatus=2            " Always show the status line

" Backup and Undo
set undofile                " Enable persistent undo
set backup                  " Enable file backup
set backupdir=~/.vim/backup " Directory for backup files
set undodir=~/.vim/undo     " Directory for undo files

" Keybindings for Plugins
" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>      " Toggle NERDTree with Ctrl+n
autocmd VimEnter * NERDTree | wincmd p  " Open NERDTree on startup