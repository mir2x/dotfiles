# Command completion
autoload -Uz compinit
compinit

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

# Starship prompt
eval "$(starship init zsh)"

# Alias
# Directory
alias mkd='mkdir'
alias rmd='rm -rf'
alias cl='clear'
# Shortcuts
alias gc='cd ~/.config'
alias gd='cd /data'
#Replacements
alias ls='lsd'
alias cat='bat'
alias du='gdu'
alias df='duf'
alias top='bpytop'
alias vi='nvim'
#Pacman
alias install='sudo pacman -S'
alias update='sudo pacman -Syu'
alias remove='sudo pacman -Rscn'
#Git
alias gst='git status'
alias gcmsg='git commit -m'

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

