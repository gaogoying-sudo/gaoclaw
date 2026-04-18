_Last updated: 2026-04-18_
---
📌 活跃项目索引

**项目注册表位置：** ~/.hermes/profiles/admin/docs/RESOURCE.md

| 项目 | 角色 | 路径 | 状态 |
|------|------|------|------|
| MyProject | 开发者 | /Projects/my-project/ | 开发中 |
| OpenViking | 架构师 | /Projects/OpenViking/ | 评估中 |

**角色区分：**
- 管理员 = 整机所有项目总控台
- 开发者 = 项目开发专属
- 架构师 = 技术分析

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
