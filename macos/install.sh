# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile    
eval "$(/opt/homebrew/bin/brew shellenv)"

# oh-my-posh
brew tap jandedobbeleer/oh-my-posh
brew install oh-my-posh
eval "$(oh-my-posh --init --shell zsh --config /Users/patrik/Source/github/patriksvensson/machine/config/oh-my-posh.json)"
source ~/.zshrc

# apps
brew install --cask visual-studio-code
brew install --cask iterm2
brew install --cask slack
brew install --cask discord
brew install --cask ripgrep
brew install --cask marta
brew install --cask spotify

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh