echo "Symlinking Git"
ln -sf $HOME/Source/github/patriksvensson/machine/config/.gitconfig $HOME/.gitconfig

echo "Symlinking Atuin"
ln -sf $HOME/Source/github/patriksvensson/machine/config/atuin.toml $HOME/.config/atuin/config.toml

echo "Symlinking Ghostty"
ln -sf $HOME/Source/github/patriksvensson/machine/config/ghostty.config "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"