---
title: "AI文章判定の精度は？99%でも誤検知が起きる理由"
emoji: "🔍"
type: "tech"
topics: ["生成ai", "ai", "llm", "chatgpt"]
published: false
---

「この文章、AIが書いたやつ？」――この問いに答えるツールが、また一段進んできました。

2026年7月29日、AI検出（AIが書いた文章かどうかを判定する技術）を作っているPangram（パングラム）という会社が、新しい検出モデル「Pangram 4」を発表しました。同じ日に、AI画像検出のリサーチプレビュー（研究段階の先行公開）も出しています。

ぱっと見ると、数字はかなり強いです。AI生成テキストの検出率は99.66%。false positive（誤検出。人間が書いた文をAIだと間違えること）は0.0041%。「約24,000本に1本しか間違えない」と聞くと、もう勝負あった感じがしますよね。

でも、ここが面白いところです。数字を追っていくと、その「99.66%」の裏側はけっこう複雑なんです。この記事では、公式発表と海外の技術メディア・報道を複数本読み込んで、自分なりに再構成しながら、「AI文章判定って、結局どこまで信じていいの？」を見ていきます。

![AI文章判定の精度をめぐる話](/images/jp-digest-20260730-ai-text-detector/figure1.png)

## 何が起きた？AI検出の会社が新モデルと資金調達を同時発表

今回の主役はPangramです。2026年7月29日、新しいテキスト検出モデル「Pangram 4」を発表し、同じ日にAI画像検出モデルのリサーチプレビューも公開しました。テキストだけでなく画像にも広げてきたわけで、守備範囲を一気に広げにきた感じがあります。

あわせて、900万ドルの資金調達も発表しています。リードはMenlo Venturesで、Haystack、ScOp Venture Capital、Script Capital、Cadenzaが参加。累計調達額は約1,300万ドルで、ここには2025年6月の270万ドルも含まれます。

創業者はMax SperoとBradley Emiの2人。どちらもスタンフォード大学でAI・機械学習を学んだ出身で、創業はおよそ2年前です。かなり若い会社ですが、すでに使われている先として、Substack（ニュースレター配信サービス）、Quora、学校・大学、出版社や著作権エージェント、採用担当者が挙がっています。

個人向けには月20ドルのサブスクでウェブから使えます。Chromeの拡張機能もあり、企業向けにはAPIも用意されています。つまり「研究用のすごいモデル」ではなく、もう実務の入口に置かれているタイプのツールなんですよね。

CEOのSperoは、The DecoderやSiliconANGLEの報道で「完全にAIが生成したコンテンツはもうそこら中にあって、その多くは開示されていない」といった趣旨の発言をしています。たしかに、ネット上の文章を読んでいて「これ、人が書いたのかな？」と感じる場面は増えました。

Pangram自身の数字としては、年間売上は前年比35倍。月間ユーザーは2025年6月の2,700人から2026年6月には12万人になったとされています。これはThe Decoderが報じた数字で、ニューヨーク・タイムズの記事を参照しているものです。

AIが書いた文章が増えるほど、それを見分けるビジネスも大きくなる。便利さが火をつけて、その火消し道具も売れる。ちょっと皮肉な構図ですよね。

![Pangramの資金調達を報じたTechCrunch](/images/jp-digest-20260730-ai-text-detector/source1.png)
出典: TechCrunch（https://techcrunch.com/2026/07/29/as-ai-content-floods-the-internet-pangram-raises-9m-to-detect-it/）

## 数字で見るPangram 4：24,000本に1本しか間違えない、らしい

では、Pangram 4の数字を見ていきましょう。ここで大事なのは、以下の数字がすべてPangram自身の評価による数字だという点です。第三者の独立検証ではありません。ここ、あとで効いてきます。

Pangram自身の評価によると、AI生成テキストの検出率は99.66%。false positive（誤検出。人間が書いた文をAIだと間違えること）の率は0.0041%で、ざっくり「約24,000本に1本」とされています。

false negative（見逃し。AIが書いた文を人間だと判定してしまうこと）の率は0.3396%。前世代のPangram 3では1.99%だったので、かなり下がったという説明です。

モデルのサイズは前世代の6倍以上。誤検出は14分の1、見逃しは6分の1になったとしています。数字だけ見ると、めちゃくちゃ伸びています。前モデルからの改善幅としては、かなり攻めた発表です。

さらに、humanizer（ヒューマナイザー。AIが書いた文をわざと人間っぽく書き換えて検出をすり抜けさせるツール）への耐性もアピールされています。市販の13種類のツールを通した文章でも、AIが関わっていることを98.83%の割合で見抜いた、という主張です。

最新のフロンティアモデル（各社の最上位モデル）については、いずれのモデルファミリでも見逃し率0.7%未満だとしています。かなり広い範囲をカバーしている、という打ち出し方ですね。

面白いのは、判定の粒度です。Pangram 4は、完全にAIが生成した文、AIに手伝ってもらった文、人間とAIが混ざった文、人間の文をAIで軽く磨いただけの文、という4段階を区別できるとされています。単に「AIか人間か」の二択ではないわけです。現場ではむしろこのグラデーションのほうが厄介ですよね。「ちょっと整えてもらっただけです」は、かなり普通に起きますから。

料金も2026年7月29日から変わっています。APIは100語あたり0.05ドル。個人プランは月30万語＋画像スキャン100回、Proプランは月150万語＋画像スキャン500回。画像スキャンは追加料金なしで全プランに付くとのことです。

前世代のPangram 3は、2ヶ月の移行期間を経て、2026年9月30日に提供終了予定です。つまり、Pangramとしてはこの新モデルへかなりはっきり舵を切っています。

画像検出のリサーチプレビューも出ています。対応するとされる生成モデルは、GPT Image、Gemini Nano Banana、Midjourney、FLUX、Grok Imagine、Kling AI、Seedance、Google Veo、Wan。方式としてはピクセル単位の分布を分析し、実写の中に埋め込まれたAI生成部分も見つけられるとしています。

ただし、何度でも強調しておきたいポイントがあります。ここまでの数字はすべてPangram自身のベンチマークです。第三者の独立検証ではありません。カタログスペックとしては強い。でも、それをそのまま現場の真実にしていいかは別問題です。

![Pangram 4の主な数字](/images/jp-digest-20260730-ai-text-detector/figure2.png)

![Pangram公式ブログ「Introducing Pangram 4」](/images/jp-digest-20260730-ai-text-detector/source3.png)
出典: Pangram Labs 公式ブログ（https://www.pangram.com/blog/introducing-pangram-4）

## どうやって見分けてるの？「文体の指紋」を当てにいく仕組み

では、そもそもAI検出ツールはどうやって見分けているのでしょうか。Pangramの仕組みはclassifier（分類器。入力がどのカテゴリに属するかを判定するニューラルネットワーク）です。ざっくり言うと、テキストが「LLM（大規模言語モデル）っぽい響きか、人間っぽい響きか」を判定します。

学習には、2021年より前に書かれた「確実に人間が書いた文章」と、AIが生成した文章をペアにして使っています。この「2021年より前」というのがミソです。生成AIが普及する前なので、人間の文章だと確信しやすいからです。

Speroいわく、モデルが学んでいるのは「AIが一貫して行う文体上の選択」です。透かしやメタデータのコピペには頼っていないとされています。つまり、生成側が協力してくれなくても動く。ここが検出ツールの強みでもあり、同時に難しさでもあります。

対応言語は22言語です。日本語も入っています。ほかに、アラビア語・中国語・チェコ語・オランダ語・フランス語・ドイツ語・ギリシャ語・ヒンディー語・イタリア語・韓国語・ポーランド語・ポルトガル語・ロシア語・スペイン語・トルコ語・ウクライナ語・ベトナム語などがサポートされています。

多言語版の自社評価もあります。2024年9月公開の評価では、1言語あたり約2,000本で検証し、22言語すべてで精度99.44%〜100%。日本語は精度100%、誤検出率0%と報告されています。これだけ見ると「日本語いけるじゃん」と言いたくなりますが、これも自社評価です。そこは忘れずに見たいところです。

多言語で伸びた理由としては、非英語向けにtokenizer（トークナイザー。文章をモデルが読む単位に切り分ける部品）を変えたこと、active learning（能動学習）でウェブ規模のデータを集めたことが挙げられています。

そして、個人的に「そこか！」となったのが、東アジアの言語が語数カウントのバグで過小評価されていたのを直したことです。日本語話者としては、最後のやつが地味に効いていそうですよね。日本語はスペースで単語を区切らないので、語数まわりの扱いはわりと地雷です。足元の数え方、大事。

![AI検出は「文体の指紋」を当てにいく](/images/jp-digest-20260730-ai-text-detector/figure3.png)

![Pangram Labsの資金調達と技術を報じたSiliconANGLE](/images/jp-digest-20260730-ai-text-detector/source2.png)
出典: SiliconANGLE（https://siliconangle.com/2026/07/29/pangram-labs-raises-9m-launch-accurate-ai-detection-text-images/）

## ここからが本題。数字はベンダーごとに食い違う

ここからが本題です。Pangramの数字だけ見ると「かなり当たる」で終わりそうなのですが、競合の数字を見ると話がややこしくなります。

競合であるGPTZeroが公開している比較記事では、同じデータセットで測った結果として、GPTZeroは精度99.6%、誤検出率0.13%、recall（再現率。AI文をどれだけ取りこぼさず拾えるか）99.4%。一方でPangramは、精度97.5%、誤検出率0.20%、再現率95.4%となっています。

つまり、Pangramの自社発表では誤検出0.0041%なのに、GPTZeroの計測では0.20%。同じ製品なのに数字が50倍近く違うわけです。開きすぎません？

GPTZero側は「Pangramはほぼゼロの誤検出を主張しているが、実環境のテストではばらつきが出る」とも書いています。さらに、言い換え（paraphrasing）テストではPangramの方が弱い、とも述べています。

もちろん、ここでGPTZeroだけを正義にするのも違います。どちらもベンダー自身の計測です。片方だけを鵜呑みにする理由はありません。自社評価と競合評価は、どちらも「その会社が見せたい切り口」を持っている可能性があります。

TechCrunchの記者が自分で試した記録もあります。自分が書いた記事をAIに推敲させたものを入れたところ、「AI補助13%」と出て、これは妥当そうだったとのことです。ただし、人間が書いた文をAI補助だと拾ってしまった箇所もあり、逆にAIが直した箇所を見逃した箇所もありました。同じ記事を自分が書いたそのままの形で入れたときは、100%人間と正しく出たそうです。

この話から見えてくる教訓はシンプルです。カタログスペックの小数点以下をにらむより、「自分の手元のデータでどう出るか」を見た方がいいです。社内文書、学生レポート、記事原稿、採用課題。対象が変われば、出方も変わるかもしれません。

![ベンダーごとに数字が食い違う](/images/jp-digest-20260730-ai-text-detector/figure4.png)

![GPTZeroが公開しているPangramとの比較表](/images/jp-digest-20260730-ai-text-detector/source5.png)
出典: GPTZero（https://gptzero.me/news/gptzero-vs-pangram/）

## 大学はむしろ「使わない」方向に動いている

さらに大事なのが、教育現場の動きです。検出精度が上がっているのと並行して、教育機関はAI検出ツールを外していっています。ここ、今いちばん大事な逆風です。

Turnitin（大学で広く使われている剽窃チェックサービス）のAI検出機能を無効化した大学として報じられているのは、2023年のVanderbilt大学とGeorgetown大学、2024年のWestern University、University of Waterloo、そして2026年1月からのCurtin大学です。12校以上が無効化しているとされています。なお、Waterlooが停止した時期は「2024年後半」とする報道と「2025年」とする報道の両方があります。

University of Waterlooでは、手書きで書いた学生がAI利用として誤って検出される事例が続いたことを受けて、全学部でTurnitinのAI検出を停止しました。同大の学務担当は、誤検出率が「学業上の重大な判断に使うツールとしては受け入れられない」と述べたと報じられています。学内テストでは、非ネイティブの英語話者がネイティブのおよそ3倍の割合で検出に引っかかっていたそうです。

International Journal for Educational Integrityに掲載された研究では、人間が書いた文章に対する誤検出率は15〜26%とされています。ざっくり「4本に1本が引っかかりうる」ということです。もし自分の提出物がその「1本」になったら、かなりしんどいですよね。

そして決定打になっているのが、スタンフォード大学のLiangらの研究です。2023年、学術誌Patternsに掲載された研究で、非ネイティブ英語話者が書いたTOEFLのエッセイのうち61.3%が「AI生成」と誤判定されました。少なくとも1つの検出器に引っかかったものは97.8%。検証した7つの検出器すべてが誤判定したものも19.8%。全部、人間が書いたものなのに、です。

いっぽうで、ネイティブが書いた文章が誤検出されたのは約5.1%でした。差がかなり大きいです。

なぜそんなことが起きるのか。非ネイティブは英語を書くとき、語彙や言い回しが単純になりがちです。その特徴がChatGPTの文章とよく似ている、という説明です。研究の共著者Weixin Liangは、多くの検出器の設計が「語彙の多様性が限られた書き手を構造的に差別している」という趣旨のことを述べています。

これ、日本の読者にとって他人事じゃありません。英語で論文や資料を書く日本人は、まさに「語彙の多様性が限られた非ネイティブ」に該当します。日本語の判定精度が良くても、英語で書いたときは話が別。ここを混ぜると危ないです。

![人間が書いた文が誤検出される](/images/jp-digest-20260730-ai-text-detector/figure5.png)

![AI検出ツールが留学生を誤って告発していると報じたThe Markup](/images/jp-digest-20260730-ai-text-detector/source6.png)
出典: The Markup（https://themarkup.org/machine-learning/2023/08/14/ai-detection-tools-falsely-accuse-international-students-of-cheating）

## もう一本の道：「見分ける」より「最初から印を付ける」

ここまで見てきた検出は、出来上がった文章から「AIっぽいかどうか」を推測するアプローチです。これとは別に、生成した時点で印を付けておくという道があります。これがwatermark（ウォーターマーク。電子透かし）とprovenance（プロヴェナンス。来歴・出どころの記録）です。

業界は2層戦略を採っています。SynthID（目に見えない透かしを出力そのものに埋め込む）と、C2PA（Content Credentials。暗号署名つきのメタデータで来歴をたどれるようにする規格）の組み合わせです。片方だけだとスクショで消えたりするので、両方重ねるわけです。ベルトとサスペンダー、みたいな話ですね。

SynthIDはすでに1,000億枚を超える画像に埋め込まれているとされ、2026年時点でGoogleの画像・動画・音声・テキスト生成にはほぼ100%入っているとされています。OpenAIも2026年5月19日に、C2PA準拠になることと、画像にSynthIDの見えない透かしを追加することを発表しました。NVIDIAやElevenLabsも採用しています。

そして、ここで日付が効いてきます。EU AI Act（EUのAI規制法）の第50条が、2026年8月2日から適用されます。生成AIの提供者は、出力、つまり音声・画像・動画・テキストを機械可読な形式でマーキングし、AI生成だと検出できるようにする義務を負います。

第50条はほかにも、チャットボットは「AIと話している」と分かるように設計する義務、ディープフェイクや公共の関心事について公開されるAI生成テキストの開示義務を課します。ただし、人間が編集して責任を持ったテキストは開示義務の例外になります。

違反時の制裁金は、最大1,500万ユーロ、または全世界年間売上高の3%のいずれか高い方です。なかなか本気の金額です。

猶予もあります。2026年5月のAI Omnibus暫定合意によって、2026年8月2日より前からすでに市場に出ている生成AIシステムは、第50条(2)の機械可読マーキング要件については2026年12月2日まで猶予されます。

第50条は「高リスク」に分類されたシステムだけの話ではありません。生成AIでコンテンツを作るあらゆる事業者に関係します。ここは、生成AIをプロダクトに組み込んでいるチームほど見落としたくないところです。

ひとことで言うと、「AIが書いたか当てる」より「AIが書いたと最初から名乗る」の方が、そりゃ確実ですよね。後から筆跡鑑定するより、最初に名札を付けておくほうが強い。身もふたもないですが、そういう話です。

![透かしと来歴という別の道](/images/jp-digest-20260730-ai-text-detector/figure6.png)

![EU AI Act 第50条の実務ガイド](/images/jp-digest-20260730-ai-text-detector/source4.png)
出典: EU Artificial Intelligence Act（https://artificialintelligenceact.eu/transparency-rules-article-50/）

## じゃあ現場でどう線を引く？4つの落としどころ

### 1. 判定スコアを単独の「証拠」にしない

大学がAI検出ツールを外している理由が、まさにこれです。人を評価したり処分したりする判断には、判定スコア単独では絶対に足りません。スコアは入口のサインにはなっても、最後のハンコにはしないほうがいいです。

### 2. 非ネイティブの英語ほど誤検出しやすい、を前提に読む

スタンフォードの研究で出てきた61.3%という数字は、かなり重いです。英語で書く日本人は、観察者ではなく当事者側です。「英語がシンプルだからAIっぽい」と見られる可能性がある、という前提で扱いたいところです。

### 3. スコアは「AIっぽさの度合い」であって真偽ではない

検出ツールのスコアは、「AIが書いたという真実」を返しているわけではありません。どの閾値で引っかけるのか、引っかかったらどう扱うのか、という運用ルールとセットで決めてから導入する必要があります。Pangramの自社発表とGPTZero側の計測で、同じ製品の誤検出率が50倍近く違った例を思い出すと、手元のデータでの実測がかなり大事です。

### 4. これから作る側は、検出より開示に投資した方が筋がいい

透かしと来歴の記録は、推測ではなく事実として残ります。しかもEUでは2026年8月2日から義務が始まります。既存システムでも2026年12月2日には猶予が切れるので、これから作る側は「見破る」より「ちゃんと名乗る」に寄せたほうが筋がよさそうです。

![現場での4つの線引き](/images/jp-digest-20260730-ai-text-detector/figure7.png)

## まとめ：検出はすごく良くなった。でも「証拠」にはまだ遠い

Pangram 4は、かなり前進しています。誤検出は14分の1、見逃しは6分の1。ヒューマナイザーを通した文章でも98.83%でAIの関与を見抜いたとされています。日本語にも対応しています。

でも、その数字はPangram自身の評価です。競合であるGPTZeroの計測とは食い違っています。同じ製品なのに誤検出率が50倍近く違う、という話を見ると、「99%超えだから安心」とはなかなか言い切れません。

そして誤検出は、非ネイティブの書き手に偏って出ます。大学がAI検出ツールを外しているのは、まさにそのリスクがあるからです。人間が書いたのにAI扱いされる、しかもそれが特定の書き手に偏る。これは技術の問題であると同時に、運用の問題でもあります。

一方で、生成した時点で印を付ける方向は、制度側から一気に進みます。2026年8月2日。EU AI Act第50条の適用開始は、生成AIを扱う事業者にとってかなり大きな節目です。

なので、使うなら参考値として。判決文にはしない。AI文章判定は便利なセンサーですが、人を裁くハンマーにすると危ないです。現場では「スコアが出た、はい終了」ではなく、「なぜそう出たのか」「この人に不利な偏りはないか」「開示や来歴で解決できないか」までセットで見ていきたいですね。

## 参考にした記事

- [Introducing Pangram 4 — Pangram Labs 公式ブログ](https://www.pangram.com/blog/introducing-pangram-4)
- [As AI content floods the internet, Pangram raises $9M to detect it — TechCrunch](https://techcrunch.com/2026/07/29/as-ai-content-floods-the-internet-pangram-raises-9m-to-detect-it/)
- [Pangram Labs raises $9M to launch more accurate AI detection for text and images — SiliconANGLE](https://siliconangle.com/2026/07/29/pangram-labs-raises-9m-launch-accurate-ai-detection-text-images/)
- [Pangram says its new AI text detector makes only one mistake per 24,000 documents — The Decoder](https://the-decoder.com/pangram-says-its-new-ai-text-detector-makes-only-one-mistake-per-24000-documents/)
- [Pangram's AI Detector demonstrates strong performance in over 20 languages — Pangram Labs](https://www.pangram.com/blog/pangram-multilingual-v2)
- [GPTZero vs. Pangram: AI Detector Accuracy Comparison — GPTZero](https://gptzero.me/news/gptzero-vs-pangram/)
- [AI Detection Tools Falsely Accuse International Students of Cheating — The Markup](https://themarkup.org/machine-learning/2023/08/14/ai-detection-tools-falsely-accuse-international-students-of-cheating)
- [GPT detectors are biased against non-native English writers — arXiv (Liang et al., 2023)](https://arxiv.org/abs/2304.02819)
- [Curtin University to disable Turnitin AI detection tool in 2026 — EdTech Innovation Hub](https://www.edtechinnovationhub.com/news/curtin-university-to-disable-turnitin-ai-detection-tool-in-2026-as-debate-over-reliability-continues)
- [The EU AI Act's Transparency Rules: A Practical Guide to Article 50 — EU Artificial Intelligence Act](https://artificialintelligenceact.eu/transparency-rules-article-50/)
- [SynthID & Co: AI Watermarking & Content Provenance 2026 — Pragma-Code](https://www.pragma-code.de/en/blog-synthid-ai-watermarking-content-provenance)
- [Advancing content provenance for a safer, more transparent AI ecosystem — OpenAI](https://openai.com/index/advancing-content-provenance/)