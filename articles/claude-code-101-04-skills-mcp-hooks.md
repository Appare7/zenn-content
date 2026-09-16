---
title: "Claude Code 101を日本語で#4 スキル・MCP・フック｜「お願い」で動かすものと「仕組み」で強制するもの"
emoji: "🪝"
type: "tech"
topics: ["claudecode", "ai", "aiagent", "mcp", "anthropic"]
published: false
---

この記事は「Claude Code 101を日本語で」シリーズの第4回です。

Anthropic（アンソロピック／Claudeの開発元）の無料コース「Claude Code 101」を一から受講しながら、学んだことを日本語でまとめています。今回はセクション4「Customizing Claude Code」の後半、スキル・MCP・フック。Claude Codeを「拡張する」3つの手段と、それぞれのコンテキストへの負担の違いがテーマです。

:::message
コースの中身をそのまま翻訳する記事ではありません。コースと公式ドキュメントで学んだことを、自分の言葉と自分の手元での実験で組み直しています。一次情報は[公式ドキュメント](https://code.claude.com/docs/en/features-overview)と[コース本体](https://anthropic.skilljar.com/claude-code-101)をあたってください。
:::

![](/images/claude-code-101-04-skills-mcp-hooks/figure1.png)
第4回はスキル・MCP・フック。Claude Codeを拡張する3つの手段と、「お願い」と「強制」の線引きをやります

## 前回のおさらい

第3回では、CLAUDE.md（毎回読まれる指示書）とサブエージェント（別の窓で働く分身）を見ました。今回の3つも「Claude Codeに何かを足す」仕組みですが、**いつコンテキストに載るか** と **守られる強さ** が全部違います。最後に表で並べます。

## スキル：呼んだときだけ読まれる手順書

コースのこのレッスンは動画だけで本文が無かったので、公式ドキュメントから要点をまとめます。

### スキルとは

再利用できる手順書です。`SKILL.md` というファイルに、先頭の設定（YAML（ヤムル）フロントマター）と、Markdownの指示を書く。`/スキル名` で自分から呼ぶか、内容が関係しそうなときにClaudeが自動で読み込みます。

CLAUDE.md との違いはただ一点、**使うときだけ読み込まれる**こと。だから長い手順や参考資料をスキルにしておけば、必要になるまでコンテキストを食いません。第1回の `/context` で「Skills: 24 skills · 3.3k tokens」と出ていたのは、24個分の **説明文だけ** が載っている状態でした。

![](/images/claude-code-101-04-skills-mcp-hooks/figure2.png)
ふだん載っているのは付箋1枚ぶんの説明文だけ。呼ばれた瞬間に本が開いて中身が展開される

### 置き場所

| 場所 | パス | 効く範囲 |
| --- | --- | --- |
| 個人用 | `~/.claude/skills/<名前>/SKILL.md` | 全プロジェクト |
| プロジェクト用 | `.claude/skills/<名前>/SKILL.md` | そのリポジトリ |
| プラグイン | `<plugin>/skills/<名前>/SKILL.md` | プラグインが有効な場所 |

### 最小の例

```markdown:~/.claude/skills/summarize-changes/SKILL.md
---
description: 未コミットの変更を要約して、リスクを指摘する
---

## 今の変更
!`git diff HEAD`

## 指示
上の変更を2〜3行で要約し、リスク（エラー処理漏れ・ハードコード・未テスト）を列挙して
```

`/summarize-changes` で呼べます。`` !`コマンド` `` の部分は **Claudeが読む前にコマンドが実行されて、結果が埋め込まれる** 仕組み。Claudeはコマンドではなく実際の差分を受け取ります。

![](/images/claude-code-101-04-skills-mcp-hooks/figure3.png)
Claudeに実行させるのではなく、読ませる前にこちらで材料を揃えて渡す。受け取るのはコマンドではなく本物の差分

### よく使う設定項目

| キー | 意味 |
| --- | --- |
| `description` | いつ自動で呼ぶべきかの説明。Claudeはこれを見て判断する |
| `disable-model-invocation: true` | 自分からしか呼べなくする。`/deploy` のような危ない操作向け |
| `allowed-tools` | そのターンだけ特定ツールを事前承認 |
| `context: fork` | 隔離されたサブエージェントで実行 |
| `paths` | 特定のファイルを触っているときだけ有効 |

## MCP：外部ツールを繋ぐ規格

### MCPとは

MCP（Model Context Protocol／モデル・コンテキスト・プロトコル）は、Claude Codeを外部のツールやデータソースに接続するためのオープンな標準規格です。コードベースの外にある文脈、たとえばデータベース、課題管理ツール、ドキュメントサイトを、Claudeが直接読み書きできるようにします。

コースは先に「ツール」の概念を押さえろと言っていました。ツールは、エージェントに「テキストを返す」以外の行動を取らせるもの。MCPはそのツールを外部サービスから持ってくる規格です。例として挙がっていたのは、課題管理のLinearや、最新ドキュメントを返すContext7。

![](/images/claude-code-101-04-skills-mcp-hooks/figure4.png)
Claude Codeと外部サービスの間にMCPサーバーが挟まる。繋ぎ方は遠隔のHTTPと、手元で動かすstdio（標準入出力）の2種類

### 追加と管理

```bash
# リモートのサービス（HTTP）
claude mcp add --transport http linear https://mcp.linear.app/mcp

# 自分のマシンで動くプロセス（stdio＝標準入出力でやり取り）
claude mcp add --transport stdio my-tool -- node ./my-mcp-server.js
```

セッション内で `/mcp` を打つと、何が繋がっているか、状態、不要なサーバーの無効化ができます。

### スコープ（範囲）は3つ

| スコープ | 効く範囲 | 共有 |
| --- | --- | --- |
| Local | 今のプロジェクト、自分だけ | しない |
| User | 自分の全プロジェクト | しない |
| Project | `.mcp.json` をコミット | チームが自動で同じサーバーを持つ |

![](/images/claude-code-101-04-skills-mcp-hooks/figure5.png)
「どこで効くか」と「誰と共有するか」の掛け合わせで3つ。チームで揃えたいならProject、自分の手癖ならUser、お試しならLocal

### コンテキストのコスト

ここがコースの一番の強調点でした。MCPサーバーは **使っていなくてもツール定義をコンテキストに載せる**。だから、

- 使っていないサーバーは `/mcp` で無効化する
- CLI（コマンドラインツール）相当品（GitHubの `gh`、AWSの `aws`）があるならCLIの方が軽い。常駐する定義が無いから
- スキルで代替できるなら、そちらは説明文しか常駐しない

そしてコースはこう続けます。「MCPツールがコンテキストの10%を超えると、自動でツール検索モードに切り替わる。ただし信頼性は下がるかもしれない」。

ところが手元の環境では、第1回・第2回で見たとおり `MCP tools · 70 tools · 0 tokens (loaded on-demand)`。**最初からツール検索モード**で、70個のツールが0トークン。コースが「例外的な救済策」として書いていた仕組みが、いまは既定の動作になっています。これも「迷ったらドキュメントを正とする」案件でした。

![](/images/claude-code-101-04-skills-mcp-hooks/figure6.png)
/mcp で繋がっているサーバーの状態を見て、要らないものは無効化する。実行結果をもとに読みやすく整形した再現画像で、サーバー名は例

## フック：必ず実行される

### なぜフックか

コースのこのレッスンの最初の一文が、そのまま結論です。

> このコースで扱った他の全てとの決定的な違いは、フックは **決定論的** であること。つまり、必ず実行される。

CLAUDE.md に「ファイル編集のたびにPrettier（コード整形ツール）を実行して」と書けば、たいていやってくれます。でも、たまにやらない。フックなら毎回、例外なく実行される。「お願い」と「強制」の違いです。

![](/images/claude-code-101-04-skills-mcp-hooks/figure8.png)
左は読んで判断して動く「お願い」、右はClaudeの判断と無関係にシェルで動く「仕組み」。たいてい守る、と必ず動く、は別物

用途としてコースが挙げていたのは、編集後の自動フォーマット、実行コマンドの記録（監査用）、危険な操作のブロック、タスク完了の通知。

### イベント

| イベント | いつ |
| --- | --- |
| `PreToolUse` | ツール呼び出しの前 |
| `PostToolUse` | ツール呼び出しの完了後 |
| `UserPromptSubmit` | プロンプト送信時、Claudeが処理する前 |
| `Stop` | Claudeが応答を終えたとき |
| `Notification` | Claudeが通知を送るとき |

![](/images/claude-code-101-04-skills-mcp-hooks/figure7.png)
1ターンの流れのどこにフックが差し込めるか。PreToolUseだけが「実行前に止められる」位置にいる

設定は `/hooks` コマンドか、`settings.json` を直接編集。

### 例1：編集後に自動フォーマット

一番よくあるフック。`PostToolUse` に「Edit か Write のとき」というマッチャーを付けます。フックは対象ツールの入力をJSONで標準入力から受け取るので、`jq`（JSONを加工するコマンド）でファイルパスを取り出してフォーマッターに渡します。

```json:.claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write"
          }
        ]
      }
    ]
  }
}
```

![](/images/claude-code-101-04-skills-mcp-hooks/figure11.png)
編集が終わるたびにフックが起動し、そのファイルにだけフォーマッターがかかる。Claudeは何も気にせず続行する

### 例2：危険なコマンドをブロック

`PreToolUse` は実行前に止められます。終了コードで挙動が決まります。

| 終了コード | 挙動 |
| --- | --- |
| 0 | 通常どおり続行 |
| 2 | **ブロック**。標準エラー出力のメッセージがClaudeに返り、理由を理解して別の手を考える |
| それ以外 | ブロックしないエラー。あなたには表示されるが止めない |

![](/images/claude-code-101-04-skills-mcp-hooks/figure9.png)
0は続行、2はブロックして理由がClaudeに返る、それ以外は表示だけ。止めたいなら2

```bash:.claude/hooks/block-rm-rf.sh
#!/bin/bash
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
if echo "$cmd" | grep -q "rm -rf"; then
  echo "rm -rf は禁止。削除するファイルを個別に指定して" >&2
  exit 2
fi
exit 0
```

```json:.claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm-rf.sh"
          }
        ]
      }
    ]
  }
}
```

`CLAUDE_PROJECT_DIR` はプロジェクトのルートを指す環境変数。Claudeがどのディレクトリで作業していても、リポジトリ内のスクリプトを確実に指せます。`.claude/settings.json` はコミットできるので、チーム全員が同じフックを持てます。

コースの締めの一文が全てです。**毎回、絶対に起きてほしいことは、プロンプトに書くな。フックに書け。**

## 5つの拡張を一枚で

セクション4で出てきた5つを、「いつコンテキストに載るか」と「守られる強さ」で並べます。

| 仕組み | コンテキストに載るタイミング | 守られる強さ | 向いている中身 |
| --- | --- | --- | --- |
| CLAUDE.md | 毎セッション、常に | お願い（たいてい守る） | 事実・規約・「常にXしろ」 |
| スキル | 呼んだときだけ | お願い | 手順・複数ステップの作業 |
| サブエージェント | 別の窓（親には要約だけ） | お願い | まっさらな状態が要る仕事・レビュー |
| MCP | 定義は常駐（いまは必要時読み込み） | お願い | 外部ツール・データ |
| フック | 載らない（シェルで実行） | **強制（必ず動く）** | 絶対に起きてほしいこと |

![](/images/claude-code-101-04-skills-mcp-hooks/figure10.png)
横軸がコンテキストに載るタイミング、縦軸が守られる強さ。点線より上にいるのはフックだけ

上4つは「Claudeに読ませて判断させる」仕組み、フックだけが「Claudeの判断と無関係に動く」仕組み。この線引きが、Claude Codeを安全に長時間走らせるときの設計の軸になります。

## やってみた記録

### 自分の環境のMCPとフックを棚卸しする

まずMCP。セッション内の `/mcp` の代わりに、ターミナルから同じ情報を出せるコマンドがあります。

```bash
claude mcp list
```

```text
Checking MCP server health…

chrome-devtools: npx -y chrome-devtools-mcp@latest - ✔ Connected
obsidian: uvx mcp-obsidian - ✔ Connected
playwright: npx -y @playwright/mcp@latest - ✔ Connected
```

自分の環境には3つのMCPサーバーが繋がっていました。ブラウザ操作が2つ（Chrome DevTools と Playwright）と、ノートアプリ（Obsidian）。全部 stdio 型で、`npx` や `uvx` で手元にプロセスを立てる方式です。第1回の `/context` で見た「70 tools · 0 tokens」の70個は、この3つ（と、デスクトップアプリが持つ連携）のツール定義の合計でした。

用途がかぶっているブラウザ操作の2つは、片方を無効化してもよさそうです。コースの「使っていないサーバーは切れ」を、自分の環境で実感した瞬間でした。

次にフック。`~/.claude/settings.json` を見ると、自分でも忘れていたフックが入っていました。

```json:~/.claude/settings.json（抜粋）
{
  "hooks": {
    "SessionStart":     [{ "matcher": "", "hooks": [{ "type": "command", "command": "node <自作ツール>/hook.js SessionStart" }] }],
    "SessionEnd":       [{ "matcher": "", "hooks": [{ "type": "command", "command": "node <自作ツール>/hook.js SessionEnd" }] }],
    "UserPromptSubmit": [{ "matcher": "", "hooks": [{ "type": "command", "command": "node <自作ツール>/hook.js UserPromptSubmit" }] }],
    "PreToolUse":       [{ "matcher": "", "hooks": [{ "type": "command", "command": "node <自作ツール>/hook.js PreToolUse" }] }]
  }
}
```

以前入れたデスクトップ常駐ツールが、セッションの開始・終了・プロンプト送信・ツール実行前の4イベント全部に、同じスクリプトを違う引数で登録していました。マッチャーが空なので全ツールが対象。つまり **このマシンで Claude Code が何かをするたびに、このスクリプトが必ず走っている**。

コースの「決定論的」という言葉が、ここで急に身近になりました。CLAUDE.md にはこんな指示は一行も無い。でもフックだから毎回動く。しかも `SessionStart` と `SessionEnd` は、コースの5イベントには無いものでした。イベントの種類は増えているので、ここも公式ドキュメントを見に行く必要があります。

### 第2回で作ったチェックを、スキルにする

第2回で `npm run check-images` を作りました。これを毎回思い出して打つのは面倒なので、スキルにします。

```markdown:.claude/skills/check-images/SKILL.md
---
description: 記事が参照している画像に3MB超がないか確認する。公開前・push前に使う
disable-model-invocation: true
---

## 結果
!`npm run check-images 2>&1`

## 指示
上の結果を読んで、超過があればファイル名とサイズを箇条書きで報告し、
`sips -Z 2000 <path>` で縮小する提案をして。超過ゼロなら「問題なし」とだけ答えて。
```

`disable-model-invocation: true` を付けたのは、Claudeが勝手に判断して走らせるものではなく、自分が「公開前に確認したい」ときに `/check-images` と打つものだから。`` !`npm run check-images` `` で実行結果が埋め込まれるので、Claudeは結果を読むところから始められます。

CLAUDE.md にコマンドを書く、スキルにする、フックにする、の3つの違いがこれで見えました。CLAUDE.md は「そういうコマンドがある」と知らせるだけ。スキルは「呼んだら手順つきで動く」。フックは「push前に必ず走る」。同じ `npm run check-images` でも、どこに置くかで意味が変わります。

## 研究者目線のメモ

フックの「決定論的」という言葉が、一番刺さりました。

AIエージェントに何かを守らせたいとき、プロンプトを丁寧に書く方向に頑張りがちです。でも、プロンプトはどこまで行っても「お願い」で、モデルの判断を経由する。本当に守らせたいことは、モデルの外側で、モデルの判断と無関係に動く仕組みに置く。Claude Codeはそれをフックとして分離している。

これは10月に担当する授業の「失敗時の切り分け」の話に直結します。マルチエージェントで事故が起きたとき、原因が「プロンプトの書き方」なのか「そもそも強制すべきことをお願いにしていた」のかを切り分けられないと、修正が的外れになる。「お願いの層」と「強制の層」を最初から分けて設計する、という話は、学生にそのまま持っていけそうです。

## 次回

第5回は修了クイズと、シリーズ全体の振り返り。コースで学んだことを「自分の研究とマルチエージェントの授業にどう使うか」でまとめます。

## 参考

- [Claude Code 101（Anthropic Academy）](https://anthropic.skilljar.com/claude-code-101)
- [Skills - Claude Code Docs](https://code.claude.com/docs/en/skills)
- [MCP - Claude Code Docs](https://code.claude.com/docs/en/mcp)
- [Hooks - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Extend Claude Code - Claude Code Docs](https://code.claude.com/docs/en/features-overview)
