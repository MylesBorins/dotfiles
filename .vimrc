set nocompatible
set backspace=indent,eol,start
set splitright
syntax enable
set mouse=a
set hidden
set ignorecase
set smartcase
set incsearch

if has('persistent_undo')
  let s:undo_dir = expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p')
  endif
  let &undodir = s:undo_dir
  set undofile
endif

if has('clipboard')
  set clipboard=unnamedplus
endif

" Remap common typos
command WQ wq
command Wq wq
command W w
command Q q

let data_dir = expand('~/.vim')
if empty(glob(data_dir . '/autoload/plug.vim'))
  echohl WarningMsg
  echom 'vim-plug is not installed. Run ./setup.sh to install it.'
  echohl None
endif

if !empty(glob(data_dir . '/autoload/plug.vim'))
  call plug#begin(data_dir . '/plugged')

  Plug 'preservim/nerdtree'
  Plug 'jistr/vim-nerdtree-tabs'
  Plug 'preservim/nerdcommenter'
  Plug 'phanviet/vim-monokai-pro'
  Plug 'vim-airline/vim-airline'

  call plug#end()
endif

filetype plugin indent on

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
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
