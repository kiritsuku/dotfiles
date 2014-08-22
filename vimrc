set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'
"call vundle#rc(path)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bundle config                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Bundle 'gmarik/vundle'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'lsdr/monokai'
Bundle 'Townk/vim-autoclose'
Bundle 'vim-scripts/AutoComplPop'
Bundle 'zah/nimrod.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-abolish'
"Bundle 'altercation/vim-colors-solarized'

" scripts from http://vim-scripts.org/vim/scripts.html
"Bundle 'FuzzyFinder'
" scripts not on GitHub
"Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Bundle 'file:///home/gmarik/path/to/plugin'

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install (update) bundles
" :BundleSearch(!) foo - search (or refresh cache first) for foo
" :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" config                                                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
set term=screen-256color
"set background=dark
"colorscheme solarized
syntax on
colorscheme github
hi Normal ctermbg=black |"ctermfg=grey
filetype on
filetype plugin indent on     " required

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

" Use CTRL-S for saving, also in Insert mode
" see: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" Use navigation between soft wrapped lines by default
nmap <silent> <Up> :<C-U>call MoveUp(v:count)<CR>
imap <silent> <Up> <C-O>:<C-U>call MoveUp(v:count)<CR>
nmap <silent> <Down> :<C-U>call MoveDown(v:count)<CR>
imap <silent> <Down> <C-O>:<C-U>call MoveDown(v:count)<CR>
nmap <silent> <home> g<home>
imap <silent> <home> <C-o>g<home>
nmap <silent> <End> g<End>
imap <silent> <End> <C-o>g<End>

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

" enable spell checking toggle
map <F5> :setlocal spell! spelllang=en_us<cr>
imap <F5> <C-O>:setlocal spell! spelllang=en_us<cr>

" leave insert mode with C-D
imap <C-D> <C-C>

" enable C++11 support for syntastic
let g:syntastic_cpp_compiler_options = ' -std=c++11'

" Nimrod support
fun! JumpToDef()
  if exists("*GotoDefinition_" . &filetype)
    call GotoDefinition_{&filetype}()
  else
    exe "norm! \<C-]>"
  endif
endf

" Jump to tag
nn <M-g> :call JumpToDef()<cr>
ino <M-g> <esc>:call JumpToDef()<cr>i

" enable neocomplcache
"let g:neocomplcache_enable_at_startup = 1

" open nerdtree in current directory
noremap <F2> :NERDTree .<return>
inoremap <F2> <C-O>:NERDTree .<return>

" remove trailing whitespace from file
function! RemoveTrailingWhitespace()
  :%s/\s\+$//e
endfunction()
:autocmd BufWritePost * :call RemoveTrailingWhitespace()

" automatically reloads .vimrc whenever it has changed
augroup reload_myvimrc
  au!
  autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

" convert this_is_a_string to ThisIsAString
function! ConvertCamel()
  :s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g
endfunction
nn <C-T> :call ConvertCamel()<cr>

" ranger support
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
nnoremap <leader>r :<C-U>RangerChooser<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim docu                                                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" C-O - leave insert mode temporarily
" C-U - remove visual mode selection

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key combinations                                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
