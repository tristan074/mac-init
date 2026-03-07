# Rust 开发环境 - 工具说明与常用命令

> 对应脚本: `src/setup-rust.sh`

## 目录

- [rustup - 工具链管理](#rustup---工具链管理)
- [cargo - 包管理与构建](#cargo---包管理与构建)
- [组件工具](#组件工具)
- [Cargo 扩展](#cargo-扩展)

---

## rustup - 工具链管理

### Toolchain 管理

| 命令 | 说明 |
|------|------|
| `rustup update` | 更新所有已安装 toolchain |
| `rustup default stable` | 设置默认 toolchain |
| `rustup default nightly` | 切换到 nightly |
| `rustup toolchain list` | 列出已安装 toolchain |
| `rustup toolchain install nightly` | 安装 nightly |

### 项目级 Toolchain

| 命令 | 说明 |
|------|------|
| `rustup override set nightly` | 当前目录使用 nightly |
| `rustup override unset` | 取消目录覆盖 |

> 也可在项目根目录创建 `rust-toolchain.toml` 文件指定版本。

### 组件管理

| 命令 | 说明 |
|------|------|
| `rustup component list` | 列出所有可用组件 |
| `rustup component list --installed` | 列出已安装组件 |
| `rustup component add rust-analyzer` | 安装组件 |
| `rustup component remove rust-analyzer` | 移除组件 |

### Target（交叉编译）

| 命令 | 说明 |
|------|------|
| `rustup target list` | 列出所有可用 target |
| `rustup target add x86_64-unknown-linux-gnu` | 添加 Linux x86_64 |
| `rustup target add aarch64-unknown-linux-gnu` | 添加 Linux ARM64 |
| `rustup target add wasm32-unknown-unknown` | 添加 WebAssembly |

---

## cargo - 包管理与构建

### 项目创建

| 命令 | 说明 |
|------|------|
| `cargo new myproject` | 创建二进制项目 |
| `cargo new --lib mylib` | 创建库项目 |
| `cargo init` | 在当前目录初始化项目 |

### 构建与运行

| 命令 | 说明 |
|------|------|
| `cargo build` | 编译（debug 模式） |
| `cargo build --release` | 编译（release 优化模式） |
| `cargo run` | 编译并运行 |
| `cargo run -- args` | 编译运行并传参 |
| `cargo run --example name` | 运行 examples/ 下的示例 |

### 测试与检查

| 命令 | 说明 |
|------|------|
| `cargo test` | 运行所有测试 |
| `cargo test test_name` | 运行匹配名称的测试 |
| `cargo test -- --nocapture` | 测试时显示 println 输出 |
| `cargo check` | 只检查编译错误（比 build 快） |
| `cargo bench` | 运行基准测试 |

### 依赖管理（cargo-edit）

| 命令 | 说明 |
|------|------|
| `cargo add serde` | 添加依赖 |
| `cargo add serde --features derive` | 添加依赖并启用 feature |
| `cargo add tokio -F full` | `-F` 是 `--features` 缩写 |
| `cargo add --dev mockall` | 添加开发依赖 |
| `cargo add --build cc` | 添加构建依赖 |
| `cargo rm serde` | 移除依赖 |
| `cargo upgrade` | 升级所有依赖到最新兼容版本 |

### 其他

| 命令 | 说明 |
|------|------|
| `cargo doc --open` | 生成文档并在浏览器打开 |
| `cargo tree` | 显示依赖树 |
| `cargo tree -d` | 只显示重复依赖 |
| `cargo clean` | 清理 target/ 目录 |
| `cargo update` | 更新 Cargo.lock |
| `cargo publish` | 发布到 crates.io |

---

## 组件工具

### clippy - Linter

官方代码检查工具，比编译器警告更严格，能捕获常见错误和不良模式。

| 命令 | 说明 |
|------|------|
| `cargo clippy` | 检查代码 |
| `cargo clippy --fix` | 自动修复 |
| `cargo clippy -- -W clippy::pedantic` | 启用更严格的检查 |
| `cargo clippy -- -D warnings` | 将警告视为错误（CI 用） |

> 在代码中用 `#[allow(clippy::xxx)]` 忽略特定规则。

### rustfmt - 格式化

| 命令 | 说明 |
|------|------|
| `cargo fmt` | 格式化整个项目 |
| `cargo fmt --check` | 只检查不修改（CI 用） |
| `cargo fmt -- --config max_width=120` | 临时指定配置 |

> 项目根目录创建 `rustfmt.toml` 自定义规则，如 `max_width = 120`。

### rust-analyzer - LSP

编辑器智能提示后端，无需手动使用命令，编辑器自动调用。

支持功能：
- 代码补全、跳转定义、查找引用
- 内联类型提示
- 宏展开预览
- 自动 import

---

## Cargo 扩展

### cargo-watch - 文件监听

文件变化时自动执行命令。

| 命令 | 说明 |
|------|------|
| `cargo watch` | 文件变化自动 `cargo check` |
| `cargo watch -x run` | 文件变化自动运行 |
| `cargo watch -x test` | 文件变化自动测试 |
| `cargo watch -x 'test -- --nocapture'` | 自动测试并显示输出 |
| `cargo watch -x clippy` | 文件变化自动 lint |

### bacon - 后台编译 TUI

比 cargo-watch 更好的终端体验，实时显示编译错误/警告。

| 命令 | 说明 |
|------|------|
| `bacon` | 启动，默认 `cargo check` 模式 |
| `bacon test` | 测试模式 |
| `bacon clippy` | Clippy 模式 |
| `bacon run` | 运行模式 |

bacon 内快捷键：

| 快捷键 | 说明 |
|------|------|
| `t` | 切换到 test |
| `c` | 切换到 check |
| `r` | 切换到 run |
| `w` | 切换 wrapping |
| `q` | 退出 |

### sccache - 编译缓存

已通过 `~/.cargo/config.toml` 配置为默认 rustc wrapper，自动生效。

| 命令 | 说明 |
|------|------|
| `sccache --show-stats` | 查看缓存命中统计 |
| `sccache --zero-stats` | 重置统计 |
| `sccache --stop-server` | 停止缓存服务 |
