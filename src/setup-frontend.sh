#!/usr/bin/env bash
#
# Mac Frontend Development Environment Setup Script
# Usage: bash src/setup-frontend.sh
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

# ---------- fnm (Fast Node Manager) ----------
install_fnm() {
    if brew list fnm &>/dev/null; then
        info "fnm already installed, skipping"
    else
        info "Installing fnm..."
        brew install fnm
    fi

    # Init fnm for current session
    eval "$(fnm env --use-on-cd)" 2>/dev/null || true
}

# ---------- Node.js ----------
install_node() {
    # Install latest LTS
    local CURRENT
    CURRENT=$(fnm list 2>/dev/null | grep -i lts || true)

    if [[ -n "$CURRENT" ]]; then
        info "Node.js LTS already installed, skipping"
    else
        info "Installing Node.js LTS..."
        fnm install --lts
    fi

    fnm default lts-latest
    fnm use lts-latest

    info "Node.js $(node --version) is now active"
    info "npm $(npm --version)"
}

# ---------- pnpm ----------
install_pnpm() {
    if command -v pnpm &>/dev/null; then
        info "pnpm already installed, skipping"
    else
        info "Installing pnpm..."
        npm install -g pnpm
    fi
}

# ---------- bun ----------
install_bun() {
    if command -v bun &>/dev/null; then
        info "bun already installed, skipping"
    else
        info "Installing bun..."
        curl -fsSL https://bun.sh/install | bash
    fi
}

# ---------- Global npm packages ----------
install_global_packages() {
    info "Installing global npm packages..."

    local packages=(
        typescript
        tsx
        prettier
        eslint
        http-server
        npm-check-updates
    )

    for pkg in "${packages[@]}"; do
        if npm list -g "$pkg" &>/dev/null; then
            info "$pkg already installed, skipping"
        else
            info "Installing $pkg..."
            npm install -g "$pkg"
        fi
    done
}

# ---------- Configure zshrc ----------
configure_zshrc_frontend() {
    local ZSHRC="$HOME/.zshrc"
    local MARKER="# ---------- Node.js (fnm) ----------"

    if grep -qF "$MARKER" "$ZSHRC" 2>/dev/null; then
        info "Frontend config already in .zshrc, skipping"
        return
    fi

    info "Adding frontend config to .zshrc..."
    cat >> "$ZSHRC" << 'EOF'

# ---------- Node.js (fnm) ----------
eval "$(fnm env --use-on-cd)"

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# aliases
alias ni='npm install'
alias nr='npm run'
alias nd='npm run dev'
alias nb='npm run build'
alias nt='npm run test'
alias pi='pnpm install'
alias pr='pnpm run'
alias pd='pnpm dev'
alias pb='pnpm build'
alias pt='pnpm test'
alias pa='pnpm add'
alias pad='pnpm add -D'
alias bi='bun install'
alias br='bun run'
alias bd='bun run dev'
alias bb='bun run build'
alias ba='bun add'
alias bad='bun add -D'
EOF

    info ".zshrc updated with frontend config"
}

# ---------- Main ----------
main() {
    echo ""
    echo "========================================"
    echo "    Frontend Development Setup"
    echo "========================================"
    echo ""

    ensure_brew_in_path

    if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Run setup-common.sh first."
        exit 1
    fi

    install_fnm
    install_node
    install_pnpm
    install_bun
    install_global_packages
    configure_zshrc_frontend

    echo ""
    echo "========================================"
    info "Frontend setup complete!"
    echo "========================================"
    echo ""
    warn "Next steps:"
    echo "  1. Restart terminal (or run: exec zsh)"
    echo "  2. Verify: node --version && pnpm --version && bun --version"
    echo ""
}

main "$@"
