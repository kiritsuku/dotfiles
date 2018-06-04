# Execute only on system login on tty1
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then

  # Start ssh agent
  ssh-agent | head -n 2 > ~/.ssh-env
  source ~/.ssh-env

  # Start xserver
  exec st
fi
