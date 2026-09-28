#!/bin/bash
# Stop: 記事を変更したターンは、検査に通るまで終わらせない。
input=$(cat)
[ "$(echo "$input" | jq -r '.stop_hook_active // false')" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
changed=$(git diff --name-only HEAD -- articles | grep '\.md$')
[ -z "$changed" ] && exit 0
out=$(bash .claude/skills/verify-article/check.sh $changed 2>&1) && exit 0
echo "記事の検査に失敗。FAIL を直してから終わること:" >&2
echo "$out" | grep -E "^(==|FAIL)" >&2
exit 2
