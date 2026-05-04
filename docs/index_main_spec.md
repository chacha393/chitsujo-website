# index_main.html 仕様ドキュメント

## 概要
`index_main.html` は秩序めあ公式サイトのメイントップページです。プロフィール、活動先、日記、ギャラリーへのナビゲーションを提供します。

## HTML構造

### メタデータ
- **言語**: `ja` (日本語)
- **タイトル**: "秩序めあ | CHITSUJO-WEBSITE"
- **説明**: "秩序めあのプロフィールや活動先を見られるトップページです。"
- **ビューポート**: `width=device-width, initial-scale=1.0`
- **フォント**: Google Fonts (Kaisei Decol, Zen Maru Gothic)

### 装飾要素
- **page-spark**: 左上と右上のスパークル効果 (aria-hidden="true")
- **page-stars**: 背景の星飾り (aria-hidden="true")

### メイン構造
- **page-shell**: ページ全体のコンテナ
  - **site-header**: サイトヘッダー
    - **brand**: ロゴとサイト名 (秩序めあ)
    - **site-nav**: ナビゲーション (Pick Up, Diary, Profile, Links)
  - **page-main**: メインコンテンツ
    - **hero**: ヒーローセクション
    - **pickup**: Pick Upセクション
    - **feed-section**: 日記セクション
    - **link-band**: リンクバンド

## セクション詳細

### Heroセクション
- **hero__copy**: テキストコンテンツ
  - eyebrow: "CHITSUJO-WEBSITE"
  - title: "秩序めあ"
  - catch: "秩序を~乱すな~❕ﾋﾟﾋﾟｰｯ❕⚡️"
  - lead: ウェルカムメッセージ
  - actions: SNSリンクボタン (X, YouTube, Twitch, IRIAM, X Sub, TikTok)
- **hero__visual**: ビジュアルコンテンツ
  - badge: "2026.04.13 debut"
  - frame: キャラクター画像とロゴのフレーム
    - halo: 光の効果 (aria-hidden="true")
    - logo: ロゴ画像 (aria-hidden="true")
    - character: メイン立ち絵

### Pick Upセクション
- **section-head**: セクションヘッダー
  - eyebrow: "Pick Up"
  - title: "Tag / Mama"
- **pickup__grid**: カードグリッド
  - 3つのpickup-card:
    - Tag: #めあにめは (総合タグ)
    - Fanart: #めはあるか (ファンアートタグ)
    - Mama: とりうら 様 (大好きママ)

### Diaryセクション
- **section-head**: セクションヘッダー
  - eyebrow: "Diary"
  - title: "日々のこと"
  - text: "新しい日記をここから見られます。"
- **feed-grid**: 日記エントリグリッド (data-diary-list, data-diary-limit="2")
  - 初期状態: empty-card (まだ日記はありません)
- **hero__actions**: ボタン
  - "日記をまとめて見る" (diary.html へ)

### Link Bandセクション
- 3つのリンクカード:
  - Profile: profile.html
  - Gallery: gallery.html
  - BOOTH: 外部リンク (グッズショップ)

## テンプレート
- **diary-card-template**: 日記カードのHTMLテンプレート
  - diary-card: 記事コンテナ
    - media-link: 画像リンク
    - body: コンテンツ
      - entry-meta: 日付と種類
      - title: タイトル
      - text: テキスト
      - text-link: Xで見るリンク

## CSS仕様 (test4.css)

### デザイン変数
- **色**: sky-*, peach-*, ink-* カラーパレット
- **影**: shadow-xl, shadow-md
- **半径**: radius-xl, radius-lg, radius-md, radius-pill

### レイアウト
- **グリッドシステム**: pickup__grid, feed-grid
- **フレックスボックス**: hero, site-header, brand
- **レスポンシブ**: min() 関数を使用した可変サイズ

### アニメーション
- **ホバー効果**: ボタン、リンクのインタラクション
- **トランジション**: スムーズな状態変化

## JavaScript仕様

### entry-logo.js
- **目的**: 外部アクセス時のロゴ表示
- **条件**: 同一オリジンでない場合に実行
- **動作**: スプラッシュロゴを表示 (1.8秒)
- **例外**: メンテナンスページではスキップ

### protect-ui.js
- **目的**: UI保護
- **機能**:
  - 右クリック無効化
  - 画像ドラッグ無効化

### diary.js
- **目的**: 日記データの動的読み込みと表示
- **データソース**: data/diary.json
- **機能**:
  - JSONデータのフェッチ
  - エントリのソート (日付降順)
  - テンプレートを使用したDOM生成
  - エラーハンドリング
- **制限**: diary-limit="2" (最大2件表示)

## アクセシビリティ
- **ARIAラベル**: site-nav, aria-hidden 装飾要素
- **セマンティックHTML**: header, main, section, article
- **キーボードナビゲーション**: リンクとボタンのフォーカス

## パフォーマンス
- **遅延読み込み**: script defer 属性
- **キャッシュ制御**: diary.js の no-store オプション
- **最適化**: 画像の user-select, -webkit-user-drag 無効化

## 依存関係
- **CSS**: site-theme.css (共通スタイル)
- **フォント**: Google Fonts
- **データ**: data/diary.json
- **アセット**: assets/images/ (ロゴ、キャラクター、日記画像)

## 更新手順
1. 日記追加: assets/images/diary/ と data/diary.json を更新
2. 動画追加: data/videos.json を更新
3. Gitコミット: 関連ファイルのみをコミット

## 注意事項
- メンテナンスモード時は index.html を使用
- 日記データは sample エントリを除外
- 外部リンクは target="_blank" rel="noreferrer noopener"

## メンテナンスモード仕様 (index.html)

### 概要
メンテナンスページ（index.html）はサイト準備中の状態で表示されます。ロゴ表示とコンテンツ遷移のアルゴリズムを以下に記載します。

### 画面遷移アルゴリズム

#### 初期化フェーズ
1. **HTML/CSS読み込み**
   - `index.html` と `maintenance.css`, `site-theme.css` が読み込まれる
   - 初期状態設定：
     - `.splash`（ロゴオーバーレイ）：表示（opacity: 1, visibility: visible）
     - `.clouds`, `.stars`, `.card`, `.footer`：隠蔽（opacity: 0, visibility: hidden）

#### ロゴ表示フェーズ（0-1800ms）
1. **スプラッシュ表示**
   - `.splash-logo` が中央に配置されたロゴを表示
   - 背景：グラデーション（linear-gradient(135deg, #667eea 0%, #764ba2 100%)）
   - アニメーション：bounce（2秒間、translateYで跳ねる効果）

2. **コンテンツ隠蔽**
   - 他のすべてのコンテンツ要素を完全に隠す
   - `pointer-events: none` でインタラクションを無効化

#### コンテンツ表示フェーズ（1800ms以降）
1. **JavaScriptトリガー**
   - `window.addEventListener('load', ...)` が発火
   - `setTimeout(1800ms)` でタイミング制御

2. **ロゴ消去**
   - `.splash` に `.hide` クラス追加
   - opacity: 0, visibility: hidden に遷移（1.8秒）

3. **コンテンツ表示**
   - `body` に `.content-visible` クラス追加
   - `.clouds`, `.stars`, `.card`, `.footer` がフェードイン
   - `pointer-events: auto` でインタラクション有効化

#### 最終状態
- スプラッシュが完全に消滅
- すべてのコンテンツが表示され、操作可能
- ページが完全にインタラクティブになる

### 技術仕様

#### CSSクラス
- `.splash`: ロゴオーバーレイコンテナ
- `.splash-logo`: ロゴ画像（bounceアニメーション適用）
- `.splash.hide`: ロゴ消去状態
- `.content-visible`: コンテンツ表示トリガー
- `.clouds`, `.stars`, `.card`, `.footer`: メインコンテンツ要素

#### JavaScriptアルゴリズム
```javascript
window.addEventListener('load', function() {
  setTimeout(function() {
    document.getElementById('splash').classList.add('hide');
    document.body.classList.add('content-visible');
  }, 1800);
});
```

#### アニメーション仕様
- **bounce**: 
  - 期間: 2秒
  - 繰り返し: 無限
  - 効果: translateY(-30px) → translateY(-15px) → translateY(0)
- **fadeIn**:
  - 期間: 1.8秒
  - 効果: opacity 0 → 1

#### 外部アクセス時の動作
- `entry-logo.js` は `.splash` 要素が存在する場合、実行をスキップ
- メンテナンスページではロゴ表示が優先され、重複表示を防ぐ

### パフォーマンス考慮
- 初期ロード時にコンテンツを隠すことで、FOUC（Flash of Unstyled Content）を防止
- ロゴ表示中にページコンテンツが一瞬見えないよう制御
- フェードインでスムーズな遷移を実現