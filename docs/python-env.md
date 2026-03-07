# Python 环境 - 工具说明与常用命令

> 对应脚本: `src/setup-python.sh`

## 目录

- [pyenv - Python 版本管理](#pyenv---python-版本管理)
- [uv - 包管理和虚拟环境](#uv---包管理和虚拟环境)
- [pipx - 全局 CLI 工具](#pipx---全局-cli-工具)
- [常用 Python CLI 工具](#常用-python-cli-工具)

---

## pyenv - Python 版本管理

安装和切换多个 Python 版本，不影响系统自带 Python。

### 版本安装与切换

| 命令 | 说明 |
|------|------|
| `pyenv install --list` | 列出所有可安装版本 |
| `pyenv install 3.13.2` | 安装指定版本 |
| `pyenv uninstall 3.13.2` | 卸载指定版本 |
| `pyenv versions` | 列出已安装版本（`*` 标记当前激活） |
| `pyenv version` | 显示当前激活版本 |

### 版本切换范围

| 命令 | 说明 |
|------|------|
| `pyenv global 3.13.2` | 设置全局默认版本 |
| `pyenv local 3.12.8` | 设置当前目录版本（写入 `.python-version` 文件） |
| `pyenv shell 3.11.0` | 设置当前 shell 会话版本（临时） |

### 虚拟环境 (pyenv-virtualenv)

| 命令 | 说明 |
|------|------|
| `pyenv virtualenv 3.13.2 myenv` | 创建虚拟环境 |
| `pyenv activate myenv` | 激活虚拟环境 |
| `pyenv deactivate` | 退出虚拟环境 |
| `pyenv virtualenvs` | 列出所有虚拟环境 |
| `pyenv virtualenv-delete myenv` | 删除虚拟环境 |
| `pyenv local myenv` | 进入目录自动激活（推荐） |

---

## uv - 包管理和虚拟环境

Rust 实现的超快 Python 包管理器，替代 pip + venv + pip-tools。

### 项目管理

| 命令 | 说明 |
|------|------|
| `uv init myproject` | 创建新项目（含 pyproject.toml） |
| `uv add requests` | 添加依赖 |
| `uv add --dev pytest` | 添加开发依赖 |
| `uv remove requests` | 移除依赖 |
| `uv sync` | 同步安装所有依赖 |
| `uv lock` | 生成/更新 lock 文件 |
| `uv run python main.py` | 在项目环境中运行命令 |
| `uv run pytest` | 在项目环境中运行测试 |

### 虚拟环境

| 命令 | 说明 |
|------|------|
| `uv venv` | 创建 `.venv` 虚拟环境 |
| `uv venv --python 3.12` | 指定 Python 版本创建 |
| `source .venv/bin/activate` | 激活虚拟环境 |
| `deactivate` | 退出虚拟环境 |

### pip 兼容模式

| 命令 | 说明 |
|------|------|
| `uv pip install requests` | 安装包（比 pip 快 10-100x） |
| `uv pip install -r requirements.txt` | 从 requirements.txt 安装 |
| `uv pip list` | 列出已安装包 |
| `uv pip freeze > requirements.txt` | 导出依赖 |
| `uv pip compile requirements.in -o requirements.txt` | 解析并锁定依赖 |

### Python 版本管理（uv 也能管）

| 命令 | 说明 |
|------|------|
| `uv python list` | 列出可用 Python 版本 |
| `uv python install 3.13` | 安装指定版本 |

---

## pipx - 全局 CLI 工具

在隔离环境中安装 Python CLI 工具，不污染全局环境。

| 命令 | 说明 |
|------|------|
| `pipx install black` | 安装工具 |
| `pipx upgrade black` | 升级工具 |
| `pipx upgrade-all` | 升级所有工具 |
| `pipx uninstall black` | 卸载工具 |
| `pipx list` | 列出已安装工具 |
| `pipx run cowsay hello` | 临时运行（不安装） |
| `pipx ensurepath` | 确保 pipx 路径在 PATH 中 |

---

## 常用 Python CLI 工具

脚本通过 pipx 自动安装以下工具：

### black - 代码格式化

固执己见的代码格式化器，无需配置。

| 命令 | 说明 |
|------|------|
| `black file.py` | 格式化单个文件 |
| `black src/` | 格式化整个目录 |
| `black --check src/` | 只检查不修改（CI 用） |
| `black --diff file.py` | 预览格式化变更 |
| `black -l 120 file.py` | 指定行宽（默认 88） |

### ruff - 超快 Linter & Formatter

Rust 实现，替代 flake8 + isort + 部分 pylint，速度快 10-100x。

| 命令 | 说明 |
|------|------|
| `ruff check .` | 检查代码问题 |
| `ruff check --fix .` | 自动修复可修复的问题 |
| `ruff format .` | 格式化代码（兼容 black 风格） |
| `ruff format --check .` | 只检查格式（CI 用） |
| `ruff rule E501` | 查看某条规则的详细说明 |

### ipython - 增强版交互式 Python

| 命令 / 快捷键 | 说明 |
|------|------|
| `ipython` | 启动交互式环境 |
| `%timeit expr` | 测量表达式执行时间 |
| `%run script.py` | 运行脚本 |
| `%paste` | 粘贴并执行代码块 |
| `?obj` | 查看对象文档 |
| `??obj` | 查看对象源码 |
| `!shell_cmd` | 执行 shell 命令 |
| `_` | 上一个输出结果 |

