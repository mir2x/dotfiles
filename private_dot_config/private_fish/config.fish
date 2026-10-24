if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Auto cd
set -g fish_autocd 1

# Abbreviations (aliases)
abbr cp 'cp -v'
abbr mv 'mv -v'
abbr rm 'rm -v'
abbr mkd 'mkdir -v'
abbr rmd 'rm -vrf'
abbr cl 'clear'
abbr gc 'cd ~/.config'
abbr gd 'cd /data'
abbr mkx 'chmod +x'

# Command replacements
abbr ls 'eza --group-directories-first --icons -aF'
abbr lsl 'eza --group-directories-first --icons -alhF'
abbr cat 'bat'
abbr du 'gdu'
abbr top 'btop'
abbr vi 'nvim'

# abbr ff 'fc-list | grep -i'

# Package management
abbr pacs 'sudo pacman -S'
abbr pacu 'sudo pacman -Syu'
abbr pacr 'sudo pacman -Rscn'

# Git
abbr gst 'git status'
abbr gcmsg 'git commit -m'
# abbr gmc 'geminicommit'

# yt-dlp
abbr yta 'yt-dlp --embed-thumbnail -f "bestaudio/best" -ciw -o "%(title)s.%(ext)s" -v --extract-audio'
# abbr yts 'yt-dlp --cookies-from-browser firefox'

# Cloudflare Warp
# abbr wcc 'warp-cli connect'
# abbr wcd 'warp-cli disconnect'
# abbr wcs 'warp-cli status'

# Development tools
# abbr g++ 'g++ -std=c++20'

# abbr flb 'flutter build apk --release --target-platform android-arm64 -v'
# abbr flr 'flutter run -v'
# abbr flc 'flutter clear'
# abbr flg 'flutter pub get'
# abbr google-chrome-stable 'google-chrome-stable --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled'

# abbr tarz 'tar -czvf'

# Zoxide (better directory navigation)
zoxide init fish | source

# fzf key bindings (Ctrl+R history, Ctrl+T files, Alt+C cd)
fzf --fish | source

# Environment variables
set -gx EDITOR nvim

set -gx XDG_CACHE_HOME $HOME/.cache
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_STATE_HOME $HOME/.local/state

# Android configuration
set -gx ANDROID_HOME $HOME/.local/share/android-sdks
set -gx ANDROID_USER_HOME "$XDG_DATA_HOME"/android
set -gx ANDROID_SDK_ROOT $ANDROID_HOME

# Development tools paths
# set -gx FLUTTER_HOME $HOME/dev/sdks/flutter
# set -gx GRADLE_USER_HOME "$XDG_DATA_HOME"/gradle

# System configuration
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
set -gx XCURSOR_PATH /usr/share/icons:$XDG_DATA_HOME/icons
set -gx CARGO_HOME "$XDG_DATA_HOME"/cargo
set -gx LESSHISTFILE "$XDG_STATE_HOME"/less/history
set -gx RENPY_PATH_TO_SAVES "$XDG_DATA_HOME"/renpy
# set -gx NVM_DIR "$XDG_DATA_HOME"/nvm
# set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
# set -gx PATH $HOME/.fvm_flutter/bin $PATH

# Add to PATH
fish_add_path -p $HOME/.local/bin
fish_add_path -p $ANDROID_HOME/platform-tools $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path -p $HOME/fvm/default/bin
# fish_add_path -p \
#     $ANDROID_SDK_ROOT \
#     $ANDROID_HOME/platform-tools \
#     $ANDROID_HOME/cmdline-tools/latest/bin \
#     $FLUTTER_HOME/bin \
#     $HOME/go/bin

# FVM
# set --export PATH /home/mir/.fvm_flutter/bin $PATH

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
# set -gx PNPM_HOME "/home/mir/.local/share/pnpm"
# if not string match -q -- $PNPM_HOME $PATH
#   set -gx PATH "$PNPM_HOME" $PATH
# end

set fish_greeting

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	command yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# pyenv init - | source
# set -Ux PYENV_ROOT $HOME/.pyenv
# fish_add_path $PYENV_ROOT/bin
# pyenv init - | source
mise activate fish | source

starship init fish | source
