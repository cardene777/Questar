# Questar

## 概要

- クエストプラットフォーム。
- ユーザーはいくつかのクエストをこなしてポイント（トークン）を受け取ることができる。
  - クエストの内容はクイズやさまざまなプロジェクトのキャンペーンタスク。
- このトークンが一定数溜まると NFT が mint される（`ERC404`, `DN404`...）
- NFT 自体の売買は可能だが、NFT を売却するとその分ポイント（トークン）が減る。
  - 逆に NFT を買うとポイントが増える。
- これによりユーザーのコレクション欲を満たしつつ、ガチャ感覚で楽しむことができる。
- プロジェクト側には、オンチェーン情報をより提供しやすくすることがメリット。
  - 「特定アドレスが幾つの NFT を持っているか」、「トランザクション数」、「マルチチェーン対応」など。

## キャンペーンタスク

- Giveaway やエアドロを中心にユーザーに特定のタスクを行なってもらうことは、現在の Web3 プロジェクトでは当たり前のように行われている。
- よく使用されているツールとしては、[gleam](https://gleam.io/)などが挙げられる。
  - X 連携、X の Post いいねや Re-Post、Discord 連携、その結果の抽選。
- あまりオンチェーン特化のサービスではないため、オンチェーン情報などの取得には向いていない。
  - 「特定アドレスの特定 NFT の保有数」、「保有期間」、「一定期間のトランザクション数」などの情報を取得することで、よりリーチしたいユーザーに届けることができる。
  - また、「マルチチェーン対応」をすることで EVM に限らない体験を提供。

## ERC404・DN404

- FT を一定数保有していると、NFT を Mint することができる仕組み。
- NFT を売却すると、その分の FT が消失する。
- NFT や FT 自体の長期保有などにも使用できる。

[https://relipasoft.com/blog/what-is-erc-404/](https://relipasoft.com/blog/what-is-erc-404/)
[https://note.com/zerox_c/n/n125fd28a7543](https://note.com/zerox_c/n/n125fd28a7543)

## ユーザー

- キャンペーンタスク自体はシンプル。
- タスク自体は単純なため正直めんどくさい。
- タスクをこなすことでポイント（トークン）を受け取れて、一定数溜まると NFT を発行できるため、ガチャを引くためにタスクをこなすなどモチベーションが生まれる。
- 企業とのコラボ NFT を出すことでコレクション欲の掻き立ても検討。

## タスク

現在実装予定のタスクは以下になります。

- Twitterの特定投稿いいね
- Twitterの特定投稿リツイート
- Discordの特定サーバー参加
- Discordの特定サーバーのロール取得
- クイズ
- 特定チェーンのネイティブトークンの保有数
- 特定チェーンの特定NFTの保有数
- 特定チェーンの特定NFTを保有しているか
- 特定チェーンの特定NFTの保有期間
- 特定チェーンの特定コントラクト内の特定の関数からの戻り値
- 特定チェーンのトランザクション数
- 特定チェーンの特定コントラクトのトランザクション数
- 特定チェーンの特定期間のトランザクション数


追加予定のタスクは以下になります。

- Farcaster関連（どのデータが最適かリサーチ中）

## 集計後のアクション

タスクを完了してもらい、集計をした後のアクションは以下を実装予定です。

- NFTの配布。
- ネイティブトークンの配布
- ERC20トークンの配布
- SBTの配布
- ポイントの配布

## 懸念点

### 特定プロジェクトがキャンペーンタスクを出しすぎる

- この影響でやたらポイントが受け取れてしまうため、キャンペーンタスクを行うときに一定数トークンを deposit してもらう。
- これにより、キャンペーンタスクの無駄撃ちを防ぐ。
- これに加え、deposit したトークンはポイント（トークン）発行のガス代に使用。
- aptos チェーンの速度であればほぼリアルタイムにトークン発行できるのではないかという見込み。
