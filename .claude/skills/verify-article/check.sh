#!/bin/bash
# 記事の公開前検査。FAIL が1つでもあれば終了コード1。
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 2
files=("$@")
if [ ${#files[@]} -eq 0 ]; then
  while IFS= read -r f; do files+=("$f"); done < <(git status --porcelain -- articles | awk '{print $2}' | grep '\.md$')
fi
[ ${#files[@]} -eq 0 ] && { echo "検査対象の記事がありません"; exit 0; }
python3 - "${files[@]}" <<'PY'
import sys,re,os
PRIVATE=["Vision Pro","WebSocket","buddy_ai","CommonSpace","栗原研","Azure","OpenAI","ChatGPT"]
fail=0
def r(ok,name,msg=""):
    global fail
    print(("PASS" if ok else "FAIL"),name,msg)
    fail+=0 if ok else 1
for p in sys.argv[1:]:
    print("==",p)
    s=open(p).read(); slug=os.path.basename(p)[:-3]
    fm=s.split('---')[1] if s.startswith('---') else ""
    body=s.split('---',2)[2] if s.startswith('---') else s
    prose=re.sub(r'```.*?```','',body,flags=re.S)
    r(bool(re.fullmatch(r'[a-z0-9_-]{12,50}',slug)),"slug",f"{len(slug)}文字")
    t=re.search(r'title: "(.*)"',fm); n=len(t.group(1)) if t else 0
    r(0<n<=70,"title",f"{n}文字")
    tp=re.search(r'topics: \[(.*)\]',fm); k=len(tp.group(1).split(',')) if tp else 0
    r(0<k<=5,"topics",f"{k}個")
    imgs=re.findall(r'!\[\]\((/images/[^)\s]+)',body)
    bad=[i for i in imgs if not os.path.exists('.'+i) or os.path.getsize('.'+i)>3*1024*1024]
    r(not bad,"images",f"{len(imgs)}枚" + (f" 問題: {bad[:3]}" if bad else ""))
    lines=body.split('\n')
    nocap=[i+1 for i,l in enumerate(lines[:-1]) if l.startswith('![](') and not re.fullmatch(r'\*[^*].*\*',lines[i+1].strip())]
    r(not nocap,"captions",f"キャプション無し: 本文{nocap[:5]}行目" if nocap else "")
    left=[w for w in ["<!-- fig","@@"] if w in prose]
    r(not left,"leftovers",str(left) if left else "")
    priv=[w for w in PRIVATE if w in prose]
    r(not priv,"private",str(priv) if priv else "")
    opens=len(re.findall(r'^:::(details|message)',body,flags=re.M)); closes=len(re.findall(r'^:::\s*$',body,flags=re.M))
    r(opens==closes,"details",f"開{opens} 閉{closes}")
sys.exit(1 if fail else 0)
PY
