#!/bin/sh
# 1ファイルをpdfに変換する
# 使い方: build.sh <ソース(.qd/.md)> [出力ディレクトリ] [出力名]
set -e

src=$1
out=${2:-$(dirname "$src")}
name=$3
if [ -z "$name" ]; then
  name=$(basename "$src")
  name=${name%.*}
fi

# mdはqdに直してから渡す。.includeの相対パスを保つため元と同じディレクトリに置く
case $src in
  *.md)
    target=$(dirname "$src")/.qdbuild.qd
    trap 'rm -f "$target"' EXIT
    sh "$(dirname "$0")/to-qd.sh" "$src" "$target"
    ;;
  *) target=$src ;;
esac

# 追加オプション(CIの--pdf-no-sandboxなど)。単語分割させるので引用しない
# QUARKDOWN_OPTSはbin/quarkdownがJVMオプションとして解釈するので別名にしている
# shellcheck disable=SC2086
quarkdown c "$target" --pdf --strict --allow global-read $QUARKDOWN_EXTRA_OPTS --out "$out" --out-name "$name"
