# Hitbox Maker（判定メーカー）

画像を入れるだけで、格ゲー風の当たり判定が付く Web ツール。AIがブラウザ内でキャラを抜き出して食らい判定（青）を自動生成し、攻撃（赤）/ 投げ（紫）/ 押し合い（緑）は手描きで足せる。合成PNGの保存・コピー・共有に対応。

画像の解析はすべて端末内（WASM）で完結し、サーバーには一切送信されない。

## 使い方

1. トップ画面に画像をドロップ（タップ選択 / ⌘V ペーストも可）
2. AIが自動でキャラを抽出し、食らい判定ボックスを生成（「判定付与!!」）
3. 必要なら手描きで判定を追加・調整（ドラッグ=新規、角ハンドル=リサイズ、`1`〜`4`=タイプ切替、`⌘Z`=取り消し）
4. 「保存」「コピー」「共有」（モバイル）で書き出し

## 仕組み

- 被写体抽出: [@imgly/background-removal](https://github.com/imgly/background-removal-js)（isnet系モデル、初回のみダウンロードしブラウザにキャッシュ）
- 抽出マスクは最大連結成分のみ使用（飛び地除去）
- ボックス化: マスクの残余領域から最大面積の内接矩形を貪欲に切り出し（ヒストグラム法）
- 同タイプの重なり矩形は結合し、歪な一体シルエットとして描画

## 開発

ビルド不要の静的サイト（`index.html` 1枚）。ローカル確認は:

```bash
python3 -m http.server 8000
```

## デプロイ (Cloudflare Pages)

- ダッシュボードでこのリポジトリを接続し、Build command なし / Output directory `/` で設定
- または `npx wrangler pages deploy . --project-name=hitbox-maker`
- デプロイ先のドメインが変わる場合は `index.html` の `og:image` / `og:url` を書き換えること

## ライセンス

このプロジェクトは **GNU AGPL-3.0** で公開されている。[LICENSE](./LICENSE) を参照。

依存ライブラリ・アセット:

| 依存 | ライセンス | 備考 |
|---|---|---|
| [@imgly/background-removal](https://github.com/imgly/background-removal-js) | AGPL-3.0 | CDN (jsdelivr) から動的import。本プロジェクトのAGPL採用の理由 |
| isnet (DIS) モデル | Apache-2.0 | imglyパッケージ経由で取得 |
| `samples/*.jpg` | 本プロジェクトの作例 | 本ツールで生成したサンプル出力 |
