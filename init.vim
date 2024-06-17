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
Plug 'rluba/vim-ripgrep' 

Plug 'glts/vim-magnum'	" For vim-radical
Plug 'glts/vim-radical' " View numbers in different representations (gA) and convert them (crd, crx, crb)

Plug 'jonsmithers/vim-html-template-literals'

Plug 'chr4/nginx.vim'
Plug 'ludovicchabant/vim-gutentags' " Update ctags files as you edit

Plug 'ConradIrwin/vim-bracketed-paste' " Supposed to fix double-indentation when pasting indented code into vim

Plug 'rluba/jai.vim'

Plug 'tpope/vim-fugitive'

Plug 'posva/vim-vue'

" This is super-broken in combination with ripgrep search
" Plug 'wellle/context.vim' " Sticky context while scrolling

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
	set guifont=Fira\ Mono:h14
endif


set tabstop=4
set shiftwidth=4
set expandtab
set nowrap
set hlsearch
set number
" set number relativenumber
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

if has("mac") && has("gui_running") 
 	let g:ctrlp_map = '<D-p>'
else 
    let g:ctrlp_map = '<C-p>'
endif

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_custom_ignore = '\v[\/]((\.(git|hg|svn))|(node_modules|build|dist)$'
if has("win32")
    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'rg %s --files --color=never --glob ""']
else
    let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
endif
let g:ctrlp_switch_buffer = 'et' " If a file is already open, open it again in a new pane instead of switching to the existing pane

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

" Next/previous search result
map <C-n> :cn<Enter>
map <C-j> :cN<Enter>

" Navigate tabs
map <C-h> gT
map <C-l> gt

" Exit terminal with Esc
tnoremap <Esc> <C-\><C-n>


" Automatically open quickfix window when compiling
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" NERDTree
let NERDTreeIgnore=['.dSYM$','\~$']
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
        let l:name = bufname(winbufnr(w))
        let l:type = getbufvar(winbufnr(w), "&buftype")
        " echo "Name: " . l:name . ", Type: " . l:type
        " @ToDo: Also ignore help window (But we don’t seem to find it with the
        " range expression above
        if l:name !~# '__Tagbar\|NERD_tree_\|coc-explorer' && type !=? "quickfix"
            return
        endif
    endfor

    if tabpagenr('$') ==? 1
        execute 'quitall'
    else
        execute 'tabclose'
    endif
endfun

autocmd WinClosed * call NoExcitingBuffersLeft()

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

autocmd FileType typescript setlocal commentstring=//\ %s
autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType c setlocal commentstring=//\ %s
""""""""""""""""
" COC stuff
""""""""""""""""

" coc config
let g:coc_node_path = '/Users/raphael/.nvm/versions/node/v18.20.2/bin/node'
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


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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
if has("win32")
    let g:jai_path='C:/git/jai'
else
    let g:jai_path='/Users/raphael/Projekte/jai/jai'
endif
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

autocmd FileType jai compiler jai
 "Set the current file as jai entry point
map <Leader>j :let g:jai_entrypoint = expand('%')<Enter> :call UpdateJaiMakeprg()<Enter>
map <Leader>u :call UpdateJaiMakeprg()<Enter>


" Ripgrep
let g:rg_highlight = 1
let g:rg_derive_root = 1
map <Leader>l "zyiw:exe 'Rg "\b'.@z.'\b"'<Enter>

"Move the quickfix window to the bottom.
"Neovim automatically opens the quickfix window when grep is called, so
"ripgrep’s g:rg_window_location has no effect because the window is already
"open
" autocmd FileType qf wincmd J

if !has("win32")
    " gutentags / ctags
    let g:gutentags_ctags_executable='/opt/homebrew/bin/ctags'
endif

" Compile Jai project
if has("win32")
    autocmd BufRead */jai/*.cpp,*/jai/*.h setlocal errorformat=%f(%l\\\,%c):\ fatal\ %t%*[^:]:\ %m,%f(%l\\\,%c):\ %t%*[^:]:\ %m,%f(%l):\ fatal\ %t%*[^:]:\ %m,%f(%l):\ %t%*[^:]:\ %m,%*[^.].lib%*[^:]:\ %t%*[^:]:\ %m,%*[^.].obj%*[^:]:\ %t%*[^:]:\ %m
    autocmd BufRead */jai/*.cpp,*/jai/*.h setlocal makeprg=MSBuild.exe\ /nologo\ /v:q\ /p:configuration=Debug\ /p:platform=x64\ /p:GenerateFullPaths=true\ jai.vcxproj
else 
    autocmd BufRead */jai/*.cpp,*/jai/*.h setlocal makeprg=cmake\ --build\ build/macos/arm_debug\ --parallel\ 8
endif


let g:airline_section_b = '' " Get rid of 'current branch' indicator

set inccommand=split " Show multiple results when doing :%s replacements

if has("win32")
	source $VIMRUNTIME/mswin.vim
	nunmap <C-a>
endif

let g:neovide_cursor_animation_length=0
