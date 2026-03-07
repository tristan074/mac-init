#!/usr/bin/env bash
#
# Mac Common Setup Script
# Usage: bash src/setup-common.sh
#

set -euo pipefail

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ---------- Homebrew ----------
ensure_brew_in_path() {
    # brew may not be in PATH when running via bash (not login zsh)
    if ! command -v brew &>/dev/null; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

install_homebrew() {
    ensure_brew_in_path

    if command -v brew &>/dev/null; then
        info "Homebrew already installed, skipping"
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        ensure_brew_in_path

        # Add brew to .zprofile for future zsh sessions (only if not already there)
        if [[ $(uname -m) == "arm64" ]]; then
            local BREW_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'
        else
            local BREW_LINE='eval "$(/usr/local/bin/brew shellenv)"'
        fi
        if ! grep -qF "$BREW_LINE" "$HOME/.zprofile" 2>/dev/null; then
            echo "$BREW_LINE" >> "$HOME/.zprofile"
        fi
    fi
}

# ---------- CLI Tools ----------
install_cli_tools() {
    info "Installing CLI tools via Homebrew..."

    local formulae=(
        git
        fzf
        ripgrep
        fd
        bat
        eza
        zoxide
        tldr
        jq
        htop
        tree
        tmux
    )

    for pkg in "${formulae[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            info "$pkg already installed, skipping"
        else
            info "Installing $pkg..."
            brew install "$pkg"
        fi
    done

    # fzf key bindings and completion
    if [[ -f "$HOME/.fzf.zsh" ]]; then
        info "fzf key bindings already configured, skipping"
    elif [[ -f "$(brew --prefix)/opt/fzf/install" ]]; then
        info "Setting up fzf key bindings..."
        "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
}

# ---------- Ghostty ----------
install_ghostty() {
    if [[ -d "/Applications/Ghostty.app" ]] || brew list --cask ghostty &>/dev/null; then
        info "Ghostty already installed, skipping"
    else
        info "Installing Ghostty..."
        brew install --cask ghostty
    fi
}

# ---------- Sublime Text ----------
install_sublime() {
    if [[ -d "/Applications/Sublime Text.app" ]] || brew list --cask sublime-text &>/dev/null; then
        info "Sublime Text already installed, skipping"
    else
        info "Installing Sublime Text..."
        brew install --cask sublime-text
    fi

    # Ensure subl command is in PATH
    local SUBL_BIN="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
    local SUBL_LINK="/usr/local/bin/subl"
    if [[ -f "$SUBL_BIN" ]] && ! command -v subl &>/dev/null; then
        info "Creating subl symlink..."
        sudo mkdir -p /usr/local/bin
        sudo ln -sf "$SUBL_BIN" "$SUBL_LINK"
    else
        info "subl command already available, skipping"
    fi
}

configure_sublime() {
    local SUBLIME_PKG_DIR="$HOME/Library/Application Support/Sublime Text/Packages"
    local SUBLIME_INSTALLED_DIR="$HOME/Library/Application Support/Sublime Text/Installed Packages"
    local SUBLIME_USER_DIR="$SUBLIME_PKG_DIR/User"
    local PC_SETTINGS="$SUBLIME_USER_DIR/Package Control.sublime-settings"

    mkdir -p "$SUBLIME_USER_DIR"
    mkdir -p "$SUBLIME_INSTALLED_DIR"

    # Install Package Control if not present
    local PC_FILE="$SUBLIME_INSTALLED_DIR/Package Control.sublime-package"
    if [[ -f "$PC_FILE" ]]; then
        info "Package Control already installed, skipping"
    else
        info "Installing Sublime Text Package Control..."
        curl -fsSL "https://packagecontrol.io/Package%20Control.sublime-package" \
            -o "$PC_FILE"
    fi

    # Configure packages to auto-install on next Sublime launch
    if [[ -f "$PC_SETTINGS" ]]; then
        info "Sublime package list already configured, skipping"
    else
        info "Configuring Sublime Text plugins..."
        cat > "$PC_SETTINGS" << 'EOF'
{
    "installed_packages":
    [
        "A File Icon",
        "BracketHighlighter",
        "Emmet",
        "GitGutter",
        "MarkdownEditing",
        "MarkdownPreview",
        "Package Control",
        "SideBarEnhancements",
        "SublimeLinter",
        "Theme - One Dark"
    ]
}
EOF
    fi

    info "Sublime Text configured (plugins will auto-install on first launch)"
}

# ---------- Zsh + Oh My Zsh + Powerlevel10k ----------
setup_zsh() {
    # Ensure zsh is default shell
    if [[ "$SHELL" != */zsh ]]; then
        info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
    else
        info "zsh is already default shell"
    fi

    # Oh My Zsh
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        info "Oh My Zsh already installed, skipping"
    else
        info "Installing Oh My Zsh..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Powerlevel10k
    if [[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        info "Powerlevel10k already installed, skipping"
    else
        info "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
            "$ZSH_CUSTOM/themes/powerlevel10k"
    fi

    # Nerd Font (for Powerlevel10k icons)
    if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        info "MesloLGS Nerd Font already installed, skipping"
    else
        info "Installing MesloLGS Nerd Font (required by Powerlevel10k)..."
        brew install --cask font-meslo-lg-nerd-font
    fi

    # zsh-autosuggestions
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        info "zsh-autosuggestions already installed, skipping"
    else
        info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        info "zsh-syntax-highlighting already installed, skipping"
    else
        info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    # zsh-completions
    if [[ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]]; then
        info "zsh-completions already installed, skipping"
    else
        info "Installing zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions \
            "$ZSH_CUSTOM/plugins/zsh-completions"
    fi
}

# ---------- Configure .zshrc ----------
configure_zshrc() {
    local ZSHRC="$HOME/.zshrc"

    # Backup existing .zshrc
    if [[ -f "$ZSHRC" ]]; then
        cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d%H%M%S)"
        info "Backed up existing .zshrc"
    fi

    info "Configuring .zshrc..."

    cat > "$ZSHRC" << 'ZSHRC_EOF'
# ---------- Powerlevel10k instant prompt ----------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---------- Oh My Zsh ----------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    fzf
    z
)

# zsh-completions needs this before oh-my-zsh loads
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# ---------- Tool configs ----------
# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# bat as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# eza aliases (replacing ls)
alias ls='eza --icons'
alias ll='eza -alh --icons --git'
alias lt='eza --tree --icons --level=2'


# ---------- Git aliases ----------
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --decorate -20'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gsc='git switch -c'
alias gst='git status'
alias gstp='git stash pop'
alias gcp='git cherry-pick'
alias grb='git rebase'
alias gm='git merge'

# ---------- Powerlevel10k config ----------
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC_EOF

    info ".zshrc configured"
}

# ---------- Git global config ----------
configure_git() {
    info "Configuring Git global settings..."

    # Only set if not already configured
    if [[ -z "$(git config --global user.name 2>/dev/null)" ]]; then
        warn "Git user.name not set. Run: git config --global user.name 'Your Name'"
    fi
    if [[ -z "$(git config --global user.email 2>/dev/null)" ]]; then
        warn "Git user.email not set. Run: git config --global user.email 'you@example.com'"
    fi

    git config --global init.defaultBranch main
    git config --global core.autocrlf input
    git config --global core.editor "vim"
    git config --global pull.rebase true
    git config --global push.autoSetupRemote true
    git config --global rerere.enabled true
    git config --global diff.algorithm histogram

    # Useful git aliases (in git itself)
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.lg "log --oneline --graph --decorate --all"

    info "Git configured"
}

# ---------- Ghostty config ----------
configure_ghostty() {
    local GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
    local GHOSTTY_CONFIG="$GHOSTTY_CONFIG_DIR/config"

    mkdir -p "$GHOSTTY_CONFIG_DIR"

    if [[ -f "$GHOSTTY_CONFIG" ]]; then
        info "Ghostty config already exists, skipping"
        return
    fi

    info "Writing Ghostty config..."
    cat > "$GHOSTTY_CONFIG" << 'EOF'
font-family = MesloLGS Nerd Font
font-size = 14
theme = Catppuccin Mocha
window-padding-x = 8
window-padding-y = 4
cursor-style = block
shell-integration = zsh
EOF

    info "Ghostty configured"
}

# ---------- QuickLook Plugins ----------
install_quicklook() {
    info "Installing QuickLook plugins..."

    local casks=(
        qlmarkdown         # Markdown 渲染预览
        quickjson          # JSON 格式化预览
        suspicious-package # .pkg 安装包内容预览
    )

    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null; then
            info "$cask already installed, skipping"
        else
            info "Installing $cask..."
            brew install --cask "$cask"
        fi
    done

    # Reset QuickLook server to load new plugins
    info "Restarting QuickLook server..."
    qlmanage -r &>/dev/null || true
}

# ---------- Main ----------
main() {
    echo ""
    echo "========================================"
    echo "    Mac Common Setup Script"
    echo "========================================"
    echo ""

    install_homebrew
    install_cli_tools
    install_ghostty
    install_sublime
    setup_zsh
    configure_zshrc
    configure_git
    configure_ghostty
    configure_sublime
    install_quicklook

    echo ""
    echo "========================================"
    info "Setup complete!"
    echo "========================================"
    echo ""
    warn "Next steps:"
    echo "  1. Restart your terminal (or run: exec zsh)"
    echo "  2. Powerlevel10k config wizard will start automatically"
    echo "     (or run: p10k configure)"
    echo "  3. In Ghostty, set font to 'MesloLGS Nerd Font' if icons look broken"
    echo "  4. Set your git identity if not done:"
    echo "     git config --global user.name 'Your Name'"
    echo "     git config --global user.email 'you@example.com'"
    echo ""
}

main "$@"
