#!/bin/sh
# 既存のmdをqdに変換する移行用スクリプト(一度だけ実行する想定)
# - 先頭のYAMLフロントマターを取り除く
# - 共通設定の読み込み(.include)を先頭に足す
# - 元のmdは削除する
# 使い方: ./md-to-qd.sh [ファイル...]  (省略時はリポジトリ内の全md)
set -e
cd "$(dirname "$0")"

sources() {
  if [ $# -gt 0 ]; then
    printf '%s\n' "$@"
  else
    find . -path ./.git -prune -o -type f -name '*.md' -print |
      sed 's|^\./||' | grep -v '\(^\|/\)README\.md$'
  fi
}

# その文書から見た_setup.qdへの相対パス
setup_path() {
  d=$(dirname "$1")
  p=""
  while [ "$d" != "." ]; do
    p="../$p"
    d=$(dirname "$d")
  done
  echo "${p}_setup.qd"
}

list=$(mktemp)
body=$(mktemp)
trap 'rm -f "$list" "$body"' EXIT
sources "$@" > "$list"

count=0
while read -r src; do
  case $src in
    *.md) ;;
    *) echo "スキップ(mdではありません): $src" >&2; continue ;;
  esac
  if [ ! -f "$src" ]; then
    echo "スキップ(見つかりません): $src" >&2
    continue
  fi
  dest=${src%.md}.qd
  if [ -e "$dest" ]; then
    echo "スキップ(既にあります): $dest" >&2
    continue
  fi

  awk 'NR == 1 && $0 == "---" { fm = 1; next } fm && ($0 == "---" || $0 == "...") { fm = 0; next } !fm' "$src" |
    sed '/./,$!d' > "$body"
  {
    # _で始まるファイルは分割用なので共通設定は読み込ませない
    case $(basename "$src") in
      _*) ;;
      *) grep -q '^\.include *{[^}]*_setup\.qd}' "$body" || printf '.include {%s}\n\n' "$(setup_path "$src")" ;;
    esac
    cat "$body"
  } > "$dest"
  rm -f "$src"
  echo "$src -> $dest"
  count=$((count + 1))
done < "$list"

if [ "$count" -eq 0 ]; then
  echo "変換するmdはありませんでした。"
else
  echo "$count件変換しました。内容を確認してコミットしてください。"
fi
