# 仕様

- `push` と `workflow_dispatch` で、ブランチに乗った状態で使えます (`pull_request` には対応していません)。PDF は呼ばれたブランチにコミットして push します。GITHUB_TOKEN で push したコミットは次のワークフローを起動しないので、変換がくり返されることはありません。
- `.qd` と同じフォルダ構造・同じ名前で `output-dir` (既定 `pdf`) の下に PDF を置きます。
- 前回変換したコミットを `<output-dir>/.seisho` に記録し、そこからの差分だけを変換します。消した `.qd` の PDF は消し、リネームは消して作り直します。全部作り直したいときは `.seisho` (かフォルダごと) を消して push します。差分を取るため、浅い clone なら履歴を取り直します。
- `_` で始まるファイルは単体では変換しません。`.include` で読み込む分割用のファイルに使います。
- `default-setup` が `true` (既定) のときは、[_setup.qd](../_setup.qd) を先頭に足した写しを同じフォルダに `.seisho.<名前>.qd` として作って変換し、終わったら消します。相対パスはそのまま使えます。先頭に 5 行足すので、`--strict` のエラーの行番号はそのぶんずれます。
- `--strict` で変換するので、未定義の関数などがあれば失敗します。
- `rclone-config` と `rclone-remote` を指定すると、変換した PDF を送り先にも同じフォルダ構造で送り、消した `.qd` の PDF は送り先からも消します。送り先にある他のファイルには触りません。送るのはコミットより先で、送れなかったときはジョブを失敗させて `.seisho` を進めないので、次の実行でまた送ります。
- Quarkdown は `quarkdown-major` の系列の最新リリースを [setup-quarkdown](https://github.com/quarkdown-labs/setup-quarkdown) で入れ、版ごとに `actions/cache` でキャッシュします。PDF は HTML をヘッドレス Chrome で描くので LaTeX は要りません。
