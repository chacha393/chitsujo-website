# サイト制作リサーチメモ

更新日: 2026-04-01

このメモは、秩序めあサイトの制作にそのまま役立つ内容だけを、公式ドキュメントベースで整理したものです。
特に、スマホ向けUI、画像表示、YouTube埋め込み、アクセシビリティ、表示速度を重視しています。

## 先に結論

- スマホ向けの主要ボタン、SNSリンク、ページ内導線は `44 x 44 CSS px` を目安に作る。最低ラインで考えるなら `24 x 24 CSS px` または十分な間隔が必要。
- ファーストビューの主画像や主見出しまわりは `LCP` になりやすいので、主画像を安易に `loading="lazy"` にしない。
- 2画面目以降の画像や YouTube 埋め込みは `loading="lazy"` を使って初期表示を軽くする。
- 日記画像やギャラリー画像は `srcset` と `sizes` を使って、スマホに大きすぎる画像を送らない。
- 画像や動画の枠には `width` / `height` または CSS の `aspect-ratio` を入れて、表示中のガタつき `CLS` を減らす。
- アニメーションは `prefers-reduced-motion` を尊重し、位置移動は `top/left` より `transform` を優先する。
- YouTube 埋め込みは `iframe` の `title` を必ず付ける。自動再生は基本オフでよい。
- 各ページの `<title>` は固有にして、ページ名が先、サイト名が後になる形が扱いやすい。

## 1. スマホ向け操作性

W3C の WCAG 2.2 では、ポインター操作の対象は `24 x 24 CSS px` 以上、または十分な間隔が必要とされています。  
さらに WCAG 2.1 の理解文書では、より扱いやすい目安として `44 x 44 CSS px` が示されています。  
特にタッチ操作は、マウスより精度が粗く、指が対象を隠しやすいと明記されています。

このサイトで効く実装方針:

- `X / YouTube / IRIAM / BOOTH` のボタンは小さく作りすぎない
- ヒーロー下の主要導線は、文字リンクだけでなくボタン化する
- タグ表示だけを細く置くより、押せるカードやチップとして余白を確保する
- スマホで片手操作しやすいよう、画面端ギリギリに重要ボタンを寄せすぎない
- スマホではカーソルを合わせる操作が前提にならないため、情報を hover のみで開示しない
- hover の見た目を残す場合でも、意味は常時表示またはタップで取得できる形にする

## 2. 画像設計と表示速度

MDN の responsive images ガイドでは、`srcset` / `sizes` / `<picture>` により、画面サイズや解像度に合った画像を出し分ける方法が整理されています。  
同ガイドでは、スマホに対して PC 向けの大きい画像をそのまま送るのは帯域の無駄になりやすいと説明されています。

web.dev の LCP ガイドでは、ページの主画像はできるだけ早く発見・読み込みされるべきで、`LCP` になっている画像へ `loading="lazy"` を付けるのは避けるべきとされています。  
一方で MDN の lazy loading ガイドでは、画面外の画像や `iframe` は `loading="lazy"` で遅延読み込みでき、初期表示を軽くできるとされています。

このサイトで効く実装方針:

- ヒーローのメインビジュアルは `loading="lazy"` を付けない
- 日記一覧、ギャラリー、埋め込み動画は `loading="lazy"` を使う
- 画像追加運用では、スマホ用の小さめ画像も用意できると理想
- 立ち絵やメイン画像は、最低でも表示枠の比率を固定して `CLS` を抑える

日記画像用の基本例:

```html
<img
  src="assets/images/diary/2026-04-01-main-960.jpg"
  srcset="
    assets/images/diary/2026-04-01-main-480.jpg 480w,
    assets/images/diary/2026-04-01-main-960.jpg 960w
  "
  sizes="(width <= 600px) 92vw, 640px"
  width="960"
  height="540"
  loading="lazy"
  alt="日記画像の説明"
>
```

補足:

- `srcset` は画像候補の一覧
- `sizes` は「この画面幅ではどのくらいの表示幅か」のヒント
- `width` と `height` は表示前に枠を予約するためにも重要

## 3. レイアウトのガタつき対策

web.dev の `CLS` ガイドでは、画像や動画の寸法が不明なまま読み込まれること、フォント差し替え、後から挿入される外部コンテンツなどが、レイアウトシフトの原因になりやすいとされています。  
また、良い `CLS` の目安は `0.1 以下` です。

このサイトで効く実装方針:

- 画像には `width` / `height` を付ける
- YouTube 枠は `aspect-ratio: 16 / 9;` などで高さを先に確保する
- 後から出る日記カードや動画カードは、読み込み前のプレースホルダー高さを固定する
- アニメーションで位置を動かすときは `transform` を使い、レイアウト再計算を減らす

動画枠の基本例:

```css
.movie-frame {
  aspect-ratio: 16 / 9;
  width: 100%;
}

.movie-frame iframe {
  width: 100%;
  height: 100%;
  border: 0;
}
```

## 4. YouTube 埋め込み

YouTube 公式の埋め込みドキュメントでは、`<iframe>` 埋め込みと `IFrame Player API` の両方が案内されています。  
通常のサイトなら、まずは `iframe` だけで十分です。再生制御やイベント連携が必要になった時だけ API 化するのが自然です。

公式資料から見て重要な点:

- 埋め込みプレイヤーは最低でも `200 x 200` が必要
- 16:9 なら `480 x 270` 以上が推奨
- `autoplay=1` はページ読み込み直後に再生され、再生データの収集も伴う
- `enablejsapi=1` を使う場合は `origin` を指定するのが推奨
- プレイリスト埋め込みも可能

このサイトで効く実装方針:

- 通常の動画掲載は `iframe` で十分
- `Movie` セクションがファーストビュー外なら `loading="lazy"` を付ける
- 動画ごとに `title` を入れて、何の動画か分かるようにする
- 自動再生は基本オフ
- 将来「おすすめ動画3本」「再生リスト」へ拡張しやすい構造にしておく

基本例:

```html
<iframe
  src="https://www.youtube.com/embed/VIDEO_ID"
  title="秩序めあのYouTube動画"
  loading="lazy"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  allowfullscreen
></iframe>
```

将来 API 化する場合の例:

```text
https://www.youtube.com/embed/VIDEO_ID?enablejsapi=1&origin=https://example.com
```

プレイリスト例:

```text
https://www.youtube.com/embed?listType=playlist&list=PLAYLIST_ID
```

## 5. アニメーションとアクセシビリティ

MDN の `prefers-reduced-motion` ドキュメントでは、ユーザーが OS 側で動きを減らす設定を有効にしているかを検出できるとされています。  
大きいスケール変化や移動は、人によっては不快感の原因になります。  
web.dev の `CLS` 記事でも、アニメーションを使うなら `prefers-reduced-motion` を尊重し、`transform` ベースの実装が推奨されています。

このサイトで効く実装方針:

- フェードや軽い浮き上がりは通常表示のみ
- `prefers-reduced-motion: reduce` ではアニメーション時間を短くするか、ほぼ無効化する
- 画面全体が大きく動く演出や、常時ループする強い演出は控える

例:

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

## 6. タイトルと埋め込みラベル

MDN の `<title>` ドキュメントでは、ページタイトルは正確で簡潔、かつ各ページ固有であることが重要とされています。  
同ページでは、支援技術の利用者はページ内容を推測するためにタイトルを先に読むことが多いため、ページの目的を先に、サイト名を後に置く形が分かりやすいと説明されています。

また、MDN の `<iframe>` ドキュメントでは、`iframe` の `title` は埋め込み内容を簡潔に説明するべきで、これがないと支援技術の利用者は中に入って内容を確かめる必要があり、混乱しやすいとされています。

このサイトで効く実装方針:

- `トップ | 秩序めあ`
- `プロフィール | 秩序めあ`
- `ギャラリー | 秩序めあ`
- `日記 | 秩序めあ`

動画埋め込みタイトル例:

- `title="秩序めあの最新動画"`
- `title="秩序めあの配信アーカイブ"`

## 7. 公開前の計測

Chrome for Developers の PageSpeed Insights ガイドでは、`PSI` は Lighthouse のラボデータに加えて、CrUX の実ユーザーデータも表示できると説明されています。  
特に `LCP`、`INP`、`CLS` をまず見るのが基本です。

このサイトで見るべき目安:

- `LCP`: `2.5秒以下`
- `INP`: `200ms以下`
- `CLS`: `0.1以下`

このサイトでの使い方:

- トップ候補ページを `PSI` で確認する
- スマホ結果を優先して見る
- ヒーロー画像差し替え前後で `LCP` を比べる
- 日記画像や YouTube を追加した後に `CLS` が悪化していないかを見る

## 8. 今のプロジェクトで優先すべき実装順

優先度 `高`

- 主要ボタンとリンクのタップ領域を `44px` 目安で統一
- ヒーロー主画像は lazy load しない
- 下層の画像と動画は lazy load する
- 画像と動画枠に寸法予約を入れる
- 各ページの `<title>` と各 `iframe` の `title` を整える

優先度 `中`

- 日記画像とギャラリー画像に `srcset` / `sizes` を導入
- `prefers-reduced-motion` を全テスト案に共通導入
- PageSpeed Insights で本番候補ページを確認

優先度 `後でよい`

- YouTube IFrame API での制御
- YouTube プレイリストの自動表示
- `fetchpriority` や preload を使った LCP の追加最適化

## 参考リンク

- W3C, Target Size (Minimum): https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum
- W3C, Target Size: https://www.w3.org/WAI/WCAG21/Understanding/target-size
- MDN, Responsive images: https://developer.mozilla.org/en-US/docs/Web/HTML/Guides/Responsive_images
- MDN, Lazy loading: https://developer.mozilla.org/en-US/docs/Web/Performance/Lazy_loading
- MDN, prefers-reduced-motion: https://developer.mozilla.org/en-US/docs/Web/CSS/%40media/prefers-reduced-motion
- MDN, `<iframe>`: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/iframe
- MDN, `<title>`: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/title
- web.dev, Web Vitals: https://web.dev/articles/vitals
- web.dev, Optimize LCP: https://web.dev/articles/optimize-lcp
- web.dev, CLS: https://web.dev/articles/cls
- YouTube, Embedded Players and Player Parameters: https://developers.google.com/youtube/player_parameters
- YouTube, IFrame Player API Reference: https://developers.google.com/youtube/iframe_api_reference
- Chrome for Developers, PageSpeed Insights guide: https://developer.chrome.com/docs/crux/guides/pagespeed-insights
