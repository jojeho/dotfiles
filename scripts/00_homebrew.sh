#!/bin/bash

echo ">>> [00] Homebrew 설치 및 설정을 시작합니다..."

# 1. brew 명령어가 이미 되는지 확인 (이미 설치됨 & 경로 잡힘)
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew가 이미 설치되어 있고, 경로도 설정되어 있습니다."
    exit 0
fi

# 2. 설치는 되어있는데 경로만 안 잡힌 경우를 위해 미리 경로 체크
# (이 부분이 없으면 이미 깔려있는데 또 설치하려고 시도하다 에러날 수 있음)
BREW_EXISTS="false"

if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    BREW_EXISTS="true"
elif [ -x "/opt/homebrew/bin/brew" ]; then
    BREW_EXISTS="true"
elif [ -x "/usr/local/bin/brew" ]; then
    BREW_EXISTS="true"
fi

# 3. 진짜 설치가 안 되어 있다면 설치 진행
if [ "$BREW_EXISTS" = "false" ]; then
    echo "Homebrew가 감지되지 않아 설치를 시작합니다..."
    # NONINTERACTIVE=1 : 엔터키 입력 없이 자동 진행
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    if [ $? -ne 0 ]; then
        echo "[ERROR] Homebrew 설치 실패"
        exit 1
    fi
fi

# 4. [핵심] 설치 직후, 현재 스크립트에 경로 강제 주입 (eval shellenv)
echo "Homebrew 경로를 현재 쉘에 등록합니다..."

if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
    # 리눅스 (기본 경로)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -d "/opt/homebrew/bin" ]; then
    # macOS (Apple Silicon)
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "/usr/local/bin" ]; then
    # macOS (Intel)
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 5. 이제 brew 명령어가 되는지 최종 확인
if ! command -v brew >/dev/null 2>&1; then
    echo "[ERROR] 경로 등록 후에도 brew 명령어를 찾을 수 없습니다."
    echo "수동으로 경로 확인이 필요합니다."
    exit 1
fi

# 6. 성공! 이제 brew 명령어 사용 가능
echo "Homebrew 설정 완료! 버전을 확인합니다."
brew --version

# (선택) 설치 직후 업데이트
# brew update
