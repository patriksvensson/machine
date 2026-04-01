echo "Symlinking Git"
ln -sf ~/Source/github/patriksvensson/machine/config/.gitconfig ~/.gitconfig

echo "Symlinking Atuin"
ln -sf ~/Source/github/patriksvensson/machine/config/atuin.toml ~/.config/atuin/config.toml

echo "Symlinking Ghostty"
ln -sf ~/Source/github/patriksvensson/machine/config/ghostty.config "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"