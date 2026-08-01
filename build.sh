#!/bin/sh
# qdを1ファイルpdfに変換する
# 使い方: build.sh <ソース(.qd)> [出力ディレクトリ] [出力名]
set -e

src=$1
out=${2:-$(dirname "$src")}
name=$3
if [ -z "$name" ]; then
  name=$(basename "$src")
  name=${name%.*}
fi

# 追加オプション(CIの--pdf-no-sandboxなど)。単語分割させるので引用しない
# QUARKDOWN_OPTSはbin/quarkdownがJVMオプションとして解釈するので別名にしている
# shellcheck disable=SC2086
quarkdown c "$src" --pdf --strict --allow global-read $QUARKDOWN_EXTRA_OPTS --out "$out" --out-name "$name"
