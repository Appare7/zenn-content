---
title: "動画生成AI 音声付きの新基準｜FLUX 3が1モデルで作る理由"
emoji: "🎞️"
type: "tech"
topics: ["生成ai", "ai", "動画生成", "flux", "マルチモーダル"]
published: false
---

動画生成AIって、これまでずっと「映像を作る」と「音を付ける」が別作業でしたよね。動画を生成して、別のツールで効果音やナレーションを足して、さらに口の動きと声を合わせる。わりと手間のかかる"後工程まつり"でした。

そこに「最初から音付きで20秒まで一発で出す」モデルとして出てきたのが FLUX 3 です。この記事は、1本の海外記事をそのまま訳したものではなく、公式ブログ・公式プレスリリース・海外の技術メディア・技術解説ブログなど複数のソースを突き合わせて、日本の読者向けに組み直しています。では、何が新しいのか見ていきましょう。

![映像と音をいっぺんに作る。FLUX 3 は画像・動画・音声・行動予測をひとつのモデルでまとめて学習する](/images/jp-digest-20260729-flux3-video-audio/figure1.png)

## そもそも何が発表されたのか

2026年7月23日、Black Forest Labs（ブラック・フォレスト・ラボ）が FLUX 3 を発表しました。Black Forest Labs は画像生成モデル FLUX シリーズで知られる、ドイツ・フライブルク拠点のAI企業です。2024年夏に創業し、フライブルクとサンフランシスコに約100人のチームを持っています。

評価額は32.5億ドル、これまでの調達額は4.5億ドル超。出資者には a16z、Salesforce Ventures、NVIDIA、Adobe Ventures、Canva、General Catalyst などが並びます。メンツが濃いですね。

FLUX 3 のポイントは、画像・動画・音声・行動予測（ロボットの次の動きを予測すること）を、別々のモデルを裏でつないだものではなく、1つのアーキテクチャ（モデルの設計）で一緒に学習させたことです。いわゆるマルチモーダル基盤モデル（画像・音声・文章など複数の種類のデータをまとめて扱う土台モデル）なんです。

公式はこれを visual intelligence（視覚的知能）の基盤モデルと呼んでいます。今回が同社にとって初の一般公開向け動画生成モデルでもあります。

製品ラインは4つです。

- FLUX 3 Video（動画＋音声）
- FLUX 3 Image（画像）
- FLUX 3 Action（行動予測）
- FLUX 3 Dev（オープンウェイト＝重みが公開される版）

![Black Forest Labs 公式ブログの FLUX 3 発表ページ](/images/jp-digest-20260729-flux3-video-audio/source.png)

出典: Black Forest Labs（https://bfl.ai/blog/flux-3）

## 「音声付きで一発」が地味にすごい理由

FLUX 3 Video は、1回の生成で最大20秒、ネイティブ音声（映像と同時に生成される音）付きのクリップを出せます。

作り方もけっこう広いです。テキストから動画、画像から動画、動画から動画、キーフレーム（起点・終点になる静止画）から動画、続きを生成する継続生成、複数カットをつなぐチェイニングに対応します。さらに、多言語のセリフ、つまりダイアログ（会話）にも対応。タイポグラフィ（文字組み）やアニメーション付きデザインも扱えるとされています。

20秒と聞くと「短くない？」と思うかもしれません。でも、テレビCM1本が15〜30秒だと考えると、実は"1本まるごと"が射程に入るサイズなんですよね。しかも、あとから音を当て込む作業が消えるかもしれない。ここがかなり効きます。映像担当と音声担当の間で「ここ、足音もう少し早く」みたいな往復が減るなら、地味どころか制作フローへの影響は大きいです。

ただし、ここは正直に。評価に使われたクリップは10秒・720p（解像度）です。20秒生成時の解像度は公表されていません。ここを勝手に盛ると、あとでハマるやつです。

![FLUX 3 の4つの製品ライン。Video と Action は早期アクセス、Image は数週間後、Dev は日付なし](/images/jp-digest-20260729-flux3-video-audio/figure2.png)

## 数字で見る：他のモデルとどう違うのか

公式が出しているのは、preference rate（選好率、人間がどちらの動画を好んだかの割合）です。テキストから動画を作らせた10秒・720pのクリップ同士を比較しています。

FLUX 3 が好まれた割合はこうです。

- Luma Ray 3.2 に対して 93%
- Runway Gen-4.5 に対して 77%
- Grok Imagine Video に対して 69%
- Kling v3 Pro に対して 60%
- Seedance 2.0 と Gemini Omni Flash に対して 52%（同率）

93%はかなり強く見えます。ただ、重要な注意があります。これは公式自身が「早期の FLUX 3 候補モデルの暫定評価」と断っている数字です。つまり、出荷される最終モデルそのものの数字ではありません。

もう1つ、52%はほぼ互角です。早すぎません？ と思うくらい競ってます。なので「全部に圧勝」ではなく、「下位帯には大差、上位帯とは横並びに近い」と見るのがよさそうです。

画像モデル側のベンチマーク（性能比較の数字）は、今のところ何も公表されていません。価格もまだ読めません。VentureBeat の比較表では、競合の価格として Gemini Omni Flash が10秒720pのクリップで1.00ドル、Veo 3.1 Fast が10秒4Kのクリップで3.00ドル。一方、FLUX 3 Video の価格は未発表です。

![人がどっちの動画を選んだか。下位帯には大差、上位帯とは横ならび](/images/jp-digest-20260729-flux3-video-audio/figure3.png)

![VentureBeat による FLUX 3 の報道記事](/images/jp-digest-20260729-flux3-video-audio/source2.png)

出典: VentureBeat（https://venturebeat.com/technology/black-forest-labs-launches-flux-3-capable-of-generating-images-and-20-second-video-with-audio-but-in-limited-release-to-start）

## なぜ「全部いっしょに学ばせる」のか

開発元の主張はかなりシンプルです。画像・動画・音声・行動は、同じ現実を別の角度から切り取ったものにすぎない。だから一緒に学ばせたほうが、それぞれの精度も上がる、という立場です。

CEO の Robin Rombach（ロビン・ロンバッハ）は「世界は静止画でできてはいない。動いて、音を立てて、変化して、応答する」と言っています。もう1つ、「本当の知能とは、世界を知覚し、どう変化するかを予測し、行動し、結果から学ぶこと」とも語っています。

学習手法の名前は Self-Flow（セルフフロー）です。これは自己教師あり型の flow matching（ノイズから目的の出力へ滑らかに変形させる学習法）で、生成の質と、モデル内部の表現の質を同時に鍛える狙いがあります。

モデルの型は Diffusion Transformer（拡散トランスフォーマー、拡散モデルの計算をTransformer構造でやるもの）。学習データには、数千万時間規模の一般的な動画に加えて、数十万時間規模の「物を操作している動画」、それに画像と音声が含まれます。

たとえるなら、「映像専門」「音声専門」の担当者を別々に雇って後から擦り合わせるのではなく、最初から同じ現場で一緒に仕事を覚えさせる感じです。後から会議で合わせるより、最初から隣の席で覚えたほうがズレにくいよね、という発想に近いです。

![これまでは映像モデルと音声モデルが別々。FLUX 3 は Self-Flow で同時に学習する](/images/jp-digest-20260729-flux3-video-audio/figure4.png)

![FLUX 3 の仕様まとめ表。モデルの型、学習データ、動画の長さ、提供状況](/images/jp-digest-20260729-flux3-video-audio/source3.png)

出典: Hugging Face ブログ「FLUX 3 Model Overview」（https://huggingface.co/blog/ResterChed/flux-3）

## 話が動画で終わらない。ロボットにまで飛び火してる

FLUX 3 Action は「行動予測」を担当する製品ラインです。ここで急にロボットの話になります。動画生成モデルの話をしていたはずなのに、いつのまにか工場にいます。展開が速い。

Black Forest Labs は、ロボット企業 mimic robotics（ミミック・ロボティクス）と共同で、FLUX 3 をベースにした FLUX-mimic というモデルを作っています。映像と行動を一緒に扱うモデルです。

これは Audi（アウディ）の Production Lab（生産技術ラボ）で、実際の製造タスクに使ってテスト・導入が進んでいます。得意なのは、布や柔らかい部品のような「軟体物のハンドリング」です。

Audi Production Lab の Christoph Schneider は「これらのロボットは、従来のロボット技術では不可能だった複雑な軟体物の取り扱いをこなす」と述べています。mimic robotics の CTO（最高技術責任者）である Elvis Nava も、「FLUX-mimic は最先端の動画モデルの上に建っているから、新しいタスクを数日ではなく数分で覚える」と語っています。

数字としては、新しいタスク向けのファインチューニング（追加学習）に必要なロボットの動作データが、従来の30時間超から約30分に減ったとされています。

この飛び火っぷりこそが、「1つのモデルで全部やる」戦略の狙いどころなんですよね。映像を理解するモデルが、現実の物体操作にもつながる。生成AIとロボットの距離が、じわっと縮んでいます。

![新しい作業を覚えさせるのに必要なロボットの動作データが30時間超から約30分に](/images/jp-digest-20260729-flux3-video-audio/figure5.png)

![Black Forest Labs の公式プレスリリース](/images/jp-digest-20260729-flux3-video-audio/source4.png)

出典: GlobeNewswire（https://www.globenewswire.com/news-release/2026/07/23/3332364/0/en/black-forest-labs-unveils-flux-3-a-new-multimodal-frontier-model-for-visual-intelligence.html）

## で、いま試せるの？（正直なところ、まだ待ち）

FLUX 3 Video と FLUX 3 Action は Early Access（早期アクセス）です。申請は誰でもできますが、開発元の承認が要るゲート付きです。

FLUX 3 Image は、数週間後に早期アクセス、その後に一般提供という順番です。つまり、今すぐ誰でも本番投入、という段階ではまだありません。

未公表のものも多いです。

- API（外部から機能を呼び出す仕組み）の価格・料金プラン: 未発表
- 本番用の安定したモデルID、完全なAPI仕様、レート制限（呼び出し回数の上限）: 未公開
- 20秒生成時の解像度・フレームレート・遅延: 未公開
- パラメータ数（モデルの規模）: 非公表。だから必要なGPU（画像処理向けの計算装置）も読めない
- 商用利用の条件やデータの保持ポリシー: 未確定

FLUX 3 Dev は「2026年後半」とだけ言われていて、具体的な日付もライセンス（利用条件）も出ていません。既存の FLUX Dev は画像だけでしたが、FLUX 3 Dev は動画・音声・画像・行動予測を含むマルチモーダルなバックボーン（土台になるモデル）を開放すると説明されています。もし本当にそうなら、音声付き動画まで手元で回せるオープンウェイトモデルは、今のところ他に無い位置づけになります。

現実的には、早期アクセスには申請だけしておくのがよさそうです。そのうえで、本番のパイプライン（制作フロー）は、価格とSLA（サービス品質の約束）が出ている既存モデルで回しておく。期待しつつ、財布と納期は守る。ここ大事です。

あと批判的な視点も1つ。「物理法則を理解している」という類の主張は、FLUX 3 に限らず、どのモデルも標準的なベンチマークを持っていません。生成された水がちゃんと水らしく動くかを測る共通のものさしが、そもそも無いんです。なので「世界を理解している」は、今のところ数字で検証しにくい話でもあります。

## まとめ：期待していい点と、様子見でいい点

期待していい点は、このあたりです。

- 映像と音を1回で作れると、音の当て込み・リップシンク（口の動きと声を合わせること）調整という工程がまるごと消える可能性がある
- 上位帯の競合とほぼ互角のところまでは来ている。下位帯には大差が出ている
- 動画・画像だけでなくロボットまで同じ土台に載せてきていて、生成AIと現実世界の距離が縮んでいる

一方で、様子見でいい点もあります。

- 公開されている数字が「早期候補モデルの暫定評価」であること
- 価格も仕様もライセンスも未発表で、コスト計算ができないこと
- オープンウェイト版に日付が無いこと

FLUX 3 は、今すぐ全員が乗り換えるモデルというより、「次の標準がどこに向かうか」をかなりはっきり見せてきた発表です。動画生成AIの"音声付きが標準"という流れ自体は、もう戻らなさそうですね。

### 参考にした記事

- [FLUX 3 - Real World Models: Towards Multimodal Flow Models as the Backbone of Visual Intelligence.（Black Forest Labs 公式ブログ）](https://bfl.ai/blog/flux-3)
- [Black Forest Labs launches FLUX 3 capable of generating images and 20-second video with audio — but in limited release to start（VentureBeat）](https://venturebeat.com/technology/black-forest-labs-launches-flux-3-capable-of-generating-images-and-20-second-video-with-audio-but-in-limited-release-to-start)
- [Black Forest Labs Unveils FLUX 3, A New Multimodal Frontier Model For Visual Intelligence（GlobeNewswire プレスリリース）](https://www.globenewswire.com/news-release/2026/07/23/3332364/0/en/black-forest-labs-unveils-flux-3-a-new-multimodal-frontier-model-for-visual-intelligence.html)
- [FLUX 3 Model Overview: Multimodal Flow Models for Image, Video, Audio, and Action Prediction（Hugging Face ブログ）](https://huggingface.co/blog/ResterChed/flux-3)
- [FLUX 3 API: Availability, Early Access, Video & Dev（CometAPI）](https://www.cometapi.com/flux-3-api/)
