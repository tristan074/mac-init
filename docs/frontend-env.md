# 前端开发环境 - 工具说明与常用命令

> 对应脚本: `src/setup-frontend.sh`

## 目录

- [fnm - Node.js 版本管理](#fnm---nodejs-版本管理)
- [包管理器对比](#包管理器对比)
- [pnpm](#pnpm)
- [bun](#bun)
- [全局工具](#全局工具)
- [Shell 别名](#shell-别名)

---

## fnm - Node.js 版本管理

Rust 实现的 Node.js 版本管理器，比 nvm 快得多。支持 `.node-version` / `.nvmrc` 自动切换。

### 版本管理

| 命令 | 说明 |
|------|------|
| `fnm list-remote` | 列出所有可安装版本 |
| `fnm install --lts` | 安装最新 LTS 版本 |
| `fnm install 22` | 安装指定大版本的最新版 |
| `fnm install 22.5.0` | 安装精确版本 |
| `fnm uninstall 20` | 卸载版本 |
| `fnm list` | 列出已安装版本 |
| `fnm current` | 显示当前版本 |

### 版本切换

| 命令 | 说明 |
|------|------|
| `fnm use --lts` | 切换到 LTS |
| `fnm use 22` | 切换到指定版本 |
| `fnm default 22` | 设置默认版本 |

> 脚本已配置 `--use-on-cd`：进入含 `.node-version` 或 `.nvmrc` 的目录时自动切换版本。

### 项目锁定版本

```bash
# 在项目根目录
node --version > .node-version
# 之后进入该目录会自动切换到此版本
```

---

## 包管理器对比

| 特性 | npm | pnpm | bun |
|------|-----|------|-----|
| 安装速度 | 慢 | 快 | 最快 |
| 磁盘占用 | 大（每项目复制） | 小（硬链接共享） | 小 |
| Lock 文件 | package-lock.json | pnpm-lock.yaml | bun.lock |
| 兼容性 | 最好 | 好 | 部分场景有差异 |
| 运行脚本 | `npm run` | `pnpm run` | `bun run` |
| 推荐场景 | 默认/兼容 | 多项目/monorepo | 追求速度 |

---

## pnpm

高效的包管理器，使用硬链接共享依赖，节省磁盘空间。Monorepo 首选。

### 依赖管理

| 命令 | 说明 |
|------|------|
| `pnpm install` | 安装所有依赖 |
| `pnpm add pkg` | 添加依赖 |
| `pnpm add -D pkg` | 添加开发依赖 |
| `pnpm add -g pkg` | 全局安装 |
| `pnpm remove pkg` | 移除依赖 |
| `pnpm update` | 更新所有依赖 |
| `pnpm update pkg` | 更新指定依赖 |

### 运行与执行

| 命令 | 说明 |
|------|------|
| `pnpm run dev` | 运行 dev 脚本 |
| `pnpm dev` | 同上（run 可省略） |
| `pnpm dlx create-react-app myapp` | 临时运行包（类似 npx） |
| `pnpm exec tsc` | 在项目上下文执行命令 |

### Monorepo (workspace)

| 命令 | 说明 |
|------|------|
| `pnpm -r run build` | 所有子包执行 build |
| `pnpm --filter pkg-name run dev` | 指定子包执行命令 |
| `pnpm --filter pkg-name add dep` | 给指定子包添加依赖 |

---

## bun

Zig 实现的 JavaScript 运行时 + 包管理器 + 打包器，极快。

### 包管理

| 命令 | 说明 |
|------|------|
| `bun install` | 安装所有依赖 |
| `bun add pkg` | 添加依赖 |
| `bun add -D pkg` | 添加开发依赖 |
| `bun remove pkg` | 移除依赖 |
| `bun update` | 更新所有依赖 |

### 运行

| 命令 | 说明 |
|------|------|
| `bun run dev` | 运行 package.json 脚本 |
| `bun run file.ts` | 直接运行 TypeScript（无需编译） |
| `bun run file.jsx` | 直接运行 JSX |
| `bun --watch run file.ts` | 文件变化自动重运行 |

### 其他功能

| 命令 | 说明 |
|------|------|
| `bun init` | 初始化新项目 |
| `bun create next-app myapp` | 用模板创建项目 |
| `bun test` | 运行测试（内置 Jest 兼容测试器） |
| `bun build src/index.ts --outdir ./dist` | 打包 |
| `bunx pkg` | 临时运行包（类似 npx） |

---

## 全局工具

脚本通过 npm 全局安装以下工具：

| 工具 | 命令 | 说明 |
|------|------|------|
| typescript | `tsc file.ts` | TypeScript 编译器 |
| tsx | `tsx file.ts` | 直接运行 TS（无需编译，比 ts-node 快） |
| prettier | `prettier --write .` | 代码格式化（支持多语言） |
| eslint | `eslint .` | JavaScript/TypeScript Linter |
| http-server | `http-server ./dist` | 零配置本地静态文件服务器 |
| npm-check-updates | `ncu` | 检查 package.json 依赖更新 |

### prettier 常用命令

| 命令 | 说明 |
|------|------|
| `prettier --write .` | 格式化当前目录所有文件 |
| `prettier --write "src/**/*.{ts,tsx}"` | 格式化指定文件 |
| `prettier --check .` | 只检查不修改（CI 用） |

### npm-check-updates 常用命令

| 命令 | 说明 |
|------|------|
| `ncu` | 检查可更新的依赖 |
| `ncu -u` | 更新 package.json 版本号 |
| `ncu -i` | 交互式选择要更新的依赖 |

---

## Shell 别名

### npm

| 别名 | 对应命令 |
|------|----------|
| `ni` | `npm install` |
| `nr` | `npm run` |
| `nd` | `npm run dev` |
| `nb` | `npm run build` |
| `nt` | `npm run test` |

### pnpm

| 别名 | 对应命令 |
|------|----------|
| `pi` | `pnpm install` |
| `pr` | `pnpm run` |
| `pd` | `pnpm dev` |
| `pb` | `pnpm build` |
| `pt` | `pnpm test` |
| `pa` | `pnpm add` |
| `pad` | `pnpm add -D` |

### bun

| 别名 | 对应命令 |
|------|----------|
| `bi` | `bun install` |
| `br` | `bun run` |
| `bd` | `bun run dev` |
| `bb` | `bun run build` |
| `ba` | `bun add` |
| `bad` | `bun add -D` |
