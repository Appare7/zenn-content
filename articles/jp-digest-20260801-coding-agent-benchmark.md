---
title: "SWE-benchとは？コーディングエージェント比較の落とし穴"
emoji: "📏"
type: "tech"
topics: ["llm", "ai", "benchmark", "aiagent"]
published: false
---

AIコーディングエージェントの発表を見ると、だいたい出てきますよね。「SWE-bench Verified で◯◯%」という数字。  
でも、その「あの%」の土台が、2026年に入ってかなりガラッと入れ替わりました。  
この記事は、海外の公式発表と技術メディア、それに論文をいくつか読み比べて、自分なりに組み直しました。  
ベンチマークを捨てよう、ではなく、読み方をアップデートしよう、という話です。

![](/images/jp-digest-20260801-coding-agent-benchmark/figure1.png)

## SWE-benchとは？まず「あの%」の正体から

SWE-bench は、GitHub 上の実際の issue（課題チケット）と、それを直した実際のプルリクエスト（変更提案）から作られたベンチマークです。

やっていることは、わりと現場っぽいです。AIエージェントにリポジトリ（コード置き場）と issue を渡して、「じゃあ直してみて」と修正パッチ（修正差分）を書かせます。で、そのリポジトリに元からあるテストが通れば正解、という測り方です。

この時点で、ただのクイズではなく「実コードに触る力」を見ようとしているわけですね。だから、コーディングAIの評価として注目されてきました。

その中でも、人手で「これはちゃんと解ける問題だ」と検証して500問に絞ったものが SWE-bench Verified です。長いあいだ、コーディングAIの事実上の通信簿みたいな扱いを受けていました。

ここまでは前提です。  
問題はこの先なんです。

## 2026年2月、OpenAIが「もう使わない」と言った

2026年2月23日を最後に、OpenAI は SWE-bench Verified での評価報告をやめました。

しかも公式ポストのタイトルが、そのまま「なぜ SWE-bench Verified はもうフロンティアのコーディング能力を測れないのか」。かなりストレートですよね。

理由は大きく2つあります。

1つ目は、テストが壊れていたこと。  
難しい問題138件を監査したところ、「失敗」と判定されたケースの少なくとも59.4%は、テスト側がおかしくて機能的に正しい解を弾いていました。

これ、かなり痛いです。モデルがちゃんと直していても、採点側が「不正解！」と言ってしまう。試験でいうと、解答は合っているのに採点表が間違っている感じです。いや、それは困る。

2つ目は、答えが漏れていたこと。  
モデルにタスクIDを見せるだけで、元の問題文や正解パッチ、つまり gold patch（正解パッチ）をそのまま再現できてしまうケースがありました。これは自社の GPT-5.2 を含め、テストしたフロンティアモデル全部で起きていました。

ここまで来ると、もう「コードを読んで直せるか」ではなく、「知っている問題を思い出せるか」になってしまいます。ベンチマークとしては、ちょっとつらいですよね。

OpenAI は代わりに SWE-bench Pro を報告していこう、と呼びかけました。さらに、業界全体でコーディング評価の基準を作り直そう、とも言っています。OpenAI Developers の X アカウントでも告知されています。

うちなりにツッコむなら、自分のモデルが高得点を取れていたベンチを自分から下ろすのは、けっこう珍しい動きです。普通なら「うち強いです！」で押し切りたくなるところですからね。

![](/images/jp-digest-20260801-coding-agent-benchmark/source1.png)
*出典: byteiota（https://byteiota.com/openai-abandons-swe-bench-verified-59-flawed-tests/）*

## 数字で見る「壊れていた証拠」

研究側からも、同じ方向の指摘が出ていました。ACL 2025 で発表された UTBoost という研究です。著者は Boxi Yu・Yuxuan Zhu・Pinjia He・Daniel Kang です。

この研究では、SWE-bench のタスクにテストを足して測り直しました。すると、テストが甘くて「正解」扱いされていたパッチが345件見つかりました。テストが足りないタスクは36件です。

つまり、「本当はその修正では足りないのに、既存テストだと通ってしまっていた」ケースがあったわけです。これも現場のテストあるあるですね。テストが通ったから安心、と思ったら、別の条件で普通に壊れるやつです。

影響範囲も小さくありません。  
SWE-bench Lite のリーダーボード登録の40.9%、SWE-bench Verified の24.4%に影響しています。実際の順位変動は Lite で18件、Verified で11件ありました。

ここで見たいのは、モデル自体は何も変わっていない、という点です。  
テストを厳しくしただけで順位が動く。モデルはそのままなのに、採点方法が変わると結果も変わる。これ、地味にえぐいです。

ベンチマークの数字を見るとき、「モデルの性能」だけを見ているつもりになりがちです。でも実際には、「問題セット」「テスト」「採点ルール」もまとめて見ています。そこが揺れると、数字も揺れるんです。

![](/images/jp-digest-20260801-coding-agent-benchmark/figure2.png)

## 後継の SWE-bench Pro は「覚えさせない」設計

では、次に何を見るのか。そこで出てくるのが、Scale AI が作った SWE-bench Pro です。

SWE-bench Pro は、1,865問／41リポジトリで構成されています。実際に動いているソフトから作った、長丁場、つまり long-horizon（長い手順が必要な）タスク集です。

内訳がかなり独特です。

| セット | 問題数 | 中身 |
|---|---:|---|
| 公開セット | 731問 | GPL系のコピーレフト（改変物にも同じライセンスを強制する仕組み）のリポジトリ |
| 非公開セット | 276問 | スタートアップ18社の商用コード。そもそもインターネット上に存在しない |
| held-out（伏せ札）セット | 858問 | 結果を公表しないセット |

リポジトリの内訳は、公開11・伏せ12・商用18です。

公式に挙げている狙いは4つあります。

- データ汚染（学習時に評価コードを見てしまっている問題）
- タスクの多様性不足
- 簡単すぎる問題
- 当てにならないテスト

特に面白いのは、公開セットに GPL系のコピーレフトなリポジトリを使っているところです。  
ライセンスを盾にして学習データに入りにくくする、という発想が地味に面白いです。技術ではなく法務でカンニングを防ぐ、というアプローチ。そこから来るのか、という感じがあります。

もちろん、これで全部完璧です、という話ではありません。けれど、少なくとも「覚えていた問題を再現するだけで高得点」になりにくくしようとしているのは見えます。

![](/images/jp-digest-20260801-coding-agent-benchmark/figure3.png)

![](/images/jp-digest-20260801-coding-agent-benchmark/source2.png)
*出典: Scale Labs リーダーボード SWE-Bench Pro（Public Dataset）（https://labs.scale.com/leaderboard/swe_bench_pro_public）*

## ネットに無いコードだと、順位まで入れ替わる

ここが、この記事のいちばんの山場です。

Scale Labs のリーダーボードは、公開セットと非公開、つまり商用セットの両方を出しています。同じモデルの数字を並べると、落差がはっきり見えます。

公開セットでは、こうです。

| モデル | 公開セット |
|---|---:|
| Muse Spark 1.1 | 61.50%（±3.10） |
| gpt-5.4 (xHigh) | 59.10%（±3.56） |
| Muse Spark | 55.00%（±3.60） |
| claude-opus-4-6 (thinking) | 51.90%（±3.61） |
| gemini-3.1-pro (thinking) | 46.10%（±3.60） |

非公開セットでは、こうなります。

| モデル | 非公開セット |
|---|---:|
| Muse Spark 1.1 | 51.50%（±5.50） |
| claude-opus-4-6 (thinking) | 47.10%（±6.07） |
| Muse Spark | 44.70%（±6.05） |
| gpt-5.4 (xHigh) | 43.40%（±6.03） |
| gemini-3.1-pro (thinking) | 32.20%（±5.69） |

落差も見てみます。

| モデル | 落差 |
|---|---:|
| gpt-5.4 (xHigh) | 15.7ポイント |
| gemini-3.1-pro (thinking) | 13.9ポイント |
| Muse Spark 1.1 | 10.0ポイント |
| claude-opus-4-6 (thinking) | 4.8ポイント |

公開セットでは gpt-5.4 (xHigh) が claude-opus-4-6 (thinking) より上にいます。ところが、非公開セットでは逆転します。

ここ、かなり大事です。  
ネット上にあるコードと、そもそもネットに無い商用コードでは、同じモデルでも見え方が変わる。しかも、ただ点が下がるだけではなく、順位まで入れ替わります。

さらに、誤差の幅にも注意です。±が3〜6ポイントあります。1位と2位の差がその中に収まっているケースもあります。

誤差より小さい差で「1位です」と言うのは、体重計の誤差より軽い増減でダイエットの成否を語るようなものです。昨日より0.2kg減った！勝った！と思ったら、体重計のブレでした、みたいな。切ない。

ついでに、SWE-bench Verified で80〜95%あたりに張り付いていた同じ世代のモデルたちが、Pro では50〜60%台まで落ちます。  
つまり、Verified の数字だけを見て「もうほぼ解けてるじゃん」と思うのは、だいぶ危ないわけです。

![](/images/jp-digest-20260801-coding-agent-benchmark/figure4.png)

![](/images/jp-digest-20260801-coding-agent-benchmark/source5.png)
*出典: Scale Labs リーダーボード SWE-Bench Pro（Private Dataset）（https://labs.scale.com/leaderboard/swe_bench_pro_private）*

## もう一本の柱、Terminal-Bench の話

コーディングと言っても、パッチを当てるだけではありません。  
ターミナルで手を動かす能力も、現場ではめちゃくちゃ大事ですよね。ログを見る、コマンドを打つ、環境を作る、設定を直す。コードを書く前後の作業がけっこう重いです。

その能力を測るのが Terminal-Bench です。スタンフォード大学と Laude Institute の共同プロジェクトで、Snorkel AI が外部から大きく貢献しています。これまでに100人近い開発者が参加しています。

測り方は、タスクごとに専用の Docker（アプリ実行環境を固める仕組み）コンテナを立てます。そこにエージェントを入れて、実際にコマンドを打たせます。最後に、コンテナの状態をテストで検証する、という流れです。

Terminal-Bench 2.0 は2025年11月7日公開の89タスクです。再現しないタスクや、そもそも解けないタスクを削って作り直した版です。同時に Harbor という、コンテナ実行の面倒を引き受けるフレームワークも出ています。ローカルの1件から数千並列まで同じ書き方でいけます。

タスクの中身も、なかなか重量級です。

たとえば、SSH（遠隔操作の通信方式）越しに Git サーバを立てて、main と dev のブランチを Nginx（Webサーバ）で別々の HTTPS（暗号化されたWeb通信）エンドポイントに配信します。さらに自己署名証明書を使い、post-receive フック（push後に動く処理）で push から3秒以内にデプロイを完了させる。

……いや、普通に仕事です。  
「ちょっとコマンド打てるか見ますね」くらいの軽さではありません。

![](/images/jp-digest-20260801-coding-agent-benchmark/source4.png)
*出典: Artificial Analysis「Terminal-Bench v2.1」の Example Tasks（https://artificialanalysis.ai/evaluations/terminalbench-v2-1）*

## ベンチのバグを直したら、スコアが12.1ポイント上がった

2026年5月6日に出た Terminal-Bench 2.1 は、この記事でいちばん覚えて帰ってほしい話です。

Terminal-Bench 2.1 は、89タスクのうち28タスクを修正して、継続的な検証、つまり continuous validation（継続的に壊れていないか確かめる仕組み）を入れたバージョンです。

直した中身は3種類あります。

- ピン留めしていた Docker イメージが勝手に変わってしまっていたもの：9件
- 正しく解くには足りないリソース、つまり時間やメモリしか与えていなかったもの：8件
- 指示とテストがズレていたもの

で、スコアがこう動きました。

| モデル | 修正前 | 修正後 | 差分 |
|---|---:|---:|---:|
| Opus 4.6（Claude Code） | 58.0% | 70.1% | +12.1ポイント |
| Gemini 3.1 Pro（Terminus 2） | 63.0% | 70.7% | +7.6ポイント |
| GPT-5.3-Codex（Codex CLI） | 73.3% | 79.1% | +5.8ポイント |
| GPT-5.4（Codex CLI） | 76.0% | 77.3% | +1.3ポイント |

ここで大事なのは、モデルは1バイトも変わっていないことです。

ベンチ側のバグを直しただけで12ポイント動きました。しかも上がり幅がモデルごとにバラバラなので、順位の解釈も変わってしまいます。

だから、バージョンをまたいだスコアの比較は、もうやっちゃダメなんです。  
「2.0ではAが上、2.1ではBが上」みたいな話を、同じ土俵のように語るとかなり危ないです。

現在の Terminal-Bench v2.1 で Artificial Analysis が独立に計測している数字だと、GPT-5.6 Sol（xhigh）が 89.5%、Claude Opus 5（Adaptive Reasoning・Max Effort）が 89.1%です。

この計測は、Terminus 2 というハーネス（エージェントの足回り）を e2b のサンドボックス（隔離実行環境）上で走らせ、1タスクにつき3回試した pass@1（1回目の回答で通る割合）の平均、という条件で揃えています。

条件を揃える。  
これ、地味ですがめちゃくちゃ大事です。

![](/images/jp-digest-20260801-coding-agent-benchmark/source3.png)
*出典: Terminal-Bench 公式ニュース「Terminal-Bench 2.1」（https://www.tbench.ai/news/terminal-bench-2-1）*

## 同じモデルなのに数字が動く、ハーネス問題

ここからは、英語圏の分析メディア digitalapplied がまとめている話です（この節の数字は同メディアの分析によるもの、という前提で読んでください）。

同じ Claude Opus 4.5 でも、走らせるエージェント基盤を3つ変えると、50.2%〜55.4% と 5.2ポイントの幅が出ました。

同じモデルなのに、です。  
中身のLLM（大規模言語モデル）が同じでも、ツールの渡し方、ファイルの見せ方、コマンド実行の設計、リトライの仕方みたいな足回りが違うと、数字が動いてしまいます。

Scale AI は、ハーネスの選び方だけで10〜20ポイント動くとしています。

さらに、SWE-bench Verified のリーダーボードは、2026年6月16日時点で100件の登録のうち99件がベンダーの自己申告です。

つまり、「モデルAが3ポイント上」みたいな比較は、足回りが揃っていない限りほぼ意味がありません。  
3ポイント差で盛り上がっていたら、実はハーネス差のほうが大きかった、というオチが普通にありえます。ベンチマーク、思ったより足場がぬかるんでいます。

ここで見たいのは、モデル名だけではありません。  
どのハーネスで、誰が、どんな環境で、何回走らせたのか。そこまで見ないと、数字だけがひとり歩きします。

## じゃあ、コーディングエージェント比較はどう読めばいい？

では、実務ではどう読めばいいのか。  
ニュースやリーダーボードを見るときは、次の5つをチェックしてみてください。

1. **誰が測ったかを見る**  
   ベンダーの自己申告なのか、第三者が固定環境で測ったものなのか。まずここです。自己申告が全部ダメという話ではありません。ただ、比較に使うなら、誰が測った数字なのかはかなり効きます。

2. **足回り、つまりハーネスが揃っているかを見る**  
   エージェントの中身が違えば、同じモデルでも数字は動きます。モデル比較のつもりが、実はエージェント基盤比較になっていることがあります。ここ、ほんとにハマりどころです。

3. **誤差の幅を見る**  
   ±3〜6ポイントなら、1位と2位は同着だと思っておくくらいでちょうどいいです。小数点以下まで見て勝ち負けを語りたくなりますが、そこまで細かく見ると逆に外します。

4. **性格の違うベンチを2本並べる**  
   SWE-bench Pro は長丁場のパッチ作業を見ています。Terminal-Bench はターミナル操作を見ています。どちらもコーディング能力の一部ですが、同じものではありません。片方だけで「強い・弱い」を決めると、かなり雑になります。

5. **最後は自分のリポジトリで20〜30件回す**  
   結局これがいちばん効きます。自分たちのコード、自分たちのテスト、自分たちの開発フローで動かすと、公開ベンチでは見えないクセが出ます。公開ベンチは足切りに使うもの、と割り切るくらいがちょうどいいです。

補足すると、ベンチのバージョンが変わったら、過去のスコアとは並べないほうがいいです。  
Terminal-Bench 2.0 と 2.1 の話でも見た通り、ベンチ側の修正だけで数字が大きく動きます。同じ名前っぽく見えても、土俵が変わっていることがあります。

![](/images/jp-digest-20260801-coding-agent-benchmark/figure5.png)

## まとめ

2026年に起きた大きな変化は、「モデルが賢くなった」だけではありません。  
むしろ、「測り方が作り直された」という変化がかなり大きいです。

数字を捨てる必要はありません。でも、数字だけで決めるのはもう無理があります。  
公開ベンチでざっくり見て、最後は手元のリポジトリで回す。結局それがいちばん早いです。

### 参考にした記事

- [Why SWE-bench Verified no longer measures frontier coding capabilities（OpenAI）](https://openai.com/index/why-we-no-longer-evaluate-swe-bench-verified/)
- [Separating signal from noise in coding evaluations（OpenAI）](https://openai.com/index/separating-signal-from-noise-coding-evaluations/)
- [OpenAI Abandons SWE-bench Verified: 59% Flawed Tests（byteiota）](https://byteiota.com/openai-abandons-swe-bench-verified-59-flawed-tests/)
- [SWE-Bench Pro Leaderboard（Public Dataset）（Scale Labs）](https://labs.scale.com/leaderboard/swe_bench_pro_public)
- [SWE-Bench Pro Leaderboard（Private Dataset）（Scale Labs）](https://labs.scale.com/leaderboard/swe_bench_pro_private)
- [SWE-bench Pro（arXiv:2509.16941）](https://arxiv.org/abs/2509.16941)
- [Terminal-Bench 2.1（Terminal-Bench 公式）](https://www.tbench.ai/news/terminal-bench-2-1)
- [Terminal-Bench 2.0: Raising the bar for AI agent evaluation（Snorkel AI）](https://snorkel.ai/blog/terminal-bench-2-0-raising-the-bar-for-ai-agent-evaluation/)
- [Terminal-Bench v2.1 Benchmark Leaderboard（Artificial Analysis）](https://artificialanalysis.ai/evaluations/terminalbench-v2-1)
- [UTBoost: Rigorous Evaluation of Coding Agents on SWE-Bench（arXiv:2506.09289 / ACL 2025）](https://arxiv.org/abs/2506.09289)
- [SWE-bench in 2026: Benchmarks vs Scaffolding Reality（digitalapplied）](https://www.digitalapplied.com/blog/swe-bench-verified-june-2026-benchmark-vs-scaffolding-analysis)
