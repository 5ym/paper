#!/bin/sh
# _setup.qdの共通設定を先頭に付けたqdを書き出す
# 使い方: to-qd.sh <ソース(.qd/.md)> <出力先(.qd)>
set -e

src=$1
dest=$2
setup=$(dirname "$0")/_setup.qd

{
  [ -f "$setup" ] && cat "$setup" || true
  case $src in
    # mdの場合は先頭のYAMLフロントマターを読み飛ばす
    *.md) awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && ($0 == "---" || $0 == "...") { fm = 0; next } !fm' "$src" ;;
    *) cat "$src" ;;
  esac
} > "$dest"
