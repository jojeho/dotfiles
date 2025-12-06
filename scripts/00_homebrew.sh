#!/bin/bash

echo ">>> [00] Homebrew 설치 및 설정..."

# 1. 설치
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew 설치 중..."
    
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew 이미 설치됨."
fi

# 3. 경로 등록 (영구적 - .zshrc 등에 추가)
# 리눅스의 경우 자동으로 추가되지 않을 수 있어 명시적 추가
LINUXBREW="/home/linuxbrew/.linuxbrew"
if [ -d "$LINUXBREW" ]; then
    if [ -f "$HOME/.zshrc" ] && ! grep -q "linuxbrew" "$HOME/.zshrc"; then
        echo "eval \"\$($LINUXBREW/bin/brew shellenv)\"" >> "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.bashrc" ] && ! grep -q "linuxbrew" "$HOME/.bashrc"; then
        echo "eval \"\$($LINUXBREW/bin/brew shellenv)\"" >> "$HOME/.bashrc"
    fi
fi
