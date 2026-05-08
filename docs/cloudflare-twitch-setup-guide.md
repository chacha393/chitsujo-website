# Cloudflare + Twitch API 手順書

更新日: 2026-05-06

この手順書は、Topページで Twitch の「配信中 / 配信中ではない」を表示し、配信中ならサムネイルを出すためのものです。

## 結論: あなたがやること

やることはこの5つです。

1. Twitch Developer Consoleでアプリを作る
2. `Client ID` と `Client Secret` を取得する
3. Cloudflareにログインする
4. Cloudflare Pagesに3つの環境変数を登録する
5. デプロイする

`Client Secret` は秘密情報です。チャットや公開ファイルには貼らず、Cloudflareの環境変数かローカルの `.dev.vars` だけに入れてください。

## 事前準備

このプロジェクト側は準備済みです。

- Wrangler インストール済み
- Cloudflare Pages Functions 実装済み
- TopページのTwitch配信カード実装済み
- デプロイ用コマンド追加済み
- 公開トップは `index.html`

使う主なファイル:

- `index.html`
- `js/twitch-status.js`
- `functions/api/twitch-status.js`
- `package.json`
- `wrangler.toml`

## 1. Twitchアプリを作る

1. Twitch Developer Consoleを開く  
   https://dev.twitch.tv/console/apps

2. Twitchアカウントでログインする

3. `Applications` タブを開く

4. `Register Your Application` を押す

5. 入力する

```text
Name: chitsujo-website
OAuth Redirect URL: http://localhost
Category: Website Integration
```

6. 作成後、アプリ詳細画面で `Client ID` を控える

7. `New Secret` か `Manage` から `Client Secret` を作成して控える

注意:

- `Client Secret` は再生成すると古いものが使えなくなります。
- `Client Secret` は公開しないでください。

## 2. ローカルで試す場合

ローカル確認をしたい場合だけ行います。Cloudflareに直接デプロイするだけなら飛ばしても大丈夫です。

1. `.dev.vars.example` をコピーして `.dev.vars` を作る

PowerShell:

```powershell
Copy-Item .dev.vars.example .dev.vars
```

2. `.dev.vars` を開いて、Twitchの値を入れる

```text
TWITCH_CLIENT_ID=ここにClient ID
TWITCH_CLIENT_SECRET=ここにClient Secret
TWITCH_USER_LOGIN=mamorumea
```

3. ローカルサーバーを起動する

PowerShellでは `npm` ではなく `npm.cmd` を使うと安全です。

```powershell
npm.cmd run dev
```

4. ブラウザで開く

```text
http://127.0.0.1:8788/
```

5. APIだけ確認したい場合

```text
http://127.0.0.1:8788/api/twitch-status?user_login=mamorumea
```

成功すると、未配信時はだいたいこのようなJSONになります。

```json
{
  "isLive": false,
  "userLogin": "mamorumea",
  "title": "",
  "gameName": "",
  "viewerCount": null,
  "startedAt": "",
  "thumbnailUrl": ""
}
```

## 3. Cloudflareにログインする

1. Cloudflareアカウントを作る、またはログインする  
   https://dash.cloudflare.com/

2. ターミナルでログインする

```powershell
npx.cmd wrangler login
```

3. ブラウザが開いたら、Cloudflare側で許可する

## 4. Cloudflare Pagesに環境変数を登録する

以下を1つずつ実行します。

```powershell
npx.cmd wrangler pages secret put TWITCH_CLIENT_ID --project-name chitsujo-website
npx.cmd wrangler pages secret put TWITCH_CLIENT_SECRET --project-name chitsujo-website
npx.cmd wrangler pages secret put TWITCH_USER_LOGIN --project-name chitsujo-website
```

それぞれ入力を求められたら、値を入れます。

```text
TWITCH_CLIENT_ID: TwitchのClient ID
TWITCH_CLIENT_SECRET: TwitchのClient Secret
TWITCH_USER_LOGIN: mamorumea
```

## 5. デプロイする

```powershell
npm.cmd run deploy
```

成功すると、Cloudflare PagesのURLが表示されます。

表示されたURLを開いて、Topページを確認してください。

## 6. 確認ポイント

Topページで確認すること:

- `https://5-omochi-5.com/` または Cloudflare Pages の `/` でTopページが開く
- `配信リンク` セクションが表示されている
- IRIAMカードに「アプリで見に来て確認してね」と出ている
- Twitchカードが「配信中」または「配信中ではない」になる
- 配信中のとき、Twitchサムネイルが表示される
- Twitchボタンから `https://www.twitch.tv/mamorumea` に飛べる

APIで確認する場合:

```text
https://あなたのCloudflare Pages URL/api/twitch-status?user_login=mamorumea
```

## 7. よくあるエラー

### Twitchカードが「確認できません」になる

原因候補:

- Cloudflareに環境変数が入っていない
- `TWITCH_CLIENT_SECRET` が間違っている
- Twitch側でSecretを再生成した
- Cloudflareにデプロイし直していない

対応:

1. Cloudflareの環境変数を確認
2. `TWITCH_CLIENT_ID` と `TWITCH_CLIENT_SECRET` を入れ直す
3. もう一度デプロイ

```powershell
npm.cmd run deploy
```

### `npm` がPowerShellで動かない

このエラーが出ることがあります。

```text
npm.ps1 cannot be loaded because running scripts is disabled
```

その場合は `npm` ではなく `npm.cmd` を使います。

```powershell
npm.cmd run build
npm.cmd run dev
npm.cmd run deploy
```

### GitHub PagesではAPIが動かない

GitHub Pagesは静的ファイルだけなので、`/api/twitch-status` は動きません。

Twitch API連携を使う場合は、Cloudflare Pages Functionsなどのサーバー機能が必要です。

## 8. 公式リンク

- Twitchアプリ登録  
  https://dev.twitch.tv/docs/authentication/register-app

- Twitch OAuth / Client Credentials Flow  
  https://dev.twitch.tv/docs/authentication/getting-tokens-oauth/#client-credentials-grant-flow

- Twitch Get Streams API  
  https://dev.twitch.tv/docs/api/reference/#get-streams

- Cloudflare Pages  
  https://developers.cloudflare.com/pages/

- Cloudflare Pages Direct Upload / Wrangler deploy  
  https://developers.cloudflare.com/pages/get-started/direct-upload/

- Cloudflare Pages Functions bindings / secrets  
  https://developers.cloudflare.com/pages/functions/bindings/
