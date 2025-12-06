#!/bin/bash

# [공통 함수] Brew 경로 로드
# 이 함수를 호출하면 현재 스크립트에서 brew 명령어를 쓸 수 있게 됩니다.
load_brew() {
    if command -v brew >/dev/null 2>&1; then return; fi

    if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# 로드되자마자 실행 (모든 스크립트가 이 파일을 source 하면 즉시 해결됨)
load_brew
