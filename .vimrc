" Plugins (using vim-plug)
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'preservim/nerdtree'

call plug#end()

" Basic Settings
set nocompatible
filetype off
syntax enable
syntax on
set termguicolors

" Set the color scheme
colorscheme dracula

" Enable transparency
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

" Filetype plugins
filetype plugin indent on

" Line Numbers
set number
set relativenumber

" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Search Settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" UI Enhancements
set cursorline
set wrap
set scrolloff=5
set sidescrolloff=8
set showcmd
set cmdheight=2
set wildmenu
set showmatch
set laststatus=2

" Backup and Undo
set undofile
set backup

if !isdirectory(expand('~/.vim/backup'))
  call mkdir(expand('~/.vim/backup'), 'p')
endif
set backupdir=~/.vim/backup

if !isdirectory(expand('~/.vim/undo'))
  call mkdir(expand('~/.vim/undo'), 'p')
endif
set undodir=~/.vim/undo
