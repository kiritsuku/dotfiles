# Antigen config {{{
source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
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

# start ssh agent if not started yet
if [ -z $SSH_AGENT_PID ]; then
  # only take first lines of ssh-agent output
  ssh-agent | head -n 2 > ~/.ssh-env
  source ~/.ssh-env
  ssh-add
else
  source ~/.ssh-env
fi
# }}}
# Exports {{{
export EDITOR="vim"
# This needs to be set and at the same time true color support needs to be disabled in
# neovim in order to display all colors correctly. Only setting true color support in
# neovim leads to broken colors in some terminals.
export COLORTERM=xterm-256color
# bin folder
export PATH=$HOME/bin:$PATH
# ruby executables
export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin
export PATH=$PATH:$HOME/.rvm/bin
# scala executables
export PATH=$PATH:$HOME/software/scala-2.12.0/bin/
export PATH=$PATH:$HOME/software/activator-1.3.2/
# go executables
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
# apache-jena executables
export PATH=$PATH:$HOME/software/apache-jena-3.0.1/bin/

# https://www.topbug.net/blog/2016/09/27/make-gnu-less-more-powerful/
export LESS='--quit-if-one-screen --ignore-case --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'

# make can't always handle parallel builds; enable on demand
#export MAKEFLAGS="-j4 $MAKEFLAGS"
# }}}
# Aliase {{{
cp() {
  command $HOME/bin/hidden/cp -B "$@"
}
mv() {
  command $HOME/bin/hidden/mv -B "$@"
}
rm() {
  command $HOME/bin/hidden/rm -B "$@"
}
g() {
  command git "$@"
}
p() {
  command sudo pacman "$@"
}
y() {
  command yaourt "$@"
}
c() {
  command code .
}

##### Vim
# needed to enable save on CTRL-S
vim() {
  stty stop '' -ixoff; command vim "$@"
}
v() {
  command nvim-client "$@"
}
gv() {
  command gvim "$@"
}
# }}}
# FZF config {{{

# Load fzf config
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -l -g ""'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# }}}
# Ranger config {{{
# Automatically jump to the directory ranger is located to when one leaves ranger
rn() {
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
man() {
  LESS_TERMCAP_md=$'\e[1;36m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[1;40;92m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[1;32m' \
  command man "$@"
}
# }}}
