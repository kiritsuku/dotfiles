# Antigen config {{{
source $HOME/.antigen.zsh

# Instead of
#   antigen use oh-my-zsh
# or
#   antigen bundle robbyrussell/oh-my-zsh lib/
# we load the source files of the lib directory directly.
# This way not all existing source files are loaded but only
# the ones that are needed.
LIB=$HOME/.antigen/bundles/robbyrussell/oh-my-zsh/lib
source $LIB/compfix.zsh
source $LIB/completion.zsh
source $LIB/correction.zsh
source $LIB/git.zsh
source $LIB/history.zsh
source $LIB/key-bindings.zsh
source $LIB/spectrum.zsh
source $LIB/theme-and-appearance.zsh

antigen bundle scala
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle autojump
antigen apply
# }}}
# Zsh prompt {{{

# `fg` is needed for color names and `FG` for color numbers
PROMPT='[%{$fg[red]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%} → %{$FG[039]%}%~%{$reset_color%}$(git_prompt_info)]
%# '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} M"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} D"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} →"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} ="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%} ??"

#symbols=""
# check if a background job is running in current session
#[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙%{$reset_color%}"

# display exitcode on the right when >0
return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

# adds the git prompt to the passed argument $1
# call with: add-git-prompt myvar
function add-git-prompt {
  eval "$1='"'$return_code$(git_prompt_status)%{$reset_color%}'"'"
}
# adding background job test doesn't work correctly
#RPROMPT='$symbols $return_code$(git_prompt_status)%{$reset_color%}'
add-git-prompt RPROMPT
# }}}
# Zsh config {{{

# set colors for zsh syntax highlighting
# execute `spectrum_ls` to get a list of color values
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=208'
ZSH_HIGHLIGHT_STYLES[path_approx]='fg=208,underline'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=208'

# Colortheme from https://github.com/seebi/dircolors-solarized
eval `dircolors ~/bin/dircolors.ansi-light`

# weird & wacky pattern matching...
setopt extendedglob
# ...but when pattern matching fails, simply use the command as is
setopt no_nomatch
# interpret lines starting with '#' as comments
setopt interactive_comments
# use insensitive matching
unsetopt CASE_GLOB

# Do not interpret ^W, we want that neovim interprets it
bindkey '^W' self-insert

# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f
# }}}
# Exports {{{
export EDITOR="vim"
# This needs to be set and at the same time true color support needs to be disabled in
# neovim in order to display all colors correctly. Only setting true color support in
# neovim leads to broken colors in some terminals.
export COLORTERM=xterm-256color
# bin folder
export PATH=$HOME/bin:$PATH
# scala executables
export PATH=$PATH:$HOME/software/scala-2.12.6/bin/

# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export LESS='--quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --tabs=4 --no-init --window=-4'

# make can't always handle parallel builds; enable on demand
#export MAKEFLAGS="-j4 $MAKEFLAGS"
# }}}
# Commands and Aliases {{{

# Default auto completions only work for aliases but not for functions
alias g='git'
alias p='sudo pacman'
alias y='yaourt'

# Requires 32 bit glibc to be installed. In arch: lib32-glibc
function cp() {
  command $HOME/bin/hidden/cp -B "$@"
}
function mv() {
  command $HOME/bin/hidden/mv -B "$@"
}
function rm() {
  command $HOME/bin/hidden/rm -B "$@"
}

function st() {
  startx >/tmp/startx.log 2>&1
}
function l() {
  ls -lAh --color=always "$@" | less
}
function c() {
  command code .
}
function cl() {
  command cloc . --exclude-dir=target,bin,node_modules --read-lang-def=$HOME/bin/cloc-ttl.txt "$@"
}
function vim() {
  # needed to enable save on CTRL-S
  stty stop '' -ixoff; command vim "$@"
}
function v() {
  command nvim-client "$@"
}
function gv() {
  command gvim "$@"
}
function d() {
  command sudo systemctl restart dhcpcd.service
}
function pacman-remove-orphans() {
  command sudo pacman -Rs $(pacman -Qdtq)
}
# }}}
# FZF config {{{

# Load fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g "" -p ~/.gitignore'
# Show results on entire screen
export FZF_DEFAULT_OPTS='--no-height'
# Show a preview window for file contents in CTRL-T
# If the file is binary, don't show its contents. Otherwise show the highlighted content.
export FZF_CTRL_T_OPTS='--preview '\''[[ $(file --mime {}) =~ binary ]] && echo "$(file {})" || (highlight -O ansi {} || head -50 {}) 2> /dev/null | head -50'\'

export FZF_COMPLETION_OPTS='+c -x'

function _fzf_compgen_path() {
  ag -g "" -p ~/.gitignore "$1"
}
# }}}
# Ranger config {{{
# Automatically jump to the directory ranger is located to when one leaves ranger
function rn() {
  tempfile='/tmp/ranger-chosendir'
  /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}
# }}}
# Colorized man pages {{{
# see: http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
function man() {
  LESS_TERMCAP_md=$'\e[1;36m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;40;92m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[1;32m' \
  command man "$@"
}
# }}}
