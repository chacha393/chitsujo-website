# CHITSUJO-WEBSITE Design Spec v0.1

## 1. 目的

このドキュメントは、個人サイト `CHITSUJO-WEBSITE` の初期設計をまとめたものです。  
現時点では「メンテナンス表示中のトップページ」と「プロフィールページの試作」が存在しており、今後それらを統一感のある本番サイトへ育てていくための土台として扱います。

## 2. プロジェクトの前提

- サイト名: `CHITSUJO-WEBSITE`
- 想定用途: VTuber / 個人活動用の公式サイト
- 主ターゲット: スマホユーザー
- 現在の公開形態: 静的サイト
- デプロイ候補: GitHub Pages
- 技術方針: まずは HTML / CSS 中心で構築し、必要最小限の JavaScript を追加する
- 設計優先度: mobile-first で組み、PC 表示はそのあと拡張する

## 3. 現在のファイル構成

```text
CHITSUJO-WEBSITE/
├─ assets/
│  ├─ audio/
│  ├─ images/
│  │  ├─ ui/
│  │  │  ├─ logo/
│  │  │  ├─ icons/
│  │  │  ├─ decorations/
│  │  │  └─ backgrounds/
│  │  ├─ character/
│  │  │  ├─ main/
│  │  │  │  ├─ base/
│  │  │  │  └─ costumes/
│  │  │  ├─ mini/
│  │  │  └─ expressions/
│  │  ├─ gallery/
│  │  │  ├─ inbox/
│  │  │  ├─ commissioned/
│  │  │  ├─ gifted/
│  │  │  ├─ fanart/
│  │  │  └─ thumbnails/
│  │  └─ ogp/
│  └─ models/
├─ css/
│  ├─ gallery.css
│  ├─ maintenance.css
│  ├─ profile.css
│  └─ style.css
├─ docs/
│  ├─ README.md
│  ├─ assets-workflow.md
│  ├─ design-spec.md
│  ├─ design-spec-v0.1.md
│  └─ owner-request.md
├─ gallery.html
├─ index.html
├─ index_main.html
└─ profile.html
```

主要アセットの現在位置:

```text
assets/images/ui/logo/logo.png
assets/images/character/mini/mini-character.png
assets/images/character/main/base/
assets/images/character/main/costumes/
```

## 4. ページ方針

### 4.1 `index.html`

- メンテナンス表示用の仮トップページ
- ロゴ、ミニキャラクター、進捗表示を中心にした短期運用ページ
- 本公開までは案内ページとして利用できる

### 4.2 `index_main.html`

- 現在の本番トップ候補
- 旧 `test4` をもとにした軽めのトップページ
- Hero、Tag / Mama、Diary 導線を中心にした構成
- `diary.html` へつながる日記プレビューを持つ

### 4.3 `profile.html`

- キャラクター設定やプロフィールを掲載するページ
- 今後の世界観表現や情報整理の基準ページとして扱う

### 4.4 `gallery.html`

- イラスト掲載用のページ
- 描いていただいた作品をまとめて見せる土台ページ
- 現時点では画像未投入でも成立する構成として実装し、あとから作品を追加できるようにする

## 5. デザインコンセプト

### 5.1 キーワード

- かわいい
- やわらかい
- 空気感が軽い
- 親しみやすい
- 少しファンタジー寄り

### 5.2 トーン

- パステル寄りのやさしい色使い
- 白をしっかり残した抜け感のあるレイアウト
- 情報量は増やしても、見た目は重くしない
- スマホで片手でも追いやすい情報密度にする

### 5.3 避けたい方向

- 企業サイトのような硬さ
- 黒ベースで重たい印象
- エフェクト過多で読みにくい画面
- hover 前提でしか意味が伝わらない UI
- カーソルを合わせないと開かない説明や補足

## 6. 情報設計

初期フェーズでは次のセクションを中心に組み立てます。

1. Hero
2. Profile / About
3. 好きなもの・趣味
4. イラスト / ビジュアル
5. お知らせ or 日記
6. SNSリンク
7. ガイドライン / Contact
8. Footer

ギャラリー系コンテンツは次の考え方で扱います。

1. まず `gallery/inbox/` に未分類で入れる
2. ページ上では「描いていただいた作品」としてまとめて見せる
3. 一覧表示用の軽量画像は必要になったら `thumbnails/` に分ける

## 7. コンテンツ方針

### 7.1 Hero

- 名前
- 一言で伝わる肩書き
- メインビジュアル
- サイト全体の空気感を決める短いコピー

### 7.2 Profile / About

- 誕生日
- デビュー日
- ママ
- 好きなもの
- タグ類
- 一言プロフィール

### 7.3 SNSリンク

- YouTube
- X
- BOOTH
- そのほか活動導線

### 7.4 お知らせ / 日記

- 更新しやすさを最優先
- 初期は HTML 直書きでも可
- 将来的に JSON 管理へ移行できる構造を意識する

### 7.5 ギャラリー

- 描いていただいた作品を継続的に追加できること
- まずは素材投入を優先し、カテゴリ分けは必須にしない
- ファイルの振り分けやサムネイル整理を後から自動化しやすい構成にする
- 内部管理では、`特にお気に入り` と `そのほか` のような区分で整理できるようにする

## 8. 実装方針

### 8.1 HTML

- セマンティックな構造を優先する
- 見た目のためだけの過剰なラッパーは増やしすぎない
- セクション単位で役割が分かる構成にする

### 8.2 CSS

- ページごとの役割に応じてファイルを分ける
- 共通化が必要になった段階で設計をまとめる
- 変数は `:root` に寄せ、色や余白を再利用しやすくする
- 重要な情報は hover しなくても見える状態を基本とする
- hover 演出は補助扱いにし、スマホでは `:active` や常時表示で成立させる

### 8.3 JavaScript

- 必要最小限にとどめる
- タブ切り替え、軽いアニメーション、更新表示などに限定する
- DOM 構造を壊す複雑なスクリプトは避ける

### 8.4 モバイルユーザー向け UI 原則

- 最初に見る幅はスマホを前提にする
- スマホユーザーはカーソルを合わせる操作が基本的に存在しない前提で設計する
- 主要ボタンやリンクは 44px 以上のタップしやすいサイズを確保する
- hover しないと読めない説明や補足は作らない
- タップ時は `:active` や色変化で反応を返す
- 画面上部で情報を詰め込みすぎず、縦方向に素直に読める構造を優先する
- アニメーションは見た目の補助にとどめ、読みにくさを生まない範囲にする
- 情報の開示やナビゲーションは、タップだけで完結する構造を優先する
- hover 演出を使う場合でも、意味や情報は常時表示またはタップで取得できる状態を必須とする
- PC 向けの hover 演出は `(hover: hover)` や `(pointer: fine)` を前提にした補助表現として扱う

## 9. 命名ルール

- クラス名は意味ベースで付ける
- 装飾より役割を優先する
- 将来的には BEM ライクな命名へ寄せる

例:

- `profile-card`
- `profile-card__title`
- `section-title`
- `sns-button`
- `diary-card`

## 10. フォルダ整理方針

現時点では大規模な移動は行わず、次のルールで整理を進めます。

- `assets/` は画像などの静的素材置き場
- `css/` はページ単位または用途単位のスタイル置き場
- `docs/` は設計書、運用メモ、仕様メモの置き場
- 追加の JavaScript が必要になったら `js/` を新設する

アセット運用ルール:

- UI 用画像は `assets/images/ui/`
- キャラクター画像は `assets/images/character/`
- 立ち絵の本体は `assets/images/character/main/base/`
- 衣装差分や別バージョンは `assets/images/character/main/costumes/`
- 未分類イラストはまず `assets/images/gallery/inbox/`
- フォルダ分類は残してよいが、ページ上ではひとまとめ表示でよい
- OGP 画像は `assets/images/ogp/`

## 11. 次フェーズの優先順位

### Phase 1

- 文字コードを UTF-8 で統一する
- `index.html` と `profile.html` の文言崩れを修正する

### Phase 2

- `index_main.html` のデザイン方針を確定する
- 共通カラー、余白、見出しルールを整理する

### Phase 3

- Hero / Profile / SNS の本実装
- 必要なら `js/` と `components/` の導入を検討する

### Phase 4

- お知らせ、日記、ギャラリーなど更新型コンテンツを追加する
- `gallery/inbox/` に投入した画像をページへ反映しやすい構造を作る

## 12. 補足

この `v0.1` は初期たたき台です。  
今後は `docs/design-spec.md` を現行版の参照先として更新し、版管理が必要になったら `v0.2`, `v0.3` を追加していきます。
