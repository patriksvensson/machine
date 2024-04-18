#!/bin/bash

########################################################
# HOMEBREW
########################################################

if ! [[ $(grep "bin/brew shellenv" "$HOME/.zprofile") ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile    
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

########################################################
# APPLICATIONS
########################################################

install_cask () { 
    if brew info "${1}" | grep "Not installed" >/dev/null 2>&1 ; then 
        brew install --cask "${1}"
    else
        echo "The brew cask ${1} has already been installed"
    fi
}

install_package () { 
    if brew info "${1}" | grep "Not installed" >/dev/null 2>&1 ; then 
        brew install "${1}"
    else
        echo "The brew package ${1} has already been installed"
    fi
}

install_package coreutils
install_package ripgrep
install_cask visual-studio-code
install_cask iterm2
install_cask slack
install_cask discord
install_cask marta
install_cask spotify
install_package bat
install_package git-delta
install_package eza
install_package gh
install_package gitui
install_cask unnaturalscrollwheels
install_package swift-format

########################################################
# OH-MY-POSH
########################################################

if brew ls --versions oh-my-posh > /dev/null; then
    echo "Oh-my-posh has already been installed"
else
    brew tap jandedobbeleer/oh-my-posh
    brew install oh-my-posh
fi

if ! [[ $(grep "oh-my-posh" "$HOME/.zshrc") ]] ; then
    OMP_CONFIG=$(grealpath ../config/oh-my-posh.json)
    eval "$(oh-my-posh --init --shell zsh --config $OMP_CONFIG)"
    source $HOME/.zshrc
fi   

########################################################
# RUST
########################################################

if [ ! -x "$HOME/.cargo/bin/cargo" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust has already been installed"
fi