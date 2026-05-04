# Update Guide

このガイドは、将来的に以下の運用でサイトを更新する前提のメモです。

- 日記画像: `assets/images/diary/` に追加
- 日記データ: `data/diary.json` に追加
- 動画データ: `data/videos.json` に追加

目的は、`半自動で画像やYouTube動画を載せる運用` を、毎回同じ手順で安全に更新できるようにすることです。

## 基本の流れ

### 日記画像を追加するとき

1. X に投稿する
2. 同じ画像を `assets/images/diary/` に入れる
3. `data/diary.json` に1件追加する
4. `git` で今回の変更だけをコミットする

### YouTube 動画を追加するとき

1. 載せたい動画URLを確認する
2. `data/videos.json` に1件追加する
3. `git` で今回の変更だけをコミットする

## Git の基本手順

### 日記だけ更新したとき

```powershell
git status
git add assets/images/diary data/diary.json
git commit -m "Add diary entry"
git push
```

### 動画だけ更新したとき

```powershell
git status
git add data/videos.json
git commit -m "Update video entries"
git push
```

### 日記と動画を両方更新したとき

```powershell
git status
git add assets/images/diary data/diary.json data/videos.json
git commit -m "Update diary and video entries"
git push
```

## 日付入りで残したいとき

コミットメッセージを日付付きにすると、あとから見返しやすくなります。

```powershell
git commit -m "Add diary entry for 2026-03-31"
```

```powershell
git commit -m "Update diary and video entries for 2026-03-31"
```

## 安全に運用するコツ

- `git add .` はできるだけ使わない
- 今回更新したファイルだけを `git add` する
- 毎回 `git status` で確認してからコミットする
- 1回の更新を1コミットにまとめる

## おすすめの確認ポイント

コミット前に、最低限これだけ見ると安全です。

- 追加した画像ファイル名が合っているか
- `data/diary.json` の追記位置がおかしくないか
- `data/videos.json` のURLが正しいか
- `git status` に関係ないファイルが混ざっていないか

## 迷ったときの最小手順

更新内容に迷ったら、まずはこの4つだけで大丈夫です。

```powershell
git status
git add assets/images/diary data/diary.json data/videos.json
git commit -m "Update site content"
git push
```

## 補足

- `push` するとリモートにも反映されます
- まだ公開したくない段階なら、`commit` だけして `push` はあとでも大丈夫です
- 大きく崩したくないときは、作業前にチェックポイントとして1コミット作っておくのも有効です
