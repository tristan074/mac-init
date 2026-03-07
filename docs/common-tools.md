# Mac Common Setup - 工具说明与常用命令

> 对应脚本: `src/setup-common.sh`

## 目录

- [Shell 环境](#shell-环境)
- [CLI 工具](#cli-工具)
- [Git 配置](#git-配置)
- [QuickLook 插件](#quicklook-插件)
- [应用程序](#应用程序)

---

## Shell 环境

### Oh My Zsh

Zsh 的配置框架，提供插件和主题管理。

### Powerlevel10k

高度可定制的 zsh 主题，支持 git 状态、命令执行时间等信息展示。

| 命令 | 说明 |
|------|------|
| `p10k configure` | 重新运行配置向导 |

> 需要 **MesloLGS Nerd Font** 字体才能正确显示图标，脚本已自动安装。

### Zsh 插件

| 插件 | 说明 |
|------|------|
| zsh-autosuggestions | 根据历史记录自动建议命令，按 `→` 接受 |
| zsh-syntax-highlighting | 命令输入实时语法高亮，正确为绿色，错误为红色 |
| zsh-completions | 扩展 Tab 补全规则，支持更多命令 |

---

## CLI 工具

### fzf - 模糊搜索

交互式模糊查找器，可搜索文件、历史命令、进程等。

| 命令 / 快捷键 | 说明 |
|------|------|
| `Ctrl+R` | 模糊搜索历史命令 |
| `Ctrl+T` | 模糊搜索文件并插入路径 |
| `Alt+C` | 模糊搜索目录并 cd 进入 |
| `vim **<Tab>` | 在 vim 参数中模糊补全文件 |
| `kill <Tab>` | 模糊选择进程并 kill |
| `command \| fzf` | 对任意命令输出做模糊筛选 |

### ripgrep (rg) - 快速搜索

比 grep 快得多的文本搜索，默认递归、忽略 .gitignore。

| 命令 | 说明 |
|------|------|
| `rg "pattern"` | 递归搜索当前目录 |
| `rg "pattern" src/` | 搜索指定目录 |
| `rg -i "pattern"` | 忽略大小写 |
| `rg -l "pattern"` | 只显示匹配的文件名 |
| `rg -t py "pattern"` | 只搜索 Python 文件 |
| `rg -C 3 "pattern"` | 显示匹配行前后各 3 行上下文 |
| `rg --hidden "pattern"` | 包含隐藏文件 |

### fd - 快速查找文件

比 find 更友好的文件查找工具，默认忽略 .gitignore。

| 命令 | 说明 |
|------|------|
| `fd "pattern"` | 按文件名模糊查找 |
| `fd -e js` | 查找所有 .js 文件 |
| `fd -e js -x wc -l` | 查找 .js 文件并统计行数 |
| `fd -H "pattern"` | 包含隐藏文件 |
| `fd -t d "pattern"` | 只查找目录 |
| `fd -t f -e log --changed-within 1d` | 查找 1 天内修改的 log 文件 |

### bat - 带高亮的 cat

带语法高亮、行号、Git 变更标记的文件查看器。

| 命令 | 说明 |
|------|------|
| `bat file.py` | 查看文件（语法高亮 + 行号） |
| `bat -l json file` | 指定语言高亮 |
| `bat -r 10:20 file` | 只显示第 10-20 行 |
| `bat -d file` | 只显示 Git diff 的行 |
| `bat --list-languages` | 列出支持的语言 |

> 脚本已配置 `cat` 为 `bat` 的别名，`man` 也用 bat 渲染。

### eza - 更好的 ls

带颜色、图标、Git 状态的 ls 替代。

| 命令 / 别名 | 说明 |
|------|------|
| `ls` | `eza --icons` - 带图标列出文件 |
| `ll` | `eza -alh --icons --git` - 详细列表含 Git 状态 |
| `lt` | `eza --tree --icons --level=2` - 树形展示 2 层 |
| `eza -s modified` | 按修改时间排序 |
| `eza -s size --reverse` | 按大小倒序 |

### zoxide - 智能 cd

记住你去过的目录，支持模糊跳转。

| 命令 | 说明 |
|------|------|
| `z foo` | 跳到最匹配 "foo" 的常去目录 |
| `z foo bar` | 匹配同时含 foo 和 bar 的路径 |
| `zi` | 交互式选择目录（结合 fzf） |
| `zoxide query -ls` | 列出所有记住的目录及权重 |

### tldr - 简化版 man

社区维护的命令速查，比 man 更实用。

| 命令 | 说明 |
|------|------|
| `tldr tar` | 查看 tar 常用用法 |
| `tldr -u` | 更新本地缓存 |
| `tldr -l` | 列出所有可用命令 |

### jq - JSON 处理

命令行 JSON 解析和转换工具。

| 命令 | 说明 |
|------|------|
| `echo '{"a":1}' \| jq .` | 格式化 JSON |
| `jq '.key' file.json` | 提取字段 |
| `jq '.items[]' file.json` | 遍历数组 |
| `jq '.items[] \| select(.age > 18)' file.json` | 过滤 |
| `jq -r '.name' file.json` | 输出原始字符串（不带引号） |
| `curl -s url \| jq .` | 格式化 API 返回 |

### htop - 进程管理

交互式进程查看器。

| 快捷键 | 说明 |
|------|------|
| `F4` / `/` | 过滤 / 搜索进程 |
| `F5` | 树形视图 |
| `F9` | 发送信号（kill） |
| `F6` | 排序 |
| `t` | 切换树形显示 |
| `u` | 按用户过滤 |

### tree - 目录树

| 命令 | 说明 |
|------|------|
| `tree` | 显示当前目录树 |
| `tree -L 2` | 限制深度为 2 层 |
| `tree -a` | 包含隐藏文件 |
| `tree -I "node_modules"` | 排除指定目录 |
| `tree -d` | 只显示目录 |

### tmux - 终端复用

在一个终端窗口中管理多个会话、窗口和面板。断开连接后会话仍在运行。

| 命令 / 快捷键 | 说明 |
|------|------|
| `tmux` | 启动新会话 |
| `tmux new -s name` | 创建命名会话 |
| `tmux ls` | 列出所有会话 |
| `tmux a -t name` | 附加到指定会话 |
| `tmux kill-session -t name` | 关闭指定会话 |
| **以下为会话内快捷键（先按 `Ctrl+B`）** | |
| `Ctrl+B d` | 分离当前会话（detach） |
| `Ctrl+B c` | 新建窗口 |
| `Ctrl+B n` / `p` | 下一个 / 上一个窗口 |
| `Ctrl+B 0-9` | 切换到第 N 个窗口 |
| `Ctrl+B %` | 左右分割面板 |
| `Ctrl+B "` | 上下分割面板 |
| `Ctrl+B 方向键` | 在面板间切换 |
| `Ctrl+B x` | 关闭当前面板 |
| `Ctrl+B [` | 进入滚动/复制模式（q 退出） |
| `Ctrl+B ,` | 重命名当前窗口 |

---

## Git 配置

### Shell 别名 (zsh)

| 别名 | 对应命令 | 说明 |
|------|----------|------|
| `gs` | `git status` | 查看状态 |
| `ga` | `git add` | 暂存文件 |
| `gc` | `git commit` | 提交 |
| `gcm` | `git commit -m` | 带消息提交 |
| `gp` | `git push` | 推送 |
| `gl` | `git pull` | 拉取 |
| `gd` | `git diff` | 查看差异 |
| `gds` | `git diff --staged` | 查看已暂存的差异 |
| `glog` | `git log --oneline --graph` | 图形化日志 |
| `gb` | `git branch` | 分支列表 |
| `gco` | `git checkout` | 切换分支 |
| `gsw` | `git switch` | 切换分支 (新语法) |
| `gsc` | `git switch -c` | 创建并切换分支 |
| `gst` | `git stash` | 暂存工作区 |
| `gstp` | `git stash pop` | 恢复暂存 |
| `gcp` | `git cherry-pick` | 摘取提交 |
| `grb` | `git rebase` | 变基 |
| `gm` | `git merge` | 合并 |

### Git 内置别名

| 别名 | 对应命令 | 说明 |
|------|----------|------|
| `git st` | `git status` | 查看状态 |
| `git co` | `git checkout` | 切换分支 |
| `git br` | `git branch` | 分支列表 |
| `git ci` | `git commit` | 提交 |
| `git unstage` | `git reset HEAD --` | 取消暂存 |
| `git last` | `git log -1 HEAD` | 查看最近一次提交 |
| `git lg` | `git log --oneline --graph --all` | 全分支图形日志 |

### Git 全局配置说明

| 配置项 | 值 | 说明 |
|------|------|------|
| `init.defaultBranch` | `main` | 默认分支名 |
| `pull.rebase` | `true` | pull 时 rebase 而非 merge |
| `push.autoSetupRemote` | `true` | push 时自动设置上游分支 |
| `rerere.enabled` | `true` | 记住冲突解决方式，自动复用 |
| `diff.algorithm` | `histogram` | 更好的 diff 算法 |

---

## QuickLook 插件

在 Finder 中选中文件按**空格键**即可快速预览，以下插件扩展了预览能力：

| 插件 | 预览内容 |
|------|----------|
| qlmarkdown | Markdown 文件（渲染后的效果） |
| quickjson | JSON 文件（格式化 + 高亮） |
| suspicious-package | .pkg 安装包（查看包内文件和安装脚本） |

> 安装后自动生效，无需额外配置。

---

## 应用程序

### Ghostty

现代终端模拟器，配置文件位于 `~/.config/ghostty/config`。

脚本默认配置:
- 字体: MesloLGS Nerd Font (14pt)
- 主题: Catppuccin Mocha
- Shell 集成: zsh

### Sublime Text

轻量级文本编辑器，可通过命令行 `subl` 打开文件。

| 命令 | 说明 |
|------|------|
| `subl file.txt` | 打开文件 |
| `subl .` | 打开当前目录为项目 |
| `subl --new-window` | 新窗口打开 |
| `subl -a dir/` | 将目录添加到当前窗口 |

#### 自动安装的插件

| 插件 | 说明 |
|------|------|
| Package Control | 插件管理器，所有插件通过它安装 |
| MarkdownEditing | Markdown 语法增强、快捷键、配色 |
| MarkdownPreview | 在浏览器中预览 Markdown（`Ctrl+Shift+P` → Markdown Preview） |
| A File Icon | 侧边栏文件图标 |
| BracketHighlighter | 括号/标签高亮匹配 |
| Emmet | HTML/CSS 快速编写（如 `div.container>ul>li*5` + Tab） |
| GitGutter | 行号旁显示 Git 变更状态 |
| SideBarEnhancements | 右键菜单增强（复制路径、在浏览器打开等） |
| SublimeLinter | 代码检查框架（需配合语言插件如 SublimeLinter-eslint） |
| Theme - One Dark | Atom 风格暗色主题 |

> 插件在首次打开 Sublime Text 时自动安装（需联网）。
