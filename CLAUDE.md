# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 这是什么

Mac 新机初始化配置仓库。集中管理开发环境搭建脚本、工具配置、Claude Code 配置等，目标是在新机器上快速恢复完整的开发环境。此仓库会持续迭代维护。

## 维护原则

- **README.md 是索引**：每次新增或修改功能后，必须同步更新 README.md，保持其作为"当前已实现功能"的准确清单
- **幂等性**：所有安装脚本必须可重复执行——先检查再安装，已存在则跳过
- **模块化**：按用途拆分独立脚本/配置，互不耦合，按需执行
- **Claude 配置**：`claude/` 目录管理 Claude Code 的全局配置，通过 `/deploy` command 部署到 `~/.claude/`

## 脚本编写规范

- `set -euo pipefail` 开头
- 安装前检查：GUI 应用查 `/Applications/xxx.app` 或 `brew list --cask`，CLI 查 `command -v` 或 `brew list`
- 脚本开头调用 `ensure_brew_in_path`（bash 非 login shell 时 brew 可能不在 PATH）
- 修改 `.zshrc` 用 marker 注释（如 `# ---------- Python (pyenv) ----------`）+ `grep -qF` 防重复
- 输出用 `info()`/`warn()`/`error()` 带颜色函数

## 语言

用户使用中文交流。文档用中文。脚本注释中英文均可。
