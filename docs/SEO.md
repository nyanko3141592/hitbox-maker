# SEO運用

## 実装済みの基礎設定

- 日本語ページを示す `lang="ja"`、固有の title と description
- canonical URL、Open Graph、X Card
- `WebApplication` の JSON-LD 構造化データ
- クロールを許可する `robots.txt`
- 本番URLだけを掲載する `sitemap.xml`

検索エンジンは構造化データの表示を保証しません。内容と異なる情報を記載せず、画面に表示される内容とメタデータを一致させます。

## 本番URLを変える場合

次のファイル内のURLを新しい正規URLへ同時に更新します。

- `public/index.html`: canonical、OGP、X Card、JSON-LD
- `public/robots.txt`: Sitemap URL
- `public/sitemap.xml`: `<loc>`

更新後に `bash scripts/verify-deployment.sh <URL>` を実行します。

## 公開後の作業

Google Search Console に本番URLをプロパティとして追加し、`https://hitbox-maker.takahashinaoki521.workers.dev/sitemap.xml` を送信します。インデックス状況は Search Console のURL検査で確認します。
