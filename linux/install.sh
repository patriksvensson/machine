#!/bin/bash

########################################################
# INSTALLATION
########################################################

# Running under Ubuntu?
if [ -f /etc/lsb-release ]; then
    if ! dpkg -s 'build-essential' >/dev/null 2>&1; then
        sudo apt-get install 'build-essential' -y
    fi
fi

# Is Rust installed?
if [ ! -x "$HOME/.cargo/bin/cargo" ]; then
    echo "Installing Rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain stable -y
    if [ $? -ne 0 ]; then
        echo -e "\n\e[31mAn error occured while installing Rust.\e[0m"
        exit -1;
    fi
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Is Starship installed?
if [ ! -x "$HOME/.cargo/bin/starship" ]; then
    echo "Installing Starship..."
    cargo install starship
    if [ $? -ne 0 ]; then 
        echo -e "\n\e[31mAn error occured while installing Starship.\e[0m"
        exit -1;
    fi
fi

# Is tmux installed?
if [ ! -x "/usr/bin/tmux" ]; then
    if [ -f "/etc/arch-release" ]; then
        echo "Installing tmux..."
        pacman -S foobar
    else
        echo "Don't know how to install tmux."
    fi
fi

########################################################
# ALACRITTY
########################################################

# Create a symlink to the alacritty configuration
if [ -f "$HOME/.alacritty.yml" ]; then
    if [ ! -L "$HOME/.alacritty.yml" ]; then # Not a symlink?
        echo "Removing default Alacritty configuration..."
        rm "$HOME/.alacritty.yml"
    fi
fi
if [ ! -L "$HOME/.alacritty.yml" ]; then
    echo "Creating symbolic link to alacritty configuration..."
    ln -s "$PWD/../config/alacritty.yml" ~/.alacritty.yml
fi

########################################################
# STARSHIP
########################################################

# Create a symlink to the Starship profile
if [ -f "$HOME/.config/starship.toml" ]; then
    if [ ! -L "$HOME/.config/starship.toml" ]; then # Not a symlink?
        echo "Removing Starship configuration..."
        rm "$HOME/.config/starship.toml"
    fi
fi
if [ ! -L "$HOME/.config/starship.toml" ]; then
    echo "Creating symbolic link to Starship configuration..."
    ln -s "$PWD/../config/starship.toml" ~/.config/starship.toml
fi

########################################################
# TMUX
########################################################

# Create a symlink to tmux
if [ -f "$HOME/.tmux.conf" ]; then
    if [ ! -L "$HOME/.tmux.conf" ]; then # Not a symlink?
        echo "Removing default tmux configuration..."
        rm "$HOME/.tmux.conf"
    fi
fi
if [ ! -L "$HOME/.tmux.conf" ]; then
    echo "Creating symbolic link to tmux configuration..."
    ln -s "$PWD/../config/tmux.conf" ~/.tmux.conf
fi

########################################################
# EDIT .BASHRC
########################################################

# Edit the .bashrc file
if ! [[ $(grep "# Load roaming profile" "$HOME/.bashrc") ]] ; then
    echo "Updating roaming profile..."
    echo -en '\n' >> "$HOME/.bashrc"
    echo '# Load roaming profile' >> "$HOME/.bashrc"
    echo "source $PWD/roaming.sh" >> "$HOME/.bashrc"
fi

########################################################
# WE'RE DONE
########################################################

source ~/.bashrc
echo -e "\e[1;32mDone!\e[0m"