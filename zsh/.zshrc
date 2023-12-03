# Command completion
autoload -Uz compinit
compinit

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

# Starship prompt
eval "$(starship init zsh)"

# Alias
alias vi='nvim'
alias mkd='mkdir'
alias rmd='rm -rf'
alias cl='clear'
alias gc='cd ~/.config'
alias gd='cd /data'
alias install='sudo pacman -S'
alias update='sudo pacman -Syu'
alias remove='sudo pacman -Rscn'

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

