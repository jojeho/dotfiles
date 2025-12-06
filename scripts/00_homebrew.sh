#!/bin/bash
echo ">>> [00] Homebrew 설정을 시작합니다..."

# Brew 설치 로직
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew 설치 중..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 경로 설정 (Linux/Mac)
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew 이미 설치됨."
fi

brew update
