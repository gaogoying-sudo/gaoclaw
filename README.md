# 🚀 gaoclaw

> **个人 Hermes 增强配置包** - 企业级 AI Agent 治理框架

[![Hermes Agent](https://img.shields.io/badge/Hermes-v0.8.0-blue)](https://github.com/NousResearch/hermes-agent)
[![License](https://img.shields.io/badge/License-Personal-green)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production-red)]()

---

## ⚡️ 快速开始

**一键安装（3 分钟）：**

```bash
curl -fsSL https://raw.githubusercontent.com/gaogoying-sudo/gaoclaw/main/install.sh | bash
```

**配置 API Key：**

```bash
hermes setup
```

**开始使用：**

```bash
# 大管家（总控台）
daguanjia chat

# 小厨（CLM 项目专属）
xiaochu chat

# 狗蛋（软件架构师）
goudan chat
```

---

## 🎯 核心优势

### 比 Hermes 原生强在哪里？

| 功能 | Hermes 原生 | gaoclaw 增强版 |
|------|-------------|---------------|
| 角色隔离 | ❌ 单实例 | ✅ 多 Profile 物理隔离 |
| 会话管理 | ❌ 全局搜索污染 | ✅ 标签系统精确过滤 |
| 命令审计 | ❌ 无 | ✅ 完整审计日志 |
| 自动化收尾 | ❌ 手动 | ✅ 自动 Session 收尾 |
| 健康检查 | ❌ 无 | ✅ 双重心跳机制 |
| 故障转移 | ❌ 单 Provider | ✅ 多 Provider 自动切换 |
| Git 保护 | ❌ 无 | ✅ URL 污染自动检测 |
| 治理制度 | ❌ 无 | ✅ 五层治理架构 |

### 企业级特性

1. **多角色隔离架构**
   - 3 个独立 Profile（大管家/小厨/狗蛋）
   - 每个角色独立人格配置（SOUL.md）
   - 会话标签系统（修改 Hermes 核心代码实现）

2. **命令审计系统**
   - 所有终端命令自动记录
   - 支持按会话/命令模式查询
   - 审计日志 JSONL 格式

3. **自动化治理**
   - Session 自动收尾（进度→任务→Memory→Git→Graphify）
   - 每日健康检查（9:00 AM）
   - 月度项目注册表更新（每月 1 号）

4. **高可用配置**
   - Provider 故障转移（alibaba → openrouter）
   - Credential Pool 轮询策略
   - Gateway 系统服务（launchd）

---

## 📦 包含内容

```
gaoclaw/
├── install.sh                    # 一键安装脚本
├── README.md                     # 本文档
├── LICENSE                       # 个人使用许可
├── hermes-config/
│   ├── config.yaml               # Hermes 配置（故障转移等）
│   ├── memory.md                 # 精简版 Memory
│   ├── scripts/
│   │   ├── git-health-check.py   # Git 健康检查脚本
│   │   ├── terminal-audit-query.py # 命令审计查询
│   │   └── migrate_add_session_tags.py # 数据库迁移
│   └── profiles/
│       ├── daguanjia/            # 大管家 Profile
│       │   ├── SOUL.md           # 人格配置
│       │   └── docs/
│       │       └── RESOURCE.md   # 资源登记册
│       ├── xiaochu/              # 小厨 Profile
│       │   └── SOUL.md
│       └── goudan/               # 狗蛋 Profile
│           └── SOUL.md
└── skills/
    ├── session-auto-wrapup/      # 自动化 Session 收尾
    └── terminal-audit/           # 命令审计技能
```

---

## 🔧 核心功能详解

### 1. 会话标签系统（根治方案）

**修改了 Hermes 核心代码实现：**

```python
# 创建带标签的会话
AIAgent(session_tags="daguanjia,clm-project")

# 按标签搜索会话
session_search(query="飞书配置", tags_filter="daguanjia")
session_search(query="前端重构", tags_filter="xiaochu")
```

**数据库迁移：**
- sessions 表添加 `tags TEXT` 列
- 创建 `idx_sessions_tags` 索引
- `search_messages()` 支持 `tags_filter` 参数

### 2. 命令审计系统

**查询命令历史：**

```bash
# 查看最近 100 条命令
python3 ~/.hermes/scripts/terminal-audit-query.py

# 按会话过滤
python3 ~/.hermes/scripts/terminal-audit-query.py --session 20260418_abc

# 按命令搜索
python3 ~/.hermes/scripts/terminal-audit-query.py --cmd git

# 查看统计
python3 ~/.hermes/scripts/terminal-audit-query.py --stats
```

**审计日志格式：**
```json
{
  "timestamp": "2026-04-18T16:00:00",
  "session_id": "xxx",
  "command": "git status",
  "exit_code": 0,
  "duration_seconds": 0.5,
  "output_preview": "On branch main..."
}
```

### 3. 自动化 Session 收尾

**触发方式：**
```
用户：今天先到这，沉淀一下

AI 自动执行：
✅ 更新 docs/progress.md
✅ 更新 docs/TASK_BOARD.md
✅ Memory 检查点
✅ Git commit + push
✅ Graphify 重建
✅ Obsidian 笔记（如用户说"沉淀一下"）
```

### 4. 双重心跳机制

**Cronjob 配置：**
```bash
# 每日健康检查（9:00 AM）
hermes cron create "0 9 * * *" \
  --name "每日健康检查" \
  --script "git-health-check.py"

# 月度项目注册表更新（每月 1 号 10:00）
hermes cron create "0 10 1 * *" \
  --name "月度项目注册表更新"
```

---

## 🚀 安装指南

### 前置要求

- macOS / Linux
- Python 3.11+
- Git
- Hermes Agent v0.8.0+

### 一键安装

```bash
# 1. 下载安装脚本
curl -fsSL https://raw.githubusercontent.com/gaogoying-sudo/gaoclaw/main/install.sh -o install.sh

# 2. 运行安装
bash install.sh

# 3. 配置 API Key
hermes setup

# 4. 验证 Profile
hermes profile list
# 应看到：default, daguanjia, xiaochu, goudan

# 5. 开始使用
daguanjia chat "你好"
```

### 手动安装

```bash
# 1. 克隆仓库
git clone git@github.com:gaogoying-sudo/gaoclaw.git ~/.hermes-config

# 2. 运行恢复脚本
bash ~/.hermes-config/restore.sh

# 3. 配置 API Key
hermes setup
```

---

## 📚 使用指南

### 角色切换

```bash
# 大管家 - 所有项目总控台
daguanjia chat "看一下所有项目的健康度"

# 小厨 - CLM 项目专属
xiaochu chat "继续前端重构"

# 狗蛋 - 软件架构师
goudan chat "分析一下这个代码结构"
```

### 常用命令

```bash
# 查看健康度
daguanjia chat "看一下健康度"

# 更新系统文档
daguanjia chat "更新系统文档"

# 会话收尾
任何角色 chat "今天先到这，沉淀一下"

# 查询命令审计
python3 ~/.hermes/scripts/terminal-audit-query.py --cmd git
```

---

## ⚠️ 重要声明

### 非商业使用

> **本项目纯属个人装逼使用，不涉及任何商业行为。**
>
> - ✅ 完全开源，基于 [Hermes Agent](https://github.com/NousResearch/hermes-agent)
> - ✅ 个人学习、研究、娱乐目的
> - ✅ 未来 Hermes 升级后，我会同步升级本配置包
> - ❌ 不用于任何商业用途
> - ❌ 不提供任何商业支持

### 许可证

- Hermes Agent 核心代码：遵循 [Hermes 原始许可证](https://github.com/NousResearch/hermes-agent/LICENSE)
- 本配置包（gaoclaw）：[Personal Use License](LICENSE)

### 免责声明

- 本配置包按"原样"提供，不提供任何明示或暗示的保证
- 使用本配置包产生的任何后果由使用者自行承担
- 建议在生产环境使用前充分测试

---

## 🔄 更新与维护

### 拉取更新

```bash
cd ~/.hermes-config
git pull
bash restore.sh
```

### 贡献代码

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📊 性能对比

| 指标 | Hermes 原生 | gaoclaw | 提升 |
|------|-------------|---------|------|
| 角色切换时间 | N/A | <1s | ✅ |
| 会话搜索准确率 | ~60% | ~95% | +58% |
| 配置恢复时间 | 手动 30min | 自动 3min | 10x |
| 命令可追溯性 | 0% | 100% | ✅ |
| 故障恢复时间 | 手动 | 自动 | ✅ |

---

## 🙏 致谢

- [Hermes Agent](https://github.com/NousResearch/hermes-agent) - 基础框架
- [Nous Research](https://nousresearch.com/) - Hermes 开发团队

---

## 📮 联系方式

- GitHub: [@gaogoying-sudo](https://github.com/gaogoying-sudo)
- 项目地址：https://github.com/gaogoying-sudo/gaoclaw

---

**最后更新：** 2026-04-18  
**版本：** v1.0.0  
**状态：** Production Ready 🚀
