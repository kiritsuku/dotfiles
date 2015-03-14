" Vundle config {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"}}}
" Plugin config {{{
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-abolish'
Plugin 'mileszs/ack.vim'
Plugin 'drewfradette/Conque-Shell'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'altercation/vim-colors-solarized'
Plugin 'majutsushi/tagbar'
Plugin 'rking/ag.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-scripts/TagHighlight'
Plugin 'jiangmiao/auto-pairs'
Plugin 'lervag/vim-latex'
Plugin 'bling/vim-airline'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
" Edit images in vim
"Plugin 'tpope/vim-afterimage'
Plugin 'zhaocai/GoldenView.Vim'
Plugin 'othree/xml.vim'
Plugin 'terryma/vim-multiple-cursors'

call vundle#end()
" }}}
" Vim config {{{

filetype on
" required for Vundle
filetype plugin indent on
syntax on

if !has("gui_running")
  set t_Co=256
  set term=screen-256color
  colorscheme desert
  " no background
  hi Normal ctermbg=none
  " highlight line of cursor
  hi CursorLine term=bold cterm=bold
else
  colorscheme solarized
  "set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
  set guifont=Fantasque\ Sans\ Mono\ Italic\ 11
  " Maximize GUI with wmctrl
  autocmd VimEnter * call system('wmctrl -i -b add,maximized_vert,maximized_horz -r'.v:windowid)
endif

" Enable patched fonts for *line
" see https://powerline.readthedocs.org/en/master/installation/linux.html#fonts-installation
" on how to get patched fonts
let g:airline_powerline_fonts=1

" enable line numbers
set number
set relativenumber
" enable line wrapping of full words
set wrap
" wrap words at end of line
set linebreak
" size of tabs
set tabstop=2
" number of spaces
set shiftwidth=2
" insert spaces instead of tabs
set expandtab
set smarttab
" copy indent of curront line when starting a new line
set autoindent
" show column and line numbers
set ruler
" show match while typing
set incsearch
" highlight search
set hlsearch
" open new splits to the right and below of the current window
set splitbelow
set splitright
" show completion menu in command mode
set wildmenu
" show matches in wildmenu but don't complete automatically
set wildmode=longest:full
" redraw only when necessary
set lazyredraw
" Always show statusline
set laststatus=2
" Automatically save file before buffer change
set autowrite
" Automatically refersh file on change
set autoread
" needed to  show whitespace characters
set list
" display whitespace characters
set listchars=tab:‣\ ,
" enable folding
set foldenable
" fold by markers
set foldmethod=marker
" fold most outer level
set foldlevel=0
" number of lines to look forward when cursor at end of screen
set scrolloff=3
" show line of cursor
set cursorline
" better terminal response time
set ttyfast
" store undofiles between sessions
set undofile
" ignore case in search
set ignorecase
" ignore 'ignorecase' if search contains upper case letters
set smartcase
" substitute flag 'g' is enabled by default
set gdefault
" Store .swp files in /tmp by their full path
set dir=/tmp//,.
" Store undo files in /tmp by their full path
set undodir=/tmp//,.

" use , instead of \ for mapleader
let mapleader=","
" Prefer LaTeX mode for files ending with .tex
let g:tex_flavor="latex"
"}}}
" Function definitions {{{
" Move `vcount` lines down and move cursor to beginning of line if more
" than one line should be moved down.
function! MoveDown(vcount)
  if a:vcount == 0
    exe "normal! gj"
  else
    exe "normal! ". a:vcount ."j|"
  endif
endfunction

" Move `vcount` lines up and move cursor to beginning of line if more
" than one line should be moved up.
function! MoveUp(vcount)
  if a:vcount == 0
    exe "normal! gk"
  else
    exe "normal! ". a:vcount ."k|"
  endif
endfunction

" Generates scala tag files for tagbar
function! GenerateScalaTags()
    if executable("sctags")
        let g:tagbar_ctags_bin = "sctags"
        let g:tagbar_type_scala = {
            \ 'ctagstype' : 'scala',
            \ 'sro'       : '.',
            \ 'kinds'     : [
                \ 'p:packages',
                \ 'V:values',
                \ 'v:variables',
                \ 'T:types',
                \ 't:traits',
                \ 'o:objects',
                \ 'O:case objects',
                \ 'c:classes',
                \ 'C:case classes',
                \ 'm:methods:1'
            \ ],
            \ 'kind2scope'  : {
                \ 'p' : 'package',
                \ 'T' : 'type',
                \ 't' : 'trait',
                \ 'o' : 'object',
                \ 'O' : 'case_object',
                \ 'c' : 'class',
                \ 'C' : 'case_class',
                \ 'm' : 'method'
            \ },
            \ 'scope2kind'  : {
                \ 'package' : 'p',
                \ 'type' : 'T',
                \ 'trait' : 't',
                \ 'object' : 'o',
                \ 'case_object' : 'O',
                \ 'class' : 'c',
                \ 'case_class' : 'C',
                \ 'method' : 'm'
            \ }
        \ }
    endif
endfunction

" Checks if current file is a scala file in order to generate tag files
function! ModifiedTagbarToggle()
  " case sensitive comparison
  if &filetype ==# "scala"
    call GenerateScalaTags()
  endif
  :TagbarToggle
endfunction
"}}}
" Key combinations {{{

" Use CTRL-S for saving, also in Insert mode
" see: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
nn <C-S> :update<CR>
vn <C-S> <C-C>:update<CR>
ino <C-S> <C-O>:update<CR>

" Used in vimdiff
" nn <S-F1> :diffget LO<CR>
" ino <C-F1> <C-0>:diffget LO<CR>
" nn <C-F2> :diffget BA<CR>
" ino <C-F2> <C-0>:diffget BA<CR>
" nn <C-F3> :diffget RE<CR>
" ino <C-F3> <C-0>:diffget RE<CR>

" Use navigation between soft wrapped lines by default
nn <silent> <Up> :<C-U>call MoveUp(v:count)<CR>
ino <silent> <Up> <C-O>:<C-U>call MoveUp(v:count)<CR>
nn <silent> <Down> :<C-U>call MoveDown(v:count)<CR>
ino <silent> <Down> <C-O>:<C-U>call MoveDown(v:count)<CR>
nn <silent> <home> g<home>
ino <silent> <home> <C-o>g<home>
nn <silent> <End> g<End>
ino <silent> <End> <C-o>g<End>

" toggle nerdtree
nn <F2> :NERDTreeToggle .<CR>
ino <F2> <C-O>:NERDTreeToggle .<CR>

" toggle tagbar
nn <F3> :TagbarToggle<CR>
ino <F3> <C-O>:TagbarToggle<CR>

" toggle spell checking
nn <F5> :setlocal spell! spelllang=en_us<CR>
ino <F5> <C-O>:setlocal spell! spelllang=en_us<CR>

" leave insert mode with C-D
ino <C-D> <C-C>

" highlight last inserted text
nn gV `[v`]
" clear search highlighting pattern
nn <silent> <leader><space> :let @/ = ""<cr>
nn <leader>r :CtrlP<cr>
nn <leader>t :CtrlPTag<cr>
nn <leader>se :setlocal spell! spelllang=en_us<cr>
nn <leader>sg :setlocal spell! spelllang=de<cr>
nn <leader>o :call ModifiedTagbarToggle()<cr>
nn <leader>n :NERDTreeToggle .<cr>
nn <leader>e :ConqueTermVSplit<space>
nn <leader>hs :set syntax=scala<cr>
nn <leader>hh :set syntax=sh<cr>
nn <leader>hn :set syntax=off<cr>
" jump to first error location
no <leader>je :cwindow<cr>:cc<cr><c-w>bz<cr><cr>
" jump to next error location
no <leader>jn :cwindow<cr>:cn<cr><c-w>bz<cr><cr>
" jump to previous error location
no <leader>jN :cwindow<cr>:cp<cr><c-w>bz<cr><cr>
" reformat paragraph
nn <leader>q gqip

" invoke functionality of latex plugin
nn <leader>lt :call latex#latexmk#toggle()<cr>
nn <leader>lv :call latex#view()<cr>

" vertical split with |
nn <C-W><Bar> :vsplit<cr>
" horizontal split with -
nn <C-W>- :split<cr>
" better key combinations for window navigation
"nn <C-h> <C-w>h
"nn <C-j> <C-w>j
"nn <C-k> <C-w>k
"nn <C-l> <C-w>l

" enable very magic regex mode (everything except a-zA-Z0-9_ is interpreted)
nn / /\v
vn / /\v

" disable history view
nn q: <nop>

"}}}
" Auto-Pairs config {{{
let g:AutoPairsFlyMode=1
" }}}
" NERDTree config {{{

"let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeShowHidden = 1

" }}}
" Syntastic config {{{

" enable C++11 support for syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_mode_map = { "mode": "active",
                           \ "active_filetypes": [],
                           \ "passive_filetypes": ["tex", "scala"] }

"}}}
" YouCompleMe config {{{

" We have to disable tab here, otherwise UltiSnips needs to be remapped
let g:ycm_key_list_select_completion=['<tab>', '<down>']
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_key_detailed_diagnostics='<leader>d'
let g:ycm_confirm_extra_conf=0
" }}}
" UltiSnips config {{{
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"}}}
" Ranger config {{{

" run ranger from within vim
function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    exec 'silent !ranger --choosefiles=' . shellescape(temp)
    if !filereadable(temp)
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction

command! -bar RangerChooser call RangeChooser()
"nn <leader>m :RangerChooser<CR>
"}}}
" gVim config {{{

" Remove menubar
set go-=m
" Remove toolbar
set go-=T
" Remove scrollbars
set go-=r
set go-=R
set go-=l
set go-=L
set go-=b
" Use console dialogs
set go+=c

" }}}
" CtrlP config {{{

" List files top to bottom
let g:ctrlp_match_window='bottom,order:ttb'
" Open files in new buffers
let g:ctrlp_switch_buffer=0
" Grabs a change to the working directory
let g:ctrlp_working_path_mode=0
" Use 'ag' as search tool
let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
" search by filname by default
let g:ctrlp_by_filename=1
"}}}
" vim-latex config {{{

let g:latex_enbaled=1
let g:latex_build_dir='out'
let g:latex_fold_enabled=1
let g:latex_quickfix_ignored_warnings = [
  \ "Usage of package",
  \ "float@addtolists detected",
  \ "Overfull "
\ ]

"}}}
" AutoPairs config {{{
let g:AutoPairsCenterLine=0
let g:AutoPairsFlyMode=0
"}}}
" Airline config {{{
let g:airline_inactive_collapse=0
"}}}
" Auto-commands {{{

function! RemoveTrailingWhitespace()
  " save last search & cursor position befre trailing whitespace is removed
  let _s=@/
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  let @/=_s
  call cursor(l, c)
endfunction()

augroup configgroup
  au!
  " remove trailing whitespace from file
  autocmd BufWritePre * :call RemoveTrailingWhitespace()
  " automatically reloads .vimrc whenever it has changed
  autocmd BufWritePost .vimrc source $MYVIMRC
  " automatically save document when focus is lost
  autocmd FocusLost * :wa
  " configure vrapperrc filetype
  autocmd BufNewFile,BufRead *.vrapperrc set filetype=vim
  " configure sbt filetype
  autocmd BufNewFile,BufRead *.sbt set filetype=scala
augroup END
"}}}
" Vim command docs {{{

" C-O - leave insert mode temporarily
" C-U - remove visual mode selection
" go - guioptions
" g; g, - move through changelist

" :r! - execute external command
" :%!xxd - make vim to hex editor
" :%!xxd -r - revert hex editor mode

"}}}
" Key combinations docs {{{

" UMSCHALT+d - delete all after cursor
" CTRL+W+direction - move between windows
" SHIFT+Z+Z - save and close window
" CTRL+D - open completion menu in command mode
" CTRL+X - decrement number
" M,H,L - place cursor at middle, top or bottom of screen

" gi - switches to insertion mode and set cursor to the same location it was
"      previously
" g<x> - change case of text, where <x> is one of
"        - ~: toggle text case
"        - u: convert to lowercase
"        - U: convert to uppercase

" V - select line wise
" V+y - copy lines
" V+d - cut lines
" d+d - cut current line

" n>>, n<< - indent n lines to right and left

" ciw - change inner word (replace entire word)
" cw - change word (replace word starting at cursor position)

" gg - jump to first line of a file
" G - jump to last line of a file

" :%y+ - copy entire file to clipboard

" z. - put line under cursor to screen center
" zt - put line under cursor to screen top
" zb - put line under cursor to screen bottom

" '' - jump to beginning of line of last cursor location
" `` - jump to last cursor location

" Coercions:
"
" crs - snake_case
" crm - MixedCase
" crc - camelCase
" cru - UPPER_CASE

" Folding:
" v{motion}zf - Surround with fold markers
" za - toggle fold
" zR - open all folds
" zM - close all folds

" Spelling:
" zg - add word to dictionary
" zw - remove word from dictionary
" z= - ask for corrections
" ]s - move to next spelling error
" [s - move to previous spelling error

"}}}
