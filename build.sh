#!/bin/sh
# コンテナ内で1ファイルをpdfに変換する
# 使い方: build.sh <ソース(.qd/.md)> [出力ディレクトリ] [出力名]
set -e

src=$1
out=${2:-$(dirname "$src")}
name=$3
if [ -z "$name" ]; then
  name=$(basename "$src")
  name=${name%.*}
fi

# 共通設定を注入した一時ファイルを作って変換する
tmp=$(dirname "$src")/.qdbuild.qd
trap 'rm -f "$tmp"' EXIT
sh "$(dirname "$0")/to-qd.sh" "$src" "$tmp"

quarkdown c "$tmp" --pdf --strict --allow global-read --out "$out" --out-name "$name"
