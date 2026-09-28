#!/bin/bash
# PreToolUse(Bash): git push の前に、デプロイを止める違反がないか確かめる。
# 違反があれば permissionDecision: deny を返して push を止める。
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
case "$cmd" in *"git push"*) ;; *) exit 0 ;; esac
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

problems=""
over=$(node scripts/check-images.mjs 2>/dev/null)
[ -n "$over" ] && problems+="3MBを超える画像がある: $(echo "$over" | tr '\n' ' ')"$'\n'
for f in articles/*.md; do
  s=$(basename "$f" .md)
  if [ ${#s} -lt 12 ] || [ ${#s} -gt 50 ] || ! [[ "$s" =~ ^[a-z0-9_-]+$ ]]; then
    problems+="slugが不正(12〜50文字の a-z0-9-_ ): $s"$'\n'
  fi
done

if [ -n "$problems" ]; then
  jq -n --arg r "$problems" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
fi
exit 0
