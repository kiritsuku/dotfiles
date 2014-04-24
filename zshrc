##############################################################################
# antigen config                                                             #
##############################################################################

source $HOME/.antigen.zsh
antigen use oh-my-zsh
antigen bundle git
antigen bundle scala
antigen bundle sharat87/autoenv
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
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

# adding background job test doesn't work correctly
#RPROMPT="$symbols $return_code$(git_prompt_status)%{$reset_color%}"
RPROMPT="$return_code$(git_prompt_status)%{$reset_color%}"

##############################################################################
# zsh config                                                                 #
##############################################################################

# weird & wacky pattern matching...
setopt extendedglob
# ...but when pattern matching fails, simply use the command as is
setopt no_nomatch

# start ssh agent if not started yet
if [ -z $SSH_AGENT_PID ]; then
  # only take first lines of ssh-agent output
  ssh-agent | head -n 2 > ~/.ssh-env
  source ~/.ssh-env
  ssh-add
else
  source ~/.ssh-env
fi

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
export PATH=$PATH:$HOME/Software/scala-2.10.2/bin/

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
