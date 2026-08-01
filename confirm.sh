#!/bin/sh
# 編集中のqd/mdを共通設定込みのqdとしてtmp/以下に書き出す
# 生成されたqdをVS Codeの公式拡張(quarkdown.quarkdown-vscode)で開いて
# Ctrl+Shift+Vでプレビューする
# 使い方: ./confirm.sh [ファイル...]  (省略時はリポジトリ内の全qd/md)
set -e
cd "$(dirname "$0")"

out=tmp

# tmp/側での対応するディレクトリ
dest_dir() {
  d=${1#./}
  if [ "$d" = "." ]; then echo "$out"; else echo "$out/$d"; fi
}

# 単体で変換されるソースがディレクトリ内にあるか
has_source() {
  [ -n "$(find "$1" -type f \( -name '*.qd' -o -name '*.md' \) ! -name '_*' -print 2> /dev/null | head -n 1)" ]
}

# 共通設定を注入したqdをtmp/以下に生成する
gen_qd() {
  src=${1#./}
  dir=$(dest_dir "$(dirname "$src")")
  name=$(basename "$src")
  name=${name%.*}
  mkdir -p "$dir"
  sh ./to-qd.sh "$src" "$dir/$name.qd"
  echo "$dir/$name.qd"
}

# 画像や_付きの分割ファイル等をtmp/側からも参照できるようにする
link_assets() {
  src_dir=${1#./}
  dir=$(dest_dir "$src_dir")
  mkdir -p "$dir"
  for e in "$src_dir"/*; do
    [ -e "$e" ] || continue
    n=${e##*/}
    # 生成済みのもの・スクリプト・変換対象のソースはリンクしない
    if [ -e "$dir/$n" ]; then continue; fi
    case $n in
      "$out" | *.sh) continue ;;
      _*) ;;
      *.qd | *.md) continue ;;
    esac
    if [ -d "$e" ] && has_source "$e"; then continue; fi
    ln -sfn "$(cd "$src_dir" && pwd)/$n" "$dir/$n"
  done
}

sources() {
  if [ $# -gt 0 ]; then
    printf '%s\n' "$@"
  else
    find . -path ./.git -prune -o -path "./$out" -prune -o -type f \( -name '*.qd' -o -name '*.md' \) -print |
      grep -v '\(^\|/\)_'
  fi
}

[ $# -gt 0 ] || rm -rf "$out"
sources "$@" | while read -r f; do gen_qd "$f"; done
sources "$@" | while read -r f; do dirname "$f"; done | sort -u | while read -r d; do link_assets "$d"; done

echo "VS Codeで上記のqdを開いてCtrl+Shift+Vでプレビューできます。"
