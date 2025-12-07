#!/bin/bash
# This script generates a new SSH key.

echo "ssh 키에 사용할 이메일 주소를 입력하세요:"
read email

if [ -z "$email" ]; then
  echo "이메일 주소는 비워둘 수 없습니다."
  exit 1
fi

ssh-keygen -t ed25519 -C "$email"

echo "SSH 키 생성이 시작되었습니다. 안내에 따라 진행해주세요."
echo "공개 키가 ~/.ssh/id_ed25519.pub 에 저장되었습니다."
echo "개인 키가 ~/.ssh/id_ed25519 에 저장되었습니다."
