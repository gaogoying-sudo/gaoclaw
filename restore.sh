#!/bin/bash
set -e

# ═══════════════════════════════════════════════════════════
# gaoclaw - 配置恢复脚本
# 用于从 Git 仓库恢复配置到 Hermes
# ═══════════════════════════════════════════════════════════

echo "🔄 gaoclaw 配置恢复"
echo "=================="
echo ""

HERMES_HOME="$HOME/.hermes"
CONFIG_DIR="$HOME/.hermes-config"

# 检查配置目录
if [ ! -d "$CONFIG_DIR" ]; then
    echo "❌ 配置目录不存在：$CONFIG_DIR"
    echo ""
    echo "请先克隆配置仓库："
    echo "  git clone git@github.com:gaogoying-sudo/gaoclaw.git ~/.hermes-config"
    exit 1
fi

# 备份现有配置
if [ -d "$HERMES_HOME" ]; then
    echo "📦 备份现有配置..."
    BACKUP_NAME="$HERMES_HOME.backup.$(date +%Y%m%d_%H%M%S)"
    mv "$HERMES_HOME" "$BACKUP_NAME"
    echo "✅ 备份到：$BACKUP_NAME"
fi

# 创建新目录
echo "📁 创建目录结构..."
mkdir -p "$HERMES_HOME"
mkdir -p "$HERMES_HOME/scripts"
mkdir -p "$HERMES_HOME/profiles/daguanjia/docs"
mkdir -p "$HERMES_HOME/profiles/xiaochu"
mkdir -p "$HERMES_HOME/profiles/goudan"
mkdir -p "$HERMES_HOME/skills/productivity"
mkdir -p "$HERMES_HOME/skills/devops"
mkdir -p "$HERMES_HOME/logs"

# 复制配置
echo "📋 复制配置文件..."
cp "$CONFIG_DIR/hermes-config/config.yaml" "$HERMES_HOME/" 2>/dev/null || true
cp "$CONFIG_DIR/hermes-config/memory.md" "$HERMES_HOME/" 2>/dev/null || true
cp -r "$CONFIG_DIR/hermes-config/scripts/" "$HERMES_HOME/" 2>/dev/null || true
cp -r "$CONFIG_DIR/hermes-config/profiles/" "$HERMES_HOME/" 2>/dev/null || true
cp -r "$CONFIG_DIR/skills/" "$HERMES_HOME/" 2>/dev/null || true

# 创建空 .env
echo "📝 创建 .env 模板..."
cat > "$HERMES_HOME/.env" << 'ENVEOF'
# gaoclaw - 个人 Hermes 增强配置包
# 请填写您的 API Keys
# 或运行 hermes setup 交互式配置

DASHSCOPE_API_KEY=
OPENROUTER_API_KEY=
ENVEOF

# 设置权限
chmod 600 "$HERMES_HOME/.env"
chmod +x "$HERMES_HOME/scripts/"*.py 2>/dev/null || true

echo ""
echo "✅ 配置恢复完成！"
echo ""
echo "下一步："
echo "  1. 运行 hermes setup 配置 API Keys"
echo "  2. 运行 hermes profile list 验证 Profile"
echo "  3. 运行 daguanjia chat 开始使用"
echo ""
