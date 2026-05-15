## Kishan Arava dotfiles

Custom configuration files for:
* Bash
* Zsh
* Git
* Tmux
* Vim
* Custom scripts

## What's Included

| Tool | What it does |
|---|---|
| `z` / `zz` | Jump to frecent directories (powered by fasd). Just `cd` around normally and fasd learns — then `z foo` jumps to the best match |
| `fzf` | Fuzzy finder — `Ctrl+R` for history search, `Ctrl+T` for file search |
| `fd` | Fast, user-friendly `find` alternative |
| `rg` | Ripgrep — blazing fast `grep` |
| `nnn` | Terminal file manager |
| `tldr` | Simplified man pages |
| `tmux` | Terminal multiplexer (prefix: `Ctrl+A`) |
| `diff-so-fancy` | Better git diffs |

## Setup Instructions

### Prerequisites
- **macOS:** Install [Homebrew](https://brew.sh) first
- **Linux:** apt-based distro (Ubuntu/Debian)

### 1. Clone and run setup scripts

```bash
cd ~
git clone <repo-url> dotfiles
cd dotfiles
./1-setup-shell.sh    # Installs tools (fd, nnn, ripgrep, tmux, fzf, oh-my-zsh, etc.)
./2-setup-dotfiles.sh # Backs up existing dotfiles and symlinks new ones via stow
```

### 2. Install Powerlevel10k theme

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 3. Install MesloLGS Nerd Font

The Powerlevel10k configuration wizard (step 6) will offer to install MesloLGS NF automatically. You can accept that, or install it manually beforehand:

```bash
# macOS
brew install font-meslo-lg-nerd-font

# Linux
# Download from https://github.com/ryanoasis/nerd-fonts/releases and install manually
```

Then set the font in your terminal:
- **iTerm2:** Settings → Profiles → Text → Font → **MesloLGS NF** (size 16)

### 4. Remap Caps Lock to Escape

- **macOS:** System Settings → Keyboard → Keyboard Shortcuts → Modifier Keys → Set Caps Lock to **Escape**

### 5. Install Hammerspoon (macOS only)

```bash
brew install --cask hammerspoon
git clone <hammerspoon-repo-url> ~/.hammerspoon
```

Grant Accessibility permissions when prompted: System Settings → Privacy & Security → Accessibility → enable **Hammerspoon**.

### 6. Restart your shell

```bash
exec zsh
```

The Powerlevel10k configuration wizard will run on first launch. If you already have a `.p10k.zsh` config it will be picked up automatically.

---

fasd and diff-so-fancy are vendored in scripts/bin and linked to ~/bin by 2-setup-dotfiles.sh.

## Reference
- [Add powerline fonts](https://opensource.com/article/19/9/adding-plugins-zsh)
  This will make it easier to find where the command was run, and where the output started
