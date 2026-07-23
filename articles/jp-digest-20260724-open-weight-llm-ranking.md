---
title: "オープンソースLLMランキング2026｜2.8兆パラメータ時代の選び方"
emoji: "🏆"
type: "tech"
topics: ["llm", "ai", "kimi", "オープンソース"]
published: false
---

2026年7月、オープンウェイト界隈がいきなり騒がしくなりました。たった2日のあいだに、大物モデルが2つ連続で出てきたんです。

7月15日には、旧OpenAI CTOのMira Muratiが2025年2月に創業したThinking Machines Labが、初のモデル「Inkling」を公開。翌7月16日には、中国のMoonshot AIが「Kimi K3」を発表しました。しかもKimi K3は総パラメータ2.8兆。当時としては世界最大のオープンウェイトモデルです。オープンなモデルって、もう少し小ぶりで可愛げのあるものでは？ という気持ちになりますよね。2.8兆、早すぎません？

この記事は、1本の記事を翻訳したものではありません。複数の海外記事と公式発表を読み比べて、日本のエンジニアが知りたい「結局どれが強いの？」「自社で動かせるの？」「いくらかかるの？」の順に組み直しています。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure1.png)
*2026年7月、オープンウェイトが一気に「フロンティア級」まで来た*

## 2日で2発、オープンウェイトの当たり年

まず時系列からいきます。

7月15日に出たのが、Thinking Machines LabのInklingです。こちらは発表と同時にオープンウェイトとして公開され、Hugging Faceから誰でもダウンロードできます。中身を見たり、改変したり、ファインチューニング（追加学習で自分用に仕立て直すこと）したりできる状態です。

そして翌7月16日に発表されたのが、Moonshot AIのKimi K3です。こちらは発表時点ではAPI（Application Programming Interface＝プログラムからサービスを呼び出す窓口）とWeb経由でのみ利用可能でした。フルの重み（ウェイト）公開は「2026年7月27日までに」と予告されています。この点は、Kimi公式ブログとSimon Willison氏の記事で確認されています。ライセンスについては、Decryptが修正版MITライセンス（ソフトウェア利用条件の一種）と報じています。

この2発が面白いのは、どちらも「研究用に置いておきました」みたいな温度感ではないところです。オープンウェイトが、フロンティアモデルの背中を遠くから眺める存在ではなく、かなり同じ土俵に近づいてきています。

その流れは、モデルルーティングサービスOpenRouterの2026年6月のブログでも触れられています。OpenRouterのブログによると、オープンウェイトモデルの知能と能力は米国のフロンティアラボに追従していて、18か月以上にわたって一貫して3〜6か月の差を保っているとのこと。つまり、フロンティア側がどんどん引き離しているようには、少なくとも今のところ見えないわけです。

![](/images/jp-digest-20260724-open-weight-llm-ranking/source4.png)
*出典: OpenRouter Blog（https://openrouter.ai/blog/insights/the-open-weight-models-that-matter-june-2026/）*

「オープンウェイトは実験用の小さいモデル」という見方は、もうだいぶ古くなってきました。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure2.png)
*7/15 Inkling、7/16 Kimi K3、そして7/27 のフルウェイト公開予告*

## そもそも「オープンソースLLM」と「オープンウェイト」は違うやつ

ここで用語を少しだけ丁寧に見ておきます。LLM（Large Language Model＝大規模言語モデル）の話では「オープンソースLLM」と「オープンウェイト」がごちゃっと使われがちですが、実務では分けて考えたほうが安全です。

オープンウェイトとは、学習済みの「重み（weights＝モデルが学習で獲得した数値パラメータの集合）」が公開されている状態のことです。つまり、モデルをダウンロードして、自社サーバーで実行したり、ファインチューニングしたりできます。

ただし、多くの場合は学習データの中身や学習コードまでは公開されません。なので、厳密な意味での「オープンソース」とは呼び分ける人が多いです。コードもデータも全部見える、というよりは、「学習済みモデルの重みは触れる」というニュアンスですね。

では何が嬉しいのか。まず、自社の環境で動かせるので、データを外に出さずに済みます。社内文書、顧客情報、機密性の高いログなどを扱う場面では、これはかなり大きいです。次に、外部APIの値上げや提供終了に振り回されにくくなります。さらに、自社データでファインチューニングして、業務に寄せた専用モデルにできます。

ただし、ライセンスは必ず見てください。たとえばKimi K3は修正版MITライセンスと報じられていますが、商用利用や再配布の条件はモデルごとに違います。「重みが落とせる＝何をしてもOK」ではありません。ここ、地味ですがハマるやつです。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure3.png)
*「重みが公開」と「全部公開」は違う。実務で効いてくるのはライセンス*

## 数字で見る2026年のオープンソースLLMランキング

では、いちばん気になるランキングの話にいきます。

フロントエンドコード生成の分野では、Kimi K3がかなり派手に勝っています。Arena.aiのFrontend Code Arenaは、人間が2つの出力を見比べて投票する形式のリーダーボードです。ここでKimi K3は1,679点で1位を取りました。Claude Fable 5が1,631点、GPT-5.6 Solが1,618点です。中国製モデルがこのベンチマークで首位を取ったのは初めてだと、Decryptやthe-decoderが伝えています。

![](/images/jp-digest-20260724-open-weight-llm-ranking/source1.png)
*出典: Decrypt（https://decrypt.co/373716/china-kimi-k3-largest-open-source-ai-model-ever-beats-claude-fable-gpt-5-6-sol）*

しかもKimi K3は、前世代のKimi K2.6では18位でした。そこから一気に1位。17ランクのジャンプです。Arena.aiの発表によると、フロントエンドの7ドメイン中6ドメインで1位を取っています。具体的には、Brand & Marketing、Reference-Based Design、Data & Analytics、Consumer Product、Simulations、Content Creation Toolsです。唯一2位だったのがGamingで、そこはFable 5が上でした。

ただし、「じゃあKimi K3が総合最強なのね」と言い切ると、ちょっと危ないです。総合力を見るArtificial Analysis Intelligence Indexでは、Kimi K3が57、Claude Fable 5が60で、僅差ながら負けています。ここはDecryptも触れています。

Kimi公式の自己申告ベンチマークでも、K3はClaude Opus 4.8 maxとGPT-5.5 highにはおおむね勝つ一方、Claude Fable 5とGPT-5.6 Solには及ばない、という見せ方になっています。この点はSimon Willison氏の記事でも紹介されています。自己申告でも負けを認めているのは、ちょっと誠実でいいですね。勝っているところだけ切り抜かないのは大事です。

一方で、オープンウェイト勢だけの総合ランキングを見ると、2026年6月時点のOpenRouterブログでは、Artificial Analysis Intelligence Index v4.1でGLM 5.2が51でトップです。続いてNVIDIA Nemotron 3 Ultraが48、MiniMax M3が44、DeepSeek V4 Proが44です。

コーディング系では、DeepSeek V4 ProがSWE-bench Verifiedで80.6%、DeepSeek V4 Flashが79.0%という数字も出ています。SWE-bench Verifiedは、ソフトウェアエンジニアリング寄りの能力を見る指標として扱われています。

ここまで見ると、「1つのベンチで1位＝最強」ではないのがよく分かります。フロントエンドが強いモデル、総合的に強いモデル、コーディングでコスパがいいモデル。それぞれ得意分野がかなり割れてきました。もう「この1体を選べば全部OK」みたいな時代ではないんです。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure4.png)
*同じ7月時点でも、指標を変えると首位の顔ぶれが入れ替わる*

## Kimi K3を分解する：2.8兆パラメータの中身

Kimi K3のいちばん目を引く数字は、やはり総パラメータ2.8兆です。とはいえ、2.8兆個のパラメータが毎回ぜんぶ動くわけではありません。

Kimi K3はMoE（Mixture of Experts＝混合エキスパート。全部の脳みそを毎回使わず、必要な一部だけ起こす仕組み）構成です。896個のエキスパート（専門家サブネットワーク）のうち、1トークンあたり16個だけが動きます。つまり、巨大な専門家集団を用意しておいて、入力ごとに必要な人だけ呼ぶようなイメージです。会議に全社員を呼ばない、みたいなものですね。

コンテキストウィンドウ（一度に読み込める文章量）は100万トークンです。さらに、画像と動画をそのまま理解できるネイティブなマルチモーダル対応（複数種類の入力を扱えること）で、推論が常時オン、つまりalways-on reasoningです。

Kimi公式ブログでは、アーキテクチャ名としてKimi Delta Attention（KDA）、Attention Residuals（AttnRes）、Stable LatentMoE、Per-Head Muon、Sigmoid Tanh Unit（SiTU）、Gated MLAが挙げられています。名前だけでも情報量が多いですね。ここは詳細な技術レポート待ち、と正直に言うのがよさそうです。名前から雰囲気で分かった気になるのが、いちばん危ないので。

2.8兆という数字の比較対象として、それまで最大級だったDeepSeek v4 Proは1.6兆でした。KimiはK3を「初のオープン3兆クラスモデル」と呼んでいます。2.8兆を3兆に丸めているわけで、Simon Willison氏もそこに軽くツッコミを入れています。まあ気持ちは分かります。2.8兆はほぼ3兆、と言いたくなる大きさです。

背景として見逃せないのが、米国のチップ輸出規制です。Decryptによると、Moonshotの社長は「We knew we didn't have the luxury to simply scale up compute」、つまり「単純にコンピュートをスケールアップする贅沢は許されないと分かっていた」と述べています。制約があるからこそ、効率化の工夫に向かったというわけです。

また、ドキュメントにはH200と「別ベンダーのGPGPU（General-Purpose computing on Graphics Processing Units＝GPUを汎用計算に使う仕組み）」への言及があり、これはHuawei AscendのハードウェアだとDecryptでは解釈されています。

## Inklingは真逆に賭けている

Kimi K3が「巨大さ」で目を引くなら、Inklingはかなり違う方向を向いています。

Inklingは総パラメータ9,750億、つまり975BのMoEです。平均的なプロンプトでは約410億、つまり41Bだけが動きます。学習データは、テキスト・画像・音声・動画あわせて45兆トークンです。入力は4つのモダリティすべてを扱えますが、出力はテキストのみです。ただし、そのテキストにはコード、装飾付きの成果物、構造化データも含まれます。このあたりはTechCrunchとSiliconANGLEが報じています。

![](/images/jp-digest-20260724-open-weight-llm-ranking/source3.png)
*出典: TechCrunch（https://techcrunch.com/2026/07/15/thinking-machines-amps-up-its-bet-against-one-size-fits-all-ai-with-its-first-open-model-inkling/）*

面白いのはビジネスモデルです。Thinking Machines Labは、API課金でモデル利用そのものから稼ぐ方向ではなく、モデルを自社タスク向けに仕立て直す有料プラットフォーム「Tinker」で収益化します。Tinkerは2025年10月に提供開始したファインチューニング用のAPIです。モデル本体はタダで配って、育てる場所でお金をもらう。かなり割り切った発想です。

思想もはっきりしています。TechCrunchによると、Thinking Machines Labは「万能な1つのAI」に賭けていません。中央で訓練されたAIより、組織が自分で適応させたAIのほうが良い成果を出す、という主張です。これは現場感がありますよね。どんなに賢い汎用モデルでも、自社の業務ルール、社内用語、判断基準までは最初から知りません。

実例として、投資会社Bridgewater Associatesとの共同プロジェクトがあります。カスタマイズしたモデルが金融推論のテストで84.7%を記録しました。コストについては報道によって数字の書き方が違います。TechCrunchは「実行コストは約14分の1」、SiliconANGLEは「最先端のプロプライエタリな選択肢を上回りながらコストは10%未満」と書いています。表現は違いますが、共通しているのは「1/10前後まで安くなった」という点です。

コーディング性能では、NVIDIAのNemotron 3 Ultraと同等の結果を、3分の2少ないトークンで達成したともSiliconANGLEは伝えています。単に精度だけでなく、必要なトークン量まで含めて効率を見るのが今っぽいところです。

会社の背景もなかなか強いです。Thinking Machines Labは2025年2月創業。Mira Muratiに加え、OpenAI共同創業者のJohn Schulman、元VPのLilian Wengが参画しています。シードラウンドで20億ドルを調達し、評価額120億ドルでスタートしたと、SiliconANGLEおよび複数報道で伝えられています。

Muratiは「Our first model, Inkling. Trained from scratch, weights are open, fine-tunable on Tinker today.」とコメントしています。日本語にすると、「私たちの最初のモデル、Inkling。ゼロから学習させ、重みはオープン、今日からTinkerでファインチューニングできます」という感じです。

Kimi K3が「デカさで殴る」なら、Inklingは「小さくして自分で育てさせる」。同じ週に出た大物なのに、方向性が完全に逆なのが面白いところです。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure5.png)
*巨大化で殴るKimi K3と、小さく配って育てさせるInkling*

## 料金を比べると、けっこう衝撃

次はお金の話です。ここ、現場ではめちゃくちゃ大事ですよね。

Kimi K3のAPI料金は、Kimi公式ブログによると、入力がキャッシュヒット時で100万トークンあたり0.30ドル、キャッシュミス時で3ドル。出力は100万トークンあたり15ドルです。

これはClaude Sonnetシリーズと同じ水準で、前世代のKimi K2.6の0.95ドル / 4ドルから大幅な値上げです。Simon Willison氏は、Kimi K3について「中国のAIラボがこれまでに出した中で最も高価なモデル」と書いています。オープンウェイトなのに高い。なかなかパンチがあります。

![](/images/jp-digest-20260724-open-weight-llm-ranking/source2.png)
*出典: Simon Willison’s Weblog（https://simonwillison.net/2026/Jul/16/kimi-k3/）*

実測コストの感覚も見てみます。Willison氏が定番のテスト、つまりペリカンが自転車に乗るSVGを描かせるやつを走らせたところ、入力95トークン・出力16,658トークン、そのうち13,241が推論トークンで、25セントかかったそうです。彼は「only has one reasoning effort right now, 'max'—and it shows」、つまり「今のところ推論の強度がmaxしか選べず、それが如実に出ている」と指摘しています。推論しすぎて高くなる。あるあるになりそうです。

一方で、Artificial Analysisの計測では見え方が少し変わります。K3のタスクあたりコストは0.94ドルで、GPT-5.6 Solの1.04ドルと同程度、Claude Opus 4.8の1.80ドルの約半分です。ただし、他のオープンウェイト勢よりは高いです。また、Intelligence Indexの測定では、K3はK2.6より21%少ない出力トークンで済んでいると、Simon Willison氏の記事で紹介されています。

他のオープンウェイト勢の料金も見てみましょう。OpenRouterブログによると、100万トークンあたりの入力/出力は、DeepSeek V4 Flashが0.054ドル/0.242ドル、MiniMax M3が0.098ドル/1.21ドル、GLM 5.2が0.447ドル/3.31ドル、Nemotron 3 Ultraが0.423ドル/2.61ドルです。

こう並べると、「オープンウェイト＝安い」という思い込みはもう危ないです。DeepSeek V4 FlashとKimi K3では、出力価格に60倍以上の開きがあります。もちろん能力も用途も違うので、単純に安いほうが正義ではありません。ただ、全部をKimi K3に投げる設計にすると、請求額でびっくりする可能性はあります。用途で選ぶ。ほんとにこれです。

## 「重みが公開＝手元で動く」ではないという現実

ここが実務でいちばん大事かもしれません。

オープンウェイトと聞くと、「じゃあ自社で動かせるんだ」と思いたくなります。間違いではないのですが、Kimi K3クラスになると話が一気に重くなります。

Hugging Face上の技術解説記事によると、Kimi K3をMXFP4（4ビット相当の低精度フォーマットで、モデルを軽くする量子化＝数値の精度を落としてサイズを削る手法）で量子化しても、重みの保存に約1.4TB（テラバイト）必要です。FP16（16ビット精度）なら約5.6TBになります。

さらに、現実的な最小構成として挙げられているのが、80GBのGPU（Graphics Processing Unit＝画像処理向けの計算装置だが、AI計算にも使われる）を8基積んだノードを8台、合計5.12TBです。これはキャッシュと活性化のための余裕を含めた数字です。

量子化によってメモリ帯域幅の要件はFP16比で約4分の1に下がるため、「中規模の組織でも経済的に成立しうる構造」だとされています。たしかに、超巨大クラウド専用というよりは、設備を持てる組織なら現実味が出てきた、と見ることもできます。

でも、ここで冷静になりたいです。ノートPCでどうこうできる話ではありません。「オープンウェイトだから手元で動く」は、この規模になるとほぼ幻想です。動かせるのは、それなりの設備を持てる組織だけです。

逆に言うと、Inklingのように975Bでアクティブ41Bという設計や、DeepSeek V4 Flashのような軽量モデルのほうが、現実の自社運用には乗りやすいです。オンプレミス（自社設備での運用）を考えるなら、最大モデルのロマンだけで選ぶと苦しくなります。

![](/images/jp-digest-20260724-open-weight-llm-ranking/figure6.png)
*MXFP4に落としても約1.4TB。オープンだけど軽くはない*

## じゃあ現場ではどう選ぶ？

ここまでの数字をもとに、用途別に見ていきます。

フロントエンドのUI実装や見た目の作り込みなら、Kimi K3はかなり有力です。Arena.aiのFrontend Code Arenaで1位を取っていて、7ドメイン中6ドメインでトップです。Brand & MarketingやReference-Based Designのような、見た目や意図の再現が効いてくる領域で強いのは魅力です。ただし、出力は100万トークンあたり15ドルです。たくさん書かせる使い方をすると、コストがじわじわ効いてきます。

難しい数学や厳密な推論を主目的にするなら、Kimi K3は避けたほうがよさそうです。the-decoderによると、FrontierMathのTier 4、つまり最難関レベルで約39%の正答率にとどまっています。OpenAIやAnthropicのモデルが約90%近い水準なのと比べると、大きく開いています。フロントエンドで強いから数学も強い、とはならないんですね。

自社データで専用モデルを育てたいなら、Inkling＋Tinkerの組み合わせがハマります。そもそもその用途のために設計されているからです。Bridgewater Associatesの事例のように、狭い領域に寄せることで、高い精度と大幅なコスト減の両取りが起きる可能性があります。

総合的な賢さで選ぶなら、Artificial Analysis Intelligence Indexでオープンウェイト首位のGLM 5.2が候補になります。スコアは51です。派手さではKimi K3に目が行きがちですが、総合指標で見ると違う名前が出てくるのが面白いところです。

コスト最優先なら、DeepSeek V4 Flashがかなり強いです。入力0.054ドル、出力0.242ドルで、SWE-bench Verifiedは79.0%です。安いだけでなく、コーディング系の指標でもかなり戦えています。

結論としては、「全部入り1つ」ではなく「使い分ける前提で組む」時代です。ルーティング、タスク分解、用途別モデル選択。LLM基盤を作る側の設計力が、ますます効いてきます。

## 気をつけたいポイント

まず、ハルシネーション（実際には無い情報をもっともらしく生成してしまうこと）です。Decryptによると、AA-Omniscienceという指標で、Kimi K2.6の39%からK3では51%に上がっています。大きくなれば全部よくなる、というわけではありません。むしろ性能が上がる一方で、もっともらしく外すリスクも見る必要があります。

次に、ベンチマークの読み方です。Kimi公式が出しているスコアは自己申告です。もちろん参考にはなりますが、それだけで判断すると偏ります。第三者のArtificial Analysis、人間投票のArena.ai、そして各メディアや開発者の実測を合わせて見たほうが安全です。

Simon Willison氏は、会話が長くなったときにツールを安定して呼び出し続けられるか、つまりagentic tool calling（エージェント的に外部ツールを使い続ける能力）についての情報が示されていない点も懸念として挙げています。エージェント用途を考えているなら、ここは自分で検証するしかありません。短いデモで動くことと、長い業務フローで安定することは別物です。

また、Kimi K3のフルウェイト公開日は「7月27日までに」という予告です。実際に自社で動かす検討は、それ以降になります。APIで試せることと、重みを持って運用できることは分けて考えたいところです。

最後にライセンスです。商用利用の条件はモデルごとに違います。修正版MITライセンスと報じられているKimi K3も含め、実際にプロダクトへ組み込む前に条件を読んでください。ここを雑にすると、あとで一番つらいタイプの技術負債になります。

## まとめ

2026年7月のこの2日間で、オープンウェイトLLMの見え方はかなり変わりました。以前は「安いから使う」「手元で試せるから使う」という印象が強かったかもしれません。でも今は、用途によっては一番強いから使う、という段階に入っています。

ただし、「重みが公開されている」ことと「自分で動かせる」ことは別物です。Kimi K3のMXFP4量子化でも約1.4TBという数字は、その現実をかなりストレートに突きつけてきます。オープンだけど軽くはない。ここは忘れないほうがよさそうです。

選び方を一行でまとめるなら、フロントエンドならKimi K3、総合ならGLM 5.2、育てるならInkling、安さならDeepSeek V4 Flashです。

そして、Kimi K3のフルウェイト公開は7月27日までに予定されています。実際の運用検証が始まったら、また景色が変わるかもしれません。さて、自分の現場ならどのモデルをどこに置きますか？


### 参考にした記事

- [Kimi K3 Tech Blog: Open Frontier Intelligence](https://www.kimi.com/blog/kimi-k3)（Moonshot AI 公式ブログ）
- [Kimi K3, and what we can still learn from the pelican benchmark](https://simonwillison.net/2026/Jul/16/kimi-k3/)（Simon Willison's Weblog）
- [China's Kimi K3 Is Out—And Beats Claude Fable and GPT 5.6 Sol on Key Benchmarks](https://decrypt.co/373716/china-kimi-k3-largest-open-source-ai-model-ever-beats-claude-fable-gpt-5-6-sol)（Decrypt）
- [Moonshot's Kimi K3 outperforms Fable 5 in frontend code but lags far behind in complex math](https://the-decoder.com/moonshots-kimi-k3-outperforms-fable-5-in-frontend-code-but-lags-far-behind-in-complex-math/)（the decoder）
- [Thinking Machines amps up its bet against one-size-fits-all AI with its first open model, Inkling](https://techcrunch.com/2026/07/15/thinking-machines-amps-up-its-bet-against-one-size-fits-all-ai-with-its-first-open-model-inkling/)（TechCrunch）
- [Mira Murati's Thinking Machines drops Inkling, an open-weights model anyone can access](https://siliconangle.com/2026/07/15/mira-muratis-thinking-machines-drops-inkling-open-weights-model-anyone-can-access/)（SiliconANGLE）
- [The Open Weight Models that Matter: June 2026](https://openrouter.ai/blog/insights/the-open-weight-models-that-matter-june-2026/)（OpenRouter Blog）
- [Kimi K3 Model Overview: 2.8T Parameters, MXFP4 Quantization, and What the Open Weights Mean for the Community](https://huggingface.co/blog/ResterChed/kimi-k3-model-overview-mxfp4-quantization-open-wei)（Hugging Face Blog）
