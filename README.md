# paper

## 仕様

- 初回実行時はpdfブランチが自動で作成されます。(mdファイルが一つもなかった場合エラーで終了しブランチは作成されません。)
- theme等を変更し全てビルドしなおしたい時はpdfブランチ削除してmasterを変更すれば全てビルドしなおします。
- 初回実行時mdファイルは再帰的に検索され全て変換されます。
- 元々のmdと同一のフォルダ構造で配置します。
- pdfブランチにはpdfファイルのみを生成します。
- masterからmdファイルを削除するとpdfからも自動で削除されます。
- 変更があったmdファイルのみをビルドするようにしています。
- リネームおよび移動した場合は旧ファイル名のpdfは残ります。
- markdownlint-cli2を使用しています。pandocでは変換できてしまうような細かい文法ミスもエラーでビルドを停止します。
- 一様eisvogelのbasic-sampleでの記法はエラーがでないようにしてあります。適宜追加していきます。
- ビルド用のイメージとして作成したpandoc/extra公式イメージ+BIZ UDPMincho+markdownlint-cli2のイメージが[ここ](https://github.com/users/5ym/packages/container/package/pandoc)にあります
- eisvogelで使えるテンプレートは[ここ](https://github.com/Wandmalfarbe/pandoc-latex-template/tree/master/examples)を参照
- `./confirm.sh ファイル名`で手元で編集中のmdをpdfに変換できます。`confirm.pdf`というのが生成されます。
- その他機能追加,質問はissueでお願いします。

## 使い方

`Use this template`をクリックして新規リポジトリを作成してそこにファイルを追加していきます。

## 機能追加予定

- ビルド速度向上のためにプルしてきたdockerイメージをキャッシュしたい
