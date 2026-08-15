---
title: "Gemini Flash と Pro の違い｜3.7 Flashの実力と値上げ"
emoji: "⚡"
type: "tech"
topics: ["llm", "ai", "gemini", "api"]
published: false
---

「Gemini の Flash と Pro、どっちを使えばいいの？」という問い、ずっとモヤっとしますよね。

その答えが、2026年8月にかなり変わりつつあります。きっかけは、2026年8月13日に一般提供開始になった Gemini 3.7 Flash です。

今回のポイントは大きく3つあります。

- Flash が「安い下位モデル」ではなく、かなり主力っぽい位置づけになった
- その一方で、上位の Pro は出てこない
- しかも、その Flash も 2027年1月1日に値段が2倍になる

この記事は、公式発表と複数の海外メディア・分析機関の記事を突き合わせて、日本のエンジニア向けに読み直したものです。API（アプリケーションからモデルを呼び出す仕組み）で LLM（大規模言語モデル）を使う前提で、「結局どれを選べばいいの？」に寄せて見ていきます。

![Gemini 3.7 Flash が変えた Flash と Pro の関係](/images/jp-digest-20260815-gemini-flash-pro-chigai/figure1.png)

## そもそも Flash と Pro の違いって何なの

まず従来の常識からいくと、ざっくりこうでした。

- Pro：賢いけど高い上位モデル
- Flash：速くて安い普段使いモデル
- Flash-Lite：いちばん安い枠

つまり、役割で分かれていたんですね。重たい推論や高精度がほしいなら Pro、普段のアプリ組み込みやチャットなら Flash、大量分類みたいな軽い処理なら Flash-Lite、という見方です。

ただ、ここにきて値段の差がかなり縮んでいます。100万トークン（AIが文章などを扱う最小単位）あたりの入力／出力料金で見ると、こうです。

| モデル | 入力 | 出力 |
|---|---:|---:|
| Gemini 3.7 Flash（2026年12月31日までの導入価格） | $0.75 | $3.75 |
| Gemini 3.7 Flash（2027年1月1日から） | $1.50 | $7.50 |
| Gemini 3.6 Flash | $1.50 | $7.50 |
| Gemini 3.5 Flash | $1.50 | $9.00 |
| Gemini 3.1 Pro | $2.00 | $12.00 |
| Gemini 3.1 Pro（20万トークンを超えるプロンプト） | $4.00 | $18.00 |
| Gemini 3.1 Flash-Lite | $0.25 | $1.50 |

ツッコミどころはここです。Gemini 3.7 Flash の導入価格のあいだは、Pro との入力単価の差が2.7倍ほどあります。なので「Pro は高いから Flash で」という説明はまだ通ります。

でも通常価格に戻ると、入力で1.33倍、出力で1.6倍しか違いません。こうなると、「Pro は高いから Flash」という理由づけはだいぶ弱くなってきますよね。

しかも今回の Gemini 3.7 Flash について、Google は「我々のいちばん賢い働き者（workhorse）モデル」と表現しています。つまり、下位モデルというより「現場でガンガン使う主力」という位置づけなんです。

![Flash と Pro のAPI料金比較](/images/jp-digest-20260815-gemini-flash-pro-chigai/figure2.png)

## 3週間で次が出る。Flashの更新ペースがおかしい

Gemini Flash 系の更新ペースも、ちょっと普通じゃありません。

- Gemini 3.5 Flash：2026年5月19日、Google I/O 2026で発表
- Gemini 3.6 Flash：2026年7月21日
- Gemini 3.7 Flash：2026年8月13日

Gemini 3.7 Flash は、3.6 Flash からわずか3週間で出ています。分析機関 Artificial Analysis は「Google DeepMind はこの3か月で3つ目の新しい Gemini Flash を出した」と書いています。いや、速い。

GoogleのAI Studioのプロダクト責任者 Logan Kilpatrick 氏は、約3週間で「強い知能の向上（strong intelligence increase）」を実現したとSNSで述べています。その理由として、Google DeepMindの各チームによるアルゴリズム面の改善を挙げています。さらに、「実務でもっと使えると感じられる」ことに注力してきたとも話しています。

Googleのシニアディレクター Tulsee Doshi 氏も、Gemini 3.7 Flash について「壁にぶつかったときの適応がうまくなり、必要なときには意図を確認し、指示により忠実に従うようになった」と説明しています。モデルの賢さというより、実務での粘り強さが増した、というニュアンスですね。

使える場所もかなり広いです。Google AI Studio、Android Studio、Google Antigravity、Gemini Enterprise Agent Platform、Gemini Enterprise アプリ、そして一般向けのAIエージェント（自律的に作業するAI）である Gemini Spark で使えます。Gemini Spark は Google AI Pro／Ultra の加入者向けで、160か国以上に展開されています。

仕様としては、入力は最大100万トークン。画像・動画・テキストを扱えます。出力は最大64,000トークンです。長文もマルチモーダル（テキスト以外の画像や動画なども扱うこと）も、かなり大きく受け止める設計になっています。

![Gemini 3.7 Flash の発表を報じた記事](/images/jp-digest-20260815-gemini-flash-pro-chigai/source.png)
*出典: OfficeChai（https://officechai.com/ai/gemini-3-7-flash-benchmarks/）*

## 数字で見る：3.6 Flash から何が伸びたのか

では、Gemini 3.6 Flash から Gemini 3.7 Flash で何が伸びたのか。公式発表の比較表では、こんな変化が出ています。

- DeepSWE v1.1（ソフトウェアの課題解決）：49.0% → 65.3%
- FrontierCode 1.1 Main（実務コードの一発正答）：34.4% → 43.6%
- AutomationBench（業務の自動化）：17.0% → 30.4%
- GDP.pdf（重たいPDFの読解）：22.0% → 34.0%
- WebDev Arena（Web画面づくり、Elo）：1538 → 1588

きれいに伸びているのは、コーディングとエージェント系です。エージェントは、自律的に手順を踏んで作業するAIのことですね。

特に AutomationBench が 17.0% → 30.4% なのは、業務アプリや社内ツールに組み込む側からすると気になるところです。「ただ返答がうまい」より、「手順を踏んで作業できる」ほうが、プロダクトには効いてきますから。

長文の読み取りも見ておきたいです。128Kトークンの範囲で目的の情報を拾うテスト、GDM-MRCR v2 は 97.0% です。かなり高いですよね。

ただし、100万トークンまで広げると 62.5% に落ちます。ここは大事です。「入る」のと「使いこなせる」のは別なんです。巨大なコンテキスト（モデルに渡す文脈）に何でも詰め込めば勝ち、というわけではありません。

あと、全部が伸びたわけでもありません。図表の読み取りである CharXiv では、ツール利用ありで 88.7% です。これは 3.6 Flash の 89.4% に負けています。強くなった領域ははっきりありますが、万能に全ベンチマークで上がった、という話ではないんですね。

![3.6 Flash から 3.7 Flash へのベンチマークの伸び](/images/jp-digest-20260815-gemini-flash-pro-chigai/figure3.png)

## 他社と並べると「惜しい2番手」が多い

他社モデルと並べると、Gemini 3.7 Flash は「かなり強いけど、トップにほんの少し届かない」場面が目立ちます。

分析機関 Artificial Analysis の知能指数、Artificial Analysis Intelligence Index では、Gemini 3.7 Flash（high）が56です。GPT-5.6 Terra（max）と Muse Spark 1.2（xhigh）がともに57なので、わずかに届いていません。Claude Sonnet 5（max）は55です。

前世代の Gemini 3.6 Flash は52なので、Gemini 3.7 Flash は4ポイント上がった計算です。3週間でこの伸びは、かなり攻めています。

Gemini 3.7 Flash は、推論の強さを3段階で切り替えられます。low／medium／high で、それぞれ 51／53／56 です。考える量を増やすほど賢くなるけど、そのぶん遅くなったり高くなったりする、というタイプですね。

勝っているところもあります。

- FrontierCode 1.1 Main：3.7 Flash 43.6%、Claude Sonnet 5 42.7%、GPT-5.6 Terra 41.3%
- AutomationBench：3.7 Flash 30.4%、GPT-5.6 Terra 23.6%、Claude Sonnet 5 10.7%

コード生成や業務自動化では、最上位級と普通に殴り合えています。むしろベンチマークによっては勝っています。

一方で、負けているところもあります。

- DeepSWE v1.1：GPT-5.6 Terra 69.6% に対し 3.7 Flash 65.3%
- OSWorld-2.0（PC操作）：GPT-5.6 Terra 50.2% に対し 3.7 Flash 38.1%
- Agent's Last Exam：Claude Sonnet 5 33.3% に対し 3.7 Flash 26.3%
- GDPval-AA v2（Elo）：Muse Spark 1.2 が1628、Claude Sonnet 5 が1598、GPT-5.6 Terra が1578、3.7 Flash は1525

まとめると、コード生成と業務自動化では最上位級と殴り合える。でも、長く自律的に動く仕事や画面操作では、まだ差がある。そんな立ち位置です。

![Artificial Analysis の知能指数における Gemini 3.7 Flash の位置](/images/jp-digest-20260815-gemini-flash-pro-chigai/source2.png)
*出典: Artificial Analysis（https://artificialanalysis.ai/articles/gemini-3-7-time-frontier）*

## いちばんの武器は、やっぱり速さ

Gemini 3.7 Flash のいちばん分かりやすい武器は、やっぱり速さです。

Artificial Analysis の計測では、出力 340.1トークン／秒。同社が計測している中でいちばん速いです。トークン／秒は、ざっくり「どれくらいの速さで文章を吐けるか」の指標ですね。

1タスクあたりの平均所要時間は、high 設定で1.7分。GPT-5.6 Terra（max）より40%速いとされています。

そのため Artificial Analysis は、Gemini 3.7 Flash が「知能 対 タスク所要時間」のパレートフロンティアに乗ったと評価しています。パレートフロンティアは、これ以上どちらも良くできない最前線のことです。つまり「賢さと速さのバランスがかなり良い場所にいる」というわけです。

コスト面も見ておきます。知能指数のテスト1タスクあたりのコストは、導入価格のもとで high 設定 0.40ドル、medium 設定 0.26ドルです。high 設定でのコストは 3.6 Flash より30%安いとされています。

ただし、現実のレイテンシ（応答の遅れ）は、数字ほど夢があるわけでもありません。OpenRouter 経由の実測では、P50（中央値）で93トークン／秒です。さらに、最初の1文字が返るまでの時間は low で0.74秒、medium で4.22秒、high で9.83秒です。

high は、考え込む時間がそれなりに長いです。チャットUIでユーザーが待つ場面だと、この「最初の1文字までの待ち時間」は体感にかなり効きます。速いモデルではあるけれど、どの思考レベルでも爆速、という話ではないんですね。

## で、肝心の Pro はどこ行った？

ここが今回いちばん面白いところです。

Google は2026年5月中旬のI/Oで Gemini 3.5 Flash を発表したとき、Pro版は6月に出すと言っていました。その期限は過ぎましたが、8月中旬の時点でも Gemini 3.5 Pro は出ていません。

Bloomberg の報道によると、Google は 3.5 Pro の能力、とくにコーディング性能を上げようと時間をかけています。6月下旬に学習データを更新してコーディング力の改善を狙ったものの、結果は期待外れだったとされています。

Google 自身は、「3.5 Pro、アップグレード版の Flash、その他のモデルをパートナーとテスト中」「幅広いモデルを高速に出しつつ、顧客にとって非常にコスト効率の良い状態を保っている」と説明しています。

現行の上位モデル Gemini 3.1 Pro は2026年2月まで遡ります。つまり Pro 系はおよそ半年、更新が止まっている状態です。

ここ、けっこう大事です。Pro が足踏みしている半年で、Flash は 3.5 → 3.6 → 3.7 と3段跳びしました。「Flash と Pro の違い」を考えるとき、いま実際に手が入っているのは Flash のほうなんです。

昔の感覚だと「本命は Pro、Flash は軽量版」でした。でも今の見え方は少し違います。少なくとも2026年8月時点では、Google が最前線で改善を回しているのは Flash 側に見えます。

![Gemini 3.5 Pro の遅延を報じた記事](/images/jp-digest-20260815-gemini-flash-pro-chigai/source3.png)
*出典: 9to5Google（https://9to5google.com/2026/07/16/gemini-3-5-pro-delays/）*

## 安いのは今だけ。2027年1月1日に請求が2倍になる

ここは予算を持つ人ほど、ちゃんと見ておきたいところです。

Gemini 3.7 Flash の導入価格は、2026年12月31日までです。料金は100万トークンあたり、入力 $0.75／出力 $3.75。

2027年1月1日からは、入力 $1.50／出力 $7.50 になります。入力も出力も、きっちり2倍です。

バッチ処理、つまりまとめて非同期に流す割安モードも上がります。$0.375／$1.875 から $0.75／$3.75 へ。コンテキストキャッシュの読み出しも $0.075 から $0.15 へ上がります。

Google 側の説明では、この $0.75／$3.75 は「3.6 Flash の導入期間終了後の価格に対して50%引き」にあたります。つまり、安いというより「期間限定の割引価格」なんですね。

実務では、ここを見積もりにどう入れるかがかなり重要です。コードは何も変えていないのに、年が明けた瞬間に請求だけ倍になります。なので、いま見積もりを作るなら、通常価格の $1.50／$7.50 で引いておくのが安全です。

節約の手札もあります。コンテキストキャッシュを使うと、入力コストは最大90%削減できます。キャッシュからの読み出しは、基準の入力価格の10%だからです。

ただし、キャッシュの保存自体に1時間あたり100万トークンで$1〜$4.50かかります。長時間保持すると、読み出しは安くても保存コストが効いてくるので注意です。

バッチ処理は全モデルで50%引きです。リアルタイム応答が不要なログ解析、まとめての分類、夜間バッチのような処理なら、かなり効く選択肢になります。

![Gemini 3.7 Flash の価格が2027年1月1日に2倍になる](/images/jp-digest-20260815-gemini-flash-pro-chigai/figure4.png)

## 移行するとき知らないとハマるやつ

Gemini 3.7 Flash に移行するとき、実務でつまずきそうなポイントを並べます。モデル名だけ差し替えれば終わり、とは限らないやつです。

### `minimal` の思考レベルが無くなった

以前の Flash には、分類のような軽い処理向けに `minimal` という安い設定がありました。

でも 3.7 Flash では、`low`／`medium`／`high` の3つだけです。いちばん安い床が上がったことになります。

大量の軽量タスクを `minimal` 前提で回していた場合、コスト感が変わる可能性があります。ここは移行前に、実リクエストで試算してみてください。

### 思考トークンは出力料金で課金される

思考トークン、つまりモデルが内部で考えた分のトークンは、こちらに要約しか返ってこなくても出力単価で請求されます。

ある例では、思考トークン297に対して、実際の出力は171トークンでした。この場合、両方が出力料金で計上されます。

さらに、複雑なタスクでは思考トークンが出力請求の70〜85%を占めることもある、という指摘もあります。見た目の返答が短いのに出力料金が重い、ということが起きるわけです。

### APIに破壊的変更がある

APIまわりも注意です。

`temperature`、`top_p`、`top_k`、`candidate_count` が廃止されました。代わりに `thinking_level` の文字列指定へ移行します。

また、複数ターンの履歴は `previous_interaction_id` へ移行する必要があります。既存コードをそのまま差し替えるだけでは動きません。SDK（開発キット）やラッパー層でこれらを吸収している場合も、内部でどのパラメータを投げているか確認してみてください。

### 事実の取り違えは増えている可能性がある

ある独立テストでは、ハルシネーション（もっともらしい嘘を作ってしまう現象）の割合が 3.7 Flash で64.5%、3.6 Flash で55.6% でした。

精度が上がった一方で、この数字は悪化しています。事実の正確さが要る用途では、検索、参照元表示、検証ステップなどの裏取りの仕組みを外さないほうがよさそうです。

ただし、この 64.5%／55.6% は独立した測定であって、公式発表ではありません。ここは混ぜないようにしたいですね。

![移行時にハマりやすい4つのポイント](/images/jp-digest-20260815-gemini-flash-pro-chigai/figure5.png)

### 思考レベルはどう使う？

Googleの説明に基づくと、使い分けの目安はこうです。

- `low`：応答速度が命の用途。障害対応、リアルタイムのチャット、下書き、素早いデータ分析
- `medium`：既定値。複雑なコードやエージェント用途
- `high`：難しい数学、いちばん難しいコーディングやエージェントの仕事、長いツール利用

最初から全部 `high` にすると、コストも待ち時間も重くなります。まず `medium` を基準にして、速度が大事なら `low`、どうしても解けないものだけ `high`、くらいの運用が現実的です。

![Gemini 3.7 Flash の思考レベル（low／medium／high）の使い分け](/images/jp-digest-20260815-gemini-flash-pro-chigai/source4.png)
*出典: eesel AI（https://www.eesel.ai/blog/gemini-3-7-flash-review）*

## 結局どう使い分ける？

最後に、実務での使い分けを短くまとめます。

### Gemini 3.7 Flash を選ぶ場面

Gemini 3.7 Flash は、コード生成、業務の自動化、重たいPDFや長い文書の読解、Web画面づくり、そして速さが効くところに向いています。

コード・PDF・画像・音声・動画・長文・Google連携のツールを、ひとつの安いエンドポイントでまとめて扱いたいときにも選びやすいです。

特に、コーディングと業務自動化のベンチマークではかなり強い数字が出ています。プロダクトに組み込む「普段使いの主力」としては、かなり現実味があります。

### Pro 系（Gemini 3.1 Pro）を選ぶ場面

Pro 系を選ぶ場面は、長く自律的に動く仕事や、他社の最上位モデルと比べられる場面です。

ただし、Pro 系は2026年2月から更新が止まっている点は織り込む必要があります。今まさに改善が速く回っているのは Flash 側です。

また、Gemini 3.1 Pro は20万トークンを超えると単価が上がります。長文を大量に投げる設計では、ここも見積もりに入れてください。

### Flash-Lite を選ぶ場面

Flash-Lite は、分類や仕分けのような軽い処理に向いています。料金は $0.25／$1.50 です。

Gemini 3.7 Flash で `minimal` が消えたぶん、いちばん安い床を求めるなら Flash-Lite に逃がす選択肢があります。大量の単純処理を全部 3.7 Flash に寄せるより、タスクごとに分けたほうがコストは読みやすくなります。

全体を通して見ると、「Flash と Pro の違い」はもう値段の差ではなく、更新の速さと得意分野の差になってきました。Flash は安い下位モデル、という見方はそろそろ古いかもしれません。

## まとめ

- Gemini 3.7 Flash は2026年8月13日にGA（一般提供）され、3週間で前世代から大きく伸びました
- 他社最上位に僅差で迫り、コード生成と業務自動化では最上位級と戦えます
- 速度は最速級ですが、high 設定では最初の応答までの待ち時間に注意です
- Pro 系はおよそ半年止まっていて、いま実際に手が入っているのは Flash 側です
- 価格は2027年1月1日に2倍になり、`minimal` 廃止やAPIの破壊的変更にも注意が必要です

「Flash で十分か？」ではなく、「Flash を主力にして、どこだけ Pro や Flash-Lite に逃がすか？」という考え方に変えるタイミングかもしれません。まずは自分たちの本番に近いプロンプトで、`low`／`medium`／`high` のコストと待ち時間を測ってみてください。

### 参考にした記事

- [Google 公式ブログ「Gemini 3.7 Flash: our most intelligent workhorse model」](https://blog.google/innovation-and-ai/models-and-research/gemini-models/introducing-gemini-3-7-flash/)
- [SiliconANGLE「Google launches Gemini 3.7 Flash for coding, AI agent projects」](https://siliconangle.com/2026/08/13/google-launches-gemini-3-7-flash-coding-ai-agent-projects/)
- [Artificial Analysis「Gemini 3.7 Flash: On the Intelligence vs. Time per Task Pareto frontier」](https://artificialanalysis.ai/articles/gemini-3-7-time-frontier)
- [eesel AI「Gemini 3.7 Flash review: benchmarks, real pricing, and the catch」](https://www.eesel.ai/blog/gemini-3-7-flash-review)
- [OfficeChai「Google Releases Gemini 3.7 Flash, Competes With GPT 5.6 Terra & Muse Spark 1.2 On Benchmarks」](https://officechai.com/ai/gemini-3-7-flash-benchmarks/)
- [9to5Google「Gemini 3.7 Flash launches three weeks after last model, live in Spark」](https://9to5google.com/2026/08/13/gemini-3-7-flash-launch/)
- [9to5Google「Gemini 3.5 Pro delays due to coding performance, upgraded Flash model in testing」](https://9to5google.com/2026/07/16/gemini-3-5-pro-delays/)
- [CloudZero「Gemini pricing in 2026」](https://www.cloudzero.com/blog/gemini-pricing/)