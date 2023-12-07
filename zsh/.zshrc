# Command completion
autoload -Uz compinit
compinit

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Alias
# Directory
alias mkd='mkdir'
alias rmd='rm -rf'
alias cl='clear'
# Shortcuts
alias gc='cd ~/.config'
alias gd='cd /data'
alias mkx='chmod +x'
#Replacements
alias ls='lsd -al'
alias cat='bat'
alias du='gdu'
alias df='duf'
alias find='fd'
alias top='bpytop'
alias grep='rg'
alias vi='nvim'
#Pacman
alias install='sudo pacman -S'
alias update='sudo pacman -Syu'
alias remove='sudo pacman -Rscn'
#Git
alias gst='git status'
alias gcmsg='git commit -m'
#Youtube-dl
alias yta='yt-dlp -x --embed-thumb --audio-format best --audio-quality 0'
#Cloudflare Warp
alias wcc='warp-cli connect'
alias wcd='warp-cli disconnect'
alias wcs='warp-cli status'

# Starship prompt
eval "$(starship init zsh)"

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

