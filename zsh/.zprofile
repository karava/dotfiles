# Standard PATH
export PATH="$HOME/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

# Locale Fix (Avoid Encoding Issues)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ─────────────────────────────────────────────────────────────
# Homebrew setup (DevData first, then fallbacks)
# ─────────────────────────────────────────────────────────────

if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ -x "/Volumes/DevData/tools/homebrew/bin/brew" ]]; then
    # Your DevData Homebrew
    eval "$(/Volumes/DevData/tools/homebrew/bin/brew shellenv)"
    export HOMEBREW_CACHE="/Volumes/DevData/cache/homebrew"
  elif [[ -x "/opt/homebrew/bin/brew" ]]; then
    # Fallback for other Macs that use default Apple Silicon prefix
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    # Fallback for Intel macOS
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi


# ─────────────────────────────────────────────────────────────
# Python paths (avoid hardcoding one version)
# ─────────────────────────────────────────────────────────────

for py_ver in 3.13 3.12 3.11 3.10 3.9; do
  if [[ -d "/Library/Frameworks/Python.framework/Versions/$py_ver/bin" ]]; then
    export PATH="/Library/Frameworks/Python.framework/Versions/$py_ver/bin:$PATH"
    break
  fi
done


# ─────────────────────────────────────────────────────────────
# Java
# ─────────────────────────────────────────────────────────────

if command -v /usr/libexec/java_home &> /dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    export PATH="$JAVA_HOME/bin:$PATH"
fi

export JAVA_HOME="/Volumes/DevData/tools/homebrew/opt/openjdk@17"
export PATH="$JAVA_HOME/bin:$PATH"


# ─────────────────────────────────────────────────────────────
# FASD (fast directory switching)
# ─────────────────────────────────────────────────────────────

# Initialise fasd, this creates the handy aliases for z and fasd_cd
if [[ -f "$HOME/bin/fasd" ]]; then
    eval "$(fasd --init auto)"
    export _FASD_DATA="$HOME/DevData/cache/fasd/fasd.db"
fi


# ─────────────────────────────────────────────────────────────
# FZF Auto-Completion (if installed, On linux fzf auto adds this line)
# ─────────────────────────────────────────────────────────────

if [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
fi


# ─────────────────────────────────────────────────────────────
# VS Code (can use 'code' to open files)
# ─────────────────────────────────────────────────────────────

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


export PATH="$PATH:/Users/kishanarava/development/flutter/bin"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"


export PATH="$HOMEBREW_PREFIX/opt/ruby/bin:$PATH"
source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/auto.sh"
chruby ruby-3.4.2

# Mysql-client
export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/mysql-client/lib $LDFLAGS"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/mysql-client/include $CPPFLAGS"
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/mysql-client/lib/pkgconfig:$PKG_CONFIG_PATH"

export PATH="/Volumes/DevData/tools/npm-global/bin:$PATH"

# ─────────────────────────────────────────────────────────────
# PYENV (Python version manager)
# ─────────────────────────────────────────────────────────────

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi


# ─────────────────────────────────────────────────────────────
# FVM (Flutter Version Manager) - store SDKs in DevData
# ─────────────────────────────────────────────────────────────
export FVM_HOME="/Volumes/DevData/sdk/flutter"
export FVM_CONFIG_DIR="/Volumes/DevData/config/fvm"

# Global/default Flutter from FVM
if [[ -d "$FVM_HOME/default/bin" ]]; then
  export PATH="$FVM_HOME/default/bin:$PATH"
fi


# ____________________________________________________________
# PNPM
# ---------------------------------------------
export PNPM_HOME="/Volumes/DevData/tools/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="/Volumes/DevData/tools/homebrew/opt/libpq/bin:$PATH"
