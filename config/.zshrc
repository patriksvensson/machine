# Remove the % if a command didn't output a newline
PROMPT_EOL_MARK=''

# Git autocomplete
fpath=(~/.zsh $fpath) 
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit 
compinit

# Start in the github directory
cd ~/Source/github

# Aliases
alias ls='eza --group-directories-first --time-style relative --no-user '
alias cat='bat'

# Initialize atuin and oh-my-posh
eval "$(atuin init zsh)"
eval "$(oh-my-posh init zsh --config ~/Source/github/patriksvensson/machine/config/oh-my-posh.json)"

# Rebind down-arrow to atuin search
bindkey '^[[B' atuin-up-search

# Disable Verify diffs
export DiffEngine_Disabled=trueexport PATH="$HOME/.local/bin:$PATH"
