#!/bin/bash
echo ">>> [11] FZF(Fuzzy Finder) 설정을 시작합니다..."

# --- [Safety Header] Brew 경로 강제 로드 ---
# 이 코드가 없으면 'brew: command not found' 에러가 발생함
if ! command -v brew >/dev/null 2>&1; then
    if [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi
# -------------------------------------------

# 2. fzf 패키지 설치
if brew list fzf >/dev/null 2>&1; then
    echo "fzf가 이미 설치되어 있습니다."
else
    echo "fzf 설치 중..."
    brew install fzf
fi

# 3. fzf 후처리 (키 바인딩 및 자동완성 설정 생성)
# Brew로 설치된 fzf 경로 찾기
FZF_PATH="$(brew --prefix)/opt/fzf"

if [ -d "$FZF_PATH" ]; then
    echo "fzf 키 바인딩 및 자동완성 스크립트를 실행합니다..."
    
    # --all: 모든 기능 활성화
    # --no-bash --no-fish: 우리는 zsh만 쓴다고 가정 (필요시 제거)
    # --no-update-rc: [중요] .zshrc를 맘대로 수정하지 못하게 함 (Stow로 관리하므로)
    "$FZF_PATH/install" --all --no-bash --no-fish --no-update-rc
    
    echo "fzf 설정 파일 생성 완료."
else
    echo "[ERROR] fzf 경로를 찾을 수 없습니다: $FZF_PATH"
    exit 1
fi
