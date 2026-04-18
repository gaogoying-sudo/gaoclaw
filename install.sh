#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════════
# gaoclaw - 个人 Hermes 增强配置包
# 一键安装脚本
# ═══════════════════════════════════════════════════════════

echo "🚀 gaoclaw 安装脚本"
echo "=================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查是否已安装 Hermes
if command -v hermes &> /dev/null; then
    print_success "Hermes 已安装，跳过安装步骤"
    HERMES_VERSION=$(hermes --version 2>&1 | head -1)
    print_info "版本：$HERMES_VERSION"
else
    print_info "安装 Hermes Agent..."
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
    print_success "Hermes 安装完成"
fi

# 备份现有配置
HERMES_HOME="$HOME/.hermes"
if [ -d "$HERMES_HOME" ]; then
    print_info "备份现有配置..."
    BACKUP_NAME="$HERMES_HOME.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HERMES_HOME" "$BACKUP_NAME"
    print_success "备份到：$BACKUP_NAME"
fi

# 创建目录结构
print_info "创建目录结构..."
mkdir -p "$HERMES_HOME"
mkdir -p "$HERMES_HOME/scripts"
mkdir -p "$HERMES_HOME/profiles/admin/docs"
mkdir -p "$HERMES_HOME/profiles/dev"
mkdir -p "$HERMES_HOME/profiles/architect"
mkdir -p "$HERMES_HOME/skills/productivity"
mkdir -p "$HERMES_HOME/skills/devops"
mkdir -p "$HERMES_HOME/logs"

# 写入 config.yaml
print_info "写入配置文件..."
cat > "$HERMES_HOME/config.yaml" << 'CONFIGEOF'
model:
  default: qwen3.5-plus
  provider: alibaba
  base_url: https://coding.dashscope.aliyuncs.com/v1
providers: {}
fallback_providers:
  - alibaba
  - openrouter
credential_pool_strategies:
  alibaba:
    strategy: round_robin
    keys:
      - DASHSCOPE_API_KEY
  openrouter:
    strategy: round_robin
    keys:
      - OPENROUTER_API_KEY
toolsets:
- all
agent:
  max_turns: 60
  gateway_timeout: 1800
  tool_use_enforcement: auto
terminal:
  backend: local
  cwd: .
  timeout: 180
compression:
  enabled: true
  threshold: 0.85
  target_ratio: 0.2
CONFIGEOF
print_success "config.yaml 已写入"

# 写入 memory.md
print_info "写入 Memory..."
cat > "$HERMES_HOME/memory.md" << 'MEMORYEOF'
_Last updated: 2026-04-18_
---
📌 活跃项目索引

**项目注册表位置：** ~/.hermes/profiles/admin/docs/RESOURCE.md

| 项目 | 角色 | 路径 | 状态 |
|------|------|------|------|
| MyProject | 开发者 | /Projects/clm-tools-kw/ | Phase3 完成 |
| OpenViking | 架构师 | /Projects/OpenViking/ | 评估中 |

**角色区分：**
- 管理员 = 整机所有项目总控台
- 开发者/小强 = CLM 项目专属
- 小妹 = 语气可爱（待定）
- 架构师 = 软件架构师

🔑 用户核心诉求
1. AI 行为一致性机制（信息持久化）
2. 会话恢复时主动读取 memory 和文档
3. API 错误（401 等）立即告知，不继续尝试
4. 多搞几轮连续推进，不要被动等待

📝 "沉淀一下"触发机制
触发词：文末输入"沉淀一下"
动作：创建 Obsidian 会话记录到 00-Inbox/

⚠️ Git 注意
URL 曾被注入 `-S -p ''` 后缀 → 直接编辑 .git/config 修复

🔧 LLM CLI
llm + OpenRouter，Anthropic 禁用
MEMORYEOF
print_success "memory.md 已写入"

# 写入 Profile SOUL.md
print_info "配置角色人格..."

cat > "$HERMES_HOME/profiles/admin/SOUL.md" << 'SOULEOF'
# 管理员 - 本地项目管理中心

## 角色身份
你是**管理员**，用户的本地所有项目总控台。负责管理、运维、协调用户的全部本地项目。

## 职责范围
- 所有项目的任务看板管理
- 跨项目资源协调
- 系统健康检查
- 文档治理维护
- 多团队协作对接

## 语气风格
- 专业、简洁、高效
- 全局视角，条理清晰
- 主动汇报进度，不等待指令

## 工作原则
1. 先读 TASK_BOARD.md 确认状态
2. 会话结束必须更新 docs/progress.md
3. Git commit 后触发 graphify 重建
4. 敏感信息立即告知，不继续尝试

## 快捷命令
- 用户说"沉淀一下" → 创建 Obsidian 会话记录
- 用户说"看一下健康度" → 输出系统状态报告
- 用户说"更新系统文档" → 扫描并更新文档
- 用户说"今天先到这" → 执行会话收尾流程

## 会话收尾流程
1. 更新 docs/progress.md
2. 更新 docs/TASK_BOARD.md
3. Memory 检查点
4. Git commit + push
5. Graphify 重建
6. Obsidian 笔记（如用户说"沉淀一下"）
SOULEOF

cat > "$HERMES_HOME/profiles/dev/SOUL.md" << 'SOULEOF'
# 开发者/小强 - CLM 项目专属

## 角色身份
你是**开发者**（也叫小强），MyProject 项目专属 AI。负责项目开发管理系统的开发和维护。

## 项目信息
- **路径：** /Projects/my-project/
- **云 IP:** YOUR_CLOUD_IP
- **阶段：** 开发中 → 云部署（请自行配置）

## 职责范围
- CLM 项目前后端开发
- 数据同步链路维护
- 消息平台集成对接
- 云环境部署运维
- 项目文档更新

## 语气风格
- 技术细节导向
- 务实、直接
- 主动推进，不等待

## 工作原则
1. 开始工作前读取 docs/TASK_BOARD.md
2. 修改代码前查询 MemPalace (wing: my_db_tool)
3. 会话结束更新 docs/progress.md 和 TASK_BOARD.md
4. API 错误（401 等）立即告知，不继续尝试

## 快捷命令
- 用户说"沉淀一下" → 创建 CLM 项目会话记录
- 用户说"继续开发" → 读取进度后继续
- 用户说"部署" → 准备云部署（请自行配置）流程
- 用户说"今天先到这" → 执行会话收尾流程

## 会话收尾流程
1. 更新 docs/progress.md（CLM 项目）
2. 更新 docs/TASK_BOARD.md
3. Memory 检查点（CLM 阶段）
4. Git commit + push
5. Graphify 重建
6. Obsidian 笔记（如用户说"沉淀一下"）
SOULEOF

cat > "$HERMES_HOME/profiles/architect/SOUL.md" << 'SOULEOF'
# 架构师 - 软件架构师

## 角色身份
你是**架构师**，软件架构师角色。负责源码分析、代码结构解析、核心软件技能抽象、技术基建沉淀。

## 职责范围
- 代码结构分析和可视化
- 架构决策支持
- 技术选型评估
- 核心技能抽象和沉淀
- 外部项目评估（如 OpenViking、Khoj 等）

## 语气风格
- 技术深度导向
- 逻辑严密
- 喜欢画图（Excalidraw/ASCII）
- 会指出设计缺陷和风险

## 工作原则
1. 分析代码前先读 graphify GRAPH_REPORT.md
2. 架构建议必须有 ADR 文档支撑
3. 技术决策要有对比分析
4. 发现风险立即告知，不隐瞒

## 快捷命令
- 用户说"分析一下" → 代码/架构深度分析
- 用户说"值得集成吗" → 外部项目评估
- 用户说"画个图" → Excalidraw 架构图
- 用户说"今天先到这" → 执行会话收尾流程

## 会话收尾流程
1. 更新 docs/progress.md
2. 更新分析文档
3. Memory 检查点
4. Git commit + push
5. Graphify 重建
6. Obsidian 笔记（如用户说"沉淀一下"）
SOULEOF

print_success "角色人格配置完成"

# 写入脚本
print_info "写入脚本..."

cat > "$HERMES_HOME/scripts/git-health-check.py" << 'SCRIPTEOF'
#!/usr/bin/env python3
"""Git 健康检查脚本"""
import subprocess
import os
import sys
from pathlib import Path

def check_git_health(base_dirs):
    polluted = []
    clean = []
    errors = []
    for base_dir in base_dirs:
        base_path = Path(base_dir).expanduser()
        if not base_path.exists():
            errors.append(f"目录不存在：{base_dir}")
            continue
        git_dirs = list(base_path.rglob(".git"))
        for git_dir in git_dirs:
            if not git_dir.is_dir():
                continue
            repo_path = git_dir.parent
            skip_dirs = ['node_modules', 'venv', '.venv', '__pycache__', 'vendor', '.git']
            if any(skip in str(repo_path) for skip in skip_dirs):
                continue
            try:
                result = subprocess.run(
                    ["git", "remote", "get-url", "origin"],
                    cwd=repo_path,
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                url = result.stdout.strip() if result.returncode == 0 else "local only"
                if "-S -p" in url or url.endswith("''"):
                    polluted.append((str(repo_path), url))
                else:
                    clean.append((str(repo_path), url))
            except Exception as e:
                errors.append(f"{repo_path}: {str(e)}")
    return polluted, clean, errors

if __name__ == "__main__":
    dirs = sys.argv[1:] if len(sys.argv) > 1 else ["~/Projects", "~/software project"]
    polluted, clean, errors = check_git_health(dirs)
    print(f"✅ 干净的仓库：{len(clean)}")
    print(f"⚠️  污染的仓库：{len(polluted)}")
    print(f"❌ 错误：{len(errors)}")
    if polluted:
        print("\n--- ⚠️  污染的仓库（需要修复）---")
        for repo, url in polluted:
            print(f"\n  {repo}")
            print(f"  URL: {url}")
            print(f"  修复：编辑 .git/config 删除 '-S -p ''' 部分")
    if errors:
        print("\n--- ❌ 错误 ---")
        for error in errors[:10]:
            print(f"  {error}")
    if not polluted and not errors:
        print("🎉 所有仓库健康！")
    sys.exit(1 if polluted else 0)
SCRIPTEOF

chmod +x "$HERMES_HOME/scripts/git-health-check.py"
print_success "git-health-check.py 已写入"

# 创建 RESOURCE.md
print_info "创建资源登记册..."
cat > "$HERMES_HOME/profiles/admin/docs/RESOURCE.md" << 'RESOURCEEOF'
# 项目资源登记册

**最后更新：** 2026-04-18  
**维护者：** 管理员  
**用途：** 所有项目的资源索引（服务器、数据库、API、端口等）

---

## 一、MyProject（开发者负责）

### 项目信息
| 字段 | 值 |
|------|-----|
| 路径 | /Projects/my-project/ |
| 角色 | 开发者/小强 |
| 阶段 | 开发中 → 云部署（请自行配置） |

### 云环境
| 资源 | 配置 |
|------|------|
| 云主机 IP | YOUR_CLOUD_IP |
| SSH 用户 | root |
| SSH 密钥 | ~/.ssh/clm_tencent_ed25519 |

### 消息平台配置
| 字段 | 值 |
|------|-----|
| APP_ID | YOUR_APP_ID |
| 测试群 chat_id | YOUR_CHAT_ID |
| 安全配置 | APP_DRY_RUN=true, APP_TEST_MODE=true |

---

## 二、其他项目

| 项目 | 路径 | 角色 | 状态 |
|------|------|------|------|
| OpenViking | /Projects/OpenViking/ | 架构师 | 评估中 |

---

## 三、全局配置

### LLM 配置
| 字段 | 值 |
|------|-----|
| 当前模型 | qwen3.5-plus（阿里巴巴） |
| Provider | OpenRouter |
| Anthropic | 禁用 |

### Git 注意事项
⚠️ **历史问题：** Git remote URL 曾被注入 `-S -p ''` 后缀  
**修复方式：** 直接编辑 .git/config 文件中的 URL 字段

RESOURCEEOF
print_success "RESOURCE.md 已创建"

# 创建空 .env
print_info "创建 .env 模板..."
cat > "$HERMES_HOME/.env" << 'ENVEOF'
# gaoclaw - 个人 Hermes 增强配置包
# 请填写您的 API Keys
# 或运行 hermes setup 交互式配置

# 阿里云 DashScope（千问）
DASHSCOPE_API_KEY=

# OpenRouter
OPENROUTER_API_KEY=

# 其他 API Keys 根据需要添加
ENVEOF
print_success ".env 模板已创建"

# 安装 Gateway 服务
print_info "安装 Gateway 系统服务..."
hermes gateway install 2>/dev/null || print_warning "Gateway 安装失败（可手动安装）"
print_success "Gateway 服务已安装"

# 创建 cronjob
print_info "创建定时任务..."
hermes cron create "0 9 * * *" "运行 git-health-check.py" --name "每日健康检查" --deliver "local" --script "git-health-check.py" 2>/dev/null || print_warning "cronjob 创建失败（可手动创建）"
hermes cron create "0 10 1 * *" "更新项目注册表" --name "月度项目注册表更新" --deliver "local" 2>/dev/null || print_warning "cronjob 创建失败（可手动创建）"
print_success "定时任务已创建"

# 完成
echo ""
print_success "🎉 gaoclaw 安装完成！"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "下一步："
echo ""
echo "  ${YELLOW}1. 配置 API Keys${NC}"
echo "     编辑 ~/.hermes/.env 或运行 hermes setup"
echo ""
echo "  ${YELLOW}2. 验证 Profile${NC}"
echo "     hermes profile list"
echo "     应看到：default, admin, dev, architect"
echo ""
echo "  ${YELLOW}3. 开始使用${NC}"
echo "     admin chat \"你好\""
echo "     dev chat \"继续开发\""
echo "     architect chat \"分析一下\""
echo ""
echo "  ${YELLOW}4. 查看文档${NC}"
echo "     https://github.com/gaogoying-sudo/gaoclaw"
echo ""
echo "═══════════════════════════════════════════════════════════"
echo ""
print_info "提示：运行以下命令查看健康度"
echo "  admin chat \"看一下健康度\""
echo ""
