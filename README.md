# paper

[Quarkdown](https://github.com/iamgio/quarkdown)でqdファイルをpdfに変換します。

## 仕様

- 初回実行時はpdfブランチが自動で作成されます。(qdファイルが一つもなかった場合エラーで終了しブランチは作成されません。)
- theme等を変更し全てビルドしなおしたい時はpdfブランチ削除してmasterを変更すれば全てビルドしなおします。
- 初回実行時qdファイルは再帰的に検索され全て変換されます。
- 元々のqdと同一のフォルダ構造で配置します。
- pdfブランチにはpdfファイルのみを生成します。
- masterからqdファイルを削除するとpdfからも自動で削除されます。
- 変更があったqdファイルのみをビルドするようにしています。
- リネームおよび移動した場合は旧ファイル名のpdfは残ります。
- `_`で始まるファイル(`_setup.qd`など)は単体では変換されません。`.include`で読み込む共通設定や分割用のファイルはこの名前にしてください。
- テーマ・用紙・フォントなどの共通設定は[_setup.qd](_setup.qd)にまとめてあります。各文書の先頭で`.include {_setup.qd}`と書けばそのまま適用されるので、文書ごとにフォント等を指定する必要はありません。(サブフォルダからは`.include {../_setup.qd}`)
- `--strict`を付けているので、未定義の関数呼び出しなど変換時のエラーがあればビルドを停止します。
- ビルド用のイメージとしてQuarkdown公式イメージ[`ghcr.io/iamgio/quarkdown:2`](https://github.com/iamgio/quarkdown/pkgs/container/quarkdown)を使用しています。PDF出力に必要なPuppeteerが同梱されています。
- PDFはHTMLをヘッドレスChromeで描画したものなのでLaTeXは不要です。数式は`$ x $`のように前後に空白を入れて書くとKaTeXで描画されます。
- 文書の設定はファイル先頭の関数呼び出しで書きます。詳しくは[sample.qd](sample.qd)と[wiki](https://quarkdown.com/wiki/)を参照。
  - 種別: `.doctype {paged}` ([document types](https://quarkdown.com/wiki/document-types/))
  - 用紙: `.pageformat size:{A4} margin:{2cm}` ([page format](https://quarkdown.com/wiki/page-format/))
  - テーマ: `.theme {paperwhite} layout:{latex}` ([themes](https://quarkdown.com/wiki/themes/))
  - フォント: `.font {GoogleFonts:BIZ UDPMincho}` ([font configuration](https://quarkdown.com/wiki/font-configuration/))
- 日本語フォントはイメージに同梱されていないため、Google Fontsかリポジトリ内のフォントファイルを指定します。既定では`_setup.qd`でBIZ UDPMinchoを指定しています。
- `./confirm.sh ファイル名`で手元で編集中のqdをpdfに変換できます。`confirm.pdf`というのが生成されます。(dockerが必要です)
- その他機能追加,質問はissueでお願いします。

## 使い方

`Use this template`をクリックして新規リポジトリを作成してそこに`.qd`ファイルを追加していきます。

## 機能追加予定

- ビルド速度向上のためにプルしてきたdockerイメージをキャッシュしたい
