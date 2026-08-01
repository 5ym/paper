#!/bin/sh
# mdをqdとして書き出す(先頭のYAMLフロントマターを読み飛ばすだけ)
# 使い方: to-qd.sh <ソース(.md)> <出力先(.qd)>
set -e

src=$1
dest=$2

awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && ($0 == "---" || $0 == "...") { fm = 0; next } !fm' "$src" > "$dest"
