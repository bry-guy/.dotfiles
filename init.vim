call plug#begin('~/.vim/plugged')
Plug 'chuling/vim-equinusocio-material'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neovim/nvim-lsp'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug '~/.fzf'
call plug#end()

"" filetype settings
filetype on
filetype plugin on

autocmd FileType json setlocal shiftwidth=2 tabstop=2 softtabstop=2


"" nvim settings
set relativenumber
set tabstop=4
set shiftwidth=4
set softtabstop=4
set signcolumn=yes
set completeopt-=preview
set hidden
set ignorecase
set smartcase

"" theming
if (has("termguicolors"))
	set termguicolors
endif

let g:equinusocio_material_darker = 1
let g:equinusocio_material_hide_vertsplit = 1

colorscheme equinusocio_material
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE

""" lightline
set noshowmode 
let g:lightline = { 'colorscheme': 'equinusocio_material' }

"" lsp
lua << EOF

local on_attach_vim = function()
  require'completion'.on_attach()
  require'diagnostic'.on_attach()
end

require'nvim_lsp'.bashls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.jsonls.setup{on_attach=on_attach_vim}
require'nvim_lsp'.tsserver.setup{on_attach=on_attach_vim}

EOF

""" lsp settings
nnoremap <silent> gd	<cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

inoremap <M-cr> <C-x><C-o>

""" diagnostic settings
nnoremap <silent> <leader>d <cmd>NextDiagnosticCycle<CR>
nnoremap <silent> <leader><c-d> <cmd>PrevDiagnosticCycle<CR>
nnoremap <silent> <leader>\ <cmd>OpenDiagnostic<CR>

""" completion settings

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

""" NERD Tree
map <C-n> :NERDTreeToggle<CR> 

" enter NERDTree when opening vim with `vim` or opening directory `vim ~`
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | exe 'cd '.argv()[0] | endif

" exit vim if NERD Tree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" black magic to prevent opening anything in NERD Tree buffer
" https://github.com/junegunn/fzf/issues/453
autocmd FileType nerdtree let t:nerdtree_winnr = bufwinnr('%')
autocmd BufWinEnter * call PreventBuffersInNERDTree()

function! PreventBuffersInNERDTree()
  if bufname('#') =~ 'NERD_tree' && bufname('%') !~ 'NERD_tree'
    \ && exists('t:nerdtree_winnr') && bufwinnr('%') == t:nerdtree_winnr
    \ && &buftype == '' && !exists('g:launching_fzf')
    let bufnum = bufnr('%')
    close
    exe 'b ' . bufnum
    NERDTree
  endif
  if exists('g:launching_fzf') | unlet g:launching_fzf | endif
endfunction

" switch to previous buffer then delete the new-previous buffer
nnoremap \d :bp<cr>:bd #<cr>

""" omnifunc
autocmd Filetype typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd CompleteDone * pclose
