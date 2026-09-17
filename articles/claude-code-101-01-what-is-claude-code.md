---
title: "公式コース「Claude Code 101」を1日で完走したので、全12レッスンを日本語でまとめる"
emoji: "🧭"
type: "tech"
topics: ["claudecode", "ai", "aiagent", "anthropic", "mcp"]
published: true
---

Anthropic（アンソロピック／Claudeの開発元）が無料で公開している学習コース「Claude Code 101」を、1日で最後まで受講して修了クイズまで通しました。コースは英語だけなので、「英語のコースはちょっと……」という人の入口になるように、全12レッスンの要点と、自分の手元で試した結果を1本にまとめます。

![](/images/claude-code-101-01-what-is-claude-code/figure01.png)
*全12レッスンを、仕組み→日常の型→記憶→拡張→やってみた、の順に1ページで*

**この記事で分かること**

- Claude Codeが「チャット」と何が違うのか（エージェントループとハーネス）
- 毎日の使い方の型：探索→計画→実装→コミット、コンテキストの管理
- CLAUDE.md・サブエージェント・スキル・MCP・フックの違いと使い分け
- Planモードで実際に1機能を計画・実装・検証した記録（コード付き）
- コースの説明と、いまの製品の挙動がズレている4か所

| 項目 | 内容 |
| --- | --- |
| コース | [Claude Code 101](https://anthropic.skilljar.com/claude-code-101)（Anthropic Academy） |
| 料金 | 無料。修了すると証明書が出る |
| 分量 | 5セクション・12レッスン＋クイズ。ほぼ全部が3〜5分のテキスト |
| 所要時間 | 読むだけなら1時間弱。手を動かしても1日 |
| 注意 | Claude Code本体を動かすには **有料プラン（Pro以上）かAPI（プログラムからClaudeを呼び出す窓口）の利用料** が必要。無料プランでは使えない |

:::message
コースの翻訳ではありません。コースと[公式ドキュメント](https://code.claude.com/docs/en/overview)で学んだことを、自分の言葉と手元の実験で組み直しています。クイズの問題は載せません。
:::

## 1. Claude Codeとは：チャットではなくエージェント

一言で言うと、**コードを読んで、書き換えて、コマンドを実行してくれるAIエージェント** です。チャット版のClaudeとの違いは「答えを返す」で終わらないこと。自分でファイルを開き、検索し、編集し、テストを走らせて、結果を見てまた直します。

![](/images/claude-code-101-01-what-is-claude-code/figure03.png)
*コピペで往復するか、Claudeが自分で中に入って作業するか*

コースの定義では、エージェントとは **環境とやり取りしながら、決められたゴールに向けて行動するソフトウェア**。中身は「大規模言語モデルをループの中で回している」だけで、そこにツールや外部サービス、別のエージェントを繋ぐことで手を動かせるようになります。

### エージェントループ

仕事を頼むと、内部では3つのフェーズを回しています。

1. **文脈を集める**：関係するファイルを探して読む
2. **行動する**：ファイルを編集する、コマンドを実行する
3. **結果を確かめる**：テストを回す、出力を読む。足りなければ1に戻る

![](/images/claude-code-101-01-what-is-claude-code/figure02.png)
*集める→動く→確かめる。終わっていなければ最初に戻り、途中でいつでも割り込める*

ここで大事なのは、**モデル自身はファイルを触れない** こと。モデルが返すのは「テキスト」か「ツール呼び出し（このファイルを読んで、という依頼）」のどちらかで、それを実行して結果をモデルに戻すのがClaude Code側の仕事です。公式ドキュメントはこの外側の仕掛けを **エージェントハーネス** と呼びます。ハーネスは馬具や安全帯の意味。モデル（Sonnet、Opusなど。`/model` で切り替え可）が頭脳で、Claude Codeは道具・作業場・安全装置を装着する枠組み、という関係です。

組み込みツールは5分類あります。

| 分類 | できること |
| --- | --- |
| ファイル操作 | 読む、編集する、新規作成する |
| 検索 | パターンでファイルを探す、正規表現で中身を検索する |
| 実行 | シェルコマンド、テスト、git |
| Web | 検索、ドキュメント取得 |
| コード理解 | 編集後の型エラー確認、定義ジャンプ（プラグインが必要） |

### 使う前に押さえる3つ

![](/images/claude-code-101-01-what-is-claude-code/figure04.png)
*コースが最初に強調していた3点*

1. **コンテキストウィンドウ**（Claudeの作業記憶）には上限がある。だからコードベース全部を読み込まず、必要な場所を「探して」読む
2. **許可を求めてくる**。コースの説明では、既定で編集やコマンド実行の前に聞いてくる（いまはプランによって既定が違う。次の節で）。手綱はこちらが握っている
3. **間違える**。意図の取り違え、バグ、作り込みすぎ、どれも起きる。だからループの中に自分が居続ける

## 2. 最初の一歩：インストールと権限モード

macOS / Linux / WSL（Windows上のLinux環境）はこれ一発です。

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

プロジェクトのディレクトリで `claude` と打てば起動。初回はブラウザでログインします。動く場所はターミナルのほかに、IDE（統合開発環境）拡張、デスクトップアプリ、Web（claude.ai/code）があり、中身のエンジンは同じ。コースの助言は「新機能が一番早いのはターミナル、裏で走らせたいならデスクトップ、手元にリポジトリが無いならWeb」でした。

最初のプロンプトは「コードを書かせる」ではなく **「プロジェクトについて聞く」** がお勧めです。日本語で通じます。

```text
このプロジェクトは何をしている？
```

こちらがファイルを指定しなくても、勝手に読んで答えます。ループの「文脈を集める」が動いているわけです。

### 権限モード：コースは3つ、製品は4つ

`Shift+Tab` で切り替えます。

| モード | 挙動 |
| --- | --- |
| Auto | 分類器が裏で危険な操作だけ止める。Pro/Max/Teamプランでは既定 |
| Manual | ファイル編集とコマンド実行の前に毎回聞いてくる |
| Accept edits | ファイル編集は聞かずにやる。それ以外のコマンドは聞く |
| Plan | 探索と計画だけ。ソースは触らない |

![](/images/claude-code-101-01-what-is-claude-code/figure05.png)
*コースの3モードと、公式ドキュメントの4モード。Autoが増えている*

コースの本文にはAutoが出てきません。手元の画面下には最初から `auto mode on` と出ていました。製品がコースを追い越している最初の例で、以後ずっと **迷ったらドキュメントを正とする** が合言葉になります。

![](/images/claude-code-101-01-what-is-claude-code/figure06.png)
*Shift+Tabを押すたびに画面下の表示が変わる。実行結果をもとに整形した再現画像*

もう一つの安全装置が **チェックポイント**。ファイルを編集する前に元の中身を必ず保存しているので、`Esc` を2回押せば巻き戻せます。gitとは別の仕組みで、コミット前でも戻せる。ただしデータベースや外部APIへの操作は戻せません。

## 3. 日常の型：探索→計画→実装→コミット

コース自身が「1つだけ持ち帰るならこれ」と言い切っている型です。多くの人は最初から「コード書いて」と頼むから、後で軌道修正が増える。サッカーで言えば、ボールを受けた瞬間にシュートを打つな、まず顔を上げろ、です。

![](/images/claude-code-101-01-what-is-claude-code/figure07.png)
*探索→計画→実装→コミット。終わったら次の機能でもう一周*

### 探索と計画はPlanモードでまとめてやる

Planモードでは、Claudeは **ファイルを編集できず、読むだけ** になります。この状態で「どこを変えるか、新しい依存が要るか、どう進めるか考えて」と投げると、関係ファイルを読み、必要ならWeb検索もして、確認の質問をはさみつつ行動計画を返してきます。

![](/images/claude-code-101-01-what-is-claude-code/figure08.png)
*Planモードの流れ。承認するまでコードは1行も書かれない*

気に入らなければ「この部分だけ直して」と言えばいい。**コードが1行も書かれていないので、方向転換しても失うものがゼロ**。コースはここを「軌道修正が一番安い場所」と呼んでいました。

実装をなめらかにするコツは3つ。

1. **成功の条件を決める**。「正しい」が何かを明示しないと、Claudeは自信を持って終われない
2. **ツールを足す**。WebのUIならブラウザ操作の拡張を入れて、直接テストさせる
3. **テストを用意する**。ただし渡す前に、そのテスト自体が正しいか（偽陽性＝本当は壊れているのに通ってしまう、がないか）を確認する

### コミットの前に「新しい目」

自分でテストして納得したら、コミット前に **別のエージェント（サブエージェント）にレビューさせる**。別のコンテキストで動くので、長いセッションの中でメインのエージェントが持ってしまった思い込みを引きずりません。

![](/images/claude-code-101-01-what-is-claude-code/figure09.png)
*作った本人ではなく、初めて読む係に見せる*

gitまわりの小技を2つ。`/commit-push-pr` はコミット・プッシュ・PR（プルリクエスト／変更をレビューしてもらう依頼）作成を1コマンドで。`claude --from-pr <番号>` は、そのPRに紐づいたセッションを後から再開できます。

## 4. コンテキスト管理：溢れたら何が起きるか

コンテキストはClaudeの作業記憶で、読んだファイル、実行したコマンド、メッセージ、ツールの結果、すべてがここに積まれます。上限に近づくと自動で **圧縮（compaction）** が走り、重要な部分は要約、不要なツール結果は削除。ここで **細部が失われることがある** とコースは明言しています。

![](/images/claude-code-101-01-what-is-claude-code/figure10.png)
*積み上がって、溢れそうになると要約される。ZIPと違って元には戻らない*

| コマンド | 何をする | いつ使う |
| --- | --- | --- |
| `/compact` | ここまでを手動で圧縮。記憶は要約として残す | 同じ機能を作っていて上限が近い |
| `/clear` | 全部消す | 新しい機能に移る。前の会話の先入観を持ち込みたくない |
| `/context` | 何がどれだけ使っているかを見る | いつでも |

節約のコツは3つ。

- **具体的に書く**。曖昧なプロンプトは、Claudeが自力で探索する分だけ結果的に高くつく
- **MCPサーバーを整理する**。MCPは外部ツールを繋ぐ規格（7節）。これはコースの説明で、現状は少し違う（後述）
- **サブエージェントに任せる**。別の窓で動いて要約だけ返す（6節）

実際に `/context` を打った結果がこれです。

![](/images/claude-code-101-01-what-is-claude-code/figure11.png)
*会話を始める前から約40kトークン（トークンは文章を数える単位）が固定費で埋まっている。実行結果をもとに整形した再現画像*

| 項目 | トークン |
| --- | --- |
| System tools（ツールの定義） | 25.5k |
| Messages（会話そのもの） | 8k |
| Memory files（自動メモリ + CLAUDE.md） | 7.6k |
| System prompt | 4.2k |
| Skills（24個の説明文だけ） | 3.3k |
| MCP tools（70個） | **0** |

ハーネスの実体は、この固定費です。そして **MCPツール70個で0トークン**。これは後でもう一度出てきます。

## 5. CLAUDE.md：消えない記憶の置き場所

会話で言っただけの指示は、圧縮でいつか消えます。消えてほしくないことを置く場所が CLAUDE.md。プロジェクト直下に置くMarkdownで、セッション開始時に毎回自動で読まれます。コースの言い方では **「コードベースのオンボーディング資料（新人向け説明書）」**。

```markdown:CLAUDE.md
# プロジェクト
Next.js 15 のアプリ。App Router、Tailwind、Drizzle ORM を使用。

# コマンド
- 開発サーバー: `pnpm dev`
- テスト: `pnpm test`

# コードスタイル
- インデントは2スペース
- APIルートは全部 app/api/ に置く
```

ポイントは **検証できる具体さ** で書くこと。「きれいに書いて」ではなく「2スペース」。

### 置き場所は6段ある

コースが紹介するのは「プロジェクト用」と「ユーザー用」の2つですが、公式ドキュメントでは6段あります。

| 段 | 場所 | パス | 効く範囲 | 読み込み |
| --- | --- | --- | --- | --- |
| 1 | 組織ポリシー | `/Library/Application Support/ClaudeCode/CLAUDE.md`（macOS） | そのマシンの全員 | 起動時 |
| 2 | ユーザー | `~/.claude/CLAUDE.md` | 自分の全プロジェクト | 起動時 |
| 3 | プロジェクト | `./CLAUDE.md` または `./.claude/CLAUDE.md` | そのリポジトリ。gitで共有 | 起動時 |
| 4 | ローカル | `./CLAUDE.local.md` | そのリポジトリ、自分だけ | 起動時 |
| 5 | サブディレクトリ | `<subdir>/CLAUDE.md` | その配下 | 配下のファイルを読んだとき |
| 6 | ルール分割 | `.claude/rules/*.md` | `paths:` 指定のファイルだけ | 該当ファイルを読んだとき |

![](/images/claude-code-101-01-what-is-claude-code/figure12.png)
*上書きではなく連結。上から順に貼られ、起動した場所に近いものほど後に読まれる*

そして大事な事実。**プロジェクト直下の CLAUDE.md は `/compact` の後に再読み込みされます**。会話の指示は消えるが、CLAUDE.md の指示は戻ってくる。

![](/images/claude-code-101-01-what-is-claude-code/figure13.png)
*消える記憶と、消えない記憶*

コースのコツは3つ。

- 同じ注意を2回したら「このルールを保存して」と頼む
- `@README.md` のように `@` + パスで文書を取り込める
- **最初は無しで始める**。どこで何度も軌道修正が要るかを見てから書けば太らない

準備できたら `/init` で叩き台を生成できます。公式の目安は1ファイル200行以内で、「コードから分かること（ディレクトリ構成や依存一覧）は書かない」。

コースに無い話を一つ。いまのClaude Codeには **自動メモリ** があります。Claudeが「次も役立つ」と判断したことを、自分で `~/.claude/projects/<project>/memory/` に書き留める仕組みです。CLAUDE.md は人が書く指示、自動メモリはClaudeが書く学び。`/memory` で両方を一覧できます。

## 6. サブエージェント：別の窓で働く分身

Claudeは「このコードベースを探索して」のような仕事をサブエージェントに委任できます。サブエージェントは **自分専用のコンテキストウィンドウ** で走り、探索を全部やって、終わったら **要約だけ** を返します。

![](/images/claude-code-101-01-what-is-claude-code/figure14.png)
*渡るのは依頼文と要約だけ。途中の大量のツール呼び出しは親には見えない*

答えは手に入るのに、そこに至る道のりでメインのコンテキストが散らからない。3節の「新しい目」も同じ仕組みです。代わりに、サブエージェントがどう結論に至ったかは見えなくなります。

作るのは `/agents` →「Create new agent」が一番簡単。スコープ、目的、使えるツール、モデル、色を聞かれて、名前・説明・プロンプトを生成してくれます。実体はYAML（ヤムル）フロントマター（先頭の設定部分）付きのMarkdownです。

```markdown:.claude/agents/code-reviewer.md
---
name: code-reviewer
description: 変更されたコードをレビューして問題点を指摘する。コミット前に使う
tools: Read, Grep, Glob, Bash
model: sonnet
---

あなたはコードレビュアーです。指摘はしますが、ファイルは編集しません。

1. `git diff` で変更箇所を確認する
2. バグ・エラー処理漏れ・ハードコード・未テストの箇所を探す
3. 重要度順に、ファイル名と行番号付きで指摘を列挙する
```

![](/images/claude-code-101-01-what-is-claude-code/figure15.png)
*tools に Edit と Write が無い。だから指摘はできるが直せない*

`tools` に Edit や Write を入れていないので、このレビュアーは直せません（Bash は `git diff` 用。厳密に読み取り専用にしたいなら外してもよい）。`description` は同時に「いつ呼ぶべきか」をメインのClaudeに教える役割も持ちます。`.claude/agents/` に置いてコミットすれば、チーム全員が同じレビュアーを使えます。

この記事の図解も、実は学習用のセッションとは別に起動したサブエージェントに作らせました。渡したのは「この節に、こういう役割の図を作って入れて」という依頼文だけ。返ってくるのは「何を作ってどこに入れたか」の要約だけで、途中で何十回ツールを呼ぼうが、学習側のコンテキストは汚れませんでした。

## 7. スキル・MCP・フック

### スキル：呼んだときだけ読まれる手順書

コースのスキルのレッスンは動画のみだったので、ここは公式ドキュメントをもとに書きます。`SKILL.md` に手順を書いておくと、`/スキル名` で呼ぶか、関係しそうなときにClaudeが自動で読み込みます。CLAUDE.md との違いはただ一点、**使うときだけ読み込まれる** こと。前述の「Skills: 24個で3.3k」は、説明文だけが常駐している状態でした。

![](/images/claude-code-101-01-what-is-claude-code/figure16.png)
*普段は付箋（説明文）だけ。呼ばれたら本が開く*

```markdown:~/.claude/skills/summarize-changes/SKILL.md
---
description: 未コミットの変更を要約して、リスクを指摘する
---

## 今の変更
!`git diff HEAD`

## 指示
上の変更を2〜3行で要約し、リスク（エラー処理漏れ・ハードコード・未テスト）を列挙して
```

`` !`コマンド` `` は、Claudeが読む前にコマンドが実行されて結果が埋め込まれる仕組みです。置き場所は個人用が `~/.claude/skills/<名前>/`、プロジェクト用が `.claude/skills/<名前>/`。危ない操作には `disable-model-invocation: true` を付けると、自分からしか呼べなくなります。

### MCP：外部ツールを繋ぐ規格

MCP（Model Context Protocol／モデル・コンテキスト・プロトコル）は、Claude Codeを外部のツールやデータに接続するためのオープンな標準規格。課題管理ツール、データベース、ドキュメントサイトなど、コードベースの外にある文脈を直接読み書きできるようにします。

![](/images/claude-code-101-01-what-is-claude-code/figure17.png)
*繋ぎ方は遠隔のHTTPと、手元でプロセスを立てるstdio（標準入出力）の2種類*

```bash
claude mcp add --transport http linear https://mcp.linear.app/mcp
claude mcp list
```

スコープは3つ。Local（今のプロジェクト・自分だけ）、User（自分の全プロジェクト）、Project（`.mcp.json` をコミットしてチームで共有）。

コースの強調点はコストでした。MCPサーバーは使っていなくてもツール定義をコンテキストに載せる。だから使っていないサーバーは切る、CLI（コマンドラインツール。GitHubの `gh` など）で済むならCLIの方が軽い、と。ツール定義がコンテキストの10%を超えると、必要なツールだけをその場で探す「ツール検索モード」に自動で切り替わる、とも書かれています。

ただし4節で見たとおり、手元では70個で0トークンでした。いまはこのツール検索が最初から既定になっています（10節）。「使っていないサーバーは切る」は今も正しい習慣ですが、切迫度はだいぶ下がりました。

### フック：必ず実行される

コースの最初の一文が結論です。**フックは決定論的。つまり、必ず実行される。**

CLAUDE.md に「編集のたびにフォーマッターを実行して」と書けば、たいていやってくれます。でも、たまにやらない。フックなら毎回、例外なく実行されます。

![](/images/claude-code-101-01-what-is-claude-code/figure18.png)
*お願い（たいてい守る）と、仕組み（必ず動く）*

| イベント | いつ |
| --- | --- |
| `PreToolUse` | ツール呼び出しの前。ここで止められる |
| `PostToolUse` | ツール呼び出しの完了後 |
| `UserPromptSubmit` | プロンプト送信時 |
| `Stop` | Claudeが応答を終えたとき |
| `Notification` | 通知を送るとき |

`PreToolUse` は終了コードで挙動が決まります。

![](/images/claude-code-101-01-what-is-claude-code/figure19.png)
*0なら続行、2ならブロックして理由をClaudeに返す、それ以外は表示だけ*

:::details 例1：編集後に自動フォーマット（PostToolUse）
フックは対象ツールの入力をJSONで標準入力から受け取ります。`jq`（JSONを加工するコマンド）でファイルパスを取り出してフォーマッターに渡します。

```json:.claude/settings.json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          { "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write" }
        ]
      }
    ]
  }
}
```
:::

:::details 例2：rm -rf をブロック（PreToolUse）
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
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-rm-rf.sh" }
        ]
      }
    ]
  }
}
```
`.claude/settings.json` はコミットできるので、チーム全員が同じフックを持てます。
:::

コースの締めの一文が全てです。**毎回、絶対に起きてほしいことは、プロンプトに書くな。フックに書け。**

## 8. 5つの拡張を一枚で

| 仕組み | コンテキストに載るタイミング | 守られる強さ | 向いている中身 |
| --- | --- | --- | --- |
| CLAUDE.md | 毎セッション、常に | お願い（たいてい守る） | 事実・規約・「常にXしろ」 |
| スキル | 呼んだときだけ | お願い | 手順・複数ステップの作業 |
| サブエージェント | 別の窓（親には要約だけ） | お願い | まっさらな目が要る仕事・探索 |
| MCP | 定義は常駐（いまは必要時読み込み） | お願い | 外部ツール・データ |
| フック | 載らない（シェルで実行） | **強制（必ず動く）** | 絶対に起きてほしいこと |

![](/images/claude-code-101-01-what-is-claude-code/figure20.png)
*上4つは「Claudeに読ませて判断させる」、フックだけが「Claudeの判断と無関係に動く」*

同じ `npm test` でも、CLAUDE.md に書けば「そういうコマンドがあると知らせる」、スキルにすれば「呼んだら手順付きで動く」、フックにすれば「コミット前に必ず走る」。どこに置くかで意味が変わります。

## 9. やってみた：Planモードで1機能を計画→実装→検証

題材は実際に困っていたことにしました。Zennは画像1枚3MBまでで、超えるとリポジトリ全体のデプロイが止まります。公開前に機械的にチェックしたい。

Planモードにして、**成功の条件を1行足した** プロンプトを投げます。

```text
articles/ 配下の記事が参照している images/ の画像に3MBを超えるものがないかチェックするスクリプトを追加したい。
成功の条件: npm run check-images で超過ファイルのパスとサイズが1行ずつ出て、超過ゼロなら終了コード0。
どこに置くか、新しい依存が要るか、どう進めるかの計画だけ出して。
```

返ってきた計画の要点はこうでした。

- **探索で分かったこと**：`package.json` が無い。Node v24がある。だから標準モジュールだけで書けて **新しい依存はゼロ**。画像参照は2パターンだけで、いまの最大画像は2.88MBと上限すれすれ
- **設計**：参照先の画像が存在しない場合は **警告だけで終了コードに影響させない**。成功条件が「超過ゼロなら0」なので、欠損は別問題
- **検証手順**：しきい値を一時的に2MBに下げて、超過が出て終了コードが1になることを確かめてから戻す
- **やらないこと**：自動圧縮、孤立画像の検出、CI（継続的インテグレーション／自動テストの仕組み）への組み込み

![](/images/claude-code-101-01-what-is-claude-code/figure21.png)
*プロンプト→探索→計画→承認の選択肢。コードを見る前に「直す」を選べる。実行結果をもとに整形した再現画像*

コードは1行も書かれていないのに、「依存ゼロ」「欠損は警告止まり」「見逃しを潰す検証」まで決まっている。こちらが書いたのは成功条件の1行だけです。承認して実装させた結果がこれ。

:::details scripts/check-images.mjs と package.json
```json:package.json
{
  "private": true,
  "scripts": {
    "check-images": "node scripts/check-images.mjs"
  }
}
```

```js:scripts/check-images.mjs
// articles/ 配下の記事が参照している images/ の画像に 3MB 超がないか確認する。
// 使い方: npm run check-images
// 終了コード: 超過 0 件 → 0 / 1 件以上 → 1（参照先が無い画像は警告のみ）
import { readdirSync, readFileSync, statSync, existsSync } from "node:fs";
import { join, resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const REPO = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const LIMIT_BYTES = 3 * 1024 * 1024;
const RAW_PREFIX = /^https:\/\/raw\.githubusercontent\.com\/Appare7\/zenn-content\/[^/]+\/images\//;

const articlesDir = join(REPO, "articles");
const refs = new Map(); // 画像の絶対パス → 最初に参照した記事

for (const name of readdirSync(articlesDir).filter((f) => f.endsWith(".md"))) {
  const md = readFileSync(join(articlesDir, name), "utf8");
  for (const m of md.matchAll(/!\[[^\]]*\]\(([^)]+)\)/g)) {
    let target = m[1].trim().split(/\s+/)[0]; // "=300x" などの幅指定を捨てる
    if (target.startsWith("/images/")) target = join(REPO, target);
    else if (RAW_PREFIX.test(target)) target = join(REPO, "images", target.replace(RAW_PREFIX, ""));
    else continue; // それ以外の外部 URL は対象外
    if (!refs.has(target)) refs.set(target, name);
  }
}

let over = 0;
for (const [file, article] of refs) {
  if (!existsSync(file)) {
    console.error(`missing: articles/${article} -> ${file.replace(REPO, "")}`);
    continue;
  }
  const bytes = statSync(file).size;
  if (bytes > LIMIT_BYTES) {
    over++;
    console.log(`${file.replace(REPO + "/", "")}  ${(bytes / 1024 / 1024).toFixed(2)} MB (${bytes} bytes)`);
  }
}
console.error(`checked ${refs.size} images, ${over} over limit`);
process.exit(over > 0 ? 1 : 0);
```
:::

```text
$ npm run check-images; echo "exit=$?"
missing: articles/（書きかけの記事） -> /images/（まだ生成していない画像）
checked 605 images, 0 over limit
exit=0
```

超過ゼロで終了コード0。書きかけの記事が参照している未生成の画像には、計画どおり警告だけが出ました。しきい値を2MBに下げると `121 over limit` / `exit=1`。「超過があれば非0」の側も確認できたので、計画に書いてあった検証手順をなぞるだけで終わりました。

ついでに3つ。

- **CLAUDE.md を後から作った**。「slug（スラッグ／記事URLになるファイル名）は12〜50文字」「画像は3MB以下」「公開は1日1本」など、過去にデプロイが止まって学んだ **コードのどこにも書いていない罠** を中心に25行ほどで。`ls` すれば分かることは最小限にする
- **フックの棚卸し**。`~/.claude/settings.json` を見たら、以前入れた常駐ツールが4つのイベント（うち2つは `SessionStart` / `SessionEnd`）に同じスクリプトを登録していました。つまりこのマシンでClaude Codeが何かするたびに必ず走っている。「決定論的」が急に身近になった瞬間です。この2つのイベントは、コースの5イベントには無いものでした
- **チェックをスキルにした**。`` !`npm run check-images 2>&1` `` を埋め込んだ `/check-images` スキルを登録しました。公開前に自分で呼ぶものなので、`disable-model-invocation: true` を付けてClaudeに勝手に走らせない

## 10. コースと製品のズレ

受講中に何度も「コースにはこう書いてあるが、手元ではこうだった」が出てきました。

| コースの記述 | 手元の製品 |
| --- | --- |
| 権限モードは3つ | 4つ（Autoが追加） |
| MCPは全ツールを常駐させる。10%を超えたらツール検索モードに切り替わる | 最初から必要時読み込みで、70個が0トークン |
| フックのイベントは5つ | `SessionStart` / `SessionEnd` などが追加 |
| 記憶は CLAUDE.md | 自動メモリも併存 |

![](/images/claude-code-101-01-what-is-claude-code/figure22.png)
*コースの説明と、手元で見えた挙動の対比*

製品の進化がコースを追い越すのは、この分野では普通のことです。ズレを見つけるたびに公式ドキュメントを開く癖がつくので、むしろ良い教材でした。

## 11. まとめ：クイズと、持ち帰る3つ

最後はクイズ1本。全問正解で修了しました。各レッスン末尾の「Recap（まとめ）」がほぼそのまま出題範囲なので、Recapを自分の言葉で言い直せるなら通ります。

学び方で効いたのは2つ。**英語を読む前に日本語の要約を先に見る**（初見の概念を英語で読むより、読む速度が体感で3倍違う）。そして **実験は自分のリポジトリでやる**（自分の困りごとが題材だと、出てきた計画が本当に使えるかを自分で判定できる）。

自分は大学院でAIエージェントを研究していて、10月には学生向けに「マルチエージェントでチームを組む」授業を担当します。このコースから持っていくのは3つです。

1. **役割分担はコンテキストの分離である**。プロンプトで役割を書き分けるだけでは足りない。別の窓で、要約だけを渡す設計にして初めて「新しい目」が生まれる。何を共有 **しない** かを先に決める
2. **お願いの層と強制の層を分ける**。絶対に起きてほしいことは、モデルの判断を経由しない仕組みに置く。失敗したとき、どちらの層の問題かを切り分ける
3. **計画は一番安い軌道修正**。コードを書く前に計画を出させて、成功の条件を人間が1行足す

![](/images/claude-code-101-01-what-is-claude-code/figure23.png)
*コースから授業に持っていく3つ*

## 次に受けるコース

1. **Introduction to subagents**：サブエージェントの専門コース
2. **Claude Code in Action**：放置しても信頼できる長いセッションの作り方
3. **Introduction to Model Context Protocol**：MCPサーバーを自分で作る

これも1コース1記事でまとめていきます。

## 参考

- [Claude Code 101（Anthropic Academy）](https://anthropic.skilljar.com/claude-code-101)
- [Claude Code Docs](https://code.claude.com/docs/en/overview)：[How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works) / [Memory](https://code.claude.com/docs/en/memory) / [Subagents](https://code.claude.com/docs/en/sub-agents) / [Skills](https://code.claude.com/docs/en/skills) / [MCP](https://code.claude.com/docs/en/mcp) / [Hooks](https://code.claude.com/docs/en/hooks)
