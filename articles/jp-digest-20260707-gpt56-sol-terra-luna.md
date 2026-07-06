---
title: "GPT-5.6 Sol・Terra・Lunaの違いと使い分け"
emoji: "☀️"
type: "tech"
topics: ["llm", "ai", "openai", "chatgpt"]
published: false
---

OpenAIが、GPT-5.6を「Sol・Terra・Luna」という3モデルの家族として発表しました。登場したのは2026年6月末、6月25日ごろ。この記事では、複数の海外解説記事と公式プレビュー情報をもとに、日本の開発者向けに「で、どれ使えばいいの？」が見えるように再構成しました。

![GPT-5.6は3兄弟で登場：Sol・Terra・Lunaをどう選ぶ？](/images/jp-digest-20260707-gpt56-sol-terra-luna/figure1.png)

名前が Sol（太陽）・Terra（地球）・Luna（月）なの、ちょっとエモいですよね。宇宙っぽい。でも中身はかなり現実的で、「全部を最強モデルで殴る」よりも「用途ごとにモデルを切り替える」方向へ、かなりはっきり寄せてきた印象です。

## GPT-5.6は「3兄弟」で来た――まず何が起きたのか

GPT-5.6は、単一モデルとしてではなく、Sol（ソル）・Terra（テラ）・Luna（ルナ）の3モデルで同時に登場しました。名前はそれぞれ、太陽・地球・月に由来しています。ここだけ聞くと「ネーミングに全力出してきたな……」という感じもありますが、ちゃんと役割も分かれています。

ただし、ここでいきなり大事な注意点です。

発表時点のGPT-5.6は「限定プレビュー」です。OpenAIのAPI（アプリやサービスからモデルを呼び出す窓口）とCodex（コード作業向けの入口）経由のみで、承認された一部の組織だけが使える状態です。ChatGPT（チャット形式でAIを使うサービス）の無料・Plus・Proでは、プレビュー中は使えません。

つまり、「新モデルきた！今すぐ触るぞ！」とは、まだいかないんです。ここはちょっと焦らされますね。

報道では、VentureBeatが「米政府と連携した限定プレビュー」という位置づけも伝えています。今後はChatGPT・Codex・APIへ、数週間かけて広げていく予定とされています。

![出典: VentureBeat（OpenAI unveils GPT-5.6 Sol, Terra and Luna models）](/images/jp-digest-20260707-gpt56-sol-terra-luna/source3.png)
*出典: VentureBeat（https://venturebeat.com/technology/openai-unveils-gpt-5-6-sol-terra-and-luna-models-but-only-accessible-to-limited-preview-partners-for-now-per-us-gov）*

## Sol・Terra・Luna の違い（役割分担）

3モデルの違いをざっくり言うと、フルスペックの高級車がSol、毎日乗る実用車がTerra、街乗りの軽がLuna、みたいな住み分けです。全部すごい車だけど、買い物に行くのに毎回高級車を出す必要はないですよね、という話です。

Solは最上位モデルです。複雑な多段推論（何段階も考えて答えを出すこと）、自律エージェント（人の代わりに手順を進めるAI）、研究、難しいコード生成に向いています。最高の「max」推論の強さと、「ultra」モードを解放できるのはSolだけです。名前どおり太陽ポジションですね。まぶしい。

Terraはバランス型で、「日常のデフォルト」になるモデルです。前世代GPT-5.5並みの実力を、約2倍安く出せるのが売りです。チャット、RAG（検索して答えを作る仕組み）、普通の本番APIに向いています。迷ったらまずTerra、という立ち位置ですね。

Lunaは軽量・高速・格安です。分類、振り分け、ルーティング（処理先を選んで流すこと）、大量処理に向きます。深い推論がいらない仕事を、一番安くさばく担当です。前処理やコンテンツのフィルタリングなど、「賢さはほどほどでいいから大量に回したい」場面で効いてきます。

![難問はSol・日常はTerra・大量はLuna：3モデルの役割分担](/images/jp-digest-20260707-gpt56-sol-terra-luna/figure2.png)

ここで面白いのは、3モデルが単なる「強い・中くらい・弱い」ではないところです。もちろんSolが最上位ではあるのですが、Terraには普段づかいの安定感があり、Lunaには安さと速さがあります。運用する側から見ると、むしろこの分け方のほうがありがたいんですよね。

## 数字で見る料金――出力は入力の6倍、が全ティア共通

次は料金です。API料金は、100万トークン（AIが読む・書くテキスト量の単位）あたりのUSDで出ています。

Solは、入力が$5.00、出力が$30.00。  
Terraは、入力が$2.50、出力が$15.00。  
Lunaは、入力が$1.00、出力が$6.00です。

どのティアでも共通しているのは、「出力は入力の6倍」という構造です。ここ、地味に大事です。チャットやエージェントのように長い返答を出す用途では、入力よりも出力コストがじわじわ効いてきます。プロンプト（AIへの指示文）を短くするだけでなく、「どれくらい長く答えさせるか」もコストに直結するわけです。

そしてもうひとつ大事なポイントがあります。Solの$5/$30は、前世代GPT-5.5と同じ値段です。つまり、最上位のSolは安くなっていません。ここは正直に見ておきたいところです。「新世代だから全部安い！」ではないんですよね。

値下げの恩恵が大きいのは、TerraとLunaのほうです。特にTerraは「GPT-5.5並みの性能を約2倍安く」がウリになっています。ふだんの本番運用で使うなら、この差はかなり効きそうです。

![GPT-5.6のAPI料金比較：Sol・Terra・Luna（100万トークンあたり）](/images/jp-digest-20260707-gpt56-sol-terra-luna/figure3.png)

![出典: Tech Jacks Solutions（GPT-5.6 Pricing: Sol vs Terra vs Luna）](/images/jp-digest-20260707-gpt56-sol-terra-luna/source1.png)
*出典: Tech Jacks Solutions（https://techjacksolutions.com/ai-tools/chatgpt/gpt-5-6-pricing/）*

## ベンチマークで見る実力（Terminal-Bench 2.1）

性能面では、Terminal-Bench 2.1（コマンドラインやコーディング系のベンチマーク）のスコアが出ています。スコアはパーセントです。

Sol Ultraは91.9。Solは88.8。前世代GPT-5.5は88.0。Lunaは84.3。Terraは82.5です。

まず、Sol Ultraが91.9で頭ひとつ抜けています。Sol単体でも88.8なので、前世代GPT-5.5の88.0を上回っています。難しいコードや複雑な推論でSolを使いたくなる理由は、数字にも出ていますね。

一方で、ちょっと面白い結果もあります。このコーディング系ベンチでは、格安のLunaが84.3で、Terraの82.5より上に出ています。早すぎません？ というより、安いモデルでも特定のタスクではかなり戦える、という見方ができそうです。

ただし、ここで「LunaのほうがTerraより常に上」と決めつけるのは危ないです。Terraはあくまで「バランス型の日常デフォルト」です。ベンチマークの1指標だけで、モデル全体の上下を決めるより、「その処理で何が必要か」を見たほうがよさそうです。

![Terminal-Bench 2.1スコア比較：Sol Ultraが91.9で最上位](/images/jp-digest-20260707-gpt56-sol-terra-luna/figure4.png)

## 現場での使い分け――「簡単はLuna、難問だけSol」

では、実務ではどう使い分けるのがよさそうか。ここでの定石は「賢いルーティング」です。つまり、簡単なリクエストはLunaに流し、本当に難しいものだけSolに回す。これがコスト最適化で一番効く打ち手になりそうです。

分類・振り分け・大量バッチ処理ならLuna。  
チャットやRAGなど、普段の本番運用ならTerra。  
長い多段推論、自律エージェント、研究、複雑なコードならSol。

この分け方にすると、「全部Solでやって請求を見て震える」みたいな展開を避けやすくなります。もちろんSolは強いです。でも、強いモデルを必要なところだけに使うほうが、運用としては健全ですよね。

さらに、料金面では割引の仕組みも効いてきます。

ひとつはプロンプトキャッシュ（同じ前置きを使い回すと安くなる仕組み）です。キャッシュの読み込みは約9割引きになります。Solなら、入力が実質$0.50/100万トークン相当まで下がります。ただし、キャッシュ書き込みは通常入力の1.25倍です。毎回同じシステム指示や長い前提を入れるようなアプリでは、かなり効きそうです。

もうひとつはバッチAPI（まとめて非同期処理する仕組み）です。入力・出力とも最大5割引きになります。リアルタイムで返す必要がない処理、たとえば大量の分類やまとめ処理なら、こういう割引を使わないともったいないですね。

スピード面では、SolがCerebras上で最大毎秒750トークンという高速提供を、7月に予定しています。フロンティア級の賢さを速く出せるのは魅力です。ただし、ここでも「速くなった＝安くなった」ではありません。Solは前世代GPT-5.5と同じ価格なので、速さと賢さに価値がある場面で使いたいところです。

![現場での使い分けフロー：簡単はLuna・難問だけSol](/images/jp-digest-20260707-gpt56-sol-terra-luna/figure5.png)

![出典: eesel AI（GPT-5.6 pricing: what Sol, Terra, and Luna actually cost）](/images/jp-digest-20260707-gpt56-sol-terra-luna/source2.png)
*出典: eesel AI（https://www.eesel.ai/blog/gpt-5-6-pricing）*

## まとめ――「どれが最強か」じゃなく「どれをどこで使うか」

GPT-5.6の肝は、単一の最強モデルが出たことではなく、「用途で選ぶ3階層」に整理し直したことだと感じます。

ざっくり指針はこうです。迷ったらTerraを普段づかいのデフォルトにする。大量で軽い処理はLunaに任せる。本当に難しいところだけSolを使う。そして、プロンプトキャッシュやバッチAPIの割引を合わせる。これだけでも、かなりコスト感が変わってきそうです。

もちろん注意点もあります。今はまだ限定プレビューで、誰でもすぐ触れるわけではありません。一般提供のタイミングで価格が変わる可能性もあります。なので、今の段階では「設計思想と価格感を先に把握しておく」くらいの温度感がちょうどよさそうです。

Sol・Terra・Lunaという名前はかなりロマンがありますが、実際の使い方はとても現実的です。太陽を毎回呼び出すのではなく、月で足りる仕事は月に任せる。地球で普段を回して、ここぞという時だけ太陽を出す。そんなモデル運用が、これからさらに普通になっていきそうですね。一般提供で触れる日が楽しみです。

### 参考にした記事

- OpenAI公式プレビュー: https://openai.com/index/previewing-gpt-5-6-sol/
- DataCamp「GPT-5.6 Sol, Terra, and Luna」: https://www.datacamp.com/blog/gpt-5-6-sol-luna-terra
- VentureBeat「OpenAI unveils GPT-5.6 Sol, Terra and Luna」: https://venturebeat.com/technology/openai-unveils-gpt-5-6-sol-terra-and-luna-models-but-only-accessible-to-limited-preview-partners-for-now-per-us-gov
- eesel AI「GPT-5.6 pricing」: https://www.eesel.ai/blog/gpt-5-6-pricing
- Tech Jacks Solutions「GPT-5.6 Pricing: Sol vs Terra vs Luna」: https://techjacksolutions.com/ai-tools/chatgpt/gpt-5-6-pricing/
- Finout「GPT-5.6 Pricing 2026」: https://www.finout.io/blog/gpt-5.6-pricing-2026-sol-terra-and-luna-tiers-explained
