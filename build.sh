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

# _setup.qdの共通設定を先頭に注入した一時ファイルを作って変換する
tmp=$(dirname "$src")/.qdbuild.qd
trap 'rm -f "$tmp"' EXIT

{
  [ -f _setup.qd ] && cat _setup.qd || true
  case $src in
    # mdの場合は先頭のYAMLフロントマターを読み飛ばす
    *.md) awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && ($0 == "---" || $0 == "...") { fm = 0; next } !fm' "$src" ;;
    *) cat "$src" ;;
  esac
} > "$tmp"

quarkdown c "$tmp" --pdf --strict --allow global-read --out "$out" --out-name "$name"
