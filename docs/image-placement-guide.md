# 画像配置ガイド

この文書は、「どの画像をどこに置くか」をすぐ判断できるようにするための案内です。

## 1. これだけ見ればOK

| 置きたい画像 | 置き場所 | 使い方 |
| --- | --- | --- |
| ロゴ | `assets/images/ui/logo/logo.png` | 同じファイル名で差し替えると、ロゴ表示に反映しやすい |
| ミニキャラ | `assets/images/character/mini/mini-character.png` | 同じファイル名で差し替えると、ミニキャラ表示に反映しやすい |
| 立ち絵の本体 | `assets/images/character/main/base/` | 内部管理用。必要になったらページ側で参照する |
| 衣装差分の立ち絵 | `assets/images/character/main/costumes/` | 内部管理用。本体と分けて保管する |
| 表情差分 | `assets/images/character/expressions/` | 内部管理用。差分管理に使う |
| 日記画像 | `assets/images/diary/` | `data/diary.json` にも1件追加する |
| 描いていただいた作品 | `assets/images/gallery/inbox/` | まずここに入れる。あとで内部整理する |
| アイコン | `assets/images/ui/icons/` | ボタンや装飾用に使う |
| 背景画像 | `assets/images/ui/backgrounds/` | 背景やセクション演出に使う |
| OGP用画像 | `assets/images/ogp/` | 将来必要になったら使う |

## 2. 置くだけで反映しやすい画像

- ロゴは `assets/images/ui/logo/logo.png` を差し替えると、トップやプロフィールなどで使っている表示に反映しやすい
- ミニキャラは `assets/images/character/mini/mini-character.png` を差し替えると、現在のページで使っている表示に反映しやすい

## 3. 置いただけでは公開ページに出ない画像

- `assets/images/character/main/base/` の立ち絵本体は、今は内部管理用
- `assets/images/character/main/costumes/` の衣装差分も、今は内部管理用
- `assets/images/character/expressions/` の表情差分も、今は内部管理用
- `assets/images/gallery/inbox/` に入れた作品は、保管先としては正しいが、ページへの反映はあとで整理する
- `assets/images/ogp/` は今の時点では未使用

## 4. 迷ったときのルール

- 立ち絵の本体なら `assets/images/character/main/base/`
- 立ち絵の衣装違いなら `assets/images/character/main/costumes/`
- 小さいキャラ画像なら `assets/images/character/mini/`
- 表情差分なら `assets/images/character/expressions/`
- 描いていただいた作品なら、まず `assets/images/gallery/inbox/`
- 日記に使う画像なら `assets/images/diary/`

## 5. ギャラリー画像の考え方

- 公開ページでは、当面「描いていただいた作品」としてまとめて見せる
- 内部では必要に応じて `特にお気に入り` と `そのほか` に分けてよい
- 依頼絵、寄付絵、ファンアートの整理も内部では分けてよい
- 迷ったら最初は `assets/images/gallery/inbox/` に入れておけばよい

## 6. 日記画像の使い方

- 画像ファイルは `assets/images/diary/` に置く
- 置くだけでは表示されないので、`data/diary.json` にも1件追加する
- 更新手順は `docs/update-guide.md` を見る

## 7. おすすめのファイル名

- 英数字とハイフン中心にする
- 空白はできるだけ使わない
- 何の画像か分かる名前にする

例:

- `standing-main.png`
- `standing-costume-summer.png`
- `expression-smile.png`
- `diary-2026-04-01-01.jpg`
- `commission-artistname-01.png`

## 8. 今の運用で大事なこと

- 今すぐ公開に出したい画像と、内部保管だけの画像は分けて考える
- 置き場所が分からない作品画像は、まず `assets/images/gallery/inbox/` に入れる
- 立ち絵は `base/` を本体、`costumes/` を差分として固定すると迷いにくい
- 後からこちらで整理できるので、最初から完璧に分類しなくてよい
