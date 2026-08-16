---
title: "x402とは？AIエージェント決済プロトコルの仕組みと使いどころ"
emoji: "🪙"
type: "tech"
topics: ["生成ai", "ai", "aiエージェント", "http"]
published: false
---

AIエージェント（自律的に作業するAI）に「このAPI（プログラムから機能を呼び出す窓口）叩いといて」と頼んだとき、そのAPIが有料だったらどうするんでしょう。  
人間ならログインして、カードを登録して、APIキーを発行して……となりますが、エージェント相手に毎回それをやらせるのはなかなかつらいですよね。  
今、その答えとしてかなり前に出てきているのが x402（エックス・よん・まる・に）というプロトコル（通信の約束事）なんです。  
この記事は、公式発表・技術メディア・オンチェーン分析レポート・セキュリティの研究論文など、複数の海外ソースを突き合わせて再構成しています。

![x402の概要](/images/jp-digest-20260817-x402-ai-agent-kessai/figure1.png)

## HTTPの402が、29年ぶりに叩き起こされた

x402 は、HTTP（Webで通信するときの約束事）の「402 Payment Required（支払いが必要です）」というステータスコードを使います。

この 402、実は 1997年の HTTP/1.1 の時点から「予約済み」でした。でも、実際に使うための標準化はされないまま放置されていたんです。つまり約29年、ずっと空席だったわけですね。予約席の札だけ置かれて、誰も座らない椅子みたいなものです。長い。長すぎる。

その空席を叩き起こしたのが、Coinbase が作った x402 です。

大きく動いたのは、2025年9月。Coinbase と Cloudflare が「x402 Foundation（x402財団）」を作ると発表しました。そして 2026年4月2日、Linux Foundation（Linux財団）の傘下で x402 Foundation が正式に発足します。発表の場は MCP Dev Summit North America でした。

Linux Foundation の CEO である Jim Zemlin は、「the internet was built on open protocols（インターネットはオープンなプロトコルの上に作られてきた）」と述べ、x402 のために「オープンでコミュニティが統治する場所」を作ると説明しています。

発足メンバーは22組織。Adyen、Amazon Web Services、American Express、Cloudflare、Coinbase、Google、Mastercard、Microsoft、Shopify、Stripe、Visa など、決済の大手からクラウドまで揃っています。カード会社もクラウドも同じテーブルに着いているの、けっこう珍しい温度感ですよね。「AIエージェントの支払い」は、もう実験室だけの話ではなくなってきた感じがあります。

![Linux Foundationの発表](/images/jp-digest-20260817-x402-ai-agent-kessai/source4.png)

出典: The Linux Foundation（https://www.linuxfoundation.org/press/linux-foundation-is-launching-the-x402-foundation-and-welcoming-the-contribution-of-the-x402-protocol）

## 仕組みはあきれるほどシンプル

x402 の流れは、Cloudflare の説明だとかなりシンプルです。

1. クライアント、つまりエージェントが、x402で保護された有料リソースをリクエストする
2. サーバーが HTTP 402 を返す。このとき一緒に「いくら」「どこ宛て」という支払い指示が返る
3. クライアントは支払い認可を HTTP ヘッダに載せて、同じリクエストをもう一度送る
4. facilitator（ファシリテーター／決済の仲介役）が支払いを検証して決済する
5. サーバーがリソース本体と、支払い確認のヘッダを返す

Webエンジニアなら、ちょっと見覚えがある構造ですよね。401（認証が必要）を返されたら、トークンを付けて再送する。あれとかなり似ています。違うのは、認証ではなく支払いだというところです。

ポイントは、アカウント登録も、サブスクも、APIキーも要らないことです。ここが従来のAPI課金と決定的に違います。毎月プランを作って、ユーザー登録させて、鍵を配って……という流れを作らずに、「このリクエストはこの金額です」と返せるわけです。

Cloudflare は x402 を「クライアントとサービスが共通の言語で価値をやり取りできるようにする枠組み」と説明しています。言い換えると、HTTP の上で「払ってから見てね」を自然にやるための共通語なんです。

さらに Cloudflare は deferred payment scheme（後払い方式）も提案しています。これは決済を遅らせて、まとめて請求できるようにする案です。リクエストごとに毎回課金するのではなく、1日分をまとめたいクローラー向けですね。自販機で1本ずつ小銭を入れるのではなく、あとでまとめて精算する社食カードっぽいノリです。

![x402の5ステップ](/images/jp-digest-20260817-x402-ai-agent-kessai/figure2.png)

## エッジで金を取る、という一手

InfoQ の 2026年7月6日の記事では、AWS と Cloudflare の動きが並べて紹介されています。

AWS は CloudFront と AWS WAF（Web Application Firewall／Webアプリを守る防火壁）で x402 サポートを一般提供、つまり GA（General Availability／正式提供）として出しました。WAF の Bot Control（ボット制御）ルールの中で「Monetize（収益化する）」というアクションを設定できます。

その約2週間後、Cloudflare は「Monetization Gateway」のウェイトリストを公開しました。Webページ、API、データセット、MCP（Model Context Protocol／AIに外部ツールを繋ぐための仕組み）ツールに課金できるようにするものです。

両者に共通するのは、支払いのやり取りをエッジ（利用者に近い場所で処理する仕組み）で処理して、オリジンサーバーに到達する前に完結させる設計です。Cloudflare は330以上の都市でルールを適用します。

決済は主に Base（ブロックチェーンの一種）上の USDC（米ドルに価値を連動させたステーブルコイン＝価格が安定するように設計された暗号資産）で、1秒未満で完了します。Coinbase の x402 Facilitator が、オンチェーン（ブロックチェーン上）での検証とコンプライアンス（法令順守）チェックを担当しています。取引コストは「1セントの何分の1にも満たない」と説明されています。

料金面では、AWS の CloudFront の x402 サポートは通常の WAF 料金以外の追加料金なし。Cloudflare は価格も提供開始時期も公表していません。

背景として大きいのが、AI学習用のクローラーによるリクエストです。2026年6月時点で全トラフィックの52%を占めていて、2025年春は22%でした。半分超え、早すぎません？

AWS と Cloudflare が数週間差で近い方向のものを出してきたのは、業界が「概念」から「インフラ」に切り替わったサインに見えます。x402 は「おもしろプロトコル」ではなく、エッジの設定項目として顔を出し始めたんです。

![InfoQの記事](/images/jp-digest-20260817-x402-ai-agent-kessai/source.png)

出典: InfoQ「Cloudflare and AWS Embed x402 Agent Payments at the Edge」（https://www.infoq.com/news/2026/07/cloudflare-aws-x402-micropayment/）

## 数字は派手。でも鵜呑みは禁物

x402 の数字は、媒体によってけっこう違います。ここをごまかすと話がズレます。

Chainalysis の 2026年6月3日公開のレポート記事では、Base 上の累計で1億件超、対象は2026年Q1までです。Coinbase の公表では、2026年4月下旬時点でアクティブなエージェント6.9万、取引1.65億件、累計およそ5,000万ドル。InfoQ は、1年目で1.69億件、買い手59万、売り手10万と書いています。

さらに研究論文 arXiv:2607.19545 では、Base と Solana を対象に1.19億件を独自に実測しています。

なぜこんなに違うのかというと、対象チェーンが Base だけなのか Solana も入れるのか、集計期間はいつまでか、誰が数えたかがバラバラだからです。どれかが嘘、というより、ものさしが違うんですね。

そして大事なのは、件数だけでは中身が分からないことです。「取引件数◯億件！」だけ切り取ると、かなり誤読します。

Chainalysis は、2025年後半の急増の多くが、エージェントがサービスを買っていたのではなく、ミームコイン（ネタで作られた暗号資産）絡みの活動だったと指摘しています。PING というトークンの pay-to-mint（払って発行する）実験は、初月だけで15万件超を処理し、1週間で10,000%も伸びました。いきなり火柱みたいな伸び方です。ただし、2026年Q1には投機が冷えて伸びは落ち着いています。

一方で、中身は改善しています。1ドル以上の取引が占める割合は、2025年初の49%から2026年初には95%になりました。1セント未満の極小取引は今も処理されていますが、経済的には無視できる規模です。

Chainalysis 自身も「mass adoption remains distant（本格的な普及はまだ遠い）」と書いています。今の定着が持続的な普及なのか、単に利用者層が入れ替わっただけなのかは分からない、と釘を刺しているんです。数字は派手。でも、まだ育っている途中として見るのがよさそうです。

![数字で見るx402](/images/jp-digest-20260817-x402-ai-agent-kessai/figure3.png)

![Chainalysisのレポート記事](/images/jp-digest-20260817-x402-ai-agent-kessai/source2.png)

出典: Chainalysis「Agentic Payments Cross the Threshold: Inside x402's Path to Meaningful Adoption」（https://www.chainalysis.com/blog/x402-agentic-payments-adoption/）

## x402 / AP2 / ACP / MPP、この4つは殴り合ってない

この手の話は「プロトコル戦争だ！」と煽られがちなんですが、実際には層が違います。OSI参照モデルみたいに、役割ごとに住み分けている感じです。

ACP は OpenAI と Stripe が作ったもので、チェックアウト（会計）と加盟店連携の層です。決済レールは法定通貨のみで、カードや銀行振込を使います。2026年2月に ChatGPT の Instant Checkout として登場し、2026年3月にアプリベースのモデルへ方針転換しました。オープンな標準であることは変わっていません。

AP2 は Google が60社超のパートナーと作ったもので、認可と信頼の層です。つまり「このエージェントは本当に支払う権限を持っているのか」を、加盟店・決済事業者・ユーザーの三者が確認できるようにする枠組みです。決済レールには依存せず、カード、振込、リアルタイム決済、ステーブルコインのどれでも使えます。仕様は公開済みです。

x402 は Coinbase のプロトコルで、実行と決済、つまり送金の層です。ステーブルコイン中心、主に USDC で、複数チェーンに対応します。プロトコル自体の手数料はゼロです。V2 は2025年12月にリリースされ、ウォレット（暗号資産を管理する入れ物）ベースのID、動的な受取先、マルチチェーン対応が入りました。2026年2月には Stripe が Base 上の USDC 決済で x402 を統合しています。

MPP は Stripe と Tempo のもので、決済とセッションの層です。Tempo 上ではステーブルコインをネイティブに、法定通貨は Stripe 経由で扱います。2026年3月18日にメインネット（本番ネットワーク）が立ち上がり、100以上のサービスが最初から統合済みです。

なので、実際の構成としては「認可は AP2、EC のチェックアウトは ACP、機械と機械の支払いは x402 や MPP」という組み合わせになりえます。

使い分けの目安もわりと素直です。加盟店のカタログを持つ買い物エージェントなら ACP。監査できる認可が要る企業システムなら AP2。APIやデータフィード、エージェント同士のサービス売買なら x402。リアルタイムの少額決済の流れなら MPP です。

Crossmint は「今日、サービスに対して支払うエージェントを作るなら、実際の取引量とインフラの支援が揃っているのは x402 だけ」という見方を示しています。ここは持ち上げポイントですが、同時に「層が違うので全部を置き換えるものではない」と見ておくのが安全です。

![4つのプロトコルのレイヤー](/images/jp-digest-20260817-x402-ai-agent-kessai/figure4.png)

## じゃあ現場で何に使えるのか

まず分かりやすいのは、APIの従量課金です。アカウントもAPIキーも配らずに、叩かれたぶんだけ課金できます。取引コストが「1セントの何分の1にも満たない」単位で成立するので、これまでカード決済では採算が合わなかった細かい課金がやりやすくなります。

ここでおいしいのは、「サブスクを切らずに済む」というより「そもそもサブスクを作らずに済む」ことです。月額プランを設計して、無料枠を決めて、超過料金を出して……という前段を飛ばせる可能性があります。

次に、MCPツールへの課金です。Cloudflare は Agents SDK と MCP サーバーに x402 対応を入れていて、エージェントが有料ツールと無料ツールを混ぜて使えるデモ、つまり playground を公開しています。エージェントが「このツールは無料、このツールは有料だけど必要だから払う」と判断して動く世界ですね。

そしてクローラー向けの従量課金です。AI学習クローラーが全トラフィックの半分を超えている以上、「弾く」以外の選択肢として「課金する」が現実味を帯びています。Cloudflare の deferred payment scheme は、1リクエストごとではなく1日分をまとめて請求したいケースを想定しています。

ただし、現時点の実装は段階があります。AWS なら CloudFront + WAF。Cloudflare なら Monetization Gateway のウェイトリスト待ちです。明日からどこでもポチッと有効化、というほどではありません。

## 先に知っておきたい、けっこう痛い注意点

ここからは冷や水です。x402 はきれいな話だけではありません。

研究論文「When HTTP 402 Meets the Blockchain: Risks on Emerging x402 Payments」は、Qinying Wang、Yong Yang、Yuan Chen、Shouling Ji、Mathias Payer によるものです。arXiv:2607.19545 として2026年7月21日に投稿され、USENIX Security 2026 に採録されています。

問題の構造は、x402 が支払いの検証とオンチェーン決済を第三者の facilitator に委ねていることです。結果として facilitator は、多数の独立した加盟店にとっての共通インフラになります。信頼と検証が1か所に集まるので、1つの欠陥が多くのサービスに波及します。便利なハブが、そのまま巨大な急所にもなるわけです。

研究者は facilitator が守るべきセキュリティルールを8つ定義し、主要な15の facilitator を半自動のブラックボックス検査で調べました。結果は、15社すべてに違反あり。この15社は合計で6万を超える売り手と36万の買い手に使われています。「15社中15社アウト」は、さすがに強いパンチですよね。

導かれた新しい攻撃の型は4つです。Free Shopping（払わずに商品やデータを持っていかれる）、Asset Theft（facilitator が預かっている資産を盗まれる）、Service Denial（決済サービス自体を止められる）、Gas Abuse（肩代わりしているネットワーク手数料を無制限に使わされる）です。

実際の被害としては、加盟店の直接的な金銭損失、facilitator が保有する資産の盗難、上限なしのスポンサー負担手数料、決済サービスの停止が挙げられています。

ただし公平に見ると、研究者は責任ある開示を行い、指摘された側、Coinbase を含む関係者は問題を認めて緩和策を入れています。なので「もう全部ダメ」と切る話ではなく、「本番の金を預ける前に、facilitator をちゃんと見る必要がある」という話です。

この論文では加えて、Base と Solana の1.19億件超の取引を実測し、普及度、facilitator への集中度、エコシステム全体のリスク指標も定量化しています。

開発者側からの懐疑論もあります。InfoQ のコメント欄では、cphoover が「ボットと人間を見分けられないのなら、そもそもボットはなぜ払うのか」と投げかけています。言われてみると、たしかにそうなんですよね。

mixedbit は「この売上は誰に請求書を出せばいい？ 付加価値税は何%かければいい？」と突っ込んでいます。ヨーロッパの VAT（付加価値税）まわりは手つかずのままです。技術より先に経理が詰む、というやつですね。

Babelfish は「エージェントには無料の代替がいくらでもあるので、わざわざ払う流れにはならない」と見ています。たしかに、無料の抜け道が多いなら、有料APIに素直に払うとは限りません。

さらに人間のユーザーから見ると、暗号資産のウォレットを用意して、ステーブルコインの残高を維持する必要があります。従来の決済手段よりも手間が増えるケースはあります。エージェントには自然でも、人間にはまだ面倒、というギャップは残っています。

![x402のセキュリティ上の注意点](/images/jp-digest-20260817-x402-ai-agent-kessai/figure5.png)

![arXivの論文ページ](/images/jp-digest-20260817-x402-ai-agent-kessai/source3.png)

出典: arXiv:2607.19545「When HTTP 402 Meets the Blockchain: Risks on Emerging x402 Payments」（https://arxiv.org/abs/2607.19545）／ライセンス: CC BY

## まとめ — 今は「使うか」より「見ておくか」

x402 は、かなり面白い場所に来ています。ただし、今日から全部これに乗り換える話ではありません。

押さえるポイントはこのあたりです。

- 402は仕様としては昔からあった。新しいのは「エージェントが自分で払う」という前提のほう
- エッジ、つまり CloudFront / Cloudflare に載った時点で、実装のハードルはかなり下がった
- 取引件数の数字は集計方法でバラバラだし、中身の質はまだ育っている途中
- facilitator に信頼が集中する構造は、まだセキュリティ的にこなれていない。触るなら本番の金を預ける前に、facilitator の選定を真面目にやる

個人開発で有料APIやデータフィードを出している人にとっては、「アカウントを作らせず、APIキーも配らず、リクエスト単位で課金する」選択肢が見えてきたのはかなり大きいです。

一方で、税務、無料代替、ウォレットの手間、facilitator のリスクなど、まだ痛いところも残っています。今日から全部これに乗り換えろ、という話ではないんですが、有料APIを出している人は一度仕様を眺めておいて損はないですよ。

### 参考にした記事

- [Launching the x402 Foundation with Coinbase, and support for x402 transactions（Cloudflare公式ブログ）](https://blog.cloudflare.com/x402/)
- [Linux Foundation is Launching the x402 Foundation and Welcoming the Contribution of the x402 Protocol（The Linux Foundation）](https://www.linuxfoundation.org/press/linux-foundation-is-launching-the-x402-foundation-and-welcoming-the-contribution-of-the-x402-protocol)
- [Cloudflare and Coinbase launch x402 Foundation to drive agent payments（The Block）](https://www.theblock.co/post/372064/cloudflare-coinbase-launch-x402-foundation)
- [Cloudflare and AWS Embed x402 Agent Payments at the Edge（InfoQ）](https://www.infoq.com/news/2026/07/cloudflare-aws-x402-micropayment/)
- [Agentic payments protocols compared: Which is best for your AI agents?（Crossmint）](https://www.crossmint.com/learn/agentic-payments-protocols-compared)
- [Agentic Payments Cross the Threshold: Inside x402's Path to Meaningful Adoption（Chainalysis）](https://www.chainalysis.com/blog/x402-agentic-payments-adoption/)
- [When HTTP 402 Meets the Blockchain: Risks on Emerging x402 Payments（arXiv:2607.19545）](https://arxiv.org/abs/2607.19545)