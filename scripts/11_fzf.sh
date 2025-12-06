#!/bin/bash

# utils.sh 로드 (필수)
. "$HOME/dotfiles/scripts/utils.sh"

echo ">>> [11] FZF 설정..."

FZF_PATH="$(brew --prefix)/opt/fzf"

if [ -d "$FZF_PATH" ]; then
    # --no-update-rc : .zshrc를 건드리지 않음 (Stow로 관리할 것이므로)
    "$FZF_PATH/install" --all --no-bash --no-fish --no-update-rc
else
    echo "[WARN] FZF 경로를 찾을 수 없습니다."
fi
