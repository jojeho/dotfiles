
#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
#  Dotfiles Main Installer (Clean Version)
# ==============================================================================

REPO_URL="https://github.com/jojeho/dotfiles.git"
DOTFILES_DIR="${HOME}/.dotfiles"

# 필요 패키지 목록 (원하는 대로 수정)
PACKAGES=(
  gcc
  stow
  neovim
  zellij
  fzf
  delta
  bat
  thefuck
  gemini-cli
)

# 전역 Homebrew 바이너리 경로
BREW_BIN=""

# ------------------------------------------------------------------------------
#  유틸 함수
# ------------------------------------------------------------------------------

info()  { echo -e "\033[34m[INFO]\033[0m  $*"; }
warn()  { echo -e "\033[33m[WARN]\033[0m  $*"; }
error() { echo -e "\033[31m[ERROR]\033[0m $*" >&2; }

# ------------------------------------------------------------------------------
#  OS / 패키지 매니저 감지
# ------------------------------------------------------------------------------

detect_os() {
  uname_s="$(uname -s)"
  case "${uname_s}" in
    Linux)   echo "Linux" ;;
    Darwin)  echo "Darwin" ;;
    *)       echo "Unknown" ;;
  esac
}

detect_pkg_manager() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "none"
  fi
}

# ------------------------------------------------------------------------------
#  Git / 빌드 도구 설치
# ------------------------------------------------------------------------------

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    info "Git 이미 설치됨."
    return 0
  fi

  info "Git이 없어 설치를 진행합니다..."
  local os pkg
  os="$(detect_os)"
  pkg="$(detect_pkg_manager)"

  if [ "${os}" = "Darwin" ]; then
    info "macOS: Xcode Command Line Tools 설치 시도..."
    xcode-select --install || warn "xcode-select 실패. 수동으로 Git을 설치해야 할 수 있습니다."
  elif [ "${os}" = "Linux" ]; then
    case "${pkg}" in
      apt)
        sudo apt-get update
        sudo apt-get install -y git
        ;;
      dnf)
        sudo dnf install -y git
        ;;
      pacman)
        sudo pacman -Sy --noconfirm git
        ;;
      *)
        error "알 수 없는 패키지 매니저입니다. Git을 수동으로 설치해 주세요."
        ;;
    esac
  else
    error "지원하지 않는 OS 입니다. Git을 수동으로 설치해 주세요."
  fi
}

install_build_tools() {
  local os pkg
  os="$(detect_os)"
  pkg="$(detect_pkg_manager)"

  if [ "${os}" != "Linux" ]; then
    info "빌드 도구 설치는 Linux에서만 처리합니다. (${os})"
    return 0
  fi

  info "Linux 빌드 도구를 설치합니다..."
  case "${pkg}" in
    apt)
      info "apt: build-essential 설치"
      sudo apt-get update
      sudo apt-get install -y build-essential
      ;;
    dnf)
      info "dnf: 'Development Tools' 그룹 설치"
      sudo dnf groupinstall -y "Development Tools"
      ;;
    pacman)
      info "pacman: base-devel 설치"
      sudo pacman -S --noconfirm base-devel
      ;;
    *)
      warn "알 수 없는 패키지 매니저입니다. 빌드 도구를 수동으로 설치해야 할 수 있습니다."
      ;;
  esac
}

# ------------------------------------------------------------------------------
#  Dotfiles 저장소 준비
# ------------------------------------------------------------------------------

bootstrap_repo() {
  info "Dotfiles 저장소를 준비합니다..."

  ensure_git

  if [ -d "${DOTFILES_DIR}" ]; then
    info "기존 저장소가 있어 업데이트를 진행합니다."
    git -C "${DOTFILES_DIR}" pull --ff-only
  else
    info "저장소를 클론합니다: ${REPO_URL} -> ${DOTFILES_DIR}"
    git clone "${REPO_URL}" "${DOTFILES_DIR}"
  fi
}

# ------------------------------------------------------------------------------
#  Homebrew 설치 및 설정
# ------------------------------------------------------------------------------

detect_brew_bin() {
  # 이미 PATH 안에 있다면 그대로 사용
  if command -v brew >/dev/null 2>&1; then
    BREW_BIN="$(command -v brew)"
    return 0
  fi

  # 대표적인 위치 확인
  for path in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew
  do
    if [ -x "${path}" ]; then
      BREW_BIN="${path}"
      return 0
    fi
  done

  return 1
}

ensure_brew() {
  info "Homebrew 설치 및 설정을 확인합니다..."

  if detect_brew_bin; then
    info "Homebrew 이미 설치됨: ${BREW_BIN}"
  else
    info "Homebrew가 없어 설치를 진행합니다..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if ! detect_brew_bin; then
      error "Homebrew 설치 후에도 brew를 찾을 수 없습니다. 설치 스크립트를 확인해 주세요."
      exit 1
    fi
    info "Homebrew 설치 완료: ${BREW_BIN}"
  fi

  # 현재 셸 환경에 brew PATH 적용
  eval "$("${BREW_BIN}" shellenv)"

  # 쉘 설정파일에 영구 반영
  local linuxbrew="/home/linuxbrew/.linuxbrew"
  if [ -d "${linuxbrew}" ]; then
    if [ -f "${HOME}/.zshrc" ] && ! grep -q "${linuxbrew}/bin/brew shellenv" "${HOME}/.zshrc"; then
      echo "eval \"\$(${linuxbrew}/bin/brew shellenv)\"" >> "${HOME}/.zshrc"
      info "~/.zshrc 에 Homebrew PATH 설정 추가"
    fi
    if [ -f "${HOME}/.bashrc" ] && ! grep -q "${linuxbrew}/bin/brew shellenv" "${HOME}/.bashrc"; then
      echo "eval \"\$(${linuxbrew}/bin/brew shellenv)\"" >> "${HOME}/.bashrc"
      info "~/.bashrc 에 Homebrew PATH 설정 추가"
    fi
  fi
}

# ------------------------------------------------------------------------------
#  패키지 설치
# ------------------------------------------------------------------------------

install_packages() {
  ensure_brew

  info "필요 패키지를 설치합니다 (Homebrew)..."
  for name in "${PACKAGES[@]}"; do
    if brew list --versions "${name}" >/dev/null 2>&1; then
      info "${name} 이미 설치됨. 건너뜁니다."
    else
      info "${name} 설치 중..."
      brew install "${name}"
      info "${name} 설치 완료."
    fi
  done
}

# ------------------------------------------------------------------------------
#  Dotfiles stow 링크
# ------------------------------------------------------------------------------

link_dotfiles() {
  info "stow를 사용하여 dotfiles를 링크합니다..."

  # stow가 설치되어 있어야 함 (PACKAGES에 있기 때문에 대부분 설치되었을 것)
  if ! command -v stow >/dev/null 2>&1; then
    warn "stow가 PATH에 없습니다. Homebrew로 설치를 시도합니다."
    ensure_brew
    brew install stow
  fi

  if ! cd "${DOTFILES_DIR}"; then
    error "DOTFILES_DIR(${DOTFILES_DIR})로 이동할 수 없습니다."
    exit 1
  fi

  # 기본: 현재 디렉토리의 모든 stow 타깃을 링크
  # 필요하다면 서브 디렉토리별로 따로 호출할 수도 있음 (e.g. stow zsh git nvim)
  stow -R .

  info "dotfiles 링크가 완료되었습니다."
}

# ------------------------------------------------------------------------------
#  메인 플로우
# ------------------------------------------------------------------------------

main() {
  info "Dotfiles 설치를 시작합니다."
  bootstrap_repo
  install_build_tools
  ensure_brew
  install_packages
  link_dotfiles
  info "모든 작업이 완료되었습니다 🎉"
}

main "$@"
