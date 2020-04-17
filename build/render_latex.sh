#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-latex/
rm -r -f ../out-latex/
mkdir -p ../out-latex/

cp -f ../bibstyle.csl .
cp -f ../bibliography.bib .

mkdir -p figures/
cp -f ../figures/*.pdf figures

rm -f _main.Rmd

cp -f ../build/index_latex.Rmd index.Rmd
cp -f ../build/preamble_latex.tex preamble.tex
cat 00-introduction.Rmd >> index.Rmd
rm -f 00-introduction.Rmd

date="DRAFT v0.2 $(date '+%Y-%m-%d %H:%M') (`git rev-parse --short HEAD`)"
sed -i -e "s/@DATE@/${date}/g" index.Rmd

Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::pdf_book",
    output_dir="../out-latex")'

mv -f ../out-latex/_main.pdf ../out-latex/lmlcr.pdf
