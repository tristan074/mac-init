#!/usr/bin/env bash
#
# Mac Rust Development Environment Setup Script
# Usage: bash src/setup-rust.sh
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

# ---------- rustup + stable toolchain ----------
install_rust() {
    if command -v rustup &>/dev/null; then
        info "rustup already installed, updating..."
        rustup update stable
    else
        info "Installing rustup + stable toolchain..."
        # Try official installer first, fallback to brew
        if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable; then
            true
        else
            warn "Official installer failed, trying brew..."
            brew install rustup-init
            rustup-init -y --default-toolchain stable
        fi

        # Source cargo env for current session
        source "$HOME/.cargo/env"
    fi

    info "Rust $(rustc --version) is now active"
}

# ---------- Components ----------
install_components() {
    info "Installing rustup components..."

    local components=(
        clippy
        rustfmt
        rust-analyzer
        rust-src
    )

    for comp in "${components[@]}"; do
        if rustup component list --installed | grep -q "$comp"; then
            info "$comp already installed, skipping"
        else
            info "Installing $comp..."
            rustup component add "$comp"
        fi
    done
}

# ---------- Cargo tools ----------
install_cargo_tools() {
    info "Installing cargo tools..."

    # Each entry: "binary_name:crate_name"
    local tools=(
        "cargo-watch:cargo-watch"
        "cargo-add:cargo-edit"
        "bacon:bacon"
        "sccache:sccache"
    )

    for entry in "${tools[@]}"; do
        local bin="${entry%%:*}"
        local crate="${entry##*:}"

        if cargo install --list | grep -q "^$crate "; then
            info "$crate already installed, skipping"
        else
            info "Installing $crate..."
            cargo install "$crate"
        fi
    done
}

# ---------- Configure sccache ----------
configure_sccache() {
    local CARGO_CONFIG_DIR="$HOME/.cargo"
    local CARGO_CONFIG="$CARGO_CONFIG_DIR/config.toml"

    if [[ -f "$CARGO_CONFIG" ]] && grep -q "sccache" "$CARGO_CONFIG"; then
        info "sccache already configured in cargo config, skipping"
        return
    fi

    info "Configuring sccache as rustc wrapper..."
    mkdir -p "$CARGO_CONFIG_DIR"
    cat >> "$CARGO_CONFIG" << 'EOF'

[build]
rustc-wrapper = "sccache"
EOF

    info "sccache configured"
}

# ---------- Configure zshrc ----------
configure_zshrc_rust() {
    local ZSHRC="$HOME/.zshrc"
    local MARKER="# ---------- Rust ----------"

    if grep -qF "$MARKER" "$ZSHRC" 2>/dev/null; then
        info "Rust config already in .zshrc, skipping"
        return
    fi

    info "Adding Rust config to .zshrc..."
    cat >> "$ZSHRC" << 'EOF'

# ---------- Rust ----------
. "$HOME/.cargo/env"
EOF

    info ".zshrc updated with Rust config"
}

# ---------- Main ----------
main() {
    echo ""
    echo "========================================"
    echo "    Rust Development Setup"
    echo "========================================"
    echo ""

    ensure_brew_in_path
    install_rust
    install_components
    install_cargo_tools
    configure_sccache
    configure_zshrc_rust

    echo ""
    echo "========================================"
    info "Rust setup complete!"
    echo "========================================"
    echo ""
    warn "Next steps:"
    echo "  1. Restart terminal (or run: exec zsh)"
    echo "  2. Verify: rustc --version && cargo --version"
    echo ""
}

main "$@"
