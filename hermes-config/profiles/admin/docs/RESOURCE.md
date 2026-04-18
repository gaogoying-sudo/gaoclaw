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
| 角色 | 开发者 |
| 阶段 | 开发中 |

### 云环境（请自行配置）
| 资源 | 配置 |
|------|------|
| 云主机 IP | YOUR_CLOUD_IP |
| SSH 用户 | root |
| SSH 密钥 | ~/.ssh/id_ed25519 |

### 消息平台配置（请自行配置）
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

---

**文档维护：**
- 新增项目时在此登记
- 资源变更时更新此文档
- 每季度审查一次
