call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
"Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Plug 'ryanoasis/vim-devicons'
"Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
"Plug 'scrooloose/nerdcommenter'

Plug 'morhetz/gruvbox' " Theme

Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

Plug 'vim-airline/vim-airline'
Plug 'https://tpope.io/vim/commentary.git'
Plug 'https://tpope.io/vim/surround.git'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'vim-scripts/regreplop.vim'  "Replace something with the clipboard (<C-K><motion>)
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/argtextobj.vim' "function arguments
Plug 'bkad/CamelCaseMotion'
Plug 'jremmen/vim-ripgrep'

Plug 'jonsmithers/vim-html-template-literals'

Plug 'rluba/jai.vim'

call plug#end()

set nobackup		" do not keep a backup file
set nowritebackup
set autoindent		" always set autoindenting on
set tabstop=4
set shiftwidth=4
set nowrap
set hlsearch
set number relativenumber
set splitbelow
set splitright
set scrolloff=5 " Scroll before hitting the edges of the window

" Auto-reload changed files
autocmd FocusGained,BufEnter * if mode() != 'c' | checktime | endif

" Write files before many operations
set autowrite
" … but keep the undo buffer when we switch files, otherwise autowrite can
" cause some nasty data loss
set hidden

set background=dark
colorscheme gruvbox

let mapleader = " "
" Disable leader timeout
set notimeout
set ttimeout

if has("gui_vimr")
	let g:ctrlp_map = '<D-p>'
else 
	let g:ctrlp_map = '<C-p>'
endif

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]((\.(git|hg|svn))|(node_modules|build|dist))$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']


" Remap jump to tag
" nnoremap ü :tj<CR>
nnoremap ü g<C-]>
nnoremap Ü <C-]>
nnoremap <C-w>ü <C-w>]

" set completeopt+=menuone,noinsert

map <Leader>= :%!jq --tab -S .<Enter>
map <Leader>c :make<Enter>

function! FindJaiExecutable(filename)
	if exists("g:jair_path")
		return g:jair_path
	else 
		return fnamemodify(a:filename, ':r')
	endif
endfunction

if !exists("jair_path")
  let jair_path = ''
endif
if !exists("jair_args")
  let jair_args = ''
endif

map <Leader>v :w<Enter> :bot terminal ++rows=20 jaic %<Enter>
map <Leader>r :execute '!jair ' . FindJaiExecutable(expand('%')) . ' ' . jair_args<Enter>
autocmd FileType jai compiler jai


" Automatically open quickfix window when compiling
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" NERDTree
let g:will_open_nerdtree = 0 "A 'mutex' to fix SyncTree opening another nerdtree when we use NERDTreeFocus for the first time
function! NERDTreeOpenSafely()
	let g:will_open_nerdtree = 1
	NERDTreeFocus
	let g:will_open_nerdtree = 0
endfunction

map <Leader>n :call NERDTreeOpenSafely()<Enter>
map <Leader>N :NERDTreeToggleVCS<Enter>

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
	return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! IsNERDTreeFocussed()        
	return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) == winnr())
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
	" echo "Modifiable: " . &modifiable . " open: " . IsNERDTreeOpen() . " name: " . expand('%') . " diff: " . &diff
	if g:will_open_nerdtree != 1 && &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
		NERDTreeFind
		if IsNERDTreeFocussed() 
			wincmd p
		endif
	endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

" Shortcuts for copy/paste clipboard
map <Leader>y "+y
map <Leader>Y "+Y
map <Leader>p "+p
map <Leader>P "+P

let g:camelcasemotion_key = '<leader>'

function! SaveSession()
  if v:this_session != ""
    echo 'Saving ' . v:this_session
    exe 'mksession! ' . v:this_session
  else
    echo "No Session."
  endif
endfunction

autocmd VimLeave * NERDTreeClose
autocmd VimLeave * :call SaveSession()

" Move lines up/down
nnoremap º :m .+1<CR>==
nnoremap ∆ :m .-2<CR>==
inoremap º <Esc>:m .+1<CR>==gi
inoremap ∆ <Esc>:m .-2<CR>==gi
vnoremap º :m '>+1<CR>gv=gv
vnoremap ∆ :m '<-2<CR>gv=gv

let g:ale_linters = {'javascript': ['eslint']}
let g:ale_javascript_eslint_executable = './node_modules/.bin/eslint'
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 1

let g:rg_highlight = 1
let g:rg_derive_root = 1

autocmd FileType typescript setlocal commentstring=//\ %s
""""""""""""""""
" COC stuff
""""""""""""""""

" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-json', 
  \ ]
" \ 'coc-pairs',

" Give more space for displaying messages.
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Jai stuff
let g:jai_path='/Users/raphael/Projekte/jai/jai'
let g:jai_compiler='jaic_vim'
let g:jai_modules=g:jai_path . '/modules/'

function! FindJaiExecutable(filename)
	if exists("g:jair_path")
		return g:jair_path
	else 
		return fnamemodify(a:filename, ':r')
	endif
endfunction

if !exists("jair_path")
  let jair_path = ''
endif
if !exists("jair_args")
  let jair_args = ''
endif

map <Leader>c :make<Enter>

map <Leader>v :w<Enter> :bot terminal ++rows=20 jaic %<Enter>
map <Leader>r :execute '!jair ' . FindJaiExecutable(expand('%')) . ' ' . jair_args<Enter>
autocmd FileType jai compiler jai
