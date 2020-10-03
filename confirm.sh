#!/bin/sh
echo $1 | xargs -i docker run -v $PWD:/data --entrypoint sh ghcr.io/5ym/pandoc -c "markdownlint-cli2 {} && pandoc --template eisvogel --listings --pdf-engine xelatex -V CJKmainfont='Noto Serif CJK JP' -o confirm.pdf {}"