# デプロイ運用

## 構成

- ホスティング: Cloudflare Workers Static Assets
- Worker 名: `hitbox-maker`
- 公開ディレクトリ: `public/`
- 本番URL: `https://hitbox.nya3neko2.dev/`
- Workers URL: `https://hitbox-maker.takahashinaoki521.workers.dev/`
- Git連携: `nyanko3141592/hitbox-maker` の `main`

`wrangler.jsonc` の `assets.directory` は `./public` です。公開すべきファイルは必ずこのディレクトリに置きます。

## デプロイ方法

通常は `main` への push により Workers Builds が `npx wrangler deploy` を実行します。手動デプロイが必要な場合のみ、リポジトリ直下で以下を実行します。

```bash
npx wrangler deploy
```

手動デプロイとWorkers Buildsを同時に走らせると、完了順によって一時的に異なるバージョンが配信されることがあります。緊急修正では、push後にWorkers Buildsの完了を待ってから手動デプロイし、両方のURLを検証します。

```bash
bash scripts/verify-deployment.sh https://hitbox.nya3neko2.dev
bash scripts/verify-deployment.sh https://hitbox-maker.takahashinaoki521.workers.dev
```

## Service Workerを変更するとき

`public/sw.js` の `CACHE_NAME` を更新します。古いキャッシュはactivate時に削除され、HTML側は`updateViaCache: 'none'`でService Workerの更新を確認します。

反映確認では通常のHTTP 200だけでなく、次も確認します。

- 本番HTMLに新しい実装を識別できる文字列が含まれる
- `/sw.js` が新しい`CACHE_NAME`を返す
- WebPが`Content-Type: image/webp`で配信される

Cloudflareのエッジが直前のアセットを返す場合は、`Cache-Control: no-cache`を付けて再検証します。

## OGPを変更するとき

`public/index.html` の以下を同じ本番オリジンに保ちます。

- `link[rel=canonical]`
- `og:url`
- `og:image`
- `twitter:image`

ドメインを変更した場合は、上記URLを更新してから `bash scripts/verify-deployment.sh <URL>` を実行します。
