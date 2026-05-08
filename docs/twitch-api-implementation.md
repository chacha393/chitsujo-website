# Twitch API 実装メモ

更新日: 2026-05-06

## 仕組み

Twitch API は `Client Secret` を使うため、ブラウザだけで安全に実装しません。
このサイトでは次の構成にします。

1. フロント: `js/twitch-status.js`
   - `/api/twitch-status?user_login=mamorumea` を取得
   - `isLive: true` なら「配信中」とサムネイルを表示
   - `isLive: false` なら「配信中ではない」と待機表示

2. サーバー: `functions/api/twitch-status.js`
   - Twitch OAuth の Client Credentials Flow で App Access Token を取得
   - `GET https://api.twitch.tv/helix/streams?user_login=mamorumea` を呼ぶ
   - ブラウザに必要な JSON だけ返す

## デプロイ時に必要な環境変数

Cloudflare Pages Functions など、`functions/api/twitch-status.js` が動く環境で以下を設定します。

```text
TWITCH_CLIENT_ID=...
TWITCH_CLIENT_SECRET=...
TWITCH_USER_LOGIN=mamorumea
```

`TWITCH_USER_LOGIN` は省略しても、フロント側が `user_login=mamorumea` を付けて呼びます。

## ローカル確認

Wrangler はプロジェクトの dev dependency として入れます。

```bash
npm install
```

`.dev.vars.example` を参考に `.dev.vars` を作り、Twitch の値を入れます。

```text
TWITCH_CLIENT_ID=...
TWITCH_CLIENT_SECRET=...
TWITCH_USER_LOGIN=mamorumea
```

起動:

```bash
npm run dev
```

トップページ:

```text
http://127.0.0.1:8788/
```

API:

```text
http://127.0.0.1:8788/api/twitch-status?user_login=mamorumea
```

## Cloudflare Pages にデプロイ

初回だけログインします。

```bash
npx wrangler login
```

Pages の secret を設定します。

```bash
npx wrangler pages secret put TWITCH_CLIENT_ID --project-name chitsujo-website
npx wrangler pages secret put TWITCH_CLIENT_SECRET --project-name chitsujo-website
npx wrangler pages secret put TWITCH_USER_LOGIN --project-name chitsujo-website
```

デプロイ:

```bash
npm run deploy
```

## 返却 JSON

```json
{
  "isLive": true,
  "userLogin": "mamorumea",
  "title": "配信タイトル",
  "gameName": "Just Chatting",
  "viewerCount": 12,
  "startedAt": "2026-05-06T10:00:00Z",
  "thumbnailUrl": "https://static-cdn.jtvnw.net/previews-ttv/live_user_mamorumea-640x360.jpg"
}
```

未配信時は `isLive: false` で、その他の配信情報は空になります。

## 公式仕様メモ

- Twitch の `Get Streams` は、指定したユーザーが配信中なら stream object を返し、配信中でなければ `data: []` になります。
- stream object の `thumbnail_url` は `{width}` と `{height}` のテンプレートなので、フロントで使いやすいようにサーバー側で `640x360` に置き換えています。
- App Access Token は Client Credentials Flow で取得します。`Client Secret` はブラウザに置かず、必ず Functions/Worker 側だけで扱います。

参考:

- https://dev.twitch.tv/docs/api/reference/#get-streams
- https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#client-credentials-grant-flow
