#!/usr/bin/env bash
set -euo pipefail

############### CONFIG: EDIT THIS IF YOU WANT IT ON THE SSD ###############

# Default: snapshot folder on your Desktop
BASE_DIR="$HOME/Desktop"

# If you want it to go directly to your SSD, comment the line above
# and uncomment + edit this one (use your actual volume name + path):
# BASE_DIR="/Volumes/SanDisk/_SETUP_REFERENCE"

############################################################################

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
SNAPSHOT_ROOT="${BASE_DIR}/dev-environment-snapshot-${TIMESTAMP}"

echo "Creating snapshot at: ${SNAPSHOT_ROOT}"
mkdir -p "${SNAPSHOT_ROOT}"

SYSTEM_DIR="${SNAPSHOT_ROOT}/system-info"
PKG_DIR="${SNAPSHOT_ROOT}/package-managers"
SDK_DIR="${SNAPSHOT_ROOT}/sdks-and-tools"
APPS_DIR="${SNAPSHOT_ROOT}/applications"
CONF_DIR="${SNAPSHOT_ROOT}/config-summaries"

mkdir -p "${SYSTEM_DIR}" "${PKG_DIR}" "${SDK_DIR}" "${APPS_DIR}" "${CONF_DIR}"

echo "Collecting system info..."

# macOS + hardware info
{
  echo "### sw_vers"
  sw_vers 2>&1
  echo
  echo "### uname -a"
  uname -a 2>&1
  echo
  echo "### system_profiler SPHardwareDataType"
  system_profiler SPHardwareDataType 2>&1
} > "${SYSTEM_DIR}/macos-and-hardware.txt" || true

# PATH executables
{
  echo "PATH: $PATH"
  echo
  echo "### Executables in PATH ###"
  IFS=':' read -r -a PATH_DIRS <<< "$PATH"
  for p in "${PATH_DIRS[@]}"; do
    if [ -d "$p" ]; then
      echo
      echo "== $p =="
      ls "$p" 2>/dev/null || echo "(cannot list)"
    fi
  done
} > "${SYSTEM_DIR}/path-executables.txt"

echo "Collecting package manager info..."

# Homebrew
if command -v brew >/dev/null 2>&1; then
  {
    echo "### brew list"
    brew list 2>&1
  } > "${PKG_DIR}/brew-packages.txt" || true

  {
    echo "### brew list --cask"
    brew list --cask 2>&1
  } > "${PKG_DIR}/brew-casks.txt" || true

  brew config > "${PKG_DIR}/brew-config.txt" 2>&1 || true
else
  echo "Homebrew not found" > "${PKG_DIR}/brew-packages.txt"
fi

# npm
if command -v npm >/dev/null 2>&1; then
  {
    echo "### npm list -g --depth=0"
    npm list -g --depth=0 2>&1
  } > "${PKG_DIR}/npm-global.txt" || true

  npm config list > "${PKG_DIR}/npm-config.txt" 2>&1 || true
else
  echo "npm not found" > "${PKG_DIR}/npm-global.txt"
fi

# pip3
if command -v pip3 >/dev/null 2>&1; then
  {
    echo "### pip3 list"
    pip3 list 2>&1
  } > "${PKG_DIR}/pip3-packages.txt" || true
else
  echo "pip3 not found" > "${PKG_DIR}/pip3-packages.txt"
fi

# Ruby gems
if command -v gem >/dev/null 2>&1; then
  {
    echo "### gem list"
    gem list 2>&1
  } > "${PKG_DIR}/ruby-gems.txt" || true
else
  echo "gem not found" > "${PKG_DIR}/ruby-gems.txt"
fi

echo "Collecting SDK / tool versions..."

tool_version() {
  local name="$1"
  local cmd="$2"
  local file="${SDK_DIR}/${name}.txt"
  if command -v ${cmd%% *} >/dev/null 2>&1; then
    echo "### ${cmd}" > "$file"
    # shellcheck disable=SC2086
    $cmd >> "$file" 2>&1 || true
  fi
}

tool_version "flutter" "flutter --version"
tool_version "dart" "dart --version"
tool_version "node" "node --version"
tool_version "python3" "python3 --version"
tool_version "pip3" "pip3 --version"
tool_version "rustup" "rustup show"
tool_version "cargo" "cargo --version"
tool_version "go" "go version"
tool_version "java" "java -version"
tool_version "gradle" "gradle -v"
tool_version "maven" "mvn -v"
tool_version "gcloud" "gcloud --version"
tool_version "aws-cli" "aws --version"
tool_version "docker" "docker --version"
tool_version "kubectl" "kubectl version --client"
tool_version "supabase" "supabase --version"
tool_version "firebase" "firebase --version"
tool_version "fastlane" "fastlane --version"
tool_version "cocoapods" "pod --version"
tool_version "vscode-cli" "code --version"
tool_version "git" "git --version"

# Android SDK + related env vars
{
  echo "### ANDROID / JAVA ENV"
  echo "ANDROID_HOME=${ANDROID_HOME-}"
  echo "ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT-}"
  echo "JAVA_HOME=${JAVA_HOME-}"
} > "${SDK_DIR}/android-java-env.txt"

# Xcode / Apple tools
{
  echo "### xcode-select -p"
  xcode-select -p 2>&1 || echo "xcode-select not found"
  echo
  echo "### xcodebuild -version"
  xcodebuild -version 2>&1 || echo "xcodebuild not found"
} > "${SDK_DIR}/xcode.txt"

echo "Collecting applications list..."

# Applications
{
  echo "### /Applications"
  ls /Applications 2>&1 || echo "no /Applications"
} > "${APPS_DIR}/applications-root.txt"

{
  echo "### ~/Applications"
  ls "$HOME/Applications" 2>&1 || echo "no ~/Applications"
} > "${APPS_DIR}/applications-user.txt"

echo "Collecting config summaries (shell / git / ssh)..."

# Shell / dotfiles summary – we avoid private keys
{
  echo "### ~/.zshrc"
  [ -f "$HOME/.zshrc" ] && cat "$HOME/.zshrc" || echo "No .zshrc"
  echo
  echo "### ~/.zprofile"
  [ -f "$HOME/.zprofile" ] && cat "$HOME/.zprofile" || echo "No .zprofile"
  echo
  echo "### ~/.bash_profile"
  [ -f "$HOME/.bash_profile" ] && cat "$HOME/.bash_profile" || echo "No .bash_profile"
} > "${CONF_DIR}/shell-config.txt"

# Git config
{
  echo "### ~/.gitconfig"
  [ -f "$HOME/.gitconfig" ] && cat "$HOME/.gitconfig" || echo "No .gitconfig"
  echo
  echo "### ~/.gitignore_global"
  [ -f "$HOME/.gitignore_global" ] && cat "$HOME/.gitignore_global" || echo "No .gitignore_global"
} > "${CONF_DIR}/git-config.txt"

# SSH config (but NOT keys)
{
  echo "### ~/.ssh/config"
  [ -f "$HOME/.ssh/config" ] && cat "$HOME/.ssh/config" || echo "No ~/.ssh/config"
  echo
  echo "### Public keys in ~/.ssh"
  if [ -d "$HOME/.ssh" ]; then
    ls "$HOME/.ssh" 2>&1 | grep -E '\.pub$' || echo "No .pub keys found"
  else
    echo "~/.ssh directory not found"
  fi
} > "${CONF_DIR}/ssh-summary.txt"

# Env-related info
{
  echo "### printenv (sanitized suggestion: you may want to edit this file and remove secrets if any)"
  printenv 2>&1
} > "${CONF_DIR}/environment-variables-raw.txt"

echo "Snapshot complete."
echo "Location: ${SNAPSHOT_ROOT}"
echo "You can now move this folder to your SSD if it's on the Desktop."
