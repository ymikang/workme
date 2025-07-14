#!/bin/bash

# 현재 날짜와 시간으로 커밋 메시지 생성
commit_message="Auto commit: $(date '+%Y-%m-%d %H:%M:%S')"

# 사용자 정의 커밋 메시지가 있다면 사용
if [ $# -gt 0 ]; then
    commit_message="$*"
fi

echo "🔄 Git 자동 업로드 시작..."
echo "📝 커밋 메시지: $commit_message"

# git add
echo "➕ 파일 추가 중..."
git add .

# 변경사항이 있는지 확인
if git diff --cached --quiet; then
    echo "❌ 변경사항이 없습니다."
    exit 0
fi

# git commit
echo "💾 커밋 생성 중..."
git commit -m "$commit_message"

# git push
echo "🚀 원격 저장소에 업로드 중..."
git push

echo "✅ 업로드 완료!"
