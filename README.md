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
- テーマ・用紙・フォントなどの共通設定は[_setup.qd](_setup.qd)にまとめてあります。ビルド時に[to-qd.sh](to-qd.sh)が各ファイルの先頭に自動で連結するので、文書ごとにフォント等を書く必要はありません。文書側で同じ関数を呼べばその文書だけ上書きできます。
  - `_setup.qd`の行数分だけエラーメッセージの行番号がずれます。
- mdファイルもqdファイルと同じように変換できます。(md→qd→pdfの順で処理し、mdの先頭のYAMLフロントマターは読み飛ばします)
  - 数式はQuarkdownの記法(`$ x $`のように前後に空白)のみ対応です。`\begin{equation}`やスペースなしの`$x$`はそのまま文字として出ます。
- `--strict`を付けているので、未定義の関数呼び出しなど変換時のエラーがあればビルドを停止します。
- ビルドは公式Action[`quarkdown-labs/setup-quarkdown`](https://github.com/quarkdown-labs/setup-quarkdown)でQuarkdown本体(JRE・PuppeteerとChromeを含む)を入れて実行します。バージョンは2系の最新リリースを自動で選びます。
  - インストール先(`$RUNNER_TOOL_CACHE/quarkdown`)を`actions/cache`でキャッシュしているので、バージョンが変わらない限り2回目以降のセットアップはダウンロード無しで済みます。
  - GitHub Actionsのubuntuランナーではpuppeteerが用意するChromeのsandboxがAppArmorで弾かれるため、CIでは`--pdf-no-sandbox`を付けています。ローカルで`build.sh`を使う場合は環境変数`QUARKDOWN_EXTRA_OPTS`が空なのでsandboxは有効のままです。(`QUARKDOWN_OPTS`は`bin/quarkdown`がJVMオプションとして解釈するので使えません)
- PDFはHTMLをヘッドレスChromeで描画したものなのでLaTeXは不要です。
- 文書の設定はファイル先頭の関数呼び出しで書きます。詳しくは[sample.qd](sample.qd)と[wiki](https://quarkdown.com/wiki/)を参照。
  - 種別: `.doctype {paged}` ([document types](https://quarkdown.com/wiki/document-types/))
  - 用紙: `.pageformat size:{A4} margin:{2cm}` ([page format](https://quarkdown.com/wiki/page-format/))
  - テーマ: `.theme {paperwhite} layout:{latex}` ([themes](https://quarkdown.com/wiki/themes/))
  - フォント: `.font {GoogleFonts:BIZ UDPMincho}` ([font configuration](https://quarkdown.com/wiki/font-configuration/))
- 日本語フォントはイメージに同梱されていないため、Google Fontsかリポジトリ内のフォントファイルを指定します。既定では`_setup.qd`でBIZ UDPMinchoを指定しています。
- その他機能追加,質問はissueでお願いします。

## プレビュー

`./confirm.sh`を実行すると、リポジトリ内のqd/mdに共通設定を注入したqdが`tmp/`以下に同じフォルダ構造で生成されます。(引数にファイルを渡すとそれだけ生成します) 画像や`_`付きの分割ファイルは`tmp/`側にシンボリックリンクされるので相対パスもそのまま使えます。生成されたqdをVS Codeで開き`Ctrl+Shift+V`でプレビューします。

セットアップは以下の通りです。

1. Quarkdown本体をインストールします。JRE同梱なのでJavaは不要です。(Node.jsが無ければ自動で入ります)

   ```sh
   curl -fsSL https://raw.githubusercontent.com/quarkdown-labs/get-quarkdown/refs/heads/main/install.sh | sudo env "PATH=$PATH" bash
   ```

   WSLで使う場合はWindows側ではなくWSL内にインストールし、VS CodeもWSLに接続した状態で使います。他のインストール方法(Homebrew, Scoop等)は[本家のREADME](https://github.com/iamgio/quarkdown#getting-started)を参照。

2. VS Codeに公式拡張[Quarkdown](https://marketplace.visualstudio.com/items?itemName=quarkdown.quarkdown-vscode)を入れます。`.qd`のみが対象なのでmdは`./confirm.sh`でqdにしてからプレビューします。
3. VS Codeの設定に以下を追加します。

   ```json
   {
     "quarkdown.additionalCompilerOptions": "--allow global-read"
   }
   ```

   `tmp/`以下の画像や分割ファイルはシンボリックリンクなので、この指定が無いと権限エラーになります。

- `Quarkdown not found. Please install Quarkdown first.`と出る場合は1が済んでいないか、PATHが通っていません。設定`quarkdown.path`に実行ファイルのパス(既定は`quarkdown`、install.shなら`/usr/local/bin/quarkdown`)を指定してください。
- `Ctrl+Alt+P`でPDFに書き出せます。出力先は設定`quarkdown.outputDirectory`(既定は`output`)です。
- 拡張は保存時にコンパイルします。反映を速くしたい場合は`files.autoSaveDelay`を調整してください。

## 使い方

`Use this template`をクリックして新規リポジトリを作成してそこに`.qd`または`.md`ファイルを追加していきます。
