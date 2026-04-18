#!/usr/bin/env python3
"""
Git 健康检查脚本
- 扫描指定目录下的所有 Git 仓库
- 检查 remote URL 是否被污染（-S -p '' 后缀）
- 输出健康报告
"""

import subprocess
import os
import sys
from pathlib import Path

def check_git_health(base_dirs):
    """检查 Git 仓库健康状态"""
    
    polluted = []
    clean = []
    errors = []
    
    for base_dir in base_dirs:
        base_path = Path(base_dir).expanduser()
        if not base_path.exists():
            errors.append(f"目录不存在：{base_dir}")
            continue
        
        # 查找所有 .git 目录
        git_dirs = list(base_path.rglob(".git"))
        
        for git_dir in git_dirs:
            if not git_dir.is_dir():
                continue
            
            repo_path = git_dir.parent
            
            try:
                # 获取 remote URL
                result = subprocess.run(
                    ["git", "remote", "get-url", "origin"],
                    cwd=repo_path,
                    capture_output=True,
                    text=True,
                    timeout=5
                )
                
                if result.returncode != 0:
                    clean.append((str(repo_path), "no remote"))
                    continue
                
                url = result.stdout.strip()
                
                # 检查污染
                if "-S -p" in url or url.endswith("''"):
                    polluted.append((str(repo_path), url))
                else:
                    clean.append((str(repo_path), url))
                    
            except subprocess.TimeoutExpired:
                errors.append(f"超时：{repo_path}")
            except Exception as e:
                errors.append(f"{repo_path}: {str(e)}")
    
    return polluted, clean, errors

def main():
    # 默认检查目录
    default_dirs = [
        "~/Projects",
        "~/software project",
        "~/.openclaw/workspace",
    ]
    
    # 从命令行参数获取目录，或使用默认值
    dirs_to_check = sys.argv[1:] if len(sys.argv) > 1 else default_dirs
    
    print("🔍 Git 健康检查")
    print("=" * 60)
    print(f"检查目录：{', '.join(dirs_to_check)}")
    print()
    
    polluted, clean, errors = check_git_health(dirs_to_check)
    
    # 输出结果
    print(f"✅ 干净的仓库：{len(clean)}")
    print(f"⚠️  污染的仓库：{len(polluted)}")
    print(f"❌ 错误：{len(errors)}")
    print()
    
    if polluted:
        print("--- ⚠️  污染的仓库（需要修复）---")
        for repo, url in polluted:
            print(f"\n  {repo}")
            print(f"  URL: {url}")
            print(f"  修复：编辑 .git/config 删除 '-S -p ''' 部分")
    
    if errors:
        print("\n--- ❌ 错误 ---")
        for error in errors[:10]:  # 只显示前 10 个错误
            print(f"  {error}")
    
    if not polluted and not errors:
        print("🎉 所有仓库健康！")
    
    # 返回退出码
    sys.exit(1 if polluted else 0)

if __name__ == "__main__":
    main()
