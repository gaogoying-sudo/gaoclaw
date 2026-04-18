#!/usr/bin/env python3
"""
终端命令审计日志查询工具

用法:
    python3 ~/.hermes/scripts/terminal-audit-query.py              # 最近 100 条
    python3 ~/.hermes/scripts/terminal-audit-query.py --limit 50   # 最近 50 条
    python3 ~/.hermes/scripts/terminal-audit-query.py --session ID # 按会话过滤
    python3 ~/.hermes/scripts/terminal-audit-query.py --cmd git    # 按命令过滤
    python3 ~/.hermes/scripts/terminal-audit-query.py --stats      # 统计信息
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

AUDIT_LOG_PATH = Path.home() / ".hermes" / "logs" / "terminal-audit.jsonl"


def read_audit_log(limit=100, session_id=None, command_pattern=None):
    """读取审计日志"""
    if not AUDIT_LOG_PATH.exists():
        print("❌ 审计日志不存在")
        print(f"   路径：{AUDIT_LOG_PATH}")
        print("\n💡 审计功能需要手动启用。参考：/skill terminal-audit")
        return []
    
    results = []
    
    with open(AUDIT_LOG_PATH, "r", encoding="utf-8") as f:
        for line in f:
            if len(results) >= limit:
                break
            
            try:
                entry = json.loads(line.strip())
                
                # 过滤
                if session_id and entry.get("session_id") != session_id:
                    continue
                if command_pattern and command_pattern not in entry.get("command", ""):
                    continue
                
                results.append(entry)
                
            except json.JSONDecodeError:
                continue
    
    # 按时间倒序
    results.sort(key=lambda x: x.get("timestamp_unix", 0), reverse=True)
    
    return results


def get_audit_stats():
    """获取统计信息"""
    if not AUDIT_LOG_PATH.exists():
        return {"total_commands": 0, "log_size_bytes": 0}
    
    log_size = AUDIT_LOG_PATH.stat().st_size
    line_count = sum(1 for _ in open(AUDIT_LOG_PATH, "r", encoding="utf-8"))
    
    return {
        "total_commands": line_count,
        "log_size_bytes": log_size,
        "log_size_mb": round(log_size / (1024 * 1024), 2),
    }


def format_entry(entry):
    """格式化单条审计记录"""
    timestamp = entry.get("timestamp", "unknown")
    command = entry.get("command", "")
    exit_code = entry.get("exit_code", -1)
    duration = entry.get("duration_seconds", 0)
    session_id = entry.get("session_id", "")[:20]
    
    status = "✅" if exit_code == 0 else "❌"
    
    return f"{status} [{timestamp}] {command[:80]} (exit={exit_code}, {duration:.2f}s, session={session_id})"


def main():
    parser = argparse.ArgumentParser(description="终端命令审计日志查询")
    parser.add_argument("--limit", "-n", type=int, default=100, help="最多返回多少条")
    parser.add_argument("--session", "-s", type=str, help="按会话 ID 过滤")
    parser.add_argument("--cmd", "-c", type=str, help="按命令模式过滤")
    parser.add_argument("--stats", action="store_true", help="显示统计信息")
    parser.add_argument("--json", action="store_true", help="JSON 格式输出")
    
    args = parser.parse_args()
    
    if args.stats:
        stats = get_audit_stats()
        if args.json:
            print(json.dumps(stats, indent=2))
        else:
            print("📊 审计日志统计")
            print(f"   总命令数：{stats.get('total_commands', 0)}")
            print(f"   日志大小：{stats.get('log_size_mb', 0):.2f} MB")
            print(f"   日志路径：{AUDIT_LOG_PATH}")
        return
    
    results = read_audit_log(
        limit=args.limit,
        session_id=args.session,
        command_pattern=args.cmd,
    )
    
    if args.json:
        print(json.dumps(results, indent=2, ensure_ascii=False))
    else:
        if not results:
            print("📭 没有找到匹配的审计记录")
            return
        
        print(f"📋 审计日志（显示 {len(results)} 条）\n")
        
        for entry in results:
            print(format_entry(entry))
        
        print(f"\n💡 使用 --json 查看完整输出，包括命令输出预览")


if __name__ == "__main__":
    main()
