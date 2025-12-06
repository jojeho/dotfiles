#!/bin/bash

# --- [핵심] Homebrew 경로 자동 로드 함수 ---
load_brew() {
    # 이미 brew 명령어가 되면 통과
    if command -v brew >/dev/null 2>&1; then
        return
    fi

    # OS별 표준 설치 경로 확인 및 로드
    if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# 파일이 로드되자마자 실행
load_brew
