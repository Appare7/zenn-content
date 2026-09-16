# zenn-content

Zenn（zenn.dev）に公開する技術記事のリポジトリ。GitHub 連携で `main` に push すると自動デプロイされる。

## 構成
- `articles/<slug>.md` 記事本体。frontmatter は title / emoji / type / topics / published
- `images/<slug>/figureN.png` 記事ごとの画像。記事からは `/images/<slug>/figureN.png` で参照
- `books/` 未使用
- `scripts/check-images.mjs` 参照画像の 3MB 超チェック

## コマンド
- 画像サイズ確認: `npm run check-images`（超過ゼロなら終了コード 0）
- ローカルプレビュー: `npx zenn preview`

## ルール（破るとリポジトリ全体のデプロイが止まる）
- slug（記事ファイル名）は `a-z0-9-_` の 12〜50 文字
- 画像は 1 ファイル 3MB 以下。push 前に `npm run check-images`
- 新規記事は `published: false` で作り、公開はユーザーが判断する
- 公開は 1 日 1 本ペース（Zenn 側の投稿上限あり）

## 文体
- です・ます調。専門用語・略語は初出で（読み／日本語訳）を付ける
- 執筆に使った裏側のベンダー名は記事に出さない
- 「Claude Code 101を日本語で」シリーズは冒頭に「この記事は〜シリーズの第N回です」を置く
