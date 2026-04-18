#!/usr/bin/env python3
"""
数据库迁移脚本：添加 session tags 支持

运行此脚本为现有 state.db 添加 tags 列
"""

import sqlite3
import sys
from pathlib import Path

# 直接计算路径，不依赖 hermes_constants
def get_hermes_home():
    return Path.home() / ".hermes"

def migrate_add_session_tags():
    """添加 tags 列到 sessions 表"""
    
    db_path = get_hermes_home() / "state.db"
    
    if not db_path.exists():
        print(f"❌ 数据库不存在：{db_path}")
        return False
    
    print(f"📍 数据库路径：{db_path}")
    
    conn = sqlite3.connect(db_path)
    conn.execute("PRAGMA journal_mode=WAL")
    cursor = conn.cursor()
    
    # 检查 tags 列是否已存在
    cursor.execute("PRAGMA table_info(sessions)")
    columns = [row[1] for row in cursor.fetchall()]
    
    if "tags" in columns:
        print("✅ tags 列已存在，无需迁移")
        conn.close()
        return True
    
    print("🔧 添加 tags 列到 sessions 表...")
    
    try:
        cursor.execute("ALTER TABLE sessions ADD COLUMN tags TEXT")
        conn.commit()
        print("✅ tags 列添加成功！")
        
        # 创建索引以加速 tags 查询
        print("🔧 创建 tags 列索引...")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_sessions_tags ON sessions(tags)")
        conn.commit()
        print("✅ 索引创建成功！")
        
        conn.close()
        return True
        
    except sqlite3.Error as e:
        print(f"❌ 迁移失败：{e}")
        conn.close()
        return False

if __name__ == "__main__":
    success = migrate_add_session_tags()
    exit(0 if success else 1)
