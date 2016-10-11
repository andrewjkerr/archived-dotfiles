" Backspace in insert mode works like normal editor
set backspace=2

" Syntax highlighting!
syntax on

" Activates indenting for files and turns on auto indenting
filetype indent on
set autoindent

" Set 4 spaces instead of tabs
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Line numbers
set relativenumber
set number

" Colorscheme desert
colorscheme atom-dark-256

" Get rid of the annoying ~file
set nobackup

" Origami-style splits
set splitbelow
set splitright

" Clear trailing whitespace on save for code
autocmd BufWritePre <buffer> %s/\s\+$//e

" Show trailing whitespace
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

" Set 2 spaces for Ruby
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2

" Automagically resize the window on vim resize
autocmd VimResized * :wincmd =

""""
" PLUGINS
""""
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim' " Ctrl + P
Plugin 'christoomey/vim-tmux-navigator' " vim + tmux navigator

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
