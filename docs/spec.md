# 仕様

- `push` と `workflow_dispatch` で使えます (`pull_request` には対応していません)。
- `.qd` と同じフォルダ構造・同じ名前で `pdf` ブランチに PDF を置きます。変更があったものだけ変換し、消した `.qd` の PDF は消します。リネームした場合は旧名の PDF が残ります。
- `_` で始まるファイル (`_setup.qd` など) は単体では変換しません。共通設定や分割用に使います。
- 全部作り直したいときは `pdf` ブランチを消してから push します。
- `--strict` で変換するので、未定義の関数などがあれば失敗します。
- Quarkdown は `quarkdown-major` の系列の最新リリースを [setup-quarkdown](https://github.com/quarkdown-labs/setup-quarkdown) で入れ、版ごとに `actions/cache` でキャッシュします。PDF は HTML をヘッドレス Chrome で描くので LaTeX は要りません。
- 途中で `pdf` ブランチに切り替えて作業し、最後に呼び出し前のブランチ (かコミット) に戻します。この Action より前の step で作業ツリーに加えた未コミットの変更は捨てられるので、`actions/checkout` の直後に置いてください。
