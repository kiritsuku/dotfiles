## Inform users about upgrade path for grml's old zshrc layout, assuming that:
## /etc/skel/.zshrc was installed as ~/.zshrc,
## /etc/zsh/zshrc was installed as ~/.zshrc.global and
## ~/.zshrc.local does not exist yet.
if [ -r ~/.zshrc -a -r ~/.zshrc.global -a ! -r ~/.zshrc.local ] ; then
    printf '-!-\n'
    printf '-!- Looks like you are using the old zshrc layout of grml.\n'
    printf '-!- Please read the notes in the grml-zsh-refcard, being'
    printf '-!- available at: http://grml.org/zsh/\n'
    printf '-!-\n'
    printf '-!- If you just want to get rid of this warning message execute:\n'
    printf '-!-        touch ~/.zshrc.local\n'
    printf '-!-\n'
fi

# needed to enable save on CTRL-S
alias vim="stty stop '' -ixoff ; vim"
# `Frozing' tty, so after any command terminal settings will be restored
ttyctl -f

# start ssh agent if not started yet
if [ -z $SSH_AGENT_PID ]; then
  # only take first lines of ssh-agent output
  ssh-agent | head -n 2 > ~/.ssh-env
  source ~/.ssh-env
  # password storage time
  ssh-add -t 2h
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

# common aliases
alias -g cp='$HOME/bin/cp -B'
alias -g mv='$HOME/bin/mv -B'
alias -g rm='$HOME/bin/rm -B'
alias -g g='git'
alias -g p='sudo pacman'
alias -g y='yaourt'
alias -g nano='~/bin/nano-sh'

# Scala partest
alias pt='test/partest'
alias pta='tools/partest-ack'

# Vim
alias -g v='vim'
alias -g vn='vim "+NERDTree ."'

# autojump
#autoload -U compinit && compinit
