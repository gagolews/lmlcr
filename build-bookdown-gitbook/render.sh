#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-bookdown-gitbook/
rm -r -f ../out-bookdown-gitbook/
mkdir -p ../out-bookdown-gitbook/
cp -f ../build-bookdown-gitbook/index.Rmd .
cp -f ../bibliography.bib .
rm -f _main.Rmd

Rscript -e 'bookdown::render_book("index.Rmd", "bookdown::gitbook", output_dir="../out-bookdown-gitbook")'
