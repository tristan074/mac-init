# mac-init

Mac 新机初始化配置仓库。集中管理开发环境搭建、工具配置、dotfiles 等，新机器上一键恢复开发环境。

## 快速开始

```bash
# 1. 基础环境（必须先执行）
bash src/setup-common.sh

# 2. 按需执行
bash src/setup-python.sh
bash src/setup-frontend.sh
bash src/setup-rust.sh
```

## 已实现功能

### 基础环境 (`src/setup-common.sh`)

- Homebrew 安装
- CLI 工具：git, fzf, ripgrep, fd, bat, eza, zoxide, tldr, jq, htop, tree, tmux
- Zsh + Oh My Zsh + Powerlevel10k 主题 + 插件（autosuggestions, syntax-highlighting, completions）
- Git 全局配置（默认分支 main, rebase pull, histogram diff 等）
- Ghostty 终端配置（Catppuccin Mocha 主题, MesloLGS Nerd Font）
- Sublime Text + Package Control + 常用插件
- QuickLook 插件（Markdown, JSON, .pkg 预览）
- `.zshrc` 完整配置（工具初始化、别名等）

### Python 环境 (`src/setup-python.sh`)

- pyenv + pyenv-virtualenv（Python 版本管理）
- 自动安装最新稳定版 Python 并设为全局默认
- uv（快速包管理）
- pipx + 常用工具：black, ruff, ipython

### 前端环境 (`src/setup-frontend.sh`)

- fnm（Node.js 版本管理）+ 最新 LTS
- pnpm, bun
- 全局 npm 包：typescript, tsx, prettier, eslint, http-server, npm-check-updates

### Rust 环境 (`src/setup-rust.sh`)

- rustup + stable 工具链
- 组件：clippy, rustfmt, rust-analyzer, rust-src
- Cargo 工具：cargo-watch, cargo-edit, bacon, sccache
- sccache 配置为 rustc wrapper

## 目录结构

```
src/           安装脚本
docs/          各环境的工具说明与常用命令参考
```

## 参考文档

各环境的详细工具说明和常用命令见 `docs/` 目录。
