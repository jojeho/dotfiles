#!/bin/bash

echo ">>> [00] Homebrew 설치 및 설정을 시작합니다..."

# ------------------------------------------------------------------------------
# 1. Homebrew 설치
# ------------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew 설치를 시작합니다..."
    
    # NONINTERACTIVE=1 : 엔터키 입력 없이 자동 진행
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo "Homebrew 설치 완료. 경로 설정을 시작합니다..."
else
    echo "Homebrew가 이미 설치되어 있습니다."
fi

# ------------------------------------------------------------------------------
# 2. 경로 설정 (핵심: "not in your PATH" 해결)
# ------------------------------------------------------------------------------
# 리눅스용 Homebrew 기본 경로
LINUXBREW="/home/linuxbrew/.linuxbrew"

if [ -d "$LINUXBREW" ]; then
    # (A) 현재 스크립트에서 brew를 쓰기 위해 경로 등록 (일시적)
    echo "현재 세션에 Homebrew 경로를 로드합니다..."
    eval "$($LINUXBREW/bin/brew shellenv)"

    # (B) 터미널을 껐다 켜도 되도록 .zshrc / .bashrc에 영구 등록
    #     (이미 등록되어 있는지 grep으로 확인 후 없으면 추가)
    
    # zsh 사용자
    if [ -f "$HOME/.zshrc" ] && ! grep -q "linuxbrew" "$HOME/.zshrc"; then
        echo "Updating .zshrc..."
        echo "eval \"\$($LINUXBREW/bin/brew shellenv)\"" >> "$HOME/.zshrc"
    fi

    # bash 사용자
    if [ -f "$HOME/.bashrc" ] && ! grep -q "linuxbrew" "$HOME/.bashrc"; then
        echo "Updating .bashrc..."
        echo "eval \"\$($LINUXBREW/bin/brew shellenv)\"" >> "$HOME/.bashrc"
    fi
fi

# ------------------------------------------------------------------------------
# 3. 검증
# ------------------------------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew 설정 성공!"
    brew --version
else
    echo "❌ [ERROR] Homebrew 경로 설정에 실패했습니다."
    exit 1
fi
