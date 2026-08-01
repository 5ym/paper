#!/bin/sh
# 手元のqdファイルをconfirm.pdfに変換する
# 使い方: ./confirm.sh path/to/file.qd
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/data" -w /data \
  ghcr.io/iamgio/quarkdown:2 c "$1" --pdf --strict --allow global-read --out . --out-name confirm
