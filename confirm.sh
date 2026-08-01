#!/bin/sh
# 手元のqd/mdファイルをconfirm.pdfに変換する
# 使い方: ./confirm.sh path/to/file.qd
docker run --rm --user "$(id -u):$(id -g)" -v "$PWD:/data" -w /data --entrypoint sh \
  ghcr.io/iamgio/quarkdown:2 ./build.sh "$1" . confirm
