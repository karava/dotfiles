#!/usr/bin/env zsh

# enable shell mode to print executed commands to terminal
set -x

mkdir -p $HOME/bin

# FD - a great alternative to find

# FZF - fuzzy finder, great from the command line or from backware recursive search of history commands
if [[ ! -f $HOME/.fzf/bin/fzf ]]; then
    git clone https://github.com/junegunn/fzf.git $HOME/.fzf
    yes | $HOME/.fzf/install
fi

# FASD - quick access to directories throuh 'z' shortcut accessing frecent directories
if [[ ! -f $HOME/bin/fasd ]]; then
    git clone https://github.com/clvv/fasd.git /tmp/fasd
    cd /tmp/fasd
    PREFIX=$HOME make install
    cd -
fi

# DIFF-SO-FANCY
if [[ ! -f $HOME/bin/diff-so-fancy ]]; then
    curl -o $HOME/bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
fi

# NNN - Nice directory navigator using cursor keys 

# RG - Ripgrep, more convenient tway to greb

# TLDR - Convenient man pages

# TMUX - Terminal multiplexer

# OH-MY-ZSH - Popular zsh shell configuration with nicetices
set +x  # turn of verbosity so doesn't show entire code page
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# BROOT - Better version of tree with search
