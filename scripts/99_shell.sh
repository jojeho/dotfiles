#!/bin/bash

echo ">>> [99] 쉘 설정..."

ZSH_PATH=$(command -v zsh)

if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "기본 쉘을 zsh로 변경합니다. (암호 필요)"
    # 리눅스 /etc/shells 등록 확인
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi
    chsh -s "$ZSH_PATH"
fi
