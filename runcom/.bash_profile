# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# OS
if [ "$(uname -s)" = "Darwin" ]; then
  OS="OSX"
elif [ "$(uname -s)" = "MINGW64_NT-10.0" ]; then
  OS="WIN10"
else
  OS=$(uname -s)
fi

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
READLINK=$(type -P readlink || type -P greadlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  if [ "$OS" = "WIN10" ]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  else
    SCRIPT_PATH=$($READLINK "$CURRENT_SCRIPT")
  fi
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return # `exit 1` would quit the shell itself
fi

for DOTFILE in "$DOTFILES_DIR"/custom/pre-dots/.{function,env,alias,completion,prompt}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Finally we can source the dotfiles (order matters)
for DOTFILE in "$DOTFILES_DIR"/system/.{function,env,alias,completion,prompt}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if [ "$OS" = "OSX" ]; then
  for DOTFILE in "$DOTFILES_DIR"/system/.git.osx; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

for DOTFILE in "$DOTFILES_DIR"/custom/post-dots/.{function,env,alias,completion,prompt}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export
export OS DOTFILES_DIR EXTRA_DIR

export NVM_DIR="/Users/alberto.fernandez/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -f /usr/local/etc/bash_completion ]; then
. /usr/local/etc/bash_completion
fi

