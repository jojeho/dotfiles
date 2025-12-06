#!/bin/bash

# utils.sh 로드
. "$HOME/dotfiles/scripts/utils.sh"

echo ">>> [20] Stow 링크 설정..."

cd "$HOME/.dotfiles" || exit 1

# 제외 목록 생성
if [ ! -f ".stow-local-ignore" ]; then
    cat > .stow-local-ignore <<EOF
.git
.github
.DS_Store
install.sh
README.md
scripts
LICENSE
EOF
fi

# 충돌 파일 백업 및 Stow 실행
mkdir -p "$HOME/.dotfiles_backup"
CONFLICT_FILES=(".zshrc" ".bashrc" ".vimrc" ".gitconfig")

for file in "${CONFLICT_FILES[@]}"; do
    target="$HOME/$file"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$HOME/.dotfiles_backup/"
        echo "백업됨: $file"
    fi
done

# Stow 실행
stow -v -R -t "$HOME" .
