#!/bin/bash

# 빠른 실행을 위한 단축 버전
echo "🚀 빠른 Git 업로드..."
git add . && git commit -m "Auto update: $(date '+%Y-%m-%d %H:%M:%S')" && git push
echo "✅ 완료!"
