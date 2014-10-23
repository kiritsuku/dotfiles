##############################################################################
# antigen config                                                             #
##############################################################################

source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle scala
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle hchbaw/opp.zsh
antigen bundle history-substring-search
antigen apply

##############################################################################
# zsh prompt/theme                                                           #
##############################################################################

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
  eval "$1='$return_code$(git_prompt_status)%{$reset_color%}'"
}
# adding background job test doesn't work correctly
#RPROMPT='$symbols $return_code$(git_prompt_status)%{$reset_color%}'
add-git-prompt RPROMPT


##############################################################################
# zsh config                                                                 #
##############################################################################

# enable vi mode
bindkey -v
# smart search with up and down arrows (needs to be enabled in vi mode)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# backspace and ^h working even after returning from command mode
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
# ctrl-w removes word backwards
bindkey '^W' backward-kill-word
# ctrl-i searches history backwards
bindkey '^R' history-incremental-search-backward

# show active vim mode in zsh
function zle-line-init zle-keymap-select {
  add-git-prompt RPROMPT
  RPROMPT="$RPROMPT ${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
  zle reset-prompt
}
# register the above function in zsh
zle -N zle-line-init
zle -N zle-keymap-select

# weird & wacky pattern matching...
setopt extendedglob
# ...but when pattern matching fails, simply use the command as is
setopt no_nomatch
# interpret lines starting with '#' as comments
setopt interactive_comments

# start ssh agent if not started yet
if [ -z $SSH_AGENT_PID ]; then
  # only take first lines of ssh-agent output
  ssh-agent | head -n 2 > ~/.ssh-env
  source ~/.ssh-env
  ssh-add
else
  source ~/.ssh-env
fi

export EDITOR="vim"

# bin folder
export PATH=$HOME/bin:$PATH
# haskell executables
export PATH=$PATH:$HOME/.cabal/bin
# ruby executables
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin
export PATH=$PATH:$HOME/.rvm/bin
# play executables
export PATH=$PATH:$HOME/Software/play-2.2.0/
# scala executables
export PATH=$PATH:$HOME/Software/scala-2.11.0/bin/

##### common aliases
alias -g cp='$HOME/bin/cp -B'
alias -g mv='$HOME/bin/mv -B'
alias -g rm='$HOME/bin/rm -B'
alias -g g='git'
alias -g p='sudo pacman'
alias -g y='yaourt'
alias -g nano='~/bin/nano-sh'

##### Scala partest
alias pt='test/partest'
alias pta='tools/partest-ack'

##### Vim
# needed to enable save on CTRL-S
alias -g vim="stty stop '' -ixoff ; vim"
alias -g v="vim"
alias -g vn='vim "+NERDTree ."'
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

##### autojump
#autoload -U compinit && compinit

##### ranger
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
