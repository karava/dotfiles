# Standard PATH
export PATH="$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Locale Fix (Avoid Encoding Issues)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Homebrew Setup for Apple Silicon
if [[ "$(uname -s)" == "Darwin" ]]; then
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# Python Paths (Avoid Hardcoding Versions)
for py_ver in 3.13 3.12 3.11 3.10 3.9; do
    if [[ -d "/Library/Frameworks/Python.framework/Versions/$py_ver/bin" ]]; then
        export PATH="/Library/Frameworks/Python.framework/Versions/$py_ver/bin:$PATH"
        break
    fi
done

# Java Setup
if command -v /usr/libexec/java_home &> /dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    export PATH="$JAVA_HOME/bin:$PATH"
fi

# FASD (Fast Directory Switching)
if [[ -f "$HOME/bin/fasd" ]]; then
    eval "$(fasd --init auto)"
fi

# FZF Auto-Completion (If Installed) On linux fzf auto adds this line
if [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
fi

# VS Code Path so we can use 'code' to open files
if [[ -d "/Applications/Visual Studio Code.app" ]]; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Add flutter items to path
# Android Emulator Path so we can use 'emulator' to launch Android emulators via the terminal
if [[ -d "$HOME/Library/Android/sdk/emulator" ]]; then
    export PATH="$PATH:$HOME/Library/Android/sdk/emulator"
    export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

# Aliases
alias django-runserver="python manage.py runserver"

# Source Additional Configurations
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.env" ]] && source "$HOME/.env"

# Initialise fasd, this creates the handy aliases for z and fasd_cd
export PATH="$PATH:/Users/kishanarava/development/flutter/bin"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"


export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
chruby ruby-3.4.2

# Mysql-client
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/mysql-client/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/mysql-client/include $CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql-client/lib/pkgconfig:$PKG_CONFIG_PATH"
