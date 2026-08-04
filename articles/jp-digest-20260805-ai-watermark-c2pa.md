---
title: "AI生成画像の電子透かしが義務化。EU AI規制と実装の中身"
emoji: "🔏"
type: "tech"
topics: ["生成ai", "ai", "c2pa", "security"]
published: false
---

2026年8月2日から、EUでAIが作ったコンテンツには「機械が読める印」を付けることが、法律上の義務になりました。

対象は画像だけではありません。音声、動画、テキストも入ります。つまり、画像生成AI、動画生成AI、LLM（大規模言語モデル）まわりでサービスやツールを作っている人は、だいたい一度は見ておきたい話なんです。

「EUの話でしょ？」と思うかもしれません。でも、EU市場に出すなら本社がどこかは関係ない、というのがこの手の規制のややこしいところ。玄関マットがEU側にあるなら、靴を脱ぐルールもEU側、みたいな感じです。

この記事では、複数の海外記事とEUの公式ページを読み比べて、日本の開発者向けに噛み砕いてまとめました。

![AIが作ったものに機械が読める印を付けろ](/images/jp-digest-20260805-ai-watermark-c2pa/figure1.png)

## 何が起きたのか、まず3行で

まずは要点だけ、ざっくりいきます。

- EU AI法（EU AI Act / 人工知能に関する欧州連合の規則）の第50条「透明性義務」が、2026年8月2日に適用開始。
- 第50条は、AIが生成・加工したコンテンツに「機械可読（machine-readable / 人の手を介さずソフトウェアが読み取れる形）」の印を付けることを、AIシステムの提供者に求めています。
- 違反すると最大で1,500万ユーロ、または全世界の年間売上高の3%の高いほうが制裁金の上限。EU機関自身への上限は75万ユーロです。

ここでややこしいのが、高リスクAIの重い義務は「デジタル・オムニバス」という制度見直しで先送りされたことです。単独型の高リスクAIは2027年12月2日、規制対象製品に組み込まれたものは2028年8月2日へ。

でも、第50条の透明性義務は先送りされず、予定どおり来ました。宅配便で「重い荷物はあとで来るけど、小さい箱だけ先に届いた」みたいなやつです。

![EU AI法 第50条のページ。施行日は2026年8月2日](/images/jp-digest-20260805-ai-watermark-c2pa/source2.png)
出典: EU Artificial Intelligence Act（https://artificialintelligenceact.eu/article/50/）※「Date of entry into force: 2 August 2026」と明記されている

## 義務は4つある。自分がどれに当たるか先に確認する

第50条の義務は、ざっくり4種類あります。まず自分がどの立場なのかを見ないと、実装する場所を間違えます。住所を見ずに荷物を送ると迷子になる、あれです。

| 対象 | やること |
|---|---|
| AIと直接やり取りするシステム | チャットボットなどは、相手がAIだと分かるようにする。義務を負うのは「提供者」。ただし「合理的に情報を持ち、注意深く、思慮のある人」から見て明らかな場合は不要。 |
| 生成AIの提供者 | 合成した音声・画像・動画・テキストに、機械可読のマーキングを付ける。技術的手段は「効果的・相互運用可能・堅牢で信頼できる」必要あり。この記事の主役です。 |
| 感情認識・生体分類システムの利用者 | デプロイヤー（導入して業務で使う側）は、さらされる人に最初の接触時点で知らせる。個人データを扱うならGDPR（EUの一般データ保護規則）にも従う。 |
| ディープフェイクや公共性のあるAI生成テキストの利用者 | ディープフェイク（AIで作った・加工した本物そっくりの画像/音声/動画）を明示。公共の関心事について書かれたAI生成テキストも、意味のある人間のレビューや編集責任がない限り明示が必要。 |

提供者とデプロイヤーの分かれ目は、「AIを使うかどうかを決め、どう使うかを決め、出力をコントロールしているか」。そこに当たるなら、デプロイヤー側です。

この立ち位置を取り違えること自体が、最大1,500万ユーロまたは売上3%の対象になりうる、という指摘もあります。席を間違えただけで高額チケット、怖いですね。

![第50条が課す4つの透明性義務](/images/jp-digest-20260805-ai-watermark-c2pa/figure2.png)

## 電子透かしとメタデータ、印は2枚重ねにする

ここが一番知りたいところですよね。「で、俺は何を実装すればいいの？」の本丸です。

2026年6月10日、欧州委員会のAI Officeが取りまとめた「AI生成コンテンツの透明性に関する行動規範（Code of Practice on Transparency of AI-generated Content）」が公開されました。独立した専門家が起草し、AIシステム提供者・市民社会・研究者が2つのワーキンググループに分かれて関わっています。

加入は任意ですが、第50条そのものは法的義務です。2026年7月下旬時点で、約190の企業・団体が署名しています。

実装の方向性は、大きく2つ+1つです。

1. **暗号署名付きのメタデータ**  
   誰が・いつ・どのシステムで作ったかを、改ざんが分かる形で暗号署名とタイムスタンプ付きで記録します。

2. **知覚できない電子透かし（imperceptible watermarking）**  
   ピクセル、音声波形、テキストならトークンの分布そのものに信号を埋め込みます。情報量は少なめですが、メタデータでは耐えられない変換に強いのがポイント。

3. **任意：指紋 + レジストリ**  
   知覚ハッシュ（perceptual hash / 見た目が近いと近い値になるハッシュ）を計算し、照会できるデータベースに登録します。ただし運用が重いので補助的な位置づけです。

大事なのは、1と2は「どちらか」ではないこと。メタデータはスクリーンショットや再エンコード、コピーで落ちやすい。一方、透かしは残りやすいけれど、入れられる情報量が少ない。つまり、お弁当でいうご飯とおかずです。片方だけだとちょっと寂しい。

提供者側には追加の宿題もあります。AI生成コンテンツが入力として入ってきたとき、既にある来歴マーキングを保持すること。利用規約で意図的な除去を禁じること。そして検出手段を無料で公開することです。

公開方法は、オープンな仕様、ダウンロードできるソフトウェア、クラウドAPIのいずれか。2027年初頭までに、公開されていて相互運用可能な業界標準への準拠を目指す方向です。

![署名付きメタデータと不可視の電子透かしの2枚重ね](/images/jp-digest-20260805-ai-watermark-c2pa/figure3.png)

## C2PAが実質の本命になっている理由

C2PA（Coalition for Content Provenance and Authenticity / コンテンツの来歴と真正性のための連合）は、デジタルコンテンツの出所と編集履歴を示すオープンな技術標準です。この仕組みは「Content Credentials（コンテンツ来歴情報）」と呼ばれます。

C2PAの公式サイトでは、Content Credentialsを「デジタルコンテンツにとっての栄養成分表示のようなもの」と説明しています。たしかに、画像の裏に「材料名：AI生成、加工履歴あり」みたいなラベルが付くイメージだと分かりやすいですよね。

技術的には、作成時点で暗号署名されたマニフェスト（JSON-LD形式の宣言データ）をファイルに埋め込むか、サイドカーファイルとして添えます。中身は生成したツール名、生成日時、署名など。改ざん検知にはX.509証明書を使います。

埋め込み先の例はこんな感じです。

- JPEG: APP11マーカー
- PNG: caBXチャンク
- MP4: uuidボックス

支持しているのはAdobe、Microsoft、Google、Meta、OpenAIといった面々。この顔ぶれが乗っている時点で、実質的にはこのC2PAが有力な道筋になっています。

ただし、ここは注意です。EU AI法はC2PAを名指しで義務化していません。「もっとも技術的に成熟した準拠の道筋」と評価されているだけで、最終的な技術標準は欧州委員会の実施法（implementing acts）に委ねられています。

画像のメタデータ側では、IPTCの「Digital Source Type」という語彙もあります。AI生成なら `trainedAlgorithmicMedia`、人間とAIの合成なら `compositeSynthetic` というURIを、XMP（メタデータの記述形式）経由で埋める実装が案内されています。

また、SynthID（Google DeepMindの不可視の電子透かし技術）にも触れておきます。画像・音声・動画・テキストをカバーしますが、判定は確率的で、現状はGoogle自身のツールで生成した画像が中心です。EUの文脈では、検出が特定企業のサービスに依存する形だと単独では足りず、C2PAの層や自前で管理できる検出APIと組み合わせる必要がある、という指摘があります。

![C2PA公式サイト。Content Credentialsの説明](/images/jp-digest-20260805-ai-watermark-c2pa/source4.png)
出典: C2PA（https://c2pa.org/）

## 締切は8月2日じゃなくて12月2日かもしれない

適用開始は2026年8月2日です。新しく市場に出すシステムは、その日から対象になります。夏休みの宿題でいうと、配られた瞬間からカウント開始です。

ただし、2026年5月のAIオムニバスの暫定合意で、それ以前に既に市場にある生成AIシステムには、第50条(2)の機械可読マーキングについて2026年12月2日まで猶予がある、という解説が複数あります。

一方で、猶予期間は特に設けられていないと整理している法律事務所の解説もあります。ここは正直、読み方が割れています。自社のシステムがどちらに当たるかは、必ず一次情報と専門家で確認してみてください。

実装期間の目安としては、分類に1か月、パイプラインへの組み込みに2〜4か月、テストに1〜2か月、適合性の認証に1〜2か月、合計3〜6か月という見積もりを紹介する解説があります。逆算すると、けっこう余裕ないです。

初期の摘発は、「開示がまったくない」「メタデータがまったくない」といった分かりやすい違反が狙われるだろう、という見立てもあります。

![第50条まわりの日程。実質の締切は12月2日](/images/jp-digest-20260805-ai-watermark-c2pa/figure4.png)

![欧州委員会のAI生成コンテンツ透明性 行動規範のページ](/images/jp-digest-20260805-ai-watermark-c2pa/source1.png)
出典: European Commission - Shaping Europe's digital future（https://digital-strategy.ec.europa.eu/en/policies/code-practice-ai-generated-content）

## やらなくていいこと、も意外とある

全部に巨大なラベルを貼る必要があるわけではありません。冷蔵庫の中のタッパー全部に履歴書を貼らなくていい、みたいな話です。

「標準的な編集機能」による加工や、元の意味を実質的に変えない加工は、マーキング義務の対象外とされています。トリミングや色補正のような日常的な編集は、ディープフェイクの線引きでも「本物らしさを実質的に変える改変」には当たりません。

ただし、製品を実際より魅力的・高品質に見せる加工は、そのライン、つまりディープフェイク扱いに近づきます。

ほかにも例外があります。

- 芸術・創作・風刺・フィクション作品は、クレジット表記や設定画面など軽めの開示方法が認められる
- 公共の関心事のAI生成テキストでも、実質的な人間のレビューと編集責任があるなら明示不要
- チャットボットの開示も、AIだと明らかな場合は不要
- 法執行機関の一部用途にも例外あり

## AI画像判定は万能じゃない、という話

メタデータは、けっこう脆いです。あるメディアの2026年3月時点の報告では、LinkedInとTikTokは来歴情報を保持した一方、Instagram・X・WhatsAppは再圧縮やリサイズの過程で剥がしてしまったとされています。

スクリーンショットを1回挟むだけでも、メタデータは引き継がれません。紙に印刷してまた撮る、みたいなものなので、そりゃ落ちます。

だから不可視の透かしとの二段構えが必要、という話に戻ってきます。

ここで大事な誤解があります。「印が付いていない = 本物」ではありません。単に付いていないだけかもしれません。同じメディアも、来歴メタデータが付いた画像はオープンなウェブではまだ珍しい、と書いています。

「AI画像判定」をうたうサイトの結果も、この文脈では過信しないほうがよさそうです。C2PAの検証については、Content Authenticity Initiativeが contentauthenticity.org で無料の検証ツールを公開しています。

なお、行動規範や解説記事は、透かしがどのくらい除去攻撃に耐えるかを数値では示していません。「技術的に可能な範囲で堅牢かつ信頼できる」という表現にとどまっています。万能の魔法シールではない、ということですね。

![メタデータは意外と簡単に消える](/images/jp-digest-20260805-ai-watermark-c2pa/figure5.png)

![第50条への実装方法を解説した記事](/images/jp-digest-20260805-ai-watermark-c2pa/source3.png)
出典: ComplianceHub.Wiki（https://compliancehub.wiki/eu-ai-act-marking-labelling-code-of-practice-article-50-2026/）

## 日本はどうなってる

日本には、AI生成コンテンツの表示を一般に義務づける法律はまだありません。

2025年に成立したAI推進法、いわゆるAI新法は、イノベーション促進が基調で、罰則を持たない設計です。

総務省・経済産業省の「AI事業者ガイドライン（第1.2版、2026年3月31日）」では、電子透かし等による来歴・認証の仕組みや、AIとのやり取りだと分かるラベリングが「推奨」として書かれています。義務ではありません。

つまり、日本国内だけで完結するなら、今すぐの法的強制はありません。ただしEU向けにサービスを出すなら第50条が効いてきます。そして実装の相場としては、C2PA + 透かしの二段構えに寄っていく流れです。潮の流れが見えているなら、早めに泳ぎ方を覚えておくと安心ですよね。

## まとめ

- 2026年8月2日、EU AI法第50条の透明性義務が適用開始。高リスクの重い義務は先送りされたのに、これは来ました。
- 生成AIの提供者がやることは「暗号署名付きメタデータ」+「不可視の電子透かし」の二段構え。片方だけでは足りません。
- 実質はC2PAのContent Credentialsが本命。ただし名指しで義務化されているわけではありません。
- 既存システムには2026年12月2日までの猶予がある、という解説がある一方、猶予なしと整理する解説もあります。一次情報で確認してください。
- 日本ではまだ推奨止まり。でも実装の相場は決まりつつあるので、今から触っておいて損はなさそうです。

## 参考にした記事

- [Code of Practice on Transparency of AI-generated Content — European Commission](https://digital-strategy.ec.europa.eu/en/policies/code-practice-ai-generated-content)
- [Article 50: Transparency Obligations for Providers and Deployers of Certain AI Systems — EU Artificial Intelligence Act](https://artificialintelligenceact.eu/article/50/)
- [Watermarks and Metadata: How to Actually Comply With the EU AI Act's Article 50 Transparency Rules — ComplianceHub.Wiki](https://compliancehub.wiki/eu-ai-act-marking-labelling-code-of-practice-article-50-2026/)
- [AI transparency under the AI Act: what businesses need to know before 2 August 2026 — Addleshaw Goddard](https://www.addleshawgoddard.com/en/insights/insights-briefings/2026/technology/ai-transparency-ai-act-what-businesses-need-know-before-2-august-2026/)
- [EU AI Act Article 50: A Complete Guide to AI Transparency Compliance — SSL.com](https://www.ssl.com/article/eu-ai-act-article-50-a-complete-guide-to-ai-transparency-compliance/)
- [EU AI Act Art.50 GPAI Content Labelling: Machine-Readable Metadata Standards & August 2026 Compliance Checklist — sota.io](https://sota.io/blog/eu-ai-act-art50-gpai-content-labelling-metadata-standards-august-2026)
- [EU AI Act and Content Provenance Regulations Making C2PA Urgent in 2026 — SoftwareSeni](https://www.softwareseni.com/eu-ai-act-and-content-provenance-regulations-making-c2pa-urgent-in-2026/)
- [What Are Content Credentials? The AI Watermarking Standard Coming to Your Feed in 2026 — Fakeout](https://www.fakeout.io/blog/content-credentials-c2pa-ai-watermarking-explainer-2026)
- [C2PA（Coalition for Content Provenance and Authenticity）公式サイト](https://c2pa.org/)
- [AI事業者ガイドライン（第1.2版）総務省・経済産業省](https://www.meti.go.jp/shingikai/mono_info_service/ai_shakai_jisso/pdf/20260331_1.pdf)