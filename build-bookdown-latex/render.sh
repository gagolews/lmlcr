#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-bookdown-latex/
rm -r -f ../out-bookdown-latex/
rm -f _main.Rmd

mkdir -p ../out-bookdown-latex/
cp -f ../build-bookdown-latex/index.Rmd .
cp -f ../bibliography.bib .
cp -f ../90-convention.Rmd .
cp -f ../99-references.Rmd .
cat ../00-introduction.Rmd >> index.Rmd

date="DRAFT v0.1 $(date '+%Y-%m-%d %H:%M') (`git rev-parse --short HEAD`)"
sed -i -e "s/@DATE@/${date}/g" index.Rmd

mkdir -p figures/
cp -f ../figures/*.pdf figures

Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book",
    output_dir="../out-bookdown-latex")'

mv -f ../out-bookdown-latex/_main.pdf ../out-bookdown-latex/lmlcr.pdf
