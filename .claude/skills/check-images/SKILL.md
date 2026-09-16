---
description: 記事が参照している画像に3MB超がないか確認する。公開前・push前に使う
disable-model-invocation: true
---

## 結果
!`npm run check-images 2>&1`

## 指示
上の結果を読んで、超過があればファイル名とサイズを箇条書きで報告し、
`sips -Z 2000 <path>` で縮小する提案をして。超過ゼロなら「問題なし」とだけ答えて。
