set backspace=indent,eol,start

set splitright

syntax enable
set mouse=a

" From https://github.com/colinwren/dotfiles/blob/master/.vimrc
" Remap :W to :w
:command WQ wq
:command Wq wq
:command W w
:command Q q

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'chriskempson/vim-tomorrow-theme'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Lokaltog/vim-powerline'

" Nerd tree Stuffs
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" auto
set sw=2 ts=2 sts=2
set autoindent
set smartindent
set expandtab
set cindent

" Powerline
let g:Powerline_symbols = 'fancy'
set laststatus=2
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors
call Pl#Theme#RemoveSegment('fileencoding')
call Pl#Theme#RemoveSegment('fileformat')

"Show line number (disable)for certain filetypes
set number
autocmd BufNewFile,BufRead .*,COMMIT_EDITMSG set nonumber"

"Highlight cursor
"highlight CursorLine cterm=NONE ctermbg=8
"
