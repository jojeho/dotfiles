#!/bin/bash

# 이 스크립트는 Git 자격 증명을 전역으로 저장하여
# 푸시할 때마다 사용자 이름과 비밀번호를 입력할 필요가 없도록 설정합니다.

echo "----------------------------------------------------------------"
echo "Git 자격 증명 등록"
echo "----------------------------------------------------------------"
echo "이 스크립트는 Git이 자격 증명 헬퍼를 사용하여 자격 증명을"
echo "전역으로 저장하도록 설정합니다. 이렇게 하면 원격 저장소와 상호 작용할 때마다"
echo "사용자 이름과 개인용 액세스 토큰을 입력할 필요가 없습니다."
echo ""
echo "다음을 입력하라는 메시지가 표시됩니다:"
echo "1. Git 사용자 이름."
echo "2. Git 이메일 주소."
echo "3. Git 개인용 액세스 토큰 (PAT). 비밀번호로 사용됩니다."
echo ""
echo "GitHub와 같은 플랫폼에서 Git 저장소에 명령줄로 액세스하려면"
echo "개인용 액세스 토큰이 필요합니다. 개발자 설정에서 생성할 수 있습니다:"
echo "GitHub: https://github.com/settings/tokens"
echo ""
echo "스크립트는 먼저 'git config --global credential.helper store'를 실행하여 자격 증명 헬퍼를 활성화합니다."
echo "그런 다음 github.com에 대한 자격 증명을 저장합니다."
echo ""
echo "자격 증명은 홈 디렉터리 (~/.git-credentials)의 파일에 일반 텍스트로 저장됩니다."
echo "이 파일을 안전하게 보관하십시오."
echo "----------------------------------------------------------------"
echo ""

read -p "Git 사용자 이름을 입력하세요: " username
if [ -z "$username" ]; then
  echo "사용자 이름은 비워둘 수 없습니다."
  exit 1
fi

read -p "Git 이메일 주소를 입력하세요: " email
if [ -z "$email" ]; then
  echo "이메일 주소는 비워둘 수 없습니다."
  exit 1
fi

read -sp "Git 개인용 액세스 토큰을 입력하세요 (표시되지 않음): " token
echo ""
if [ -z "$token" ]; then
  echo "개인용 액세스 토큰은 비워둘 수 없습니다."
  exit 1
fi

echo "전역 git user.name 및 user.email 설정 중..."
git config --global user.name "$username"
git config --global user.email "$email"

echo "'store' 자격 증명 헬퍼를 사용하도록 git 설정 중..."
git config --global credential.helper store

echo "github.com에 대한 자격 증명 저장 중..."
# 'git credential approve'에 자격 증명을 파이프로 전달하기 위해 echo 사용
# 이것이 프로그래밍 방식으로 헬퍼에 자격 증명을 제공하는 방법입니다.
# 입력 형식은 줄 바꿈으로 구분된 키=값 쌍의 연속입니다.
echo "protocol=https
host=github.com
username=$username
password=$token
" | git credential approve

echo ""
echo "----------------------------------------------------------------"
echo "성공! Git 자격 증명이 저장되었습니다."
echo "이제 사용자 이름이나 비밀번호를 묻지 않고 비공개 GitHub 저장소에"
echo "푸시하고 풀할 수 있습니다."
echo "----------------------------------------------------------------"
