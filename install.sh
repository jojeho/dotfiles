#!/bin/bash

# ==============================================================================
#  Dotfiles Main Installer
# =============================================================================

#PACKAGES=( 'gcc'  'neovim' 'zellij'  'fzf'  'delta' 'eza' 'bat' 'thefuck'  'gemini-cli' ) # 색상 유틸리티
REPO_URL="https://github.com/jojeho/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

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
    for name in "${PACKAGES[@]}"; do
	brew install "$name"
	info "${name} 설치 되었어요" 	
    done
}

run_stow(){
	info "stow link to parent folder"
	brew install stow
	stow  .
}

install_build_tools() {
    info "필수 빌드 도구를 설치합니다..."
    if [ "$(uname)" == "Linux" ]; then
        if command -v apt-get >/dev/null 2>&1; then
            # Debian/Ubuntu
            info "apt를 사용하여 build-essential을 설치합니다."
            sudo apt-get update && sudo apt-get install -y build-essential
        elif command -v dnf >/dev/null 2>&1; then
            # Fedora/CentOS
            info "dnf를 사용하여 'Development Tools'를 설치합니다."
            sudo dnf groupinstall -y "Development Tools"
        elif command -v pacman >/dev/null 2>&1; then
            # Arch Linux
            info "pacman를 사용하여 base-devel을 설치합니다."
            sudo pacman -S --noconfirm base-devel
        else
            error "배포판에 맞는 빌드 도구 설치 명령어를 찾지 못했습니다. 수동 설치가 필요합니다."
        fi
    fi
}

run_brew(){
 
echo ">>> [00] Homebrew 설치 및 설정..."

# 1. 설치
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew 설치 중..."
    
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Homebrew를 현재 셸에 로드
    if [ -x "/opt/homebrew/bin/brew" ]; then
        # Apple Silicon Mac
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
    elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        # Linux
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew 이미 설치됨."
    # Homebrew가 이미 설치된 경우에도, 현재 셸에 로드
    if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
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

}
main() {
    bootstrap_repo
    install_build_tools
    run_brew
    run_scripts
    run_stow
}

main
