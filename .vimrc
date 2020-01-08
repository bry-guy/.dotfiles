syntax on
filetype plugin indent on
let g:typescript_indent_disable = 0

set nu 
colorscheme desert
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent
set clipboard=unnamed

set nocompatible
filetype plugin on
syntax on

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%121v', 100)
