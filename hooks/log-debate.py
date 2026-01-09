#!/usr/bin/env python3
"""
PM 에이전트 토론 내용을 로깅합니다.
SubagentStop hook으로 실행됩니다.
"""

import json
import sys
import os
from datetime import datetime
from pathlib import Path


def get_log_dir():
    """로그 디렉토리 경로를 반환합니다."""
    project_dir = os.environ.get("CLAUDE_PROJECT_DIR", ".")
    log_dir = Path(project_dir) / ".claude" / "planning"
    log_dir.mkdir(parents=True, exist_ok=True)
    return log_dir


def log_debate_round(session_id: str, agent_name: str, content: str):
    """토론 라운드를 로그 파일에 기록합니다."""
    log_dir = get_log_dir()
    log_file = log_dir / f"debate-{session_id[:8]}.md"
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # 에이전트별 이모지
    emoji = "🚀" if "optimist" in agent_name.lower() else "⚠️"
    
    with open(log_file, "a", encoding="utf-8") as f:
        f.write(f"\n---\n\n## {emoji} {agent_name} - {timestamp}\n\n")
        f.write(content)
        f.write("\n")


def main():
    try:
        # stdin에서 hook input 읽기
        input_data = json.load(sys.stdin)
        session_id = input_data.get("session_id", "unknown")
        
        # SubagentStop에서는 transcript_path에서 마지막 응답을 읽을 수 있음
        transcript_path = input_data.get("transcript_path", "")
        
        # 간단한 로그 기록
        log_dir = get_log_dir()
        log_file = log_dir / f"debate-{session_id[:8]}.md"
        
        # 파일이 없으면 헤더 추가
        if not log_file.exists():
            with open(log_file, "w", encoding="utf-8") as f:
                f.write(f"# 📋 플래닝 토론 기록\n\n")
                f.write(f"- **세션**: {session_id}\n")
                f.write(f"- **시작**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
                f.write("---\n")
        
        # 토론 라운드 기록 (SubagentStop 발생 기록)
        with open(log_file, "a", encoding="utf-8") as f:
            f.write(f"\n*[{datetime.now().strftime('%H:%M:%S')}] Subagent 완료*\n")
        
        sys.exit(0)
        
    except Exception as e:
        # 로깅 실패해도 계속 진행
        print(f"로깅 오류 (무시됨): {e}", file=sys.stderr)
        sys.exit(0)


if __name__ == "__main__":
    main()
