---
title: "LLM APIの料金比較｜OpenRouterで安いモデルに自動で流す"
emoji: "🚦"
type: "tech"
topics: ["llm", "ai", "openrouter", "litellm"]
published: false
---

LLM（大規模言語モデル）のAPI（アプリから機能を呼ぶ窓口）を触っていると、「結局どのモデルが安くて十分なの？」を毎回考えるハメになりますよね。しかも新モデルが出るペースが早すぎません？ 2026年7月17日〜23日のたった1週間で、主要な公開が7〜8本ありました。

この記事は、特定の1本を翻訳したものではなく、複数の海外記事と公式ドキュメント・公式発表をもとに再構成しています。結論だけ先に言うと、LLM APIの料金比較は入り口でしかなくて、「料金表を見比べる」から「安いモデルへ自動で流す」に発想を変えると、コストが数十％単位で変わるんです。

![モデルが毎週出てくる時代の、リクエストの交通整理](/images/jp-digest-20260728-llm-router-gateway/figure1.png)

## 料金の差が100倍になった、というのが出発点

まず、2026年6月時点の参考価格です。条件は $/100万トークン。出典は DigitalApplied のエンジニアリングガイド（2026年6月14日公開）です。

| モデル | 入力 | 出力 |
|---|---:|---:|
| DeepSeek V4 | $0.44 | - |
| Claude Haiku 4.5 | $1 | $5 |
| Claude Sonnet 4.6 | $3 | - |
| GPT-5.5 | $5 | $30 |
| Claude Opus 4.8 | $25 | $25 |
| GPT-5.5-pro | $30 | $180 |

一番安い層と一番高い層で、価格差はおよそ100倍。同じ「LLMのAPI」なのにこの開きなんです。全部を一番賢いモデルに投げるのは、封筒を出すのに毎回バイク便を呼ぶようなもの。豪華すぎる。

しかも選択肢は毎週増えます。DigitalApplied のまとめでは、2026年7月17日〜23日の1週間だけで、Kimi K3（Moonshot）、Qwen3.8-Max-Preview（Alibaba）、Qwen-Audio-3.0-TTS（Alibaba）、Gemini 3.6 Flash とその派生（Google）、Laguna S 2.1（poolside）、Qwen-Image-3.0（Alibaba）、Ling-3.0-flash（Ant Group）、FLUX 3（Black Forest Labs、発表）が出ています。

同記事は「7本のうち5本は能力向上というより効率改善だった」「毎回の発表を自動アップグレードとして扱うのはやめよう」とも書いています。つまり、最強モデル1本に決め打ちする発想自体がもう合わない、というわけです。

![2026年6月時点の参考価格。一番安い層と一番高い層で約100倍ひらいている](/images/jp-digest-20260728-llm-router-gateway/figure2.png)

![DigitalApplied のLLMルーティング解説。RouteLLMの85%削減、必要な最上位モデル呼び出しは14%、価格差100倍、ルール型オーバーヘッド1ミリ秒未満が冒頭に並ぶ](/images/jp-digest-20260728-llm-router-gateway/source3.png)
出典: DigitalApplied（https://www.digitalapplied.com/blog/llm-model-routing-2026-cost-quality-optimization-engineering-guide）

## LLMルーターって、結局なにをしてくれる子なの？

LLMルーターは、リクエストが来るたびに「これを捌ける中でいちばん安いモデル」を選んで送る層です。AIゲートウェイ（人工知能向けの出入口）は、複数プロバイダを1つのAPIにまとめ、フェイルオーバー（障害時の切り替え）・負荷分散・利用状況の可視化までやる層。

2026年時点では、良いツールはこの両方をやるので、呼び名の区別はゆるくなっています。Eden AI の比較記事も「ルーターとゲートウェイに違いはあるのか」という節を立てているくらいです。

判断材料は、コスト・レイテンシ（応答の遅さ）・品質・可用性・リージョン・タスク種別など。LiteLLM 公式ドキュメントでは、実装レベルの戦略として次が出ています。

- simple-shuffle（既定・推奨）: rpm（1分あたりのリクエスト数）/ tpm（1分あたりのトークン数）の比率で配分
- latency-based: 応答が速かった先を優先
- usage-based v2: そのタイミングでトークン消費が少ない先へ流す。本番では Redis（使用量を追跡する置き場）で追跡
- least-busy: 同時処理数がいちばん少ない先を選ぶ
- cost-based: いちばん安い先を選ぶ
- カスタム戦略も書ける

信頼性の仕組みもセットです。優先順位づけ、重み付け、クールダウン（失敗した接続先を一時的に休ませる）、指数バックオフ付きリトライ（待ち時間を伸ばしながら再試行）、フォールバック（別候補への逃がし）があります。

![ルーターは「振り分け」、ゲートウェイは「統一API＋フェイルオーバー＋可視化」。いまは両方入りが普通](/images/jp-digest-20260728-llm-router-gateway/figure3.png)

## 数字で見る効果：「85%削減」の中身

軸になるのは RouteLLM。LMSYS が2024年7月1日に公開したオープンソースのルーティング研究で、論文は arXiv 2406.18665、ICLR 2025 です。

公式ブログでは、強いモデル＝GPT-4、弱いモデルと組み合わせた場合に、MT Bench でコスト削減85%超、そのうえで GPT-4の性能の95%を維持。MMLU では45%のコスト削減、GSM8K では35%のコスト削減でした。品質維持の95%は、評価した各ベンチマークで共通の水準です。

面白いのは MT Bench。行列分解（matrix factorization）ルーターは、Arena のデータだけだと GPT-4呼び出しが26%必要でした。そこに LLM による判定データを足すと14%まで下がったんです。裏返すと、86%のクエリは弱いモデルで足りていたわけです。

ただし、ここは正直に。MMLU では、正解ラベルで増強しても GPT-4呼び出しが54%必要でした。分野によって「弱いモデルで足りる割合」は全然違います。なので、自分のワークロードで測るしかありません。

商用のルーティングサービスである Martian、Unify AI と同等の性能を、40%以上安く出せたとも書かれています。実運用レンジでは、DigitalApplied が40〜85%、Eden AI が30〜85%。Eden AI の試算では、月100万リクエストを「簡単60% / 標準30% / 複雑10%」で階層化すると、月$6,000 → $1,020、つまり83%減です。

DigitalApplied の別の目安では、Haiku/Opus を70:30で分けると約67%減、DeepSeek/Opus を80:20だと約79%減、50:50だと約48%減。BERT分類器ベースのルーターは MMLU で45%のコスト削減、同等品質です。もちろん、数字は環境依存です。ここ大事。

![RouteLLM（LMSYS）の解説記事。性能とコストの散布図で「Ideal Router」がどこを狙う話かが分かる](/images/jp-digest-20260728-llm-router-gateway/source1.png)
出典: LMSYS Org（https://lmsys.org/blog/2024-07-01-routellm/）

## で、遅くならないんですか？

いちばん気になるやつです。DigitalApplied によると、振り分け判断そのものの時間はこうです。

- ルールベース: 1ミリ秒未満
- 埋め込みベース: 約5ミリ秒
- 機械学習の分類器: 50〜100ミリ秒
- 比較対象として、LLMの推論そのもの: 500〜2,000ミリ秒

つまり、ルール型・埋め込み型なら誤差レベル。分類器を挟んでも推論時間の1割前後です。

ゲートウェイ側の数字もあります。ClawRouters の比較記事による計測では、Bifrost 約11マイクロ秒、Helicone 約20ミリ秒、ZenMux 約30ミリ秒、OpenRouter と Portkey が各約40ミリ秒、LiteLLM が50ミリ秒以上。ただし、この計測は自社製品を売っている側が出したものなので、鵜呑みにせず順序の目安として読むのが安全です。

もう少し検証しやすい材料もあります。Vercel AI Gateway は「20ミリ秒未満」を掲げていて、コーディングエージェントの Cline が1週間かけて従来のルーターと本番トラフィックをA/Bで分けた結果、よく使うモデル群で P99（遅い上位1%の境目）のストリーミング遅延が10〜14%改善し、エラー率は43.8%下がった、という事例が Cline と Vercel の双方から公開されています。ゲートウェイを挟んだのに速くなったのは、経路の多くが公衆インターネットではなく専用のバックボーンを通るからだと説明されています。

結論、遅延は「ルーターを入れる／入れない」より「どの方式で判断するか」で決まります。

![判断方式ごとのオーバーヘッド。推論そのものが500〜2000msなので、ルール型・埋め込み型は誤差の範囲](/images/jp-digest-20260728-llm-router-gateway/figure4.png)

## 主要ツール、どう使い分ける？

| ツール | ざっくり立ち位置 |
|---|---|
| OpenRouter | マーケットプレイス型。まず試すならここ |
| LiteLLM | 自前で持ちたい人向け |
| Portkey | キャッシュや統制まで欲しいとき |
| Vercel AI Gateway | 上乗せゼロで薄く挟みたいとき |
| Braintrust | 評価とセットで品質ベースにしたいとき |

OpenRouter の対応規模は媒体で幅があります。Braintrust は「60以上のプロバイダの400以上のモデル」、Eden AI は「300以上のモデル」、ClawRouters は「623以上のモデル」。数え方が違うので幅があります。

Auto Router は2種類あり、旧 `openrouter/auto` は NotDiamond 製で非推奨、現行は `openrouter/auto-beta`。Auto Beta は「タスクの種類を分類し、直近7日間の実際の利用額シェアでランキングする」仕組みです。品質重視の設定で GPQA Diamond の正答率が83.8%。旧Autoは同条件で50%でした。cost / quality tradeoff は0〜10で、0が品質優先、10がコスト優先。Auto Beta の既定値は9です。

セッション固定（session stickiness）も便利です。同じ会話の続きは同じモデル・同じプロバイダに固定されます。メッセージの指紋か `session_id` で判定し、5分間動きがないと解除。プロンプトキャッシュ（同じ前置きの再利用による割引）が効きやすくなるのがうれしいところ。Auto Router 自体に追加料金はなく、選ばれたモデルの通常料金だけです。一方、クレジット購入時の手数料は媒体によって5%と5.5%で記述が割れています。課金まわりは必ず公式の最新ページを見てください。

LiteLLM は MITライセンスのオープンソースのプロキシ兼SDK。100以上のLLMをOpenAI互換のインターフェースで扱えます。仮想キー、予算、レート制限、支出トラッキングがあり、セルフホストなら無料です。

Portkey は250以上のプロバイダ、Apache 2.0のオープンソース。条件付きルーティング、フォールバック、サーキットブレーカー（障害時に遮断する仕組み）に加えて、シンプルキャッシュとセマンティックキャッシュ（意味が近い質問の使い回し）で重複呼び出しを減らせます。無料枠は1万リクエストのログ、有料は月$49から。

Vercel AI Gateway は、2026年4月時点で40以上のプロバイダ組織。トークンはプロバイダの定価どおりでマークアップ（上乗せ）ゼロ、BYOK（自分のAPIキー持ち込み）でも上乗せなし。プロバイダのアカウントを個別に作らなくてよく、新規アカウントに月$5のクレジットがあります。

Braintrust は experiments（実験）とオンラインスコアリング（本番中の採点）に結びつけた品質ベースのルーティングが特徴。無料枠は処理データ1GBと1万スコア、Proは月$249です。

その他では、Eden AI は500以上のモデル、プラットフォーム手数料5.5%、EUのデータプライバシー対応。Cloudflare AI Gateway はエッジ配置、コア機能は無料。Bifrost はオープンソースの高速ゲートウェイですが、実装言語がGoと書く媒体とRustと書く媒体があり食い違っています。TrueFoundry、Kong AI Gateway はエンタープライズ向けです。

![主要ツールの立ち位置。マーケットプレイス型／セルフホスト型／マネージド型で選ぶ軸が変わる](/images/jp-digest-20260728-llm-router-gateway/figure5.png)

![OpenRouter公式ドキュメントのAuto Router。Auto Beta、コスト/品質ダイヤル、セッション固定などの項目が並ぶ](/images/jp-digest-20260728-llm-router-gateway/source4.png)
出典: OpenRouter Docs（https://openrouter.ai/docs/features/model-routing）

![LiteLLM公式ドキュメントのRouter。負荷分散、クールダウン、フォールバック、リトライが並ぶ](/images/jp-digest-20260728-llm-router-gateway/source2.png)
出典: LiteLLM Docs（https://docs.litellm.ai/docs/routing）

## 実際、どこから手をつける？

多くのルーター／ゲートウェイは OpenAI互換です。つまり、`base_url` と `api_key` を差し替えるだけで動き出すことが多いです。

```python
client = Client(
    base_url="<ゲートウェイのURL>",
    api_key="<ゲートウェイのAPIキー>",
)

response = client.chat.completions.create(
    model="<ルーターまたはモデル名>",
    messages=[{"role": "user", "content": "要約して"}],
)
```

段取りはこんな感じで十分です。

1. まず1週間、どのリクエストが何にいくら使っているかを可視化する  
2. 簡単／標準／複雑にざっくり3階層で仕分ける  
3. カスケード（まず小さいモデルに投げて、ダメそうなら上位へ上げる）を試す  
4. プロンプトキャッシュ・セマンティックキャッシュを併用する  

効果の目安としては、Haiku/Opus を70:30で分けると約67%減、DeepSeek/Opus を80:20だと約79%減でした。もちろん、ここも自分のログで確認です。

## ハマりどころ（ここが本題かもしれない）

いちばん怖いのは、静かに品質が落ちることです。DigitalApplied は、50〜500件の代表的なテストケースをマージ前のCI（変更前に自動で動く確認）に入れて、気づかないうちの劣化を止めることを勧めています。

ルーター自体が単一障害点になるのも忘れがち。フォールバックとクールダウンの設定はセットで見てください。LiteLLM にはこの機能があります。

データがどこを通るかも大事です。マネージド型は自分のトラフィックが第三者を経由します。ログの保持やリージョン・コンプライアンス設定は先に見ておきたいところ。Eden AI がEUのデータプライバシー対応を売りにしているのは、逆に言えばそこが論点だからです。

手数料の記述もブレます。OpenRouterのクレジット手数料は媒体で5%と5.5%に割れていました。公式の最新ページで確認するのが早いです。

あと、ベンダーが出した比較記事の数字は、その会社に有利に作られていることがあります。レイテンシ表は、信じるというより「自分で測る前の仮説」くらいの距離感がちょうどいいです。

毎週の新モデルも、反射的に採用しないほうが安全です。DigitalApplied は「週30分のトリアージ」を勧めています。見るのは3問だけ。「今日使えるか」「第三者の検証があるか」「自分のワークロードの経済性が改善するか」。これくらいでちょうどいいです。

![静かな品質劣化、単一障害点、データ経路、手数料の記述ブレ。ルーティングの落とし穴](/images/jp-digest-20260728-llm-router-gateway/figure6.png)

## まとめ

LLM APIの料金比較は入り口です。その先にあるのは、「リクエストごとに選ぶ」という設計です。

数字をもう一度だけ。2026年6月時点で価格差はおよそ100倍。RouteLLMは MT Bench で85%超のコスト削減と95%の品質維持。実運用の報告は30〜85%。ルール型の判断オーバーヘッドは1ミリ秒未満です。

ただし、MMLU では54%が最上位モデルを必要とした例もあります。なので、自分のワークロードで測るところからしか始まりません。

週7本モデルが出る世界で、1つのモデルに配線を固定するほうがむしろリスクです。まずはログを見て、安く流せるところから流してみてください。請求額、けっこう素直に反応してくれるはずです。
### 参考にした記事

- [RouteLLM: An Open-Source Framework for Cost-Effective LLM Routing — LMSYS Org](https://lmsys.org/blog/2024-07-01-routellm/)
- [RouteLLM: Learning to Route LLMs with Preference Data — arXiv](https://arxiv.org/abs/2406.18665)
- [LLM Model Routing in 2026: Cost-Quality Optimization — DigitalApplied](https://www.digitalapplied.com/blog/llm-model-routing-2026-cost-quality-optimization-engineering-guide)
- [Seven Days, Seven Model Releases: The New AI Normal — DigitalApplied](https://www.digitalapplied.com/blog/seven-days-seven-releases-july-2026-model-wave)
- [Best LLM Routers in 2026: Compared by Cost, Latency & Features — Eden AI](https://www.edenai.co/post/best-llm-routers)
- [Best LLM routers and model routing platforms in 2026 — Braintrust](https://www.braintrust.dev/articles/best-llm-routers-2026)
- [Best LLM Routers 2026: 11 Tools Tested — ClawRouters](https://www.clawrouters.com/blog/best-llm-routers-2026)
- [Auto Router — OpenRouter Docs](https://openrouter.ai/docs/features/model-routing)
- [Router - Load Balancing — LiteLLM Docs](https://docs.litellm.ai/docs/routing)
- [7 Best AI Gateways in 2026, Compared — Vercel](https://vercel.com/i/best-ai-gateways)
- [Cline now runs on Vercel AI Gateway — Vercel](https://vercel.com/blog/cline-on-ai-gateway)
- [The Cline Provider Now Runs on the Vercel AI Gateway — Cline](https://cline.bot/blog/cline-provider-now-runs-on-vercel)
