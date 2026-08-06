# デプロイ運用

## 構成

- ホスティング: Cloudflare Workers Static Assets
- Worker 名: `hitbox-maker`
- 公開ディレクトリ: `public/`
- 本番URL: `https://hitbox.nya3neko2.dev/`
- Git連携: `nyanko3141592/hitbox-maker` の `main`

`wrangler.jsonc` の `assets.directory` は `./public` です。公開すべきファイルは必ずこのディレクトリに置きます。

## デプロイ方法

通常は `main` への push により Workers Builds が `npx wrangler deploy` を実行します。手動デプロイが必要な場合のみ、リポジトリ直下で以下を実行します。

```bash
npx wrangler deploy
```

## OGPを変更するとき

`public/index.html` の以下を同じ本番オリジンに保ちます。

- `link[rel=canonical]`
- `og:url`
- `og:image`
- `twitter:image`

ドメインを変更した場合は、上記URLを更新してから `bash scripts/verify-deployment.sh <URL>` を実行します。
