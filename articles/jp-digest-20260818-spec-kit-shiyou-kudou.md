---
title: "Spec Kitの使い方と仕様駆動開発｜Kiro・OpenSpecの違い"
emoji: "📐"
type: "tech"
topics: ["llm", "ai", "speckit", "kiro", "claudecode"]
published: false
---

2026年、AIコーディングツールがそろって「仕様（spec）」を言い出しています。Claude Code、GitHub Copilot、Cursor みたいなエージェントに日常的にコードを書かせるのは、もう珍しくないですよね。

でも、いま困っているのは「生成が遅いこと」ではなく「ドリフト（drift＝ずれ）」なんです。自信たっぷりで、それらしく動くコードが、静かに“間違った問題”を解いてしまう。なぜかというと、誰も作業を本物の仕様に紐づけていないからです。

一文で言うと、AIエージェントはコードを書くのは得意で、こっちが何を意図したかを当てるのは苦手、というわけです。

この記事は1本の記事の翻訳ではなく、複数の海外記事と公式発表・公式リポジトリを読み比べて、日本の読者が知りたい順に組み直したものです。Spec Kit、Kiro、OpenSpec が結局どう違うのか、やさしく見ていきます。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure1.png)
*AIエージェントはコードを書くのは得意。でも「何を作ってほしいか」を当てるのは苦手なんです*

## 仕様駆動開発とは？主役がコードから仕様に入れ替わる

仕様駆動開発、つまり SDD（Spec-Driven Development＝仕様駆動開発）は、「書かれた仕様（spec）を、いちばん主要で実行可能な成果物として扱う」やり方です。コードは仕様から生成される出力、という位置づけになります。

仕様には、意図、振る舞い、エッジケース（例外的な状況）、非機能要件が入ります。しかも、人間と言語モデルの両方が読める構造で書くのがポイントです。

よく比べられるのが、バイブコーディング（vibe coding＝思いつきで指示して書かせるやり方）です。バイブコーディングはプロトタイプには強いです。ただ、規模が出てくると、静かなドリフト、存在しないAPI（アプリ同士の接続口）のハルシネーション（hallucination＝もっともらしい嘘）、文脈の喪失で崩れがちなんですね。SDDは最初のセットアップが遅くなる代わりに、本番運用に耐える信頼性を取りに行きます。

TDD（Test-Driven Development＝テスト駆動開発）とも違います。TDDは失敗するユニットテスト（小さな単位のテスト）が中心。SDDはバージョン管理された仕様そのものが主役です。アーキテクチャ（設計構造）や非機能要件まで含むので、開発者の手元にフォーカスするTDDより範囲が広いんです。

ウォーターフォールとの違いも大事です。昔ながらの仕様書は「助言的」で、開発者は逸脱してもよかったし、すぐ古びて“考古学”になりました。SDDの仕様は違います。

- 実行可能：ずれたらテストが落ちる
- 生きている：継続的に検証される
- リポジトリの中にある：CI/CD（継続的な検査と配布）の一部で、誰も開かないwikiではない

ウォーターフォールが仕様を最初にロックするのに対して、SDDの仕様はバージョン管理の中でコードと一緒に変わり続けます。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure2.png)
*仕様が主役になると、コードは仕様から生まれる出力になる*

## Spec Kitの使い方は7段階。いきなり実装に飛ばないのが肝です

Spec KitはGitHub製のオープンソースツールです。リポジトリ説明は “Toolkit to help you get started with Spec-Driven Development”、つまり仕様駆動開発を始めるためのツールキット。MITライセンスです。

2026年8月18日にリポジトリを見た時点では、スター 130k、フォーク 11.6k、コミット 1,805、タグ 214、オープンIssue 153、オープンPR 175。2026年5月8日付の技術メディア記事では「93,000+ スター、v0.8.7（2026年5月7日）」と書かれていました。3か月ちょっとでこの伸び方、さすがに勢いがすごいですよね。

対応するAIコーディングエージェントは30以上。動かす条件は Linux / macOS / Windows、Python 3.11以上、Git、uv（推奨）または pipx、そして対応しているAIコーディングエージェントです。

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z
```

中心になるスラッシュコマンドはこの流れです。

1. `/speckit.constitution`：プロジェクトの原則（constitution＝憲法）を決める。常に守る不変のルールです。
2. `/speckit.specify`：何を作りたいかを書く。
3. `/speckit.plan`：技術スタック（使う技術の組み合わせ）とアーキテクチャを渡す。
4. `/speckit.tasks`：実行できるタスクリストに割る。
5. `/speckit.implement`：タスクを実行する。
6. `/speckit.converge`：コードベースを仕様と突き合わせて評価する。

オプションで `/speckit.clarify`、`/speckit.analyze`、`/speckit.checklist` もあります。

現場で回されている流れは、constitution → specify → clarify → plan → tasks → implement → analyze の7段階です。各段階の境目に人間のレビューゲートを置きます。仕様からいきなりコードに飛ばないことが肝なんです。プランを見てからタスク分解に進む。タスクを見てから実装に進む。これでドリフトが積み上がるのを防ぎます。

出てくる成果物は普通のMarkdownファイルで、Gitに入ります。constitution、spec、plan、tasks、contracts が残るので、AIとのやりとりが一過性のチャットで終わらないんですね。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/source1.png)
*出典: GitHub「github/spec-kit」（https://github.com/github/spec-kit）*

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure3.png)
*Spec Kitの使い方。境目ごとに人間がレビューして、仕様からいきなりコードに飛ばない*

## 数字で比べる仕様駆動開発ツール。無料OSS勢とクレジット制IDE勢

| ツール | 規模・状態 | 料金・条件 |
|---|---:|---|
| GitHub Spec Kit | スター 130k、MITライセンス、対応エージェント30以上 | 無料 |
| OpenSpec | スター 65.2k、フォーク 4.5k、コミット 777、MITライセンス、最新リリース v1.9.0（2026年8月中旬） | 無料 |
| BMAD-METHOD | スター 46,700以上、フォーク 5,500以上、v6.6.0（2026年4月29日）、MITライセンス | 無料 |
| Kiro | VS Codeをフォークした統合IDE | クレジット制 |

OpenSpecのリポジトリ説明は “Spec-driven development (SDD) for AI coding assistants”。インストールは `npm install -g @fission-ai/openspec@latest` → `openspec init` で、Node.js 20.19.0以上が必要です。対応AIアシスタントは30以上です。

Kiroは公式料金ページで、KIRO FREE が月$0、50クレジット、オープンウェイトモデルとClaude Sonnet 4.5にアクセス。KIRO PRO は1ユーザー月$20、1,000クレジット。KIRO PRO+ は1ユーザー月$40、2,000クレジット。KIRO PRO MAX は1ユーザー月$100、5,000クレジット。KIRO POWER は1ユーザー月$200、10,000クレジットです。有料プランは追加クレジットを1クレジット$0.04で買い足せます。日本の請求先住所の場合は日本の消費税がかかる旨も明記されています。

オープンソース勢が無料で、統合IDE勢はクレジット制。「どっちが偉い」ではなく、課金の形が違うだけ、と見ておくのがよさそうです。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure4.png)
*スター数と料金。無料のOSS勢と、クレジット制の統合IDE勢に分かれている*

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/source2.png)
*出典: Kiro 公式 料金ページ（https://kiro.dev/pricing）*

## Kiroの仕様駆動開発とOpenSpecの違いは「仕様をどこまで残すか」

6ツール、Spec-Kit / Spec Kitty / BMad / OpenSpec / Kiro / Tessl を比較した公開リサーチでは、成熟度を3段階に分けています。

1. Spec-First（仕様は使い捨て）：Spec-Kit、Kiro、BMad
2. Spec-Anchored（仕様が残り続ける）：OpenSpec、Spec Kitty
3. Spec-as-Source（コードは仕様から自動生成される成果物）：Tessl

共通の弱点もあります。ほとんどのツールは「要件が最初からはっきりしているとき」は強い一方で、「ボタンを青から緑に変えて」みたいな途中の細かい変更に弱いんです。

OpenSpecは delta形式（ADDED / MODIFIED / REMOVED のタグ）で、まさにこの用途に作られています。Tesslは仕様を直して再生成するやり方。Spec-Kitは `/speckit.clarify` を挟んで回避します。Kiro / BMad は、些細な変更には「クルミを割るのに大ハンマー」と評されています。

git worktree（作業ツリーを分ける仕組み）の組み込み自動化を持つのは、6ツールのうち Spec Kitty だけ。他の5つ、Spec-Kit / BMad / OpenSpec / Kiro / Tessl にはありません。

KiroはVS Codeをフォークした統合IDEです。`requirements.md`（EARS記法）、`design.md`、`tasks.md` という構造化された成果物を生成します。Agent Hooks という仕組みで仕様とコードを双方向に同期します。

OpenSpecは `/opsx:explore`（選択肢を一緒に考える相棒）→ `/opsx:propose`（仕様と設計を含む変更提案を作る）→ `/opsx:apply`（提案のタスクを実装する）→ `/opsx:archive`（終わった変更をアーカイブに移す）という流れです。他に `/opsx:new`、`/opsx:continue`、`/opsx:verify`、`/opsx:onboard` などがあります。ツールによって `/opsx:`、`/opsx-`、`@opsx-`、`$openspec-` のように書き方が変わります。

OpenSpec自身は「こっちのほうが軽くて自由に反復できる」、Spec Kitは「徹底的だが重量級で、フェーズのゲートが固く、Pythonのセットアップが要る」と位置づけています。

多くのチームが現実的に目指すべきなのは、3段階目の spec-as-source ではなく、2段階目の spec-anchored です。仕様とコードが一緒に育つ生きたドキュメントで、自動テストが両者の一致を担保する。これが「たいていの本番システムのスイートスポット」です。人間が仕様だけを編集してコードは完全生成、という spec-as-source は、多くのチームにとってはまだ理想論なんですね。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure5.png)
*仕様を使い捨てるか、残すか、それとも仕様だけを保守するか*

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/source3.png)
*出典: GitHub「Fission-AI/OpenSpec」（https://github.com/Fission-AI/OpenSpec）*

## 仕様を書く芯はEARS記法にあります

EARS記法は、Alistair Mavin が Rolls-Royce で2009年に作ったものです。いま主要なSDDツールがそろって「AIが読める要件の書き方」として採用しています。

5つのパターンがあります。

1. Ubiquitous（常に真）：例「システムはすべての認証試行をログに残すこと」
2. Event-driven（when-then／〜のとき〜する）
3. State-driven（while／〜の状態のあいだ〜する）
4. Unwanted behavior（if-then／望ましくないことが起きたときのエラー処理）
5. Optional features（条件付きで有効になる機能）

ハンズオン比較記事の結論として大事なのは、「悪い仕様はどのエージェントも悪くする。良い仕様はツールをまたいで持ち運べる」という話です。ツール選びより、成果物の質のほうが効くんです。小さいレビュー、明示的な“やらないこと”、読める差分、検証。この習慣はプラットフォームをまたいで持ち運べます。

落とし穴もあります。振る舞いではなく実装詳細まで書く過剰仕様、「ちゃんと動くこと」みたいな雑な仕様、constitutionを飛ばす、仕様を不変のものとして扱う、フェーズの境目に人間のチェックを置かない、仕様をGitの外、たとえばNotionなどに置く。こういうところで、せっかくのSDDがただの儀式になりがちです。

## 結局どの仕様駆動開発ツールを使えばいい？

ハンズオン比較記事の原則は、「その機能から曖昧さを消せる範囲で、いちばん浅いセットアップを選べ」です。重い道具を最初から持ち込まなくてもいいんです。

一人で小さい機能を作るなら、Claude Codeのスキル、つまり `.claude/skills/` にリポジトリ内のカスタムコマンドを置き、`CLAUDE.md` でプロジェクトの文脈を読ませるやり方や、OpenSpecが合います。

小さいチームでエディタがバラバラなら、30以上のエージェントで動く Spec Kit がロックインを最小にしやすいです。エンタープライズでAWS前提なら Kiro。ただしロックインは最大で、仕様は `.kiro/` に置かれます。既存コードの改修、いわゆるブラウンフィールドなら、OpenSpec や軽量なワークフローが向いています。

やる価値があるのは、AIコーディングアシスタントを使っている、要件が複雑、メンテナが複数いる、連携が多い、あるいは規制のあるシステムです。逆に、使い捨てのプロトタイプ、一人でやる短命なプロジェクト、要件が読めない探索的な作業なら、無理に入れなくても大丈夫です。

## 冷静に見ておきたいこと

Thoughtworks の Technology Radar（技術レーダー）は、2025年11月5日公開の版で spec-driven development を「Assess」リングに置きました。Assess は「採用せよ」ではなく、「影響を理解する目的で探る価値がある」という位置づけです。なお、現在の最新版のレーダーにはこの項目は載っていません。過去の版のブリップです。

Thoughtworksの原文は、「ワークフローは大がかりで押しつけがましいまま」で、タスクの大きさや種類によって挙動がまるで変わる、と懸念しています。レビューしづらい長大な仕様ファイルを生成するものがあり、PRD（製品要求文書）やユーザーストーリーを出してきても、それが誰向けなのか分からないことがある、とも書いています。さらに「AIのために詳細なルールを手作りしても、結局スケールしない」という苦い教訓を学び直しているのかもしれない、とも。同じ文章の中で、Kiro、GitHubのspec-kit、Tessl Framework の3つを「それぞれ違う解釈を探っている」と挙げています。

開発者コミュニティ側にも、「価値は仕様を書くあいだにやる思考のほうで、その周りのツールではない」という指摘や、「ウォーターフォール／契約駆動設計の看板の掛け替えでは」という声があります。

数字も冷静に見たいところです。GitHubは、社内プロジェクトでSpec Kitを使ったチームは、行き当たりばったりのプロンプトに比べて「ゼロから作り直す」サイクルがおよそ1桁少ない、と報告しています。AWS Kiroのドキュメントには、仕様を先に書いた場合に40時間かかる機能が人間の作業8時間未満で出荷された顧客事例があります。

ただし、これらはどちらもベンダー発の数字で、独立した検証ではありません。方向性として読むくらいが、ちょうどいいと思います。いちばん争いようがない変化は、人の時間の使い所が、実装をタイプすることから、レビューと明確化に移ることです。

ツールを入れても、ドリフトとハルシネーションは消えません。過剰仕様はプログラムを2回書くのと同じです。間違った仕様に一致しただけで安心してしまう「偽の自信」もあります。ツールの複雑さが、見合わない儀式を増やすこともあるんですね。

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/figure6.png)
*効きそうな感じはある。ただ数字はまだベンダー発が中心なんです*

![](/images/jp-digest-20260818-spec-kit-shiyou-kudou/source4.png)
*出典: Thoughtworks Technology Radar「Spec-driven development」（https://www.thoughtworks.com/en-us/radar/techniques/spec-driven-development）*

## まとめ

仕様駆動開発は「AIを賢くする魔法」ではありません。こっちが何を作りたいかを、AIが読める形で置いておく、という地味な作業です。

最初の一歩としては、いきなりツールを入れなくても大丈夫です。次に作る機能ひとつぶんの仕様を、「やること」「やらないこと」「受け入れ条件」の3つだけ、リポジトリのMarkdownに書いてエージェントに渡してみてください。

それで「たしかにズレにくいな」という手応えがあったら、Spec Kit や OpenSpec を入れてみる。Kiroのような統合IDEを試すのも、そのあとでいいと思います。AIに速く書かせる時代だからこそ、何を作るのかをちゃんと残す。そこが、これからの開発でじわじわ効いてくるはずです。

### 参考にした記事

- [GitHub「spec-kit」公式リポジトリ](https://github.com/github/spec-kit)
- [Fission-AI「OpenSpec」公式リポジトリ](https://github.com/Fission-AI/OpenSpec)
- [Kiro 公式 料金ページ](https://kiro.dev/pricing)
- [Thoughtworks Technology Radar「Spec-driven development」](https://www.thoughtworks.com/en-us/radar/techniques/spec-driven-development)
- [BCMS「Spec-Driven Development (SDD): The Definitive 2026 Guide」](https://www.thebcms.com/blog/spec-driven-development/)
- [MarkTechPost「9 Best AI Tools for Spec-Driven Development in 2026」](https://www.marktechpost.com/2026/05/08/9-best-ai-tools-for-spec-driven-development-in-2026-kiro-bmad-gsd-and-more-compare/)
- [Rost Glukhov「GitHub Spec Kit vs Kiro vs Claude Code SDD Workflows」](https://www.glukhov.org/ai-devtools/ai-coding-assistants/spec-kit-vs-kiro-vs-claude-code/)
- [cameronsjo「spec-compare」6ツール比較リサーチ](https://github.com/cameronsjo/spec-compare)
- [DEV Community「Spec-Driven Development in 2026: What It Is, the Tooling, and How Teams Actually Use It」](https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2)