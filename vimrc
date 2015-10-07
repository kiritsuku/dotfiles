" Plugin config {{{
" Plugin manager: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Both python2 and python3 support needs to be installed explicitly:
" python -m easy_install --user neovim
" python2 -m easy_install --user neovim

" adds colorthemes
Plug 'romainl/flattened'
Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'Valloric/YouCompleteMe', { 'do': 'python2 ./install.py' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/TagHighlight'
Plug 'jiangmiao/auto-pairs'
Plug 'lervag/vimtex'
Plug 'bling/vim-airline'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Edit images in vim
"Plug 'tpope/vim-afterimage'
Plug 'zhaocai/GoldenView.Vim'
Plug 'othree/xml.vim'
Plug 'terryma/vim-multiple-cursors'
" Expand region by key combination
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'
call plug#end()
" }}}
" Vim config {{{

filetype on
filetype plugin indent on
syntax on

if has('nvim')
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let g:terminal_scrollback_buffer_size=10000
  colorscheme flattened_light
elseif has("gui_running")
  colorscheme flattened_light
  set guifont=Fantasque\ Sans\ Mono\ Italic\ 11
else
  set t_Co=256
  set term=screen-256color
  colorscheme desert
  " no background
  hi Normal ctermbg=none
  " highlight line of cursor
  hi CursorLine term=bold cterm=bold
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
set wildmode=full
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
" Enable to move the cursor freely around
set virtualedit=all
" Enable mouse support
set mouse=a

" Specify a custom tabline
set tabline=%!CustomTabLine()

" use , instead of \ for mapleader
let mapleader=","
" Prefer LaTeX mode for files ending with .tex
let g:tex_flavor="latex"
"}}}
" Function definitions {{{

function! CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let name = bufname(buflist[winnr - 1])
  " check if the buffer is a terminal
  if name =~ 'term:'
    let shortName = substitute(name, 'term://.*//.*:\(.*\)', 'term:\1', '')
    return '[' . a:n . ':' . shortName . ']'
  elseif !empty(name)
    let shortName = substitute(name, '.*/\(.*\)', '\1', '')
    return '[' . a:n . ':' . shortName . ']'
  else
    return '[' . a:n . ':No Name]'
  endif
endfunction

function! CustomTabLine()
  let s = ''
  let nrOfTabs = tabpagenr('$')
  for i in range(nrOfTabs)
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by CustomTabLabel()
    let s .= '%{CustomTabLabel(' . (i + 1) . ')}'
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  return s
endfunction

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

" Create a new tab and open a terminal buffer in it
function! CreateNewTabShell()
  $tabnew
  term
endfunction()

"}}}
" Key combinations {{{

" Use CTRL-S for saving, also in Insert mode
" see: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
nn <C-S> :update<CR>
vn <C-S> <C-c>:update<CR>
ino <C-S> <C-o>:update<CR>

" Used in vimdiff
" nn <S-F1> :diffget LO<CR>
" ino <C-F1> <C-0>:diffget LO<CR>
" nn <C-F2> :diffget BA<CR>
" ino <C-F2> <C-0>:diffget BA<CR>
" nn <C-F3> :diffget RE<CR>
" ino <C-F3> <C-0>:diffget RE<CR>

" Use navigation between soft wrapped lines by default
nn <silent> <Up> :<C-u>call MoveUp(v:count)<cr>
ino <silent> <Up> <C-o>:<C-u>call MoveUp(v:count)<cr>
nn <silent> <Down> :<C-u>call MoveDown(v:count)<cr>
ino <silent> <Down> <C-o>:<C-u>call MoveDown(v:count)<cr>
nn <silent> <home> g<home>
ino <silent> <home> <C-o>g<home>
nn <silent> <End> g<End>
ino <silent> <End> <C-o>g<End>

" leave insert mode with C-d
ino <C-d> <C-c>

" clear search highlighting pattern
nn <silent> <leader><space> :let @/ = ""<cr>
nn <leader>r :CtrlP<cr>
nn <leader>t :CtrlPTag<cr>
nn <leader>b :CtrlPBuffer<cr>
nn <leader>se :setlocal spell! spelllang=en_us<cr>
nn <leader>sg :setlocal spell! spelllang=de<cr>
" see http://superuser.com/questions/195022/vim-how-to-synchronize-nerdtree-with-current-opened-tab-file-path
nn <leader>o :NERDTreeFind<cr>
nn <leader>c :NERDTreeToggle<cr>
nn <leader>hs :setlocal syntax=scala<cr>
nn <leader>hh :setlocal syntax=sh<cr>
nn <leader>hn :setlocal syntax=off<cr>
" jump to first error location
no <leader>je :cwindow<cr>:cc<cr><c-w>bz<cr><cr>
" jump to next error location
no <leader>jn :cwindow<cr>:cn<cr><c-w>bz<cr><cr>
" jump to previous error location
no <leader>jN :cwindow<cr>:cp<cr><c-w>bz<cr><cr>
" reformat paragraph
nn <leader>q gqip
" run a given macro on the whole file
nn <leader>@ :%normal @
" run a given macro on selected area
vn <leader>@ :normal @
" copy to system clipboard
vn <leader>y "+y
" paste from system clipboard
nn <leader>p "+p
nn <leader>P "+P
vn <leader>p "+p
vn <leader>P "+P

" Enable easymotion plugin
nm <space> <Plug>(easymotion-prefix)

" vertical split with |
nn <C-w><Bar> :vsplit<cr>
nn <C-a><Bar> :vsplit<cr>
" horizontal split with -
nn <C-w>- :split<cr>
nn <C-a>- :split<cr>

" enable very magic regex mode (everything except a-zA-Z0-9_ is interpreted)
nn / /\v
vn / /\v
" search text that is visually selected
vn // y/<C-r>"<cc>

" disable history view
nn q: <nop>

" Allows saving of files with sudo
cno w!! w !sudo tee > /dev/null %<cr>

" Expand and shrink region
map + <Plug>(expand_region_expand)
map - <Plug>(expand_region_shrink)

" highlight last inserted text
nn gV `[v`]
" Automatically jump to the end of yanked text
vn <silent> y y`]
" Automatically jump to the end of pasted text
vn <silent> p p`]
nn <silent> p p`]

" Create new tab
nn <C-a>c :call CreateNewTabShell()<cr>
" <C-a> is also used to switch windows in terminal mode
nn <C-a> <C-w>

" Jump to tab by typing its number
for i in range(1, 9)
  exe 'nn <C-a>' . i . ' ' . i . 'gt'
endfor

if has('nvim')
  " leave terminal mode
  tno <C-a> <C-\><C-n>
  tno <C-a>a <C-\><C-n>
  " Create new tab
  tno <C-a>c <C-\><C-n>:call CreateNewTabShell()<cr>

  " better navigation in terminal mode
  tno <C-a><left> <C-\><C-n><C-w>h
  tno <C-a><down> <C-\><C-n><C-w>j
  tno <C-a><up> <C-\><C-n><C-w>k
  tno <C-a><right> <C-\><C-n><C-w>l

  " Jump to tab by typing its number
  for i in range(1, 9)
    exe 'tno <C-a>' . i . ' <C-\><C-n>' . i . 'gt'
  endfor
endif

"}}}
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
" vimtex config {{{

let g:vimtex_enbaled=1
let g:vimtex_latexmk_build_dir='bin'
let g:vimtex_fold_enabled=1
let g:vimtex_quickfix_ignored_warnings = [
  \ "Usage of package",
  \ "float@addtolists detected",
  \ "Overfull ",
  \ "Underfull "
\ ]

"}}}
" AutoPairs config {{{
let g:AutoPairsCenterLine=0
let g:AutoPairsFlyMode=1
"}}}
" Airline config {{{
let g:airline_inactive_collapse=0
"}}}
" Easymotion config {{{
" }}}
" Auto-commands {{{
"
function! SaveAfterFocusLost()
  " check if filename is not empty and file is modifiable
  if !empty(@%) && &modifiable
    :call RemoveTrailingWhitespace()
    :update
  endif
endfunction()

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
  au BufWritePre * :call RemoveTrailingWhitespace()
  " automatically reloads .vimrc whenever it has changed
  au BufWritePost .vimrc source $MYVIMRC
  " automatically save document when focus is lost
  au FocusLost * :call SaveAfterFocusLost()
  " configure vrapperrc filetype
  au BufNewFile,BufRead *.vrapperrc setlocal filetype=vim
  " configure sbt filetype
  au BufNewFile,BufRead *.sbt setlocal filetype=scala
  " enable useful features for git commit files
  au FileType gitcommit setlocal spell | setlocal colorcolumn=72
  " set a maximum textwidth to tex files
  au BufNewFile,BufRead *.tex setlocal textwidth=80 | setlocal colorcolumn=81 | setlocal spell

  " auto commands that should only work when a gui is running
  if has("gui_running")
    " Maximize GUI with wmctrl
    au VimEnter * call system('wmctrl -i -b add,maximized_vert,maximized_horz -r'.v:windowid)
  endif

  " auto commands that should only work in neovim
  if has('nvim')
    " automatically move to insert mode once a terminal buffer is entered
    au WinEnter * if &buftype == 'terminal' | :startinsert | endif
  endif
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

" Moving:
" C-O - Jump to previous location
" C-I - Jump to next location

"}}}
