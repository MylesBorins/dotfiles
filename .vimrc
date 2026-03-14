set nocompatible
set backspace=indent,eol,start
set splitright
syntax enable
set mouse=a
set hidden
set ignorecase
set smartcase
set incsearch
set wildmenu
set scrolloff=4
set updatetime=300

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
if isdirectory('/opt/homebrew/opt/fzf')
  set runtimepath+=/opt/homebrew/opt/fzf
endif

if empty(glob(data_dir . '/autoload/plug.vim'))
  echohl WarningMsg
  echom 'vim-plug is not installed. Run ./setup.sh to install it.'
  echohl None
endif

if !empty(glob(data_dir . '/autoload/plug.vim'))
  call plug#begin(data_dir . '/plugged')

  Plug 'preservim/nerdtree'
  Plug 'preservim/nerdcommenter'
  Plug 'phanviet/vim-monokai-pro'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'junegunn/fzf.vim'

  call plug#end()
endif

filetype plugin indent on

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>rg :Rg<Space>
nnoremap <silent> <Leader>t :botright 12split<Bar>terminal ++curwin<CR>
nnoremap <silent> <Leader>a :call <SID>TmuxAgentSplit()<CR>
nnoremap <silent> <S-h> :tabp<CR>
nnoremap <silent> <S-l> :tabn<CR>
autocmd bufenter * if winnr("$") == 1 && &filetype ==# 'nerdtree' | q | endif

function! s:TmuxAgentSplit() abort
  if exists('$TMUX')
    silent execute '!tmux split-window -v'
    redraw!
  else
    echo 'Not running inside tmux'
  endif
endfunction

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
set relativenumber
autocmd BufNewFile,BufRead .*,COMMIT_EDITMSG setlocal nonumber norelativenumber
