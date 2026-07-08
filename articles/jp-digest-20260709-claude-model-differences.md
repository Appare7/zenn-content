---
title: "Claudeモデルの違い｜Sonnet 5とOpus 4.8の使い分け"
emoji: "⚖️"
type: "tech"
topics: ["claude", "llm", "ai", "anthropic"]
published: false
---

Claudeを使っていると、「モデルがいくつもあるけど、結局どれを選べばいいの？」ってなりますよね。そこに2026年6月30日、Claude Sonnet 5が登場して、Sonnet 5とOpus 4.8の使い分けがまたちょっと動きました。この記事では、複数の海外記事・公式発表をもとに、日本のエンジニア向けに噛み砕いて再構成していきます。

![Claudeモデルの違い｜Sonnet 5とOpus 4.8の使い分けガイド](/images/jp-digest-20260709-claude-model-differences/figure1.png)

## Claude Sonnet 5がやってきた——まず何が起きたの?

Claude Sonnet 5は、2026年6月30日に登場しました。翌日の7月1日からは、Free/Proの標準モデルとして使われるようになっています。それまで標準だったSonnet 4.6から置き換わった、という流れですね。

Max/Team/Enterpriseでも使えて、Claude CodeやAPI(アプリからモデルを呼び出すための窓口)でも利用できます。APIのモデルIDは `claude-sonnet-5` です。

今回のSonnet 5をひとことで言うなら、「Opus 4.8との差をかなり詰めつつ、2026年8月31日までは安いモデル」です。

これ、けっこう大きいんですよ。というのも、Claudeの中でOpusは「いちばん賢いけど高い」枠です。一方でSonnetは、普段使いしやすいバランス型。そこにSonnet 5が来て、かなりOpus寄りの性能まで近づいてきました。

Sonnet 5の特徴としては、途中で止まらずに多段のタスクを最後までやり切る力、努力度(effort、どれくらい粘って考えるかの調整)を上げ下げできること、ハルシネーション(それっぽい嘘)の低減、プロンプトインジェクション(悪意ある指示を入力に混ぜ込む攻撃)への耐性向上が挙げられています。

つまり、「毎日の開発作業を任せる相棒」として、かなり扱いやすくなったわけです。

## そもそもClaudeのモデルって何が違うの?

![Claudeのモデルは3階層。いまの2枚看板がSonnet 5とOpus 4.8](/images/jp-digest-20260709-claude-model-differences/figure2.png)

Claudeモデルの違いをざっくり一覧で見るなら、まずは3階層で考えるとわかりやすいです。

- Opus: 最上位。いちばん賢いけど高い
- Sonnet: 中位。バランス型で普段使い向き
- Haiku: 軽量。速くて安い

こんな感じです。

名前についている「Sonnet 5」や「Opus 4.8」の数字は、世代やバージョンだと思っておけばOKです。今の2枚看板が、Sonnet 5とOpus 4.8ですね。

たとえるなら、Opus 4.8は「難問に強い優等生」。じっくり考えさせたい、絶対に外したくない、複雑な判断をしてほしい、みたいな場面で強いです。

一方のSonnet 5は「器用な万能選手」。毎日のコーディング、文章の読み書き、ツールをまたいだ作業、自動化、長丁場のタスクなどを、コストを抑えつつ広く任せやすいモデルです。

なので、「どちらが上か」だけで見るより、「いつ、何に使うか」で選ぶのが大事なんです。

## 数字で見るSonnet 5 vs Opus 4.8

![主要ベンチの比較。多くの項目で差は数ポイントまで縮まった](/images/jp-digest-20260709-claude-model-differences/figure3.png)

では、数字を見ていきましょう。ここではSonnet 5、Opus 4.8、そして前世代のSonnet 4.6を並べます。

| ベンチマーク | Sonnet 5 | Opus 4.8 | Sonnet 4.6 |
|---|---:|---:|---:|
| SWE-bench Pro(実際のGitHub課題をコードで直せるか測るテスト) | 63.2% | 69.2% | 58.1% |
| Terminal-Bench 2.1(ターミナル操作の自動化力を見るテスト) | 80.4% | 82.7% | 67.0% |
| OSWorld-Verified(PC画面を見て操作するコンピュータ操作力を見るテスト) | 81.2% | 83.4% | 78.5% |
| Humanity's Last Exam(超難問テスト) ツールあり | 57.4% | 57.9% | 46.8% |
| Humanity's Last Exam ツールなし | 43.2% | 49.8% | - |
| GDPval-AA v2(仕事っぽい知的作業の総合力を見るスコア) | 1618 | 1615 | 1395 |

表を見ると、まずコーディング系のSWE-bench ProではOpus 4.8が69.2%、Sonnet 5が63.2%。ここはOpusが上です。難しいGitHub課題をコードで直すような場面では、やっぱりOpusの強さが出ています。

Terminal-Bench 2.1やOSWorld-Verifiedでも、Opus 4.8が少し上。ただし差はかなり小さくなっています。Terminal-Bench 2.1ではSonnet 5が80.4%、Opus 4.8が82.7%。OSWorld-VerifiedではSonnet 5が81.2%、Opus 4.8が83.4%。「かなり迫ってるな」という数字ですよね。

Humanity's Last Examのツールありでは、Sonnet 5が57.4%、Opus 4.8が57.9%。ここもほぼ僅差です。ただし、ツールなしの素の推論力ではSonnet 5が43.2%、Opus 4.8が49.8%なので、何も道具を使わずに難問を解く力ではOpusが上です。

おもしろいのはGDPval-AA v2です。ここではSonnet 5が1618、Opus 4.8が1615で、Sonnet 5がわずかに上回っています。仕事っぽい知的作業の総合力では、Sonnet 5が逆転しているんですね。

まとめると、コーディングの最難関やツールなしの難問はOpus 4.8が数ポイント上。一方で、知的作業ではSonnet 5が上回る場面もあり、多くの項目で差はかなり縮まっています。

![CodingFleetの比較記事「93% of the Power at 60% of the Price」](/images/jp-digest-20260709-claude-model-differences/source1.png)
*出典: CodingFleet（https://codingfleet.com/blog/claude-sonnet-5-vs-claude-opus-4-8/）*

## 料金で見ると——「93%の性能を60%の値段で」

![API料金の比較。Sonnet 5はOpus 4.8のおよそ6割・1.7倍安い](/images/jp-digest-20260709-claude-model-differences/figure4.png)

性能差が縮まっているなら、次に気になるのは料金ですよね。

API料金は、100万トークンあたりで見るとこうです。トークンは、モデルが文章を読むときの細かい単位だと思ってください。

- Sonnet 5
  - 導入価格: 入力 $2 / 出力 $10
  - 2026年8月31日まで
- Sonnet 5
  - 標準価格: 入力 $3 / 出力 $15
  - 9月以降
- Sonnet 4.6
  - 入力 $3 / 出力 $15
- Opus 4.8
  - 入力 $5 / 出力 $25

Sonnet 5は、導入価格の間はかなり安いです。Opus 4.8と比べると、およそ6割の値段。言い換えると、約1.7倍安いということになります。

開発者の間では「性能の約93%を、値段6割で」という言い回しでも語られています。もちろん、これはあくまでざっくりした見方ですが、感覚としてはかなりわかりやすいですよね。

さらにSonnet 5は、文脈窓(コンテキストウィンドウ、一度に読める量)が100万トークンあります。最大出力は12.8万トークンです。長いログ、長い仕様書、大きめのコードベース、複数ステップの作業を扱いたいときに、この広さは効いてきます。

日常的にAPIで大量に回すなら、ここはかなり大事です。1回だけならOpusでもいいかもしれません。でも、本番で毎日たくさん呼ぶ、エージェント的に長く動かす、何度も試行錯誤する、となると料金差がじわじわ効いてきます。

## 結局どっちを使う? 使い分けの目安

![使い分けの目安。普段はSonnet 5、難所だけOpus 4.8](/images/jp-digest-20260709-claude-model-differences/figure5.png)

では結論です。

普段はSonnet 5を既定にして、いちばん難しいときだけOpus 4.8に上げる。これでOKです。

Sonnet 5を選びたいのは、こんな場面です。

- 毎日のコーディング
- 機能追加
- テスト作成
- ルーチンなリファクタ
- ツールを使う自動化
- 複数システムをまたぐ作業
- 長丁場のエージェント作業
- 知的作業や文書分析
- コスト重視で量が多い本番運用

つまり、日々の開発で「とりあえずClaudeに頼むか」という場面の多くはSonnet 5でよさそうです。性能はOpus 4.8にかなり近づいていて、しかも料金が安い。普段の相棒としてはかなり強いです。

逆に、Opus 4.8を選びたいのはこういう場面です。

- いちばん難しい複数ファイルにまたがるGitHub課題
- ツールなしの素の推論が必要な難題
- アーキテクチャ設計の判断
- 難しいデバッグ
- きちんとしたセキュリティレビュー
- 絶対に外せないミッションクリティカルな用途

Opus 4.8は高いぶん、「ここで間違えると困る」「かなり複雑」「人間でも悩む」みたいな場面に回すのがよさそうです。

たとえば、日常の実装やテスト作成はSonnet 5。どうしても直らないバグ、設計判断、重要なレビューはOpus 4.8。こう分けると、コストと精度のバランスが取りやすいです。

![The New Stack「Sonnet 5はOpus 4.8との差を詰め、8月まで安い」](/images/jp-digest-20260709-claude-model-differences/source2.png)
*出典: The New Stack（https://thenewstack.io/claude-sonnet-5-launch/）*

## 使う前に知っておきたい注意点

![使う前にチェックしたい4つの注意点](/images/jp-digest-20260709-claude-model-differences/figure6.png)

ただし、「Sonnet 5は安いから全部お得！」と飛びつく前に、いくつか注意点があります。

まず、トークナイザ(文章をトークンに刻む仕組み)が新しくなっています。同じ文章でも、トークン数が1.0〜1.35倍に増えることがあるんです。

これは地味に大事です。単価が安くても、トークン数が増えれば、実際の請求額は思ったほど下がらない場合があります。特に長いログや大量のドキュメントを投げるワークフローでは、実測しておいたほうが安心です。

次に、セキュリティ用途では差があります。攻撃コード、つまりエクスプロイト(脆弱性を突くコード)を作らせる評価では、Firefox 147を対象にした結果として、Opus 4.8が8.8%成功、Sonnet 5が0.0%成功でした。

これは「Sonnet 5が安全側に振ってある」とも読めます。一方で、攻撃的セキュリティ検証のような用途ではOpus 4.8、という住み分けにも見えます。もちろん、何をさせるかによって評価は変わるので、ここも用途次第ですね。

そして、Sonnet 5の導入価格は2026年8月31日までです。9月からは入力 $3 / 出力 $15 に上がります。今の安さは期間限定なので、料金を見て本番投入を考えている人は、そこを忘れないようにしたいです。

最後に、ベンチマークの数字は実務の体感と必ずしも一致しません。これは本当にそうです。自分のコード、自分のプロンプト、自分のワークフローで小さく試すのがいちばんです。

たとえば、いつも使っているリポジトリで同じ修正を頼んでみる。いつものレビュー観点で見てもらう。普段のログ分析を投げてみる。そういう小さな検証をしてから、既定モデルを決めるのが安全です。

## まとめ

Claude Sonnet 5は、かなり「普段使いの本命」っぽい立ち位置になりました。

- 普段のコーディング、テスト、リファクタ、文書分析はSonnet 5でOK
- 最難関のコード修正、素の推論、設計判断、重要レビューはOpus 4.8に上げる
- Sonnet 5はOpus 4.8のおよそ6割の値段で、性能差もかなり縮まっている
- ただし導入価格は2026年8月31日まで。トークン数の増え方も要チェック

結論としては、「普段はSonnet 5、精度が命のときだけOpus 4.8」です。

8月末までの安さを活かせるなら、今のうちに自分のワークフローで試してみるのがよさそうです。ベンチの数字も大事ですが、最後に信じるべきは自分の開発現場での体感ですからね。

### 参考にした記事

- MarkTechPost「Anthropic Claude Sonnet 5 vs Sonnet 4.6 vs Opus 4.8: Agentic Coding Benchmarks, API Pricing, and Cost-Performance Tradeoffs Compared」 https://www.marktechpost.com/2026/06/30/anthropic-claude-sonnet-5-vs-sonnet-4-6-vs-opus-4-8-agentic-coding-benchmarks-api-pricing-and-cost-performance-tradeoffs-compared/
- The New Stack「Anthropic Sonnet 5: It closes the gap with Opus 4.8, and is cheap until August」 https://thenewstack.io/claude-sonnet-5-launch/
- DataCamp「Claude Sonnet 5: Features, Benchmarks, and Pricing」 https://www.datacamp.com/blog/claude-sonnet-5
- CodingFleet「Claude Sonnet 5 vs Claude Opus 4.8: 93% of the Power at 60% of the Price」 https://codingfleet.com/blog/claude-sonnet-5-vs-claude-opus-4-8/
- SmartScope「Claude Sonnet 5 vs Opus 4.8: Price, Limits, and Benchmarks」 https://smartscope.blog/en/blog/claude-sonnet-5-vs-opus-4-8/
