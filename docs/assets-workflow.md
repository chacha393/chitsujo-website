# Assets Workflow

## 1. 目的

このメモは、画像素材を「とりあえず全部入れる」運用と、あとから整理する運用を両立するためのルールです。

## 2. 基本方針

- 受け取った画像は、まず `assets/images/gallery/inbox/` に入れる
- Web ページ上では「描いていただいた作品」としてまとめて扱う
- 内部管理では必要に応じて `特にお気に入り` と `そのほか` に分けてよい
- Web ページ用に軽量版が必要になったら `thumbnails/` を使う

## 3. フォルダの役割

### UI 系

- `assets/images/ui/logo/`: ロゴ
- `assets/images/ui/icons/`: アイコン
- `assets/images/ui/decorations/`: 飾り素材
- `assets/images/ui/backgrounds/`: 背景画像

### キャラクター系

- `assets/images/character/main/base/`: 立ち絵の本体
- `assets/images/character/main/costumes/`: 衣装差分や別バージョンの立ち絵
- `assets/images/character/mini/`: ミニキャラ
- `assets/images/character/expressions/`: 表情差分

### ギャラリー系

- `assets/images/gallery/inbox/`: 未分類の投入先
- `assets/images/gallery/commissioned/`: 依頼して描いてもらった絵
- `assets/images/gallery/gifted/`: 寄付・贈り物としてもらった絵
- `assets/images/gallery/fanart/`: ファンアート
- `assets/images/gallery/thumbnails/`: 一覧表示用サムネイル

補足:

- フォルダは残すが、ページ上では必ずしもカテゴリ分け表示をしなくてよい
- 当面は「描いていただいた作品」としてひとまとめに見せる
- `特にお気に入り` / `そのほか` は内部で選定や整理をしやすくするための管理用区分として使ってよい
- 立ち絵は `main/base/` を本体、`main/costumes/` を差分として内部で分けてよい

### その他

- `assets/images/ogp/`: OGP 画像
- `assets/audio/`: 音素材
- `assets/models/`: モデル系素材

## 4. まずやること

画像を受け取ったら、最初は細かく悩まず次の流れでよい。

1. `assets/images/gallery/inbox/` に入れる
2. ファイル名を大きく壊さない範囲で整理する
3. ギャラリーページへ順次反映する

## 5. 後からこちらでできること

画像を `inbox/` に入れてもらえれば、あとから次の作業を進められる。

- 依頼絵 / 寄付絵 / FA の分類
- 内部向けの `特にお気に入り` / `そのほか` の振り分け
- サムネイル用画像の切り分け方針整理
- ギャラリーページ用の一覧データ整理
- HTML に載せる候補の選定
- トップページや別ページへの流用提案
- 立ち絵の本体を `assets/images/character/main/base/` に整理する
- 衣装差分や別バージョンを `assets/images/character/main/costumes/` に整理する

## 6. 補足

- 厳密な分類は最初からやらなくてよい
- まず投入しやすいことを優先する
- ページ上では「描いていただいた作品」のまとまりとして見せてよい
- 作品数が増えたら、内部では `特にお気に入り` を先に選んで整理すると管理しやすい
- 立ち絵は `base/` を本体置き場、`costumes/` を差分置き場として固定すると迷いにくい
- 将来的に `gallery.html` や JSON 管理へ拡張しやすい構成を前提にしている
