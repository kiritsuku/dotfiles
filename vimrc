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
"Bundle 'Shougo/neocomplete.vim'
Bundle 'Valloric/YouCompleteMe'

" scripts from http://vim-scripts.org/vim/scripts.html
"Bundle 'L9'
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
colorscheme github
hi Normal ctermbg=black |"ctermfg=grey
syntax on
filetype on
filetype plugin indent on     " required

" enable line numbers
set number
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

" Use CTRL-S for saving, also in Insert mode
" see: http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key combinations                                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" UMSCHALT+d - delete all after cursor
" CTRL+W+direction - move between windows
" SHIFT+Z+Z - save and close window
" CTRL+D - open completion menu in command mode
" CTRL+X - decrement number
