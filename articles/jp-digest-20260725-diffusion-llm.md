---
title: "拡散言語モデルとは？LLMが2.42倍速くなる新しい生成の仕組み"
emoji: "🌫️"
type: "tech"
topics: ["llm", "ai", "machinelearning", "nvidia"]
published: false
---

## いま「拡散言語モデル」がざわついている理由

LLM（大規模言語モデル）の生成って、そろそろ「速さ」がかなり大事になってきましたよね。今回は海外の論文と複数の技術メディア、公式発表を突き合わせて、日本の読者向けに再構成しました。

2026年7月1日、NVIDIAが「Nemotron-Labs-TwoTower」というモデルをオープンウェイト（重みが公開されていて自分で動かせる）で公開しました。ライセンスは NVIDIA Nemotron Open Model License です。

このモデルは拡散言語モデル（diffusion language model、略してdLLM）というタイプ。ポイントは、すでにある自己回帰モデルに、後から並列生成を足したことなんです。品質は元モデルの98.7%を保ったまま、生成スループット（単位時間あたりに生成できる量）が2.42倍になりました。

しかも、一から作り直していません。ここが今回いちばん面白いところです。

拡散言語モデルという言葉自体は新しくありません。後で出てくる Mercury や Gemini Diffusion が先にあります。ただ、「既存資産の上に後付けできる」とかなりはっきり示されたのが、今回の変化というわけです。

![拡散言語モデルの要点](/images/jp-digest-20260725-diffusion-llm/figure1.png)

## そもそも自己回帰と拡散、何が違うの

いまのLLMのほぼ全部は自己回帰（autoregressive、AR）方式です。「次の1トークン（単語のかけら）」を予測して、1個ずつ左から右に並べていきます。だから出力が長いほど、その回数だけ待つことになります。ラーメン屋で麺を1本ずつ出される感じです。つらい。

一方、拡散方式は考え方が逆です。まずブロック全体を[MASK]（穴あき）で埋めておいて、「ノイズ除去」を何回か繰り返して、穴を一気に埋めていきます。画像生成の拡散モデルが、砂嵐みたいなノイズから絵を浮かび上がらせるのと同じ発想を、テキストに持ち込んでいます。

TwoTowerの場合は完全な一括生成ではなく、ブロック単位で進む準自己回帰（semi-autoregressive）です。1ブロックはS個のトークン（既定でS=16）で、これをT回の除去ステップで磨いていきます。各ステップで、確信度がしきい値γ（既定0.8）を超えた位置だけ確定させます。

おもしろいのは、最初の1ステップでほとんどのトークンが確定して、残りのステップは自信のない位置だけを詰めていく挙動になること。だから「何回も回すのに結果的に速い」が成立します。ここは arXiv の論文（arXiv:2606.26493）に載っている図がいちばん分かりやすいです。

![自己回帰と拡散の違い](/images/jp-digest-20260725-diffusion-llm/figure2.png)

![TwoTower論文のFigure 1](/images/jp-digest-20260725-diffusion-llm/source1.png)
*出典: arXiv:2606.26493 Nemotron-Labs-TwoTower 論文 Figure 1（https://arxiv.org/html/2606.26493v2）*

## 数字で見る：どれくらい速いのか

Inception Labsの公式ブログに載っている比較表では、H100 GPU（計算用GPU）での計測として、スループット（トークン/秒）は Mercury Coder Mini が 1,109、Mercury Coder Small が 737。同じ表の比較対象は Gemini 2.0 Flash-Lite が 201、Claude 3.5 Haiku が 61、GPT-4o Mini が 59 です。桁が違います。

Google DeepMindの Gemini Diffusion は 2025年5月20日に実験的モデルとして公開され、1,479トークン/秒。コーディングのベンチマークでは HumanEval 89.6%、MBPP 76.0% と、普通の自己回帰モデルと張り合える水準です。ただし今も実験段階で、限られたテスターに配っている状態です。

後継の Mercury 2 は 1,000トークン/秒超。DigitalAppliedの2026年2月27日の解説記事では、GPT-5.2 のおよそ10倍の速さで、品質はフロンティアモデル（最先端級モデル）比 85〜95% と整理されています。ただこの「10倍」「85〜95%」は1媒体のまとめなので、数字だけ一人歩きさせないほうがよさそうです。

今回のTwoTowerは 2.42倍。条件は H100を2枚、γ=0.8、S=16 です。論文の図では、品質をもっと削ってよければ3倍あたりまで伸ばせるカーブも出ています。

トークン/秒が3桁に乗ると、体感はかなり変わります。いままで「文章が流れてくる」のを眺めていたのが、「もう出てるじゃん」になります。エレベーター待ちが自動ドア通過くらいになる感じです。早すぎません？

![生成スループット比較](/images/jp-digest-20260725-diffusion-llm/figure3.png)

![Inception Labsのベンチマーク表](/images/jp-digest-20260725-diffusion-llm/source4.png)
*出典: Inception Labs「Introducing Mercury」ベンチマーク表（https://www.inceptionlabs.ai/blog/introducing-mercury）*

![Mercury 2の解説記事](/images/jp-digest-20260725-diffusion-llm/source3.png)
*出典: DigitalApplied「Mercury 2: Diffusion LLM at 1000+ Tokens/Second」（https://www.digitalapplied.com/blog/inception-labs-mercury-2-diffusion-llm-speed-guide）*

## 「2つの塔」でどうやって速くしてるのか

TwoTowerの名前の由来は、モデルを2つの塔（tower）に分けたことです。

左の塔はAR/コンテキスト塔。凍結（frozen、重みを一切いじらない）されています。すでに学習済みの自己回帰バックボーンをそのまま使って、プロンプトと確定済みトークンを順番に読む役です。

右の塔は拡散/デノイザー塔。こっちだけを新しく学習します。穴あきブロックを、左の塔の各層から情報をもらいながら磨いていく役です。

なぜ分けるのか。従来の拡散言語モデルは、1つのネットワークが「きれいな文脈を保つ役」と「ノイズを消す役」の両方を背負っていて、そこが容量のボトルネックでした。役割を分けるとそれが解ける、というのが論文の主張です。

副産物として、凍結した左の塔ではKVキャッシュ（一度計算した内部状態を使い回す高速化の仕組み）とMamba-2（層の種類）の状態がそのまま使えます。純粋な双方向注意の拡散モデルだとKVキャッシュが壊れて速度を稼ぎにくいので、ここは地味に効いています。

ベースは Nemotron-3-Nano-30B-A3B。各塔は52層で、内訳は Mamba-2 が23層、自己注意が6層、MoE（Mixture of Experts、専門家の切り替え）が23層。MoEは128個のエキスパートのうち6個＋共有2個が動きます。合計はおよそ60Bパラメータで、1トークンあたり実際に動くのは塔ごとに約3Bです。

学習コストも効率的です。デノイザー塔の学習は約2.1兆トークン。バックボーン自体の事前学習は25兆トークンなので、その一部で済んでいます。つまり、自己回帰のチェックポイントを持っているチームなら、2つ目のネットワークを足すだけで並列生成を後付けできる。ここが業界的にかなりインパクトのある部分です。

![TwoTowerの2つの塔](/images/jp-digest-20260725-diffusion-llm/figure4.png)

![Hugging Faceのモデルカード](/images/jp-digest-20260725-diffusion-llm/source2.png)
*出典: Hugging Face nvidia/Nemotron-Labs-TwoTower-30B-A3B-Base-BF16 モデルカード（https://huggingface.co/nvidia/Nemotron-Labs-TwoTower-30B-A3B-Base-BF16）*

## いいことばかりじゃない（ハマりどころ）

もちろん、魔法の杖ではありません。品質は少し落ちます。

分野別だと、一般知識は約1点、コードは約3〜4点、数学は約2〜3点の低下。常識推論と多言語はむしろ戻るか少し改善しています。個別スコアだと MMLU 78.56→78.24、HumanEval 79.27→75.58、GSM8K 92.49→90.14。これで全体平均が98.7%というわけです。

ブロックサイズの落とし穴もキツいです。S=16で学習したモデルを S=64 でサンプリングすると HumanEval が 76.40 から 19.85 まで落ちます。条件によっては2.20まで落ちた記録もあります。学習時とサンプリング時のブロックサイズを揃えないと崩壊します。ここ、設定ファイル1行で地雷を踏むタイプですね。

動かすGPUも軽くはありません。拡散モードをフルで動かすにはGPU 2枚、BF16（16ビット浮動小数点形式）で1枚あたり約59GB。自己回帰モードだけなら80GBのGPU 1枚で足ります。

拡散言語モデル全般の弱点もあります。トークンを1個ずつ流すストリーミング表示ができない。出力の長さを先に見積もる必要がある。順番に積み上げる思考、つまりchain-of-thought（途中の考えを順に書く推論）が要るタスクは苦手。さらに、自己回帰まわりに比べて本番運用のノウハウやエコシステムがまだ薄いです。

論文も構造的な制約に触れています。凍結した塔は拡散向けに適応できないので長い生成では効きにくい可能性があります。それと、左から右に確定していく癖、つまり自己回帰的なバイアスも残っています。

![拡散言語モデルのハマりどころ](/images/jp-digest-20260725-diffusion-llm/figure5.png)

## じゃあ現場でどこに使う？

向いているのは、速さがそのまま体験になるところです。

まずコード補完。とくにFill-in-the-Middle（コードの途中の穴埋め）は相性がよさそうです。Inception Labsの表だと Mercury Coder Small が 84.8、Mercury Coder Mini が 82.2 に対して、GPT-4o Mini は 60.9、Claude 3.5 Haiku は 45.5。ここは差が大きいです。

ほかには翻訳、分類、構造化された出力（決まった形式で吐かせるやつ）、それと大量のバッチ処理。まとめて処理してナンボ、という場面ではかなり気持ちよく使えそうです。

逆に、じっくり考える系は向いていません。同じ表の LiveCodeBench だと Mercury Coder Mini は 17.0 で、Claude 3.5 Haiku の 31.0 に負けています。難しいコード課題は、素直に自己回帰モデルに任せたほうがいいです。

つまり「全部置き換える」ではなく、「速さが効く工程だけ差し替える」が現実的です。ツール箱に新しい電動ドライバーが増えた、くらいの感覚がちょうどいいかもしれません。

![拡散言語モデルの使いどころ](/images/jp-digest-20260725-diffusion-llm/figure6.png)

## まとめ

拡散言語モデルは、「1個ずつ」から「まとめて磨く」への発想転換です。うまくハマると、トークン/秒が桁で変わります。

2026年7月のTwoTowerが示したのは、それを既存の自己回帰モデルに後付けできるということでした。デノイザーだけ学習すればいい。これはかなり大きいです。

ただし、品質は数点落ちます。ブロックサイズの設定ミスで一気に壊れます。ストリーミングもできません。なので、万能選手ではなく用途を選ぶ道具です。

とはいえ、Nemotron-Labs-TwoTowerは重みが公開されています。環境がある人は、まず手元で試してみると楽しそうです。数字だけ見るより、「あ、これは待ち時間の感覚が違うやつだ」と体で分かるはずです。

### 参考にした記事

- [Nemotron-Labs-TwoTower: Diffusion Language Modeling with Pretrained Autoregressive Context（arXiv:2606.26493）](https://arxiv.org/html/2606.26493v2)
- [NVIDIA Releases Nemotron-Labs-TwoTower（MarkTechPost）](https://www.marktechpost.com/2026/07/01/nvidia-releases-nemotron-labs-twotower/)
- [nvidia/Nemotron-Labs-TwoTower-30B-A3B-Base-BF16（Hugging Face モデルカード）](https://huggingface.co/nvidia/Nemotron-Labs-TwoTower-30B-A3B-Base-BF16)
- [Introducing Mercury, the World's First Commercial-Scale Diffusion Large Language Model（Inception Labs）](https://www.inceptionlabs.ai/blog/introducing-mercury)
- [Mercury 2: Diffusion LLM at 1000+ Tokens/Second（DigitalApplied）](https://www.digitalapplied.com/blog/inception-labs-mercury-2-diffusion-llm-speed-guide)
- [Diffusion LLMs from the Ground Up: Training, Inference, and Practical Engineering（Daily Dose of DS）](https://www.dailydoseofds.com/diffusion-models-part-2/)
- [Gemini Diffusion: API Pricing, Context Window & Benchmarks（LLM Stats）](https://llm-stats.com/models/gemini-diffusion)