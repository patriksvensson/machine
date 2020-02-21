#!/bin/bash

# Running on archlinux?
if [ -f "/etc/arch-release" ]; then
    alias open="xdg-open"
fi

# Aliases
alias github="cd ~/Source/github"
alias t="tmux"
alias ta="t a -t"
alias tls="t ls"
alias tn="t new -t"
alias tkill="tmux kill-session -t"

# Initialize Starship
if [ -f "$HOME/.cargo/bin/starship" ]; then
    echo -e "Initializing Starship... \c"
    eval "$(~/.cargo/bin/starship init bash)"
    echo -e "\e[1;32mDone!\e[0m"
fi