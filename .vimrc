set nocompatible
set backspace=indent,eol,start
set splitright
syntax enable
set mouse=a

" Remap common typos
:command WQ wq
:command Wq wq
:command W w
:command Q q

" Auto-install vim-plug
let data_dir = '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'preservim/nerdcommenter'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'

call plug#end()
filetype plugin indent on

" NERDTree
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | q | endif

" Theme
set termguicolors
set background=dark
silent! colorscheme monokai_pro

" Airline
set laststatus=2
set t_Co=256

" Indentation
set sw=2 ts=2 sts=2
set autoindent
set smartindent
set expandtab
set cindent

" Line numbers
set number
autocmd BufNewFile,BufRead .*,COMMIT_EDITMSG set nonumber
