# paper

[Quarkdown](https://github.com/iamgio/quarkdown)でqdファイルをpdfに変換します。

## 仕様

- 初回実行時はpdfブランチが自動で作成されます。(qdファイルが一つもなかった場合エラーで終了しブランチは作成されません。)
- theme等を変更し全てビルドしなおしたい時はpdfブランチ削除してmasterを変更すれば全てビルドしなおします。
- 初回実行時qdファイルは再帰的に検索され全て変換されます。
- 元々のファイルと同一のフォルダ構造で配置します。
- pdfブランチにはpdfファイルのみを生成します。
- masterからqdファイルを削除するとpdfからも自動で削除されます。
- 変更があったファイルのみをビルドするようにしています。
- リネームおよび移動した場合は旧ファイル名のpdfは残ります。
- `_`で始まるファイル(`_setup.qd`など)は単体では変換されません。`.include`で読み込む共通設定や分割用のファイルはこの名前にしてください。
- テーマ・用紙・フォントなどの共通設定は[_setup.qd](_setup.qd)にまとめてあります。文書の先頭で`.include {_setup.qd}`と書いて読み込んでください。([including other files](https://quarkdown.com/wiki/including-other-quarkdown-files/))
  - `_setup.qd`からの相対パスではなく、その文書から見た相対パスです。サブフォルダに置いた文書なら`.include {../_setup.qd}`になります。
  - `.include`の後に同じ関数を呼べばその文書だけ設定を上書きできます。
- 変換対象は`.qd`のみです。mdから移行する場合は[md-to-qd.sh](md-to-qd.sh)を参照してください。
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
- 日本語フォントはQuarkdownに同梱されていないため、Google Fontsかリポジトリ内のフォントファイルを指定します。既定では`_setup.qd`でBIZ UDPMinchoを指定しています。
- その他機能追加,質問はissueでお願いします。

## プレビュー

Quarkdown本体のライブプレビューを使います。JRE同梱なのでJavaは不要です。(Node.jsが無ければ自動で入ります)

```sh
curl -fsSL https://raw.githubusercontent.com/quarkdown-labs/get-quarkdown/refs/heads/main/install.sh | sudo env "PATH=$PATH" bash
```

WSLで使う場合はWindows側ではなくWSL内にインストールします。他のインストール方法(Homebrew, Scoop等)は[本家のREADME](https://github.com/iamgio/quarkdown#getting-started)を参照。

```sh
quarkdown c sample.qd -w -p --allow global-read
```

`-w`が保存のたびに再コンパイル、`-p`がwebserver(既定で`localhost:8089`)を立ててブラウザを開き自動リロードします。`.doctype {paged}`はpaged.jsを使うのでwebserver越しでないと正しく表示されません。([CLI options](https://quarkdown.com/wiki/cli-options/))

- `--allow global-read`はリポジトリ外・親ディレクトリのファイル(サブフォルダ文書からの`../_setup.qd`など)を読むために付けています。
- ブラウザを開かずポートだけ使いたい場合は`-b none`、ポート変更は`--server-port`です。
- PDFを手元で出したい場合は`./build.sh <ファイル>`です。CIと同じオプションで変換します。

VS Codeの公式拡張[Quarkdown](https://marketplace.visualstudio.com/items?itemName=quarkdown.quarkdown-vscode)(`Ctrl+Shift+V`でプレビュー、`Ctrl+Alt+P`でPDF出力)も使えます。設定に以下を入れると`.include`や画像の読み込みで権限エラーになりません。

```json
{
  "quarkdown.additionalCompilerOptions": "--allow global-read"
}
```

`Quarkdown not found. Please install Quarkdown first.`と出る場合はインストールが済んでいないかPATHが通っていません。設定`quarkdown.path`に実行ファイルのパス(既定は`quarkdown`、install.shなら`/usr/local/bin/quarkdown`)を指定してください。VS CodeはWSLに接続した状態で使います。

## 使い方

`Use this template`をクリックして新規リポジトリを作成してそこに`.qd`ファイルを追加していきます。

## mdからの移行

既にmdで書いている場合は[md-to-qd.sh](md-to-qd.sh)を一度実行すると全てqdに移行できます。(引数にファイルを渡すとそれだけ変換します)

```sh
./md-to-qd.sh
```

- 先頭のYAMLフロントマターを取り除きます。(そのままだと`---`が区切り線、`title:`行が見出しとして本文に出てしまいます)
- その文書から見た相対パスで`.include {_setup.qd}`を先頭に足します。既に書いてある場合は足しません。
- `_`で始まるファイルは分割用とみなして`.include`を足しません。
- 元のmdは削除するので、結果を確認してからコミットしてください。`README.md`は対象外です。

Quarkdown自体はMarkdownの上位互換なので、本文の書き方はほとんどそのままで通ります。ただし数式はQuarkdownの記法(`$ x $`のように前後に空白)のみ対応で、`\begin{equation}`やスペース無しの`$x$`はそのまま文字として出ます。
