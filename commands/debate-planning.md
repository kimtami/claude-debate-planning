# Debate Planning - 두 PM 에이전트 토론 기반 플래닝

이 명령은 **낙관적 PM**과 **비판적 PM** 두 에이전트가 토론하여 균형 잡힌 플래닝을 생성합니다.

## 사용법

```
/debate-planning [플래닝 요청 내용]
```

## 프로세스

1. **초기 분석**: 요청을 분석하고 관련 코드/문서 조사
2. **토론 진행**: 두 PM이 최대 20라운드 토론
3. **합의 도출**: Critic이 수용할 때까지 개선
4. **문서 생성**: 최종 PRD 및 토론 기록

---

## 내부 워크플로우

다음 단계를 순서대로 실행하세요:

### Step 1: 초기 조사

먼저 다음을 수행합니다:

1. **코드베이스 분석**:
```bash
# 관련 파일 탐색
find . -type f -name "*.md" | head -20
# 기존 문서 확인
ls -la docs/ 2>/dev/null || echo "docs 폴더 없음"
```

2. **시장/기술 조사** (WebSearch 활용)

3. **초기 PRD 초안 작성**

### Step 2: 토론 시작

`planning-orchestrator` 에이전트를 사용하여 토론을 조율합니다:

```
Use the planning-orchestrator subagent to facilitate a debate between pm-optimist and pm-critic on:

[사용자의 플래닝 요청을 여기에 삽입]
```

### Step 3: 토론 실행

각 라운드에서:

1. **pm-optimist 호출**:
```
Use the pm-optimist subagent to argue for a fast, MVP-focused approach to:
[요청 내용]

Consider the critic's previous concerns:
[이전 Critic 의견]
```

2. **pm-critic 호출**:
```
Use the pm-critic subagent to critically evaluate the optimist's proposal:
[Optimist 의견]
```

3. **합의 확인**: Critic이 "✅ 수용합니다"라고 할 때까지 반복

### Step 4: 최종 문서 생성

토론이 완료되면:

1. `.claude/planning/` 디렉토리 생성
2. 토론 기록 저장
3. 최종 PRD 생성
4. 위험 레지스터 생성

---

## 예시 사용

```
/debate-planning 우리 서비스에 AI 챗봇 기능을 추가하고 싶습니다. 
고객 지원 자동화가 목표이고, 3개월 내 출시를 원합니다.
```

## 출력 파일

- `.claude/planning/debate-[timestamp].md` - 전체 토론 기록
- `.claude/planning/prd-[project].md` - 최종 PRD (변경점 포함)
- `.claude/planning/risks-[project].md` - 위험 레지스터

---

$ARGUMENTS
