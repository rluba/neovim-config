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
Plug 'bfrg/vim-cpp-modern' " C++ syntax
Plug 'mustache/vim-mustache-handlebars' " Handlebars syntax
Plug 'tie/llvm.vim' " LLVM IR syntax

Plug 'junegunn/vim-easy-align' " Align code

Plug 'vim-airline/vim-airline'
Plug 'https://tpope.io/vim/commentary.git'
Plug 'https://tpope.io/vim/surround.git'
Plug 'https://tpope.io/vim/repeat.git' " To make surround repeatable
Plug 'tpope/vim-abolish'				   " To convert between camel case, snake case, etc. (crs, crc, crm)
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'vim-scripts/regreplop.vim'  "Replace something with the clipboard (<C-K><motion>)
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/argtextobj.vim' "function arguments
Plug 'bkad/CamelCaseMotion'
Plug 'jremmen/vim-ripgrep' 

Plug 'glts/vim-magnum'	" For vim-radical
Plug 'glts/vim-radical' " View numbers in different representations (gA) and convert them (crd, crx, crb)

Plug 'jonsmithers/vim-html-template-literals'

Plug 'chr4/nginx.vim'
Plug 'ludovicchabant/vim-gutentags' " Update ctags files as you edit

Plug 'ConradIrwin/vim-bracketed-paste' " Supposed to fix double-indentation when pasting indented code into vim

Plug 'rluba/jai.vim'

Plug 'tpope/vim-fugitive'

call plug#end()

set nobackup		" do not keep a backup file
set nowritebackup
set autoindent		" always set autoindenting on
set autoread		" Load changed files without alerting us all the time
autocmd FileType html setlocal autoindent smartindent nocindent indentexpr=
autocmd FIleType changelog set tw=0	" Prevent VIM from hard-wrapping in changelog

if has("win32") || has("win64")
	set guifont=Fira\ Mono:h11
else 
	set guifont=Fira\ Mono:h15
endif


set tabstop=4
set shiftwidth=4
set nowrap
set hlsearch
set number relativenumber
set splitbelow
set splitright
set scrolloff=5 	 " Scroll vertially before hitting the edges of the window
set sidescrolloff=10 " Scroll horizontally before hitting the edges of the window
set ignorecase		 " Make search case-insensitive by default

" HTML indentation

let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

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

" Auto-close tags on "</"
autocmd FileType html inoremap </ </<C-X><C-O>

autocmd FileType javascript syntax keyword jsAsync async await
autocmd FileType javascript highlight link jsAsync Keyword

" if has("gui_vimr") || has("gui_macvim")
" 	let g:ctrlp_map = '<D-p>'
" else 
let g:ctrlp_map = '<C-p>'
" endif

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_custom_ignore = '\v[\/]((\.(git|hg|svn))|(node_modules|build|dist)$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'rg %s --files --color=never --glob ""']


" Remap jump to tag
" nnoremap ü :tj<CR>
nnoremap ü g<C-]>
nnoremap Ü <C-]>
nnoremap <C-w>ü <C-w>]

" set completeopt+=menuone,noinsert

map <Leader>= :%!jq --tab -S .<Enter>
map <Leader>c :make<Enter>

" Visual mode EasyAlign
xmap <leader>a <Plug>(EasyAlign)
" Normal mode EasyAlign
nmap <leader>a <Plug>(EasyAlign)

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
map <Leader>f :NERDTreeFind<Enter>
map <Leader>s :call SyncTree()<Enter>

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
" Disabled because it’s terribly slow for non-trivial projects
" autocmd BufEnter * call SyncTree()
"

fun! NoExcitingBuffersLeft()
    for w in range(1, winnr('$'))
        if bufname(winbufnr(w)) !~# '__Tagbar\|NERD_tree_\|coc-explorer'
                \ && getbufvar(winbufnr(w), "&buftype") !=? "quickfix"
            return
        endif
    endfor

    if tabpagenr('$') ==? 1
        execute 'quitall'
    else
        execute 'tabclose'
    endif
endfun

autocmd WinEnter * call NoExcitingBuffersLeft()

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

let g:rg_highlight = 1
let g:rg_derive_root = 1

autocmd FileType typescript setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType c setlocal commentstring=//\ %s
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
set cmdheight=1
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

" Jump to error/warning
nmap <silent> <leader>gn :call CocAction('diagnosticNext')<CR>
nmap <silent> <leader>gN :call CocAction('diagnosticPrevious')<CR>

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

nmap <M-Right> :vertical resize +1<CR>
nmap <M-Left> :vertical resize -1<CR>
nmap <M-Down> :resize +1<CR>
nmap <M-Up> :resize -1<CR>

" Jai stuff
let g:jai_path='C:/git/jai'
let g:jai_compiler='jai'
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

map <Leader>v :w<Enter> :bot terminal ++rows=20 jaic %<Enter>
map <Leader>r :execute '!jair ' . FindJaiExecutable(expand('%')) . ' ' . jair_args<Enter>
autocmd FileType jai compiler jai

" Ripgrep
let g:rg_highlight='true'
map <Leader>l "zyiw:exe 'Rg "\b'.@z.'\b"'<Enter>

"Move the quickfix window to the bottom.
"Neovim automatically opens the quickfix window when grep is called, so
"ripgrep’s g:rg_window_location has no effect because the window is already
"open
" autocmd FileType qf wincmd J


" Compile Jai project
autocmd BufRead */jai/*.cpp,*/jai/*.h set makeprg=cmake\ --build\ build/macos/debug\ --parallel\ 8
map <Leader>c :make<Enter>

let g:airline_section_b = '' " Get rid of 'current branch' indicator

set inccommand=split " Show multiple results when doing :%s replacements

if has("win32")
	source $VIMRUNTIME/mswin.vim
	nunmap <C-a>
endif
