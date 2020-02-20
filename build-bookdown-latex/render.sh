#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-bookdown-latex/
rm -r -f ../out-bookdown-latex/
rm -f _main.Rmd

mkdir -p ../out-bookdown-latex/
cp -f ../build-bookdown-latex/index.Rmd .
cp -f ../bibliography.bib .
cat ../00-introduction.Rmd >> index.Rmd

mkdir -p figures/
for f in ../figures/*.svg; do
    if [ ! -f "${f/%.svg/.pdf}" ]; then
        # @TODO !!!!
        inkscape $f --without-gui --export-pdf=${f/%.svg/.pdf} && cp ${f/%.svg/.pdf} figures/
    fi
done

Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book",
    output_dir="../out-bookdown-latex")'
