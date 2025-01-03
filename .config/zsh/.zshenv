export EDITOR=nvim

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java -Djavafx.cachedir=${XDG_CACHE_HOME}/openjfx"

export ANDROID_HOME=$HOME/dev/sdks/android
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export ANDROID_SDK_ROOT=$HOME/dev/sdks/android

export FLUTTER_HOME=$HOME/dev/sdks/flutter

export GRADLE_HOME=$HOME/dev/sdks/gradle
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons

export HISTFILE="$XDG_STATE_HOME"/zsh/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export ZSHZ_DATA="$XDG_DATA_HOME/z"
export RENPY_PATH_TO_SAVES="$XDG_DATA_HOME/renpy"
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

export QT_QPA_PLATFORMTHEME=qt6ct

export PATH="$HOME/.local/bin:$ANDROID_SDK_ROOT:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$FLUTTER_HOME/bin:$GRADLE_HOME/bin:$PATH:$HOME/go/bin:/opt/intellij-idea/bin"
