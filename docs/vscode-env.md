# VSCode 环境 - 插件说明与分类

> 对应脚本: `src/setup-vscode.sh`

## 目录

- [安装方式](#安装方式)
- [通用插件](#通用插件)
- [前端开发](#前端开发)
- [Python 开发](#python-开发)
- [Rust 开发](#rust-开发)
- [相关配置](#相关配置)

---

## 安装方式

```bash
bash src/setup-vscode.sh
```

脚本会安装 VSCode 并提示选择插件分类（可多选），输入数字组合即可：

- `1` — 通用（默认推荐）
- `2` — 前端
- `3` — Python
- `4` — Rust
- `a` — 全部安装

---

## 通用插件

| 插件 | ID | 说明 |
|------|----|------|
| Prettier | `esbenp.prettier-vscode` | 代码格式化标准工具 |
| EditorConfig | `editorconfig.editorconfig` | 跨编辑器统一缩进/编码配置 |
| GitLens | `eamodio.gitlens` | Git blame、行历史、CodeLens（免费版够用） |
| Material Icon Theme | `pkief.material-icon-theme` | 文件图标主题，覆盖全面 |
| One Dark Pro | `zhuangtongfa.material-theme` | Atom One Dark 风格暗色主题 |
| Code Spell Checker | `streetsidesoftware.code-spell-checker` | 变量名/注释拼写检查 |
| Todo Tree | `gruntfuggly.todo-tree` | 扫描并聚合 TODO/FIXME/HACK 标记 |
| Error Lens | `usernamehw.errorlens` | 错误/警告内联显示在代码行末 |
| GitHub Copilot Chat | `github.copilot-chat` | AI 代码补全与对话（旧 `github.copilot` 已废弃并合并到此） |
| Claude Code | `anthropic.claude-code` | Anthropic 官方 Claude Code VSCode 集成 |
| IntelliJ Keybindings | `k--kato.intellij-idea-keybindings` | IntelliJ/WebStorm/PyCharm 快捷键映射（200+ 快捷键） |
| Remote - SSH | `ms-vscode-remote.remote-ssh` | SSH 远程开发，微软官方维护 |
| Markdown All in One | `yzhang.markdown-all-in-one` | 快捷键、自动 TOC、表格格式化、列表续行 |
| markdownlint | `davidanson.vscode-markdownlint` | Markdown lint 规则检查 + 自动修复 |
| ShellCheck | `timonwong.shellcheck` | Shell 脚本实时 lint，自带 shellcheck 二进制 |
| Bash IDE | `mads-hartmann.bash-ide-vscode` | Shell 脚本 LSP（跳转定义、补全、引用、重命名） |
| shfmt | `mkhl.shfmt` | Shell 脚本格式化（需 `brew install shfmt`，脚本自动安装） |

---

## 前端开发

| 插件 | ID | 说明 |
|------|----|------|
| ESLint | `dbaeumer.vscode-eslint` | JS/TS 代码检查，支持 ESLint v9 flat config |
| Tailwind CSS IntelliSense | `bradlc.vscode-tailwindcss` | Tailwind class 自动补全、悬停预览、lint |
| Pretty TypeScript Errors | `yoavbls.pretty-ts-errors` | 将 TS 错误信息格式化为可读格式 |

### 不再推荐的前端插件

| 插件 | 原因 |
|------|------|
| Auto Rename Tag | VSCode 内置 `editor.linkedEditing` 已替代 |
| ES7+ React Snippets | AI 补全时代价值低 |
| styled-components | 生态已转向 Tailwind CSS |

> **提示**：在 settings.json 中启用 `"editor.linkedEditing": true` 即可获得标签自动重命名功能。

---

## Python 开发

| 插件 | ID | 说明 |
|------|----|------|
| Python | `ms-python.python` | Microsoft 官方核心扩展，自动捆绑 Pylance + debugpy |
| Ruff | `charliermarsh.ruff` | 替代 black/flake8/isort/pylint 的一体化 linter+formatter |

### 说明

- **Pylance** 和 **debugpy** 无需单独安装，随 `ms-python.python` 自动安装
- **Ruff** 是 Python 社区当前标准的 lint/format 工具，FastAPI/pandas/pydantic 等大项目已全面采用
- Ruff 不做类型检查，需要 mypy 可额外安装 `ms-python.mypy-type-checker`

---

## Rust 开发

| 插件 | ID | 说明 |
|------|----|------|
| rust-analyzer | `rust-lang.rust-analyzer` | Rust 官方 LSP，唯一标准方案 |
| Even Better TOML | `tamasfe.even-better-toml` | TOML 语法高亮与验证 |
| Dependi | `fill-labs.dependi` | Cargo.toml 依赖版本管理（替代已废弃的 `crates`） |
| CodeLLDB | `vadimcn.vscode-lldb` | LLDB 调试器，macOS 上 Rust 调试首选 |

### 说明

- `serayuzgur.crates` 已废弃（GitHub 标记 deprecated），由 `fill-labs.dependi` 继承
- Dependi 额外支持 Go/JS/TS/Python 等语言的依赖管理
- CodeLLDB 利用 macOS 原生 LLDB，适配最好

---

## 相关配置

### IntelliJ 快捷键

安装 `k--kato.intellij-idea-keybindings` 后立即生效。常用映射：

| IntelliJ | VSCode 映射后 | 功能 |
|----------|---------------|------|
| `⌘ ⇧ A` | `⌘ ⇧ P` | 命令面板 |
| `⌘ E` | `⌘ E` | 最近文件 |
| `⌘ B` | `F12` | 跳转到定义 |
| `⌘ ⇧ F` | `⌘ ⇧ F` | 全局搜索 |
| `⌥ ↩` | `⌘ .` | Quick Fix |
| `⇧ ⇧` | — | 需手动配置或用 `⌘ P` 替代 |

> 个别快捷键可能与 macOS 或其他插件冲突，可在 `Preferences > Keyboard Shortcuts` 中调整。
