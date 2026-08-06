# HITBOX SNAP

画像を入れるだけで、格ゲー風の当たり判定が付く Web ツール。端末内AIで被写体を高精度に抽出して食らい判定（青）を自動生成する。攻撃（赤）/ 投げ（紫）/ 押し合い（緑）の手描き追加、背景変更、合成PNGの保存・コピー・共有に対応。

画像の解析はすべて端末内（WASM）で完結し、サーバーには一切送信されない。
初回に約42MBの軽量QUINT8モデルを取得し、PCではWebGPU優先、スマホでは安定性を優先してCPU/WASMで必ず被写体を抽出する。モデルはブラウザにキャッシュされる。モバイルの抽出でメモリが不足した場合は、キュピーン猫（InspirationCat）と同様に1024→768→512pxへ段階的に縮小して再試行する。処理中はダウンロード・推論の進捗率を表示する。スマホのドラッグ描画はフレーム単位でまとめ、元画像と背景の合成結果をキャッシュする。

## 使い方

1. トップ画面に画像をドロップ（タップ選択 / ⌘V ペーストも可）
2. 端末内AIが被写体を抽出し、輪郭に沿った食らい判定ボックスを生成（「判定付与!!」）
3. 必要なら手描きで判定を追加・調整（ドラッグ=新規、角ハンドル=リサイズ、`1`〜`4`=タイプ切替、`⌘Z`=取り消し）
4. 「保存」「コピー」「共有」（モバイル）で書き出し
5. 投稿文をコピーするかX共有を使い、`#HITBOXSNAP` で作品を公開

## 仕組み

- 被写体抽出: [@imgly/background-removal](https://github.com/imgly/background-removal-js)（isnet系モデル、初回のみダウンロードしブラウザにキャッシュ）
- 抽出マスクは最大連結成分のみ使用（飛び地除去）
- ボックス化: マスクの残余領域から最大面積の内接矩形を貪欲に切り出し（ヒストグラム法）
- 同タイプの重なり矩形は結合し、歪な一体シルエットとして描画

## 開発

ビルド不要の静的サイトです。公開対象は `public/` 配下に限定しています。

```text
public/
├── index.html
├── apple-touch-icon.png
├── manifest.webmanifest
├── sw.js
└── samples/
```

ローカル確認は:

```bash
python3 -m http.server 8000 --directory public
```

## デプロイ (Cloudflare Workers)

Cloudflare Workers の静的アセット配信を使用します。`wrangler.jsonc` は `public/` のみを配信対象にしており、Git メタデータや運用ドキュメントは公開されません。

```bash
npx wrangler deploy
```

本番は Workers Builds で GitHub の `main` ブランチと連携済みです。以後は `main` への push で自動デプロイされます。詳細は [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) を参照してください。

公開URL: [https://hitbox.nya3neko2.dev/](https://hitbox.nya3neko2.dev/)

SEO・OGPの運用は [docs/SEO.md](docs/SEO.md) を参照してください。

作品共有から改善提案へつなげるUGC導線は [docs/UGC.md](docs/UGC.md) にまとめています。

## 本番確認

```bash
bash scripts/verify-deployment.sh
```

別の環境を確認する場合はURLを指定します。

```bash
bash scripts/verify-deployment.sh https://example.workers.dev
```

## ライセンス

このプロジェクトは **GNU AGPL-3.0** で公開されている。[LICENSE](./LICENSE) を参照。

依存ライブラリ・アセット:

| 依存 | ライセンス | 備考 |
|---|---|---|
| [@imgly/background-removal](https://github.com/imgly/background-removal-js) | AGPL-3.0 | CDN (jsdelivr) から動的import。本プロジェクトのAGPL採用の理由 |
| isnet (DIS) モデル | Apache-2.0 | imglyパッケージ経由で取得 |
| `samples/*.jpg` | 本プロジェクトの作例 | 本ツールで生成したサンプル出力 |
