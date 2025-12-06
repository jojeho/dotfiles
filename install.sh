#!/bin/bash

# ==============================================================================
#  Dotfiles Main Installer
# ==============================================================================

REPO_URL="https://github.com/jojeho/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# 색상 유틸리티
info() { echo -e "\033[34m[INFO]\033[0m $1"; }
error() { echo -e "\033[31m[ERROR]\033[0m $1"; }

# 1. 저장소 다운로드 (Bootstrapping)
bootstrap_repo() {
    info "Dotfiles 저장소를 준비합니다..."

    # Git 없으면 일시적으로 설치 시도 (Linux/Mac)
    if ! command -v git >/dev/null 2>&1; then
        info "Git이 없어 설치를 시도합니다..."
        if [ "$(uname)" == "Darwin" ]; then
            xcode-select --install
        elif command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y git
        fi
    fi

    if [ ! -d "$DOTFILES_DIR" ]; then
        info "저장소를 다운로드합니다: $REPO_URL"
        git clone "$REPO_URL" "$DOTFILES_DIR"
    else
        info "저장소 업데이트 중..."
        cd "$DOTFILES_DIR" && git pull
    fi
}

# 2. 스크립트 순차 실행
run_scripts() {
    info "설정 스크립트를 실행합니다..."
    
    # scripts 폴더 내의 .sh 파일들을 번호 순서대로 실행
    for script in "$DOTFILES_DIR/scripts/"*.sh; do
        # utils.sh는 실행용이 아니므로 건너뜀
        if [ "$(basename "$script")" == "utils.sh" ]; then continue; fi

        if [ -f "$script" ]; then
            filename=$(basename "$script")
            info "Running: $filename"
            
            # 실행 권한 부여
            chmod +x "$script"
            
            # 스크립트 실행
            /bin/bash "$script"
            
            if [ $? -ne 0 ]; then
                error "$filename 실행 중 오류 발생! 중단합니다."
                exit 1
            fi
        fi
    done
}

main() {
    bootstrap_repo
    run_scripts
    
    info "모든 설치가 완료되었습니다! 쉘을 재시작합니다."
    exec zsh -l
}

main
