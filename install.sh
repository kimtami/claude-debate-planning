#!/bin/bash
# Claude Debate Planning 설치 스크립트 (macOS / Linux)

set -e

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Claude Debate Planning 설치 ==="
echo ""

# 디렉토리 생성
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/hooks"
mkdir -p "$CLAUDE_DIR/planning"

# 에이전트 복사
echo "[1/4] 에이전트 복사 중..."
cp "$SCRIPT_DIR/agents/"*.md "$CLAUDE_DIR/agents/"

# 명령어 복사
echo "[2/4] 명령어 복사 중..."
cp "$SCRIPT_DIR/commands/"*.md "$CLAUDE_DIR/commands/"

# 훅 복사
echo "[3/4] 훅 복사 중..."
cp "$SCRIPT_DIR/hooks/"*.py "$CLAUDE_DIR/hooks/" 2>/dev/null || true

# hooks.json 병합 또는 복사
echo "[4/4] hooks.json 설정 중..."
if [ -f "$CLAUDE_DIR/hooks.json" ]; then
    echo "  기존 hooks.json이 있습니다. 백업 후 복사합니다."
    cp "$CLAUDE_DIR/hooks.json" "$CLAUDE_DIR/hooks.json.backup.$(date +%Y%m%d%H%M%S)"
fi
cp "$SCRIPT_DIR/hooks.json" "$CLAUDE_DIR/hooks.json"

echo ""
echo "=== 설치 완료! ==="
echo ""
echo "사용법: Claude Code에서 /debate-planning [요청] 실행"
echo ""
