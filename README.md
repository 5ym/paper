# seisho / 清書

清書。リポジトリの `.qd` を [Quarkdown](https://github.com/iamgio/quarkdown) で PDF にし、`pdf` ブランチへ置く GitHub Action。

## 使い方

```yaml
# .github/workflows/pdf.yml
on:
  push:
    branches: [master]

permissions:
  contents: write

# 続けて push したときに pdf ブランチへの push がぶつからないように
concurrency: pdf

jobs:
  pdf:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: 5ym/seisho@v1
```

| 入力 | 既定 | 内容 |
| --- | --- | --- |
| `source-branch` | push されたブランチ | `.qd` を読むブランチ |
| `pdf-branch` | `pdf` | PDF を置くブランチ。無ければ作る |
| `quarkdown-major` | `2` | この系列の最新リリースを使う |

動きの細かいところ (変換する範囲・消したときの扱い・作り直し方など) は [docs/spec.md](docs/spec.md) にまとめています。

## 書き方

共通設定を `_setup.qd` に置き、各文書の先頭で読み込みます (パスはその文書から見た相対パス)。例は [_setup.qd](_setup.qd)、記法は [sample.qd](sample.qd) と [wiki](https://quarkdown.com/wiki/) を参照。

```text
.include {_setup.qd}
```

- 日本語フォントは同梱されていないので `.font` で指定します。コード用も指定しないと、コード中の日本語が豆腐になります。
- Mermaid の図の中は日本語が出ません。ラベルは英数字で書いてください。

## 手元で確認

[インストール](https://github.com/iamgio/quarkdown#getting-started)して `quarkdown c 文書.qd -w -p --allow global-read` でライブプレビュー、`--pdf` で PDF です。`--allow global-read` は `../_setup.qd` のような親ディレクトリのファイルを読むために要ります。VS Code なら公式拡張 [Quarkdown](https://marketplace.visualstudio.com/items?itemName=quarkdown.quarkdown-vscode) に `"quarkdown.additionalCompilerOptions": "--allow global-read"` を設定します。
