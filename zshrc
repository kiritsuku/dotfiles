# Antigen config {{{
source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle scala
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
#antigen bundle hchbaw/opp.zsh # needed for vi mode
#antigen bundle history-substring-search # needed for vi mode
antigen bundle autojump
antigen apply
# }}}

# Zsh prompt {{{
PROMPT='[%{$fg[red]%}%n%{$reset_color%}@%{$fg[magenta]%}%m%{$reset_color%} → %{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)]
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

# Vi mode {{{
#
## enable vi mode
#bindkey -v
## smart search with up and down arrows (needs to be enabled in vi mode)
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
## backspace and ^h working even after returning from command mode
#bindkey '^?' backward-delete-char
#bindkey '^H' backward-delete-char
## ctrl-w removes word backwards
#bindkey '^W' backward-kill-word
## ctrl-i searches history backwards
#bindkey '^R' history-incremental-search-backward
## pos1 key
#bindkey '\e[1~' beginning-of-line
## end key
#bindkey '\e[4~' end-of-line
## See http://stackoverflow.com/questions/161676/home-end-keys-in-zsh-dont-work-with-putty for more key bindings
#
# show active vim mode in zsh
#function zle-line-init zle-keymap-select {
#  add-git-prompt RPROMPT
#  #RPROMPT="$RPROMPT ${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
#  zle reset-prompt
#}
## register the above function in zsh
#zle -N zle-line-init
#zle -N zle-keymap-select
# }}}

# Zsh config {{{

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
# Do not clear screen after less is exited
# See: http://unix.stackexchange.com/questions/38634/is-there-any-way-to-exit-less-without-clearing-the-screen
export LESS="-r -X"

# bin folder
export PATH=$HOME/bin:$PATH
# ruby executables
export PATH=$PATH:$HOME/.gem/ruby/2.2.0/bin
export PATH=$PATH:$HOME/.rvm/bin
# scala executables
export PATH=$PATH:$HOME/software/scala-2.11.7/bin/
export PATH=$PATH:$HOME/software/activator-1.3.2/
# electron executables
export PATH=$PATH:$HOME/software/electron/
# go executables
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# make can't always handle parallel builds; enable on demand
#export MAKEFLAGS="-j4 $MAKEFLAGS"
# }}}

# Aliase {{{
alias -g cp='$HOME/bin/hidden/cp -B'
alias -g mv='$HOME/bin/hidden/mv -B'
alias -g rm='$HOME/bin/hidden/rm -B'
alias -g g='git'
alias -g p='sudo pacman'
alias -g y='yaourt'

##### Scala partest
alias pt='test/partest'
alias pta='tools/partest-ack'

##### Vim
# needed to enable save on CTRL-S
alias -g vim="stty stop '' -ixoff ; vim"
alias -g v="nvim-client"
alias -g gv="gvim"
# }}}

# Ranger {{{
# Automatically jump to the directory ranger is located to when one leaves ranger
function ranger-cd {
  tempfile='/tmp/ranger-chosendir'
  /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
  cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}

alias -g rn='ranger-cd'
# }}}
