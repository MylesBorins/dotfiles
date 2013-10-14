set backspace=indent,eol,start

set splitright

set nocompatible               " be iMproved
filetype off                   " required!


set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

filetype on
syntax enable
set mouse=a

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle "chriskempson/vim-tomorrow-theme"
Bundle "pangloss/vim-javascript"
Bundle "hallettj/jslint.vim"
Bundle 'vrackets'
Bundle "scrooloose/nerdcommenter"
Bundle 'Lokaltog/vim-powerline'

" Nerd tree Stuffs
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

filetype plugin indent on     " required!

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