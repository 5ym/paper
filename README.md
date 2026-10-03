# seisho / 清書

清書。リポジトリの `.qd` を [Quarkdown](https://github.com/iamgio/quarkdown) で PDF にし、同じブランチの `pdf/` フォルダ (と、指定すれば OneDrive などの送り先) に置く GitHub Action。

## 使い方

```yaml
# .github/workflows/pdf.yml
on:
  push:
    branches: [main]

permissions:
  contents: write

# 続けて push したときに PDF のコミットがぶつからないように
concurrency: pdf

jobs:
  pdf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: 5ym/seisho@v2
```

| 入力 | 既定 | 内容 |
| --- | --- | --- |
| `output-dir` | `pdf` | PDF を置くフォルダ。`.qd` と同じフォルダ構造でこの下に置き、コミットして push する |
| `default-setup` | `true` | 既定の設定 ([_setup.qd](_setup.qd)) を各文書の先頭に足す |
| `rclone-config` | | `rclone.conf` の中身。`rclone-remote` と一緒に指定すると、そこへも PDF を送る |
| `rclone-remote` | | PDF を送る先 (例 `onedrive:Documents/report`) |
| `quarkdown-major` | `2` | この系列の最新リリースを使う |

動きの細かいところは [docs/spec.md](docs/spec.md) にまとめています。

## 書き方

`.qd` をそのまま書けば、A4・日本語・BIZ UDP明朝などの既定の設定 ([_setup.qd](_setup.qd)) が先頭に足されて PDF になります。変えたいところだけ文書の中で同じ関数を呼べば上書きできます (後に書いたほうが効きます)。記法は [sample.qd](sample.qd) と [wiki](https://quarkdown.com/wiki/) を参照。

- 日本語フォントは同梱されていないので `.font` で指定しています。コード用も指定しないと、コード中の日本語が豆腐になります。
- Mermaid の図の中は日本語が出ません。ラベルは英数字で書いてください。

## OneDrive などにも置く

送り先は [rclone](https://rclone.org/) の設定で決めます (OneDrive・Google Drive・Dropbox・S3 など)。

1. 手元で `rclone config` を実行し、送り先 (例 `onedrive`) を作る。ブラウザでのログインが求められます
2. できた設定 (`rclone config file` で場所が出ます) をリポジトリの secret にする: `gh secret set RCLONE_CONFIG < ~/.config/rclone/rclone.conf`
3. ワークフローに足す:

```yaml
      - uses: 5ym/seisho@v2
        with:
          rclone-config: ${{ secrets.RCLONE_CONFIG }}
          rclone-remote: onedrive:Documents/report
```

OneDrive のログインは、使わないまま 90 日ほど経つと切れます。切れたら手元で `rclone config reconnect onedrive:` をして、secret を入れ直してください。

## 手元で確認

[インストール](https://github.com/iamgio/quarkdown#getting-started)して `quarkdown c 文書.qd -w -p --allow global-read` でライブプレビュー、`--pdf` で PDF です。手元では既定の設定が足されないので、同じ見た目で確かめたいときは文書の先頭に [_setup.qd](_setup.qd) の中身を写すか `.include` してください。VS Code なら公式拡張 [Quarkdown](https://marketplace.visualstudio.com/items?itemName=quarkdown.quarkdown-vscode) に `"quarkdown.additionalCompilerOptions": "--allow global-read"` を設定します。

## v1 から移る

v1 は `pdf` ブランチに置いていました。`5ym/seisho@v2` に変え、入力の `pdf-branch`・`source-branch` を外して push すると、最初の実行で全ての PDF を `pdf/` に作ります。`pdf` ブランチは要らなくなるので消してください。
