#!/bin/bash

# utils.sh 로드 (필수)
. "$HOME/dotfiles/scripts/utils.sh"

echo ">>> [10] 패키지 설치..."

PACKAGES=(
    "git"
    "zsh"
    "vim"
    "stow"
    "curl"
    "fzf"
    # "tmux"
    # "neovim"
)

for pkg in "${PACKAGES[@]}"; do
    if brew list "$pkg" >/dev/null 2>&1; then
        echo "$pkg : 이미 설치됨"
    else
        brew install "$pkg"
    fi
done
