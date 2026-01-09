# Claude Debate Planning 설치 스크립트 (Windows PowerShell)

$ErrorActionPreference = "Stop"

$ClaudeDir = "$env:USERPROFILE\.claude"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== Claude Debate Planning 설치 ===" -ForegroundColor Cyan
Write-Host ""

# 디렉토리 생성
$dirs = @("agents", "commands", "hooks", "planning")
foreach ($dir in $dirs) {
    $path = Join-Path $ClaudeDir $dir
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

# 에이전트 복사
Write-Host "[1/4] 에이전트 복사 중..."
Copy-Item "$ScriptDir\agents\*.md" "$ClaudeDir\agents\" -Force

# 명령어 복사
Write-Host "[2/4] 명령어 복사 중..."
Copy-Item "$ScriptDir\commands\*.md" "$ClaudeDir\commands\" -Force

# 훅 복사
Write-Host "[3/4] 훅 복사 중..."
if (Test-Path "$ScriptDir\hooks\*.py") {
    Copy-Item "$ScriptDir\hooks\*.py" "$ClaudeDir\hooks\" -Force
}

# hooks.json 병합 또는 복사
Write-Host "[4/4] hooks.json 설정 중..."
$hooksJsonPath = Join-Path $ClaudeDir "hooks.json"
if (Test-Path $hooksJsonPath) {
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupPath = "$hooksJsonPath.backup.$timestamp"
    Write-Host "  기존 hooks.json이 있습니다. 백업: $backupPath"
    Copy-Item $hooksJsonPath $backupPath
}
Copy-Item "$ScriptDir\hooks.json" $hooksJsonPath -Force

Write-Host ""
Write-Host "=== 설치 완료! ===" -ForegroundColor Green
Write-Host ""
Write-Host "사용법: Claude Code에서 /debate-planning [요청] 실행" -ForegroundColor Yellow
Write-Host ""
