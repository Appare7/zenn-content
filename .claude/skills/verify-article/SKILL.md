---
name: verify-article
description: Zenn記事を書いた・直した・画像を入れた後に、公開してよい状態かを検証する。記事ファイル(articles/*.md)や images/ を変更したら使う
---

記事を変更したら、報告の前に必ず次をやる。

1. `bash .claude/skills/verify-article/check.sh <記事のパス>` を実行する(引数なしなら変更のあった記事すべて)
2. 出力を読み、FAIL の行を1つずつ直す。直したら 1 に戻る
3. `git diff --stat` で、触るつもりのなかったファイルが変わっていないか確かめる
4. 結果を「合格 / 不合格」と、check.sh の出力(証拠)を添えて報告する。実行していない検査を「通った」と書かない

検査項目の意味と直し方は [reference.md](reference.md) にある。FAIL の直し方に迷ったときだけ読む。
