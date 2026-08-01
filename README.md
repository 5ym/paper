# paper

[Quarkdown](https://github.com/iamgio/quarkdown)でqd/mdファイルをpdfに変換します。

## 仕様

- 初回実行時はpdfブランチが自動で作成されます。(qd/mdファイルが一つもなかった場合エラーで終了しブランチは作成されません。)
- theme等を変更し全てビルドしなおしたい時はpdfブランチ削除してmasterを変更すれば全てビルドしなおします。
- 初回実行時qd/mdファイルは再帰的に検索され全て変換されます。
- 元々のファイルと同一のフォルダ構造で配置します。
- pdfブランチにはpdfファイルのみを生成します。
- masterからqd/mdファイルを削除するとpdfからも自動で削除されます。
- 変更があったファイルのみをビルドするようにしています。
- リネームおよび移動した場合は旧ファイル名のpdfは残ります。
- `_`で始まるファイル(`_setup.qd`など)は単体では変換されません。`.include`で読み込む共通設定や分割用のファイルはこの名前にしてください。
- テーマ・用紙・フォントなどの共通設定は[_setup.qd](_setup.qd)にまとめてあります。ビルド時に[build.sh](build.sh)が各ファイルの先頭に自動で連結するので、文書ごとにフォント等を書く必要はありません。文書側で同じ関数を呼べばその文書だけ上書きできます。
  - `_setup.qd`の行数分だけエラーメッセージの行番号がずれます。
- mdファイルもそのまま変換できます。(内部的にはmd→qd→pdfで、先頭のYAMLフロントマターは読み飛ばします)
  - 数式はQuarkdownの記法(`$ x $`のように前後に空白)のみ対応です。`\begin{equation}`やスペースなしの`$x$`はそのまま文字として出ます。
- `--strict`を付けているので、未定義の関数呼び出しなど変換時のエラーがあればビルドを停止します。
- ビルド用のイメージとしてQuarkdown公式イメージ[`ghcr.io/iamgio/quarkdown:2`](https://github.com/iamgio/quarkdown/pkgs/container/quarkdown)を使用しています。PDF出力に必要なPuppeteerが同梱されています。
- PDFはHTMLをヘッドレスChromeで描画したものなのでLaTeXは不要です。
- 文書の設定はファイル先頭の関数呼び出しで書きます。詳しくは[sample.qd](sample.qd)と[wiki](https://quarkdown.com/wiki/)を参照。
  - 種別: `.doctype {paged}` ([document types](https://quarkdown.com/wiki/document-types/))
  - 用紙: `.pageformat size:{A4} margin:{2cm}` ([page format](https://quarkdown.com/wiki/page-format/))
  - テーマ: `.theme {paperwhite} layout:{latex}` ([themes](https://quarkdown.com/wiki/themes/))
  - フォント: `.font {GoogleFonts:BIZ UDPMincho}` ([font configuration](https://quarkdown.com/wiki/font-configuration/))
- 日本語フォントはイメージに同梱されていないため、Google Fontsかリポジトリ内のフォントファイルを指定します。既定では`_setup.qd`でBIZ UDPMinchoを指定しています。
- `./confirm.sh ファイル名`で手元で編集中のファイルをpdfに変換できます。`confirm.pdf`というのが生成されます。(dockerが必要です)
- その他機能追加,質問はissueでお願いします。

## 使い方

`Use this template`をクリックして新規リポジトリを作成してそこに`.qd`または`.md`ファイルを追加していきます。

## 機能追加予定

- ビルド速度向上のためにプルしてきたdockerイメージをキャッシュしたい
