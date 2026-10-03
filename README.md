# paper

リポジトリの `.qd` を [Quarkdown](https://github.com/iamgio/quarkdown) で PDF にし、`pdf` ブランチへ置く GitHub Action。

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
      - uses: 5ym/paper@v1
```

| 入力 | 既定 | 内容 |
| --- | --- | --- |
| `source-branch` | push されたブランチ | `.qd` を読むブランチ |
| `pdf-branch` | `pdf` | PDF を置くブランチ。無ければ作る |
| `quarkdown-major` | `2` | この系列の最新リリースを使う |

- `push` と `workflow_dispatch` で使えます (`pull_request` には対応していません)。
- `.qd` と同じフォルダ構造・同じ名前で `pdf` ブランチに PDF を置きます。変更があったものだけ変換し、消した `.qd` の PDF は消します。リネームした場合は旧名の PDF が残ります。
- `_` で始まるファイル (`_setup.qd` など) は単体では変換しません。共通設定や分割用に使います。
- 全部作り直したいときは `pdf` ブランチを消してから push します。
- `--strict` で変換するので、未定義の関数などがあれば失敗します。

## 書き方

共通設定を `_setup.qd` に置き、各文書の先頭で読み込みます (パスはその文書から見た相対パス)。例は [_setup.qd](_setup.qd)、記法は [sample.qd](sample.qd) と [wiki](https://quarkdown.com/wiki/) を参照。

```text
.include {_setup.qd}
```

- 日本語フォントは同梱されていないので `.font` で指定します。コード用も指定しないと、コード中の日本語が豆腐になります。
- Mermaid の図の中は日本語が出ません。ラベルは英数字で書いてください。

## 手元で確認

[インストール](https://github.com/iamgio/quarkdown#getting-started)して `quarkdown c 文書.qd -w -p --allow global-read` でライブプレビュー、`--pdf` で PDF です。`--allow global-read` は `../_setup.qd` のような親ディレクトリのファイルを読むために要ります。VS Code なら公式拡張 [Quarkdown](https://marketplace.visualstudio.com/items?itemName=quarkdown.quarkdown-vscode) に `"quarkdown.additionalCompilerOptions": "--allow global-read"` を設定します。

## md から移す

対象のリポジトリの中で [md-to-qd.sh](md-to-qd.sh) を一度実行すると (`sh path/to/md-to-qd.sh`)、全ての `.md` (README.md 以外) を `.qd` にします。先頭の YAML フロントマターを取り、`.include {_setup.qd}` を足し、元の `.md` は消します。
