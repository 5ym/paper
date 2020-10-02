# paper

アプロードしたmarkdownがdocxに自動で変換されてdocxブランチに配置されます。

## 仕様

- 初回実行時はdocxブランチが自動で作成されます。(mdファイルが一つもなかった場合エラーで終了しブランチは作成されません。)
- mdファイルは再帰的に検索され全て変換されます。
- 元々のmdと同一のフォルダ構造で配置します。
- masterからmdファイルを削除するとdocxからも自動で削除されます。
- 変更があったmdファイルのみをビルドするようにしています。
- リネームおよび移動した場合は旧ファイル名のdocxは残ります。
- markdownlint-cli2を使用しています。pandocでは変換できてしまうような細かい文法ミスもエラーでビルドを停止します。
