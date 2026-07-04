---
title: "Google Antigravity 使い方｜Gemini CLIはなぜ終了？"
emoji: "🚀"
type: "tech"
topics: ["生成ai", "ai", "googleantigravity", "geminicli"]
published: false
---

「Gemini CLI が 6月18日で終わる」——そんなニュースが海外の開発者界隈をざわつかせました。えっ、あの便利なやつ消えるの？と焦った人もいるはず。でも落ち着いて。消えるんじゃなくて、**Google Antigravity（グーグル・アンチグラビティ）**という新しい入れ物に引っ越した、というのが正しい理解なんです。

この記事は、Google の公式発表と海外メディア数本を突き合わせて再構成したものです。「Antigravity ってそもそも何？」「どう使うの？」「Gemini CLI 終了で自分は何をすればいい？」を、順番にやさしくほどいていきますね。

![Google Antigravity 使い方とGemini CLI終了の全体像](/images/jp-digest-20260705-google-antigravity/figure1.png)

## そもそも Google Antigravity って何者？

ひとことで言うと、**AIエージェント（自分で手を動かして作業するAI）を主役にした開発ツール**です。2025年11月18日、大型モデル Gemini 3 と同じ日にデビューしました。

面白いのは設計思想。ふつうのAIコーディングって、エディタの右端にチャット欄がちょこんと居て、そこに話しかける感じですよね。Antigravity はそれをひっくり返して、「エージェントには専用の作業場をあげようよ」という発想で作られているんです。

中身は大きく2つの画面に分かれています。

- **エディタ画面（Editor View）**：見慣れた VS Code 風の IDE（統合開発環境）。タブ補完もインライン指示も効くので、書き味はいつも通り。
- **マネージャ画面（Manager Surface）**：複数のエージェントを並べて指揮する司令塔。ここが今回のいちばんの目玉です。

頭脳は Gemini 3 Pro が中心。さらに Claude や GPT-OSS といった他社のモデルも選べる「モデル選び放題」仕様になっています。土台は VS Code のフォーク（派生）だと言われていますが、「いや Windsurf の派生じゃない？」という議論もあって、そこは海外でもちょっと意見が割れています。正体としては **IDE・CLI・SDK（開発キット）の3点セット**、と覚えておけばOKです。

![Google Antigravityの構成：エディタ画面とマネージャ画面](/images/jp-digest-20260705-google-antigravity/figure2.png)

## 使い方はかんたん：4ステップで動く

「なんだか大掛かりそう…」と身構えなくて大丈夫。始めるまでの手順は、拍子抜けするくらいシンプルです。

1. 公式サイト **antigravity.google** から、自分のOS版をダウンロード。VS Code を落とすのと同じ感覚です。
2. **Google アカウントでサインイン**。無料プレビューを使うのに必要です。
3. プロジェクトの**フォルダを開く**。ここまでは普通のエディタと変わりません。
4. マネージャ画面で**エージェントに日本語で指示**を出す。あとはお任せ。

対応OSは macOS / Windows / Linux。2026年時点ではまだプレビュー段階で、**個人は無料**で触れます（正式版になったら有料プランが来る、とは告知済み）。ここまで無料でこの機能盛りは、正直ちょっと太っ腹すぎません？

![Google Antigravityの使い方4ステップ](/images/jp-digest-20260705-google-antigravity/figure3.png)

## 主役は「Agent Manager」——5体のAIを同時に走らせる

さて、Antigravity のいちばんの推しポイント。マネージャ画面では、**エージェントを最大5体まで同時に、しかも非同期で走らせられる**んです。「片方にテスト書かせてる間に、もう片方でバグ調査」みたいな並行作業が、指揮者みたいにさばける。ここが従来ツールとの決定的な差なんですよね。

もうひとつ賢いのが **Artifacts（アーティファクト＝成果物）** という考え方。エージェントの作業を、ずらーっと流れる生ログで追うのって地味にしんどいじゃないですか。Antigravity はそこを、

- タスク一覧
- 実装計画
- スクリーンショット
- **ブラウザ操作の録画**

みたいな「見て分かる成果物」で報告してくれます。内蔵の Chrome ブラウザでエージェントが自分でUIを触って確認までしてくれるので、差分（コードの変更点）を1行残らず読まなくても、要点だけレビューできる。この「全部読まなくていい」の安心感、けっこう効きます。

![Agent Managerで最大5体のエージェントを並行実行、Artifactsで成果物レビュー](/images/jp-digest-20260705-google-antigravity/figure4.png)

海外の解説記事でも、この「エージェント優先（agent-first）」の設計が Antigravity の目玉として紹介されています。

![出典スクリーンショット：AI Made Tools の Antigravity 2.0 解説](/images/jp-digest-20260705-google-antigravity/source3.png)
*出典: AI Made Tools（https://www.aimadetools.com/blog/antigravity-2-complete-guide/）*

## なんで Gemini CLI は終わっちゃうの？

ここで本題の「Gemini CLI 終了」の話。時系列で並べると、流れはこうです。

- **2025/11/18**：Antigravity が Gemini 3 と同時にデビュー
- **2026年 春**：Antigravity 2.0 が登場し、マルチエージェント基盤に進化
- **2026年 5月**：Gemini CLI を「Antigravity CLI へ移行する」と告知
- **2026/6/18**：個人向けの Gemini CLI が受付停止

公式の言い分はこうです。6月18日をもって、**Gemini CLI と Gemini Code Assist の IDE拡張は、Google AI Pro / Ultra ユーザーや無料の個人向けにリクエストの受付を止める**、と。代わりに来るのが **Antigravity CLI**。ターミナル（コマンドで操作する画面）から呼び出すコマンド名は `agy` です。

中身は Go 言語で書き直されていて、「キビキビ動いて軽い」と謳われています。しかも Antigravity 2.0 とまったく同じ土台（エージェントの動作基盤）を共有しているので、本体とCLIで挙動がバラつかない、というのがウリ。Agent Skills・Hooks・Subagents・Extensions（プラグイン扱いに）といった機能も引き継がれます。

ただし全員が対象ではありません。**Gemini Code Assist の Standard / Enterprise ライセンス勢や、有料のAPIキーを使っている組織はそのまま**。影響を受けるのは主に無料・個人利用の層、というわけです。

![Gemini CLI終了までのタイムラインとagyコマンド](/images/jp-digest-20260705-google-antigravity/figure5.png)

![出典スクリーンショット：The Register の Gemini CLI 移行報道](/images/jp-digest-20260705-google-antigravity/source1.png)
*出典: The Register（https://www.theregister.com/ai-ml/2026/05/20/bye-bye-gemini-cli-google-nudges-devs-toward-antigravity/）*

## 賛否両論：オープンソースだったのに…

で、ここからが正直しんどいところ。この移行、海外の開発者からはけっこう反発が出ています。

いちばん大きいのが **オープンソース → クローズド問題**。旧 Gemini CLI は Apache-2.0 という OSS（オープンソース）で、リポジトリ（コード置き場）にソースが全部載っていました。ところが新しい Antigravity CLI のリポジトリには、変更履歴と README、デモ用のGIFがあるだけで、**肝心のソースコードが公開されていない**んです。「コミュニティの貢献で育てたOSSを土台に、非公開の後継を作った」ように見える、と受け取る人が出るのも無理はないですよね。

さらに、Google 自身が「**初日から機能が1対1で一致するわけじゃない（There won't be 1:1 feature parity right out of the gate）**」と認めています。加えて、利用枠（クォータ）がキツすぎて数リクエストで週の上限に達した、なんて不満も GitHub 上で飛び交いました。極めつけは、6月18日の停止が**猶予期間なし・予告なし**だったこと。`gemini` コマンドを呼んでいた **CI/CD（自動ビルド・デプロイの仕組み）が、その日いきなり止まった**現場もあったとか。急な引っ越しは、やっぱりどこかで軋みますね。

| 項目 | Gemini CLI（旧） | Antigravity CLI（新） |
| --- | --- | --- |
| 言語 | TypeScript | Go（速い・軽い） |
| 公開 | Apache-2.0 の OSS | 現状ソース非公開 |
| エージェント | 基本ひとり | 並行・非同期で複数 |
| 呼び出し | `gemini` | `agy` |
| 土台 | 単機能のCLI | 2.0 と共通の基盤 |

![Gemini CLIとAntigravity CLIの違い比較表](/images/jp-digest-20260705-google-antigravity/figure6.png)

![出典スクリーンショット：AI Builder Club の Gemini CLI 終了・移行解説](/images/jp-digest-20260705-google-antigravity/source2.png)
*出典: AI Builder Club（https://www.aibuilderclub.com/blog/google-kills-gemini-cli-june-18-2026）*

## で、いまどうすればいい？

タイプ別に、ざっくり指針を置いておきますね。

- **Gemini CLI を個人で無料利用していた人**：素直に Antigravity（CLI か本体）に乗り換えるのが現実的。まだ機能が完全に揃っていない点だけ頭に入れておきましょう。
- **CI/CD に組み込んでいたチーム**：`gemini` 依存のスクリプトが止まっていないか要点検。`agy` への置き換えか、有料ライセンス継続かを早めに判断を。
- **これから触る人**：無料プレビューのうちに、まず本体アプリを入れて Agent Manager の並行エージェントを体験してみるのがおすすめ。この使用感は他ツールにはない持ち味です。

## まとめ

- Google Antigravity は、**AIエージェントに専用の作業場を与える**エージェント優先の開発プラットフォーム。IDE・CLI・SDK の3点セット。
- 使い方はダウンロード→サインイン→フォルダを開く→指示、の4ステップ。**個人は無料**で試せます（2026年時点）。
- 目玉は **最大5体の並行エージェント**と、成果物で報告してくれる **Artifacts**。
- 2026年6月18日で**個人向け Gemini CLI は受付停止**。後継は Go 製の Antigravity CLI（`agy`）。
- ただし**オープンソースから非公開へ**という変化には賛否あり。乗り換え前提で、影響範囲だけは早めに確認を。

新しい道具って、ワクワクと「うわ引っ越しめんどい」が同居しますよね。Antigravity は方向性としてかなり尖っていて面白いので、まずは無料のうちに触って、自分の肌に合うか確かめてみてください。

### 参考にした記事

- Google Developers Blog「An important update: Transitioning Gemini CLI to Antigravity CLI」 https://developers.googleblog.com/an-important-update-transitioning-gemini-cli-to-antigravity-cli/
- Google Developers Blog「Build with Google Antigravity, our new agentic development platform」 https://developers.googleblog.com/build-with-google-antigravity-our-new-agentic-development-platform/
- The Register「Bye-bye, Gemini CLI; Google's gone and swapped you for a closed-source AI」 https://www.theregister.com/ai-ml/2026/05/20/bye-bye-gemini-cli-google-nudges-devs-toward-antigravity/
- AI Builder Club「Google Kills Gemini CLI June 18: Antigravity Migration」 https://www.aibuilderclub.com/blog/google-kills-gemini-cli-june-18-2026
- Virtualization Review「Google Moves Gemini CLI Into Antigravity CLI as Agent Platform Expands」 https://virtualizationreview.com/articles/2026/05/19/google-moves-gemini-cli-into-antigravity-cli-as-agent-platform-expands.aspx
- AI Made Tools「Google Antigravity 2.0 Complete Guide」 https://www.aimadetools.com/blog/antigravity-2-complete-guide/
- Beginners in AI「Google Antigravity: Agent-First IDE Built on VS Code」 https://beginnersinai.org/google-antigravity/
- Wikipedia「Google Antigravity」 https://en.wikipedia.org/wiki/Google_Antigravity
