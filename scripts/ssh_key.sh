#!/bin/bash

# 1. 이메일 입력 받기
echo -e "\n🔵 Git 계정에 연동할 이메일 주소를 입력하세요:"
read -p "Email: " COMMENT_EMAIL

if [ -z "$COMMENT_EMAIL" ]; then
    echo "❌ 이메일이 입력되지 않았습니다. 스크립트를 종료합니다."
    exit 1
fi

KEY_NAME="id_ed25519"
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"

# 2. .ssh 디렉토리 확인 및 생성
if [ ! -d "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# 3. 기존 키 존재 여부 확인 (덮어쓰기 방지)
if [ -f "$KEY_PATH" ]; then
    echo -e "\n⚠️  이미 $KEY_PATH 키가 존재합니다."
    read -p "덮어쓰고 새로 만드시겠습니까? (y/N): " OVERWRITE
    if [[ "$OVERWRITE" != "y" && "$OVERWRITE" != "Y" ]]; then
        echo "스크립트를 종료합니다."
        exit 0
    fi
    rm "$KEY_PATH" "$KEY_PATH.pub"
fi

# 4. SSH 키 생성 (Ed25519 알고리즘)
echo -e "\n🔑 SSH 키를 생성합니다..."
# -t: 타입, -C: 코멘트(이메일), -f: 파일경로, -N: 비밀번호(여기서는 빈값으로 설정하거나 제거하여 입력 유도 가능)
ssh-keygen -t ed25519 -C "$COMMENT_EMAIL" -f "$KEY_PATH"

# 5. ssh-agent 실행 및 키 추가
echo -e "\n⚙️  ssh-agent를 백그라운드에서 실행하고 키를 추가합니다..."
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$KEY_PATH"

# 6. macOS 설정 (Config 파일 생성 - 필요한 경우)
# macOS는 재부팅 후에도 키를 기억하게 하려면 config 설정이 권장됨
if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_FILE="$SSH_DIR/config"
    if [ ! -f "$CONFIG_FILE" ]; then
        touch "$CONFIG_FILE"
    fi
    
    # 설정이 없는 경우에만 추가
    if ! grep -q "Host *" "$CONFIG_FILE"; then
        echo -e "\nHost *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile $KEY_PATH" >> "$CONFIG_FILE"
        echo "📝 macOS용 SSH Config 설정을 추가했습니다."
    fi
fi

# 7. 공개키 출력 및 복사 안내
echo -e "\n✅ 모든 작업이 완료되었습니다!"
echo -e "👇 아래의 공개키(Public Key)를 복사하여 GitHub/GitLab에 등록하세요:\n"
echo "----------------------------------------------------------------------"
cat "$KEY_PATH.pub"
echo "----------------------------------------------------------------------"

# 클립보드 복사 시도 (macOS/Linux)
if command -v pbcopy &> /dev/null; then
    cat "$KEY_PATH.pub" | pbcopy
    echo -e "✨ 공개키가 클립보드에 복사되었습니다! (Cmd+V로 붙여넣기 가능)"
elif command -v xclip &> /dev/null; then
    cat "$KEY_PATH.pub" | xclip -selection clipboard
    echo -e "✨ 공개키가 클립보드에 복사되었습니다!"
fi
