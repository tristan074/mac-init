将 mac-init 仓库中 `claude/` 目录下的配置部署到当前机器的 `~/.claude/`。

## 部署规则

1. 读取 `claude/CLAUDE.md`，部署到 `~/.claude/CLAUDE.md`
   - 如果目标已存在，展示 diff 并确认是否覆盖
2. 读取 `claude/settings.json`，合并到 `~/.claude/settings.json`
   - 保留目标文件中已有的配置，仅补充新增项，冲突时提示用户选择
3. 将 `claude/agents/custom/` 下所有文件部署到 `~/.claude/agents/`
4. 将 `claude/commands/custom/` 下所有文件部署到 `~/.claude/commands/`
5. 将 `claude/tools/custom/` 下的配置合并到 Claude Code 的 MCP 设置中
6. 将 `claude/scripts/` 下的脚本部署到 `~/.claude/scripts/`
7. 使用 **symlink** 方式部署，这样修改仓库文件即时生效
6. 已存在的 symlink 跳过，目标是非 symlink 的已有文件时提示用户确认
7. 部署完成后列出所有已部署的配置清单
