#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"

# Update dotfiles itself first
if [ -d "$DOTFILES_DIR/.git" ]; then
  git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master
fi

# Bunch of symlinks
for DOTFILE in "$DOTFILES_DIR"/{runcom,git}/.*; do
  if [ -f ~/${DOTFILE##*/} ]; then
    if [ -f ~/${DOTFILE##*/}.bk ]; then
      read -n 1 -p "Backup file ~/${DOTFILE##*/}.bk already exists, do you want to override it?[Y/n]" OVERRIDE_BK
      if [[ $OVERRIDE_BK == {"y","Y",""} ]]; then
        mv -f ~/${DOTFILE##*/} ~/${DOTFILE##*/}.bk
        echo "~/${DOTFILE##*/} overrided ~/${DOTFILE##*/}.bk"
      fi
    else
      mv ~/${DOTFILE##*/} ~/${DOTFILE##*/}.bk
      echo "~/${DOTFILE##*/} moved to ~/${DOTFILE##*/}.bk"
    fi
  fi

  if [ -f "$DOTFILE" ]; then
    if [ "$OS" = "WIN10" ] || [ "$OS" = "Windows_NT" ]; then
      PARSED_HOME=${HOME//\//\\}
      PARSED_HOME=${PARSED_HOME/\\/}
      PARSED_HOME=${PARSED_HOME/\\/:\\}
      PARSED_DOTF=${DOTFILE//\//\\}
      PARSED_DOTF=${PARSED_DOTF/\\/}
      PARSED_DOTF=${PARSED_DOTF/\\/:\\}
      [ -f ~/${DOTFILE##*/} ] && rm ~/${DOTFILE##*/}
      cmd //C mklink $PARSED_HOME\\${DOTFILE##*/} $PARSED_DOTF
      unset PARSED_HOME
      unset PARSED_DOTF
    else
      ln -sfv "$DOTFILE" ~
    fi
    echo "linked ${DOTFILE##*/}"
  fi
done
