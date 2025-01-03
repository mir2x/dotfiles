# Command completion
autoload -Uz compinit
compinit

[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION


# Auto cd
setopt autocd

# Autocompletion with an arrow-key driven interface
zstyle ':completion:*' menu select

HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Alias
# File
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'

# Directory
alias mkd='mkdir -v'
alias rmd='rm -vrf'
alias cl='clear'

# Shortcuts
alias gc='cd ~/.config'
alias gd='cd /data'
alias mkx='chmod +x'

#Replacements
alias ls='lsd -A --group-dirs=first'
alias cat='bat'
alias du='gdu'
#alias df='duf'
#alias find='fd'
alias top='bpytop'
#alias grep='rg'
alias vi='nvim'

#pacman
alias pacs='sudo pacman -S'
alias pacu='sudo pacman -Syu'
alias pacr='sudo pacman -Rscn'

#git
alias gst='git status'
alias gcmsg='git commit -m'

#yt-dlp
alias yta='yt-dlp --embed-thumbnail -f "bestaudio/best" -ciw -o "%(title)s.%(ext)s" -v --extract-audio'

#Cloudflare Warp
alias wcc='warp-cli connect'
alias wcd='warp-cli disconnect'
alias wcs='warp-cli status'

alias g++='g++ -std=c++20'
alias air='/home/mir/go/bin/air'

alias adb='HOME="$XDG_DATA_HOME"/android adb'

# Starship prompt
eval "$(starship init zsh)"

# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# ZSH z plugin
source /usr/share/zsh/plugins/zsh-z/zsh-z.plugin.zsh

# pnpm
export PNPM_HOME="/home/mir/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
