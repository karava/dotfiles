#!/usr/bin/env bash 

# enable shell mode to print executed commands to terminal
set -x

####################
# TOOLS
####################

mkdir -p $HOME/bin

# FD - a great alternative to find.
# NNN - Nice directory navigator using cursor keys 
# TLDR - Convenient man pages
# RG - Ripgrep, more convenient tway to greb
# TMUX - Terminal multiplexer
# STOW - Symlink farm manager for dotfiles
# Note there are issues on pizero 32-bit arch. May need to manually install it.
if [[ "$(uname)" == "Darwin" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo "detected silicon"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    brew install fd
    brew install nnn
    brew install tldr
    brew install ripgrep
    brew install tmux
    brew install stow
fi
if [[ "$(uname)" == "Linux" ]]; then
    # Ubuntu distros have bash by default we need to install it and set it as the default shell
    sudo apt install zsh
    sudo apt install nnn
    sudo apt install tldr
    sudo apt install ripgrep 
    sudo apt install tmux
    sudo apt install -y zsh powerline fonts-powerline
    sudo apt install stow
    sudo chsh -s /usr/bin/zsh $(whoami)
    sudo apt install fd-find
    # On Linux need to link it otherwise will have to run fd with fdfind
    sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
fi

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

####################
# ZSH
#################### 

# OH-MY-ZSH - Popular zsh shell configuration with nicetices
set +x  # turn of verbosity so doesn't show entire code page
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ "$(uname)" == "Darwin" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
        chsh -s /bin/zsh
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    else
        chsh -s /usr/bin/zsh
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
    fi
fi


# auto-suggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
