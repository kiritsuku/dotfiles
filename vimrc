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
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/TagHighlight'
Plugin 'jiangmiao/auto-pairs'
Plugin 'lervag/vim-latex'
Plugin 'bling/vim-airline'

call vundle#end()
" }}}

" Vim config {{{
if !has("gui_running")
  set t_Co=256
  set term=screen-256color
  syntax on
  colorscheme github
  hi Normal ctermbg=black |"ctermfg=grey
else
  syntax on
  colorscheme solarized
  set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
endif

" Enable patched fonts for *line
" see https://powerline.readthedocs.org/en/master/installation/linux.html#fonts-installation
" on how to get patched fonts
let g:airline_powerline_fonts=1

filetype on
filetype plugin indent on     " required for Vundle

" enable line numbers
set number
set relativenumber
" enable line wrapping of full words
set wrap
set linebreak
" print margin
"set cc=80
" size of tabs
set tabstop=2
" number of spaces
set shiftwidth=2
set expandtab
" insert spaces instead of tab
set smarttab
set autoindent
set ruler
" highlight search
set incsearch
set hlsearch
" open new splits to the right and below of the current window
set splitbelow
set splitright
" show completion menu in command mode
set wildmenu
" redraw only when necessary
set lazyredraw
" Always show statusline
set laststatus=2

" enable folding
set foldenable
" fold by markers
set foldmethod=marker
" fold most outer level
set foldlevel=0

let mapleader=","

" Store .swp files in /tmp by their full path
set dir=/tmp//,.
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
"}}}

" Key combinations {{{

" Use CTRL-S for saving, also in Insert mode
" see: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
nmap <C-S> :update<CR>
vmap <C-S> <C-C>:update<CR>
imap <C-S> <C-O>:update<CR>

" Used in vimdiff
" nn <S-F1> :diffget LO<CR>
" ino <C-F1> <C-0>:diffget LO<CR>
" nn <C-F2> :diffget BA<CR>
" ino <C-F2> <C-0>:diffget BA<CR>
" nn <C-F3> :diffget RE<CR>
" ino <C-F3> <C-0>:diffget RE<CR>

" Use navigation between soft wrapped lines by default
nmap <silent> <Up> :<C-U>call MoveUp(v:count)<CR>
imap <silent> <Up> <C-O>:<C-U>call MoveUp(v:count)<CR>
nmap <silent> <Down> :<C-U>call MoveDown(v:count)<CR>
imap <silent> <Down> <C-O>:<C-U>call MoveDown(v:count)<CR>
nmap <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
nmap <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

" toggle nerdtree
nmap <F2> :NERDTreeToggle .<CR>
imap <F2> <C-O>:NERDTreeToggle .<CR>

" toggle tagbar
nmap <F3> :TagbarToggle<CR>
imap <F3> <C-O>:TagbarToggle<CR>

" toggle spell checking
nmap <F5> :setlocal spell! spelllang=en_us<CR>
imap <F5> <C-O>:setlocal spell! spelllang=en_us<CR>

" leave insert mode with C-D
imap <C-D> <C-C>

" highlight last inserted text
nmap gV `[v`]
" remove search highlighting
nmap <leader><space> :nohlsearch<cr>
nmap <leader>r :CtrlP<cr>
nmap <leader>t :CtrlPTag<cr>
nmap <leader>s :setlocal spell! spelllang=en_us<cr>
nmap <leader>o :TagbarToggle<cr>
nmap <leader>n :NERDTreeToggle .<cr>

" vertical split with |
nmap <C-W><Bar> :vsplit<cr>
" horizontal split with -
nmap <C-W>- :split<cr>

"}}}

" Auto-Pairs config {{{
let g:AutoPairsFlyMode=1
" }}}

" NERDTree config {{{

"let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeShowHidden = 1

" }}}

" Other config {{{

" enable C++11 support for syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'

"}}}

" YouCompleMe config {{{

let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_complete_in_comments=1
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_seed_identifiers_with_syntax=1
let g:ycm_key_detailed_diagnostics='<leader>d'
let g:ycm_confirm_extra_conf=0
" }}}

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
" nmap <leader>r :<C-U>RangerChooser<CR>
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
"}}}

" vim-latex config {{{

let g:latex_enbaled=1
let g:latex_build_dir="out"
let g:latex_fold_enabled=1

"}}}

" Save actions {{{

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
augroup END
"}}}

" Vim command docs {{{

" C-O - leave insert mode temporarily
" C-U - remove visual mode selection
" go - guioptions

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

"}}}
