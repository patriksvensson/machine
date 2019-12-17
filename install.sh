# Create the config directory
if [ ! -d "~/.config" ]; then
    echo "Creating configuration directory..."
    mkdir -p ~/.config
fi

# Create a symlink to the Starship profile
if [ ! -f "$PWD/Starship/starship.toml" ]; then
    echo "Creating symbolic link to Starship profile..."
    ln -s "$PWD/Starship/starship.toml" ~/.config/starship.toml
fi

# Copy the roaming profile
echo "Copying roaming profile..."
cp "$PWD/Bash/roaming.sh" ~/.config/roaming.sh

# Reminder
echo "Do not forget to update ~/.bashrc"

# Reload the profile
source ~/.bashrc
