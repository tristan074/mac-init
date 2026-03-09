#!/usr/bin/env bash
#
# Mac VSCode Setup Script
# Usage: bash src/setup-vscode.sh
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

# ---------- Install VSCode ----------
install_vscode() {
    if [[ -d "/Applications/Visual Studio Code.app" ]] || brew list --cask visual-studio-code &>/dev/null; then
        info "VSCode already installed, skipping"
    else
        info "Installing VSCode..."
        brew install --cask visual-studio-code
    fi

    # Ensure `code` command is available
    local CODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
    if [[ -f "$CODE_BIN" ]] && ! command -v code &>/dev/null; then
        info "Adding code command to PATH..."
        local SHELL_PROFILE="$HOME/.zprofile"
        local CODE_PATH='export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"'
        if ! grep -qF "$CODE_PATH" "$SHELL_PROFILE" 2>/dev/null; then
            echo "$CODE_PATH" >> "$SHELL_PROFILE"
        fi
        export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
    else
        info "code command already available"
    fi
}

# ---------- Extension install helper ----------
install_extensions() {
    local category="$1"
    shift
    local extensions=("$@")

    info "Installing $category extensions..."
    for ext in "${extensions[@]}"; do
        if code --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
            info "  $ext already installed, skipping"
        else
            info "  Installing $ext..."
            code --install-extension "$ext" --force 2>/dev/null || warn "  Failed to install $ext"
        fi
    done
}

# ---------- Extension categories ----------
install_general_extensions() {
    local extensions=(
        esbenp.prettier-vscode
        editorconfig.editorconfig
        eamodio.gitlens
        pkief.material-icon-theme
        zhuangtongfa.material-theme
        streetsidesoftware.code-spell-checker
        gruntfuggly.todo-tree
        usernamehw.errorlens
        github.copilot-chat
        anthropic.claude-code
        k--kato.intellij-idea-keybindings
        ms-vscode-remote.remote-ssh
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint
    )
    install_extensions "General" "${extensions[@]}"
}

install_frontend_extensions() {
    local extensions=(
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss
        yoavbls.pretty-ts-errors
    )
    install_extensions "Frontend" "${extensions[@]}"
}

install_python_extensions() {
    local extensions=(
        ms-python.python
        charliermarsh.ruff
    )
    install_extensions "Python" "${extensions[@]}"
}

install_rust_extensions() {
    local extensions=(
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        fill-labs.dependi
        vadimcn.vscode-lldb
    )
    install_extensions "Rust" "${extensions[@]}"
}

# ---------- Category selection ----------
prompt_categories() {
    echo ""
    echo "Select extension categories to install:"
    echo "  1) General        (Prettier, GitLens, ErrorLens, Copilot, Claude Code, IntelliJ keys, SSH, Markdown...)"
    echo "  2) Frontend        (ESLint, Tailwind CSS, Pretty TS Errors)"
    echo "  3) Python          (Python, Ruff)"
    echo "  4) Rust            (rust-analyzer, TOML, Dependi, CodeLLDB)"
    echo "  a) All of the above"
    echo "  q) Skip extensions"
    echo ""
    read -rp "Enter choices (e.g. 123, a, q): " choices

    if [[ "$choices" == "q" ]]; then
        info "Skipping extension installation"
        return
    fi

    if [[ "$choices" == "a" ]]; then
        choices="1234"
    fi

    [[ "$choices" == *1* ]] && install_general_extensions
    [[ "$choices" == *2* ]] && install_frontend_extensions
    [[ "$choices" == *3* ]] && install_python_extensions
    [[ "$choices" == *4* ]] && install_rust_extensions
}

# ---------- Main ----------
main() {
    echo ""
    echo "========================================"
    echo "    VSCode Setup Script"
    echo "========================================"
    echo ""

    ensure_brew_in_path

    if ! command -v brew &>/dev/null; then
        error "Homebrew not found. Run setup-common.sh first."
        exit 1
    fi

    install_vscode
    prompt_categories

    echo ""
    echo "========================================"
    info "VSCode setup complete!"
    echo "========================================"
    echo ""
    warn "Next steps:"
    echo "  1. Restart terminal (or run: exec zsh)"
    echo "  2. Open VSCode and check installed extensions"
    echo "  3. IntelliJ keybindings are active immediately"
    echo "  4. Run 'p10k configure' if terminal icons look broken in VSCode terminal"
    echo ""
}

main "$@"
