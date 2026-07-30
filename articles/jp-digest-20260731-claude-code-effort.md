---
title: "Claude Code effortとは？5段階の違いと料金の落とし穴"
emoji: "🎛️"
type: "tech"
topics: ["llm", "ai", "claudecode", "anthropic"]
published: false
---

「モデルを選ぶ」のとは別に、「そのモデルにどれくらい考えさせるか」をリクエストごとに決めるツマミが、主要な LLM（大規模言語モデル）に一通り出そろってきました。

Claude では effort、OpenAI では reasoning effort（推論の努力度）、Google Gemini では thinking level（思考レベル）だとか thinking budget（思考の予算）と呼ばれています。名前は違うんですが、狙いはかなり近いです。

**この記事は、Anthropic・OpenAI・Google の公式ドキュメントと、海外の技術メディア・解説記事を複数読み比べて再構成したもの**です。ざっくり言うと、「速いか賢いかを、リクエストごとに選べるようになった」という話なんです。

![モデル選びとは別に、「どれくらい考えさせるか」を決めるツマミが3社に出そろった](/images/jp-digest-20260731-claude-code-effort/figure1.png)
*モデル選びとは別に、「どれくらい考えさせるか」を決めるツマミが3社に出そろった*

## そもそも effort って何を変えてるの？

Claude の effort は、API では `output_config` の中に書きます。ベータヘッダーは不要で、正式機能として扱われています。

```json
{
  "model": "claude-opus-5",
  "max_tokens": 4096,
  "output_config": { "effort": "medium" },
  "messages": [{ "role": "user", "content": "..." }]
}
```

ここで大事なのは、effort が効くのは「思考」だけではないところです。Anthropic の公式ドキュメントでは、**応答に含まれる全トークン**に効くと説明されています。

対象になるのは、本文や説明の文章、ツール呼び出しとその引数、そして thinking（思考）が動いているときの思考部分です。

つまり、thinking を有効にしていなくても effort は効きます。さらに、ツール呼び出しを含む支出全体にも効きます。effort を下げると、単にしゃべる量が減るだけではなく、ツールを呼ぶ回数自体も減るわけです。

公式ドキュメントは、effort を「厳密なトークン予算」ではなく、**行動のシグナル**だと説明しています。低い effort でも、十分に難しい問題ならモデルはちゃんと考えます。ただし、同じ問題を高い effort で解くときよりは短く考える、というニュアンスです。

ツールを使う場面だと違いがかなり見えます。effort が低いと、複数の操作を1回のツール呼び出しにまとめたり、呼び出し回数が減ったり、前置きなしでいきなり作業に入ったりします。終わったあとの報告も簡潔です。

逆に高い effort では、呼び出し回数が増え、作業前に計画を説明し、変更点の詳しいサマリを出し、コードコメントも多めになります。

なので effort は「トークンの蛇口」というより、仕事の進め方そのものを変えるツマミなんですよね。うちの感覚だと、同じ買い物でも「近所のコンビニで済ませる」のか「献立から考えてスーパーを回る」のか、くらい動き方が変わります。

![effort が効くのは思考だけじゃない。ツール呼び出しの回数まで変わる](/images/jp-digest-20260731-claude-code-effort/figure2.png)
*effort が効くのは思考だけじゃない。ツール呼び出しの回数まで変わる*

## 5段階、それぞれ何が違う？

Anthropic の公式ドキュメントでは、Claude の effort は5段階です。

| レベル | 中身 | 向いてる用途 |
|---|---|---|
| `max` | トークン支出に一切の制約をかけない最大能力 | いちばん深い推論と徹底した分析が要るタスク |
| `xhigh` | 長丁場の作業のための拡張 | **30分を超えるような長時間のエージェント作業・コーディング**、数百万トークン規模の予算になるケース |
| `high` | 既定値 | 複雑な推論、難しいコーディング、エージェント作業 |
| `medium` | バランス型 | ほどほどにトークンを節約したいエージェント作業 |
| `low` | いちばん効率がいい。大幅にトークンを減らせるが能力は少し落ちる | サブエージェントなど、速度と安さを優先したい単純なタスク |

ここでまず覚えておきたいのは、**API の既定は `high`** という点です。`effort: "high"` と書くのと、effort を書かないのは、まったく同じ挙動だと公式ドキュメントに明記されています。

もうひとつ、`xhigh` は後から入った新しいレベルです。なので、**`max` に対応していても `xhigh` には対応していないモデルがあります**。対応状況はモデルごとに違います。

公式ドキュメント上、`max` は Claude Fable 5 / Opus 5 / Opus 4.8 / Opus 4.7 / Opus 4.6 / Sonnet 5 / Sonnet 4.6 が対応。`xhigh` は Fable 5 / Opus 5 / Opus 4.8 / Opus 4.7 / Sonnet 5 が対応しています。

![Claude の effort は5段階。既定は high](/images/jp-digest-20260731-claude-code-effort/figure3.png)
*Claude の effort は5段階。既定は high*

![出典: Effort - Claude Platform Docs（https://platform.claude.com/docs/en/build-with-claude/effort）](/images/jp-digest-20260731-claude-code-effort/source1.png)
*出典: Effort - Claude Platform Docs（https://platform.claude.com/docs/en/build-with-claude/effort）*

## 世代で推奨が逆転した（ここが一番の落とし穴）

ここ、けっこう大事です。

Claude Opus 4.7 / Opus 4.8 の公式推奨は、「**コーディングとエージェント作業は xhigh から始めろ**、他の知性が要る作業も最低 high」でした。

ところが Claude Opus 5 では推奨が変わっています。まずは**既定の high から始める**。評価結果を見て、要求の厳しいコーディングやエージェント作業なら `xhigh` に上げる。制約なしでよければ `max` に上げる。そして、**品質が保てると評価で確認できたところでは `low` と `medium` を「トークンコストと応答時間の主要な制御手段として」どんどん使え**、という方向です。

つまり、「上げれば賢い」の時代から、「まず既定で試して、下げられるところは下げる」に振り子が戻った感じです。前のモデル用のチューニングをそのままコピーしてくるのが、一番もったいないやつですね。

公式ドキュメントも、「以前のモデルから effort 設定を引き継いだなら、そのまま使い回さず、自分の評価セットで effort を振り直せ」と釘を刺しています。

Opus 5 では追加の注意もあります。

1つ目。**effort は「応答の長さ」のダイヤルではありません。** effort を変えても、目に見える応答が確実に短くなるわけではありません。長さを変えたいなら、プロンプトで指示します。

2つ目。**Opus 5 では `xhigh` / `max` のとき thinking を無効化できません。** `thinking: {"type": "disabled"}` を送ると 400 エラーになります。

3つ目。**`xhigh` / `max` で走らせるなら `max_tokens` を大きめに取ります。** サブエージェントやツール呼び出しをまたいで考える余地が要るので、64k あたりから始めて調整するのが妥当な出発点、とされています。

参考までに、Claude Opus 5 は 2026年7月24日リリース。料金は入力100万トークンあたり$5、出力100万トークンあたり$25で、これは Opus 4.8 と同額です（VentureBeat, 2026年7月24日）。コンテキストウィンドウは100万トークン、最大出力は12万8千トークン。海外メディアはこの effort 設定を **effort dial（努力度ダイヤル）** と呼び、リクエストごとに推論の深さとコスト・レイテンシを引き換えにできる点を紹介していました。

![出典: VentureBeat（https://venturebeat.com/orchestration/anthropic-launches-claude-opus-5-a-cheaper-ai-model-for-coding-agents-and-enterprise-workflows）](/images/jp-digest-20260731-claude-code-effort/source4.png)
*出典: VentureBeat（https://venturebeat.com/orchestration/anthropic-launches-claude-opus-5-a-cheaper-ai-model-for-coding-agents-and-enterprise-workflows）*

## Claude Code で effort を変える3つの方法

Claude Code では、effort を変える入り口が3つあります。

`/effort` はチャット中に使うコマンドです。打つとスライダーが開きますし、`/effort high` のようにレベル名を直接指定してもOKです。`/effort auto` でモデルの既定に戻せます。

`--effort` は起動時のフラグです。これは**そのセッションだけ**に効きます。

`CLAUDE_CODE_EFFORT_LEVEL` は環境変数です。こちらは**最優先で、全セッションに適用されます**。

優先順位は、**環境変数 ＞ その場で設定したレベル ＞ モデルの既定**です。なお、設定ファイル側の `effortLevel` では `max` は指定できない、という記述もあります。

小ネタですが、環境変数で `CLAUDE_CODE_EFFORT_LEVEL=max` を設定すると `/effort` の表示が `xhigh` になってしまう、という不具合が GitHub の claude-code リポジトリに issue #52781 として上がっています。表示と実挙動がズレて見える場面があるので、環境変数で固定している人は頭の片隅に置いておくとよさそうです。

![Claude Code 側の入り口は3つ。環境変数がいちばん強い](/images/jp-digest-20260731-claude-code-effort/figure4.png)
*Claude Code 側の入り口は3つ。環境変数がいちばん強い*

## 他社はどうやってる？名前は違うけど発想は同じ

### OpenAI（reasoning effort ＝ 推論の努力度）

OpenAI は `reasoning.effort` です。公式ドキュメントに載っているレベルは、`none` / `minimal` / `low` / `medium` / `high` / `xhigh` / `max` の7つ。ただし、モデルによってはこのうち一部しかサポートしない、と明記されています。

GPT-5.5 も GPT-5.6 も、省略時の既定は `medium` です。

用途の目安は、`none` が推論の恩恵がないレイテンシ最優先タスク、`low` がツール利用・計画・検索・複数ステップの判断を速度とコスト優先でやりたいとき、`medium` が計画・複雑な推論・判断の既定、`high` が難しい推論や複雑なデバッグ、深い計画。`xhigh` はディープリサーチ、非同期のワークフロー、長時間走るエージェント、`max` はいちばん複雑なタスク向けの最大推論です。

お金の話では、**推論トークンは API から中身が見えない。でもコンテキストウィンドウは食うし、出力トークンとして課金される**のが大事です。数はレスポンスの `usage` の `output_tokens_details` に入ります。OpenAI は、試し始めるときは推論と出力用に最低25,000トークンを確保しておくことをすすめています。

### Google Gemini（thinking level / thinking budget）

Gemini 3.x 以降は **thinking level** です。値は `MINIMAL` / `LOW` / `MEDIUM` / `HIGH` の4段階で、既定は全 Gemini 3.x モデルで `LOW`。そして **Gemini 3.x 以降は思考をオフにできません**。

Gemini 2.5 系は段階ではなく、**thinkingBudget（思考の予算）＝トークン数**で指定します。2.5 Pro は既定8,192／最小128／最大32,768で無効化不可。2.5 Flash は既定8,192／最小1／最大24,576で、0を入れれば無効化。2.5 Flash-Lite は既定0／最小512／最大24,576です。`-1` を入れると動的思考、つまりモデルが自分で判断し、上限8,192トークンになります。

**思考トークンの料金はテキスト出力トークンと同じ**です。数はレスポンスの `thoughtsTokenCount` で取れます。

### 読み比べて見えてくること

流れとしては、「トークン数で予算を切る」方式から、「段階名で指示する」方式へ移っているように見えます。Gemini 2.5 系は前者、Claude の effort や Gemini 3.x の thinking level は後者です。Anthropic も以前は `budget_tokens` というトークン数指定を持っていましたが、いまは effort に一本化しています。

数字で切るのは気持ちいいんですが、タスクの難しさって事前には分かりません。だったら「このくらいの本気度でやって」と伝えて、あとはモデルに配分させるほうが実用的だった、というわけです。

ただし**既定値は3社バラバラ**です。Claude は `high`、OpenAI は `medium`、Gemini 3.x は `LOW`。何も指定せずに乗り換えると、体感も請求額もぜんぜん違います。ここは移行時に必ず見たいところです。

![パラメータ名も段階数も既定値も、3社バラバラ](/images/jp-digest-20260731-claude-code-effort/figure5.png)
*パラメータ名も段階数も既定値も、3社バラバラ*

![出典: Reasoning models - OpenAI API（https://developers.openai.com/api/docs/guides/reasoning）](/images/jp-digest-20260731-claude-code-effort/source2.png)
*出典: Reasoning models - OpenAI API（https://developers.openai.com/api/docs/guides/reasoning）*

![出典: Gemini thinking - Gemini API Docs（https://ai.google.dev/gemini-api/docs/thinking）](/images/jp-digest-20260731-claude-code-effort/source3.png)
*出典: Gemini thinking - Gemini API Docs（https://ai.google.dev/gemini-api/docs/thinking）*

## 知らないとハマるやつ：effort を途中で変えるとキャッシュが飛ぶ

これが一番の実務上の罠かもしれません。

`output_config.effort` は**リクエスト単位**の設定です。次のリクエストで別の値を渡せば、その先は新しい effort で動きます。

ただし、**effort はレンダリングされるプロンプトの形そのものを変えます**。なので、リクエスト間で effort を変えると、それ以前のキャッシュ済みプレフィックスは再利用されません。

Anthropic の Best practices には、「長いセッションでプロンプトキャッシュに頼っているなら、**最初に effort を決めて、一定に保て**」と書かれています。会話の途中で変えるのではなく、ワークロード単位で変える、という考え方です。

海外の解説記事では、`high` から `low` に落として出力トークンを40%減らしたのに、キャッシュが失効したせいでそのリクエストは結局38%高くついた、というシナリオが紹介されています。

これは**実測値ではなくシナリオ上の試算**です。その記事の筆者自身も、ベンダー公表のベンチマーク値は独自検証していないと明記しています。それでも、「節約したつもりが高くつく」経路があることは、公式ドキュメントの記述とちゃんと噛み合っています。

途中でツマミをいじるのは、料理の途中で鍋を替えるようなものです。できなくはないけど、洗い物も増えるし、だいたい思ったより面倒になります。

![「節約したつもりが高くつく」経路がちゃんと存在する](/images/jp-digest-20260731-claude-code-effort/figure6.png)
*「節約したつもりが高くつく」経路がちゃんと存在する*

## 結局どう決めればいい？

1. **まず既定のまま走らせて、自分の評価セットを作る。**  
   世代をまたいで effort 設定をコピーしないのが第一歩です。Opus 4.8 で `xhigh` がベストだったからといって、Opus 5 でもそうとは限らない、というのは公式ドキュメント自身が言っていることです。

2. **下げるのは、サブエージェント・分類・単純な調べもの。上げるのは、長時間の自律作業。**  
   公式ドキュメントが `xhigh` の例として挙げているのは「30分を超えるようなエージェント作業」です。数分で終わる作業に `xhigh` を張るのは、たぶん払いすぎです。

3. **1つの会話の中で effort をコロコロ変えない。**  
   キャッシュが飛びます。変えるなら、会話の途中ではなくワークロード単位で分けるのが安全です。

4. **`xhigh` や `max` を使うなら、先に `max_tokens` を上げておく。**  
   64k あたりから始めて調整します。ここをケチると、考えている途中で出力が切れます。

モデル名の比較はどうしても話題になりがちですが、同じモデルの中にも、もうひとつ大きなツマミが増えています。日々の請求額に効いてくるのは、むしろこちらかもしれません。まずは既定、測って、下げられるところを下げる。これくらいの温度感で付き合うのがよさそうです。

## 参考にした記事

- [Effort - Claude Platform Docs（Anthropic 公式）](https://platform.claude.com/docs/en/build-with-claude/effort)
- [Reasoning models - OpenAI API（OpenAI 公式）](https://developers.openai.com/api/docs/guides/reasoning)
- [Thinking - Firebase AI Logic（Google 公式）](https://firebase.google.com/docs/ai-logic/thinking)
- [Gemini thinking - Gemini API Docs（Google 公式）](https://ai.google.dev/gemini-api/docs/thinking)
- [Anthropic launches Claude Opus 5, a cheaper AI model for coding, agents and enterprise workflows（VentureBeat）](https://venturebeat.com/orchestration/anthropic-launches-claude-opus-5-a-cheaper-ai-model-for-coding-agents-and-enterprise-workflows)
- [What is /effort Command in Claude Code（ClaudeLog）](https://claudelog.com/faqs/what-is-slash-effort-command/)
- [Claude Code の「Effort」設定の使い分け（note / ザンル）](https://note.com/zanru/n/n08d60ff0bbc6)
- [Claude Opus 5 effort levels and real cost（Hashnode）](https://hashnode.com/blog/claude-opus-5-effort-levels-cost)
- [/effort displays 'xhigh' instead of 'max' when CLAUDE_CODE_EFFORT_LEVEL=max is set via env var（GitHub Issue #52781）](https://github.com/anthropics/claude-code/issues/52781)
