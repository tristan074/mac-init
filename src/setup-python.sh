#!/usr/bin/env bash
#
# Mac Python Environment Setup Script
# Usage: bash src/setup-python.sh
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

# ---------- Ensure brew in PATH ----------
ensure_brew_in_path() {
    if ! command -v brew &>/dev/null; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

# ---------- pyenv ----------
install_pyenv() {
    if brew list pyenv &>/dev/null; then
        info "pyenv already installed, skipping"
    else
        info "Installing pyenv..."
        brew install pyenv
    fi

    # pyenv-virtualenv plugin
    if brew list pyenv-virtualenv &>/dev/null; then
        info "pyenv-virtualenv already installed, skipping"
    else
        info "Installing pyenv-virtualenv..."
        brew install pyenv-virtualenv
    fi

    # Init pyenv for current shell session
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)" 2>/dev/null || true
}

# ---------- Install latest Python ----------
install_python() {
    # Find latest stable version (3.x.x, skip dev/rc)
    local LATEST
    LATEST=$(pyenv install --list | grep -E '^\s+3\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')

    if [[ -z "$LATEST" ]]; then
        error "Could not determine latest Python version"
        return 1
    fi

    if pyenv versions --bare | grep -qF "$LATEST"; then
        info "Python $LATEST already installed, skipping"
    else
        info "Installing Python $LATEST (this may take a few minutes)..."
        pyenv install "$LATEST"
    fi

    # Set as global default
    info "Setting Python $LATEST as global default..."
    pyenv global "$LATEST"

    info "Python $(python --version 2>&1) is now active"
}

# ---------- uv ----------
install_uv() {
    if command -v uv &>/dev/null; then
        info "uv already installed, skipping"
    else
        info "Installing uv..."
        brew install uv
    fi
}

# ---------- pipx ----------
install_pipx() {
    if command -v pipx &>/dev/null; then
        info "pipx already installed, skipping"
    else
        info "Installing pipx..."
        brew install pipx
        pipx ensurepath 2>/dev/null || true
    fi
}

# ---------- Common CLI tools via pipx ----------
install_python_tools() {
    info "Installing common Python CLI tools via pipx..."

    local tools=(
        black          # 代码格式化
        ruff           # 超快 linter + formatter
        ipython        # 增强版交互式 Python
    )

    for tool in "${tools[@]}"; do
        if pipx list 2>/dev/null | grep -q "package $tool"; then
            info "$tool already installed, skipping"
        else
            info "Installing $tool..."
            pipx install "$tool"
        fi
    done
}

# ---------- Configure zshrc for pyenv ----------
configure_zshrc_python() {
    local ZSHRC="$HOME/.zshrc"
    local MARKER="# ---------- Python (pyenv) ----------"

    if grep -qF "$MARKER" "$ZSHRC" 2>/dev/null; then
        info "Python config already in .zshrc, skipping"
        return
    fi

    info "Adding Python config to .zshrc..."
    cat >> "$ZSHRC" << 'EOF'

# ---------- Python (pyenv) ----------
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# pipx
export PATH="$HOME/.local/bin:$PATH"
EOF

    info ".zshrc updated with pyenv config"
}

# ---------- Main ----------
main() {
    echo ""
    echo "========================================"
    echo "    Python Environment Setup"
    echo "========================================"
    echo ""

    ensure_brew_in_path

    if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Run setup-common.sh first."
        exit 1
    fi

    install_pyenv
    install_python
    install_uv
    install_pipx
    install_python_tools
    configure_zshrc_python

    echo ""
    echo "========================================"
    info "Python setup complete!"
    echo "========================================"
    echo ""
    warn "Next steps:"
    echo "  1. Restart terminal (or run: exec zsh)"
    echo "  2. Verify: python --version && uv --version"
    echo ""
}

main "$@"
