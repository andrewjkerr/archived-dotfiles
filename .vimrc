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
set number

" Colorscheme desert
colorscheme desert

" Get rid of the annoying ~file
set nobackup

" Origami-style splits
set splitbelow
set splitright

""""
" PLUGINS
""""
" ctrlp plugin
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" php.vim plugin
set runtimepath^=~/.vim/bundle/php.vim

function! PhpSyntaxOverride()
    hi! def link phpDocTags  phpDefine
    hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
    autocmd!
    autocmd FileType php call PhpSyntaxOverride()
augroup END
