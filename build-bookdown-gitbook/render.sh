#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-bookdown-gitbook/
rm -r -f ../out-bookdown-gitbook/
rm -f _main.Rmd

mkdir -p ../out-bookdown-gitbook/
cp -f ../build-bookdown-gitbook/index.Rmd .
cp -f ../bibliography.bib .
cp -f ../98-convention.Rmd .
cp -f ../99-references.Rmd .
cat ../00-introduction.Rmd >> index.Rmd

date="DRAFT v0.1 $(date '+%Y-%m-%d %H:%M') (`git rev-parse --short HEAD`)"
sed -ie "s/@DATE@/${date}/g" index.Rmd

mkdir -p figures/
cp -f ../figures/*.png figures

Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook",
    output_dir="../out-bookdown-gitbook")'
