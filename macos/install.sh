########################################################
# HOMEBREW
########################################################

if ! [[ $(grep "bin/brew shellenv" "$HOME/.zprofile") ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile    
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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
    eval "$(oh-my-posh --init --shell zsh --config $HOME/Source/github/patriksvensson/machine/config/oh-my-posh.json)"
    source $HOME/.zshrc
fi   

########################################################
# APPLICATIONS
########################################################

install_cask () { 
        if brew info "${1}" &>/dev/null; then
        echo "The brew cask ${1} has already been installed"
    else
        brew install --cask "${1}" 
    fi
}

install_cask visual-studio-code
install_cask iterm2
install_cask slack
install_cask discord
install_cask ripgrep
install_cask marta
install_cask spotify

########################################################
# RUST
########################################################

if [ ! -x "$HOME/.cargo/bin/cargo" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust has already been installed"
fi