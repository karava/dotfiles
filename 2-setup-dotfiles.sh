#!/usr/bin/env bash

# set -e          # Exit on error
# set -o pipefail # Exit on pipe error
# set -x          # Enable verbosity

# Dont link DS_Store files
find . -name ".DS_Store" -exec rm {} \;

PROGRAMS=(alias git stow scripts tmux vim zsh env karabiner)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

function backup_if_exists() {
    if [ -f $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
    if [ -d $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
}

# Clean common conflicts
backup_if_exists ~/.bash_profile
backup_if_exists ~/.aliases
backup_if_exists ~/.bashrc
backup_if_exists ~/.gitconfig
backup_if_exists ~/.tmux.conf
backup_if_exists ~/.zshrc
backup_if_exists ~/.zprofile
backup_if_exists ~/.stow-global-ignore
backup_if_exists ~/.vimrc
backup_if_exists ~/.env
backup_if_exists ~/bin

mkdir -p ~/.vim/undodir

for program in ${PROGRAMS[@]}; do
  stow -v --target=$HOME $program
  echo "Configuring $program"
done

echo "Done!"
