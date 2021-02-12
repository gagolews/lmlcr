#!/bin/bash

# Copyright (C) 2020-2021, Marek Gagolewski <https://www.gagolewski.com>

set -e

cd tmp-gitbook/
rm -r -f ../out-gitbook/
mkdir -p ../out-gitbook/

cp -f ../bibstyle.csl .
cp -f ../bibliography.bib .

mkdir -p figures/
# cp -f ../figures/*.svg figures
cp -f ../figures/*.png figures

# cd figures
# for f in *.svg; do gzip "$f"; done
# rename.ul ".svg.gz" ".svgz" *.svg.gz
# cd ..

rm -f _main.Rmd

cp -f ../build/index_gitbook.Rmd index.Rmd
cp -f ../build/preamble_gitbook.html preamble.html
cat 00-introduction.Rmd >> index.Rmd
rm -f 00-introduction.Rmd

date="DRAFT v0.2.1 $(date '+%Y-%m-%d %H:%M') (`git rev-parse --short HEAD`)"
sed -i -e "s/@DATE@/${date}/g" index.Rmd

Rscript -e 'bookdown.marek.mods::render_book("index.Rmd", "bookdown.marek.mods::gitbook",
    output_dir="../out-gitbook")'
