#!/bin/bash

# Copyright (C) 2020-2021, Marek Gagolewski <https://www.gagolewski.com>

set -e

if [[ -z "${LATEX_DRAFT}" ]]; then
    # full build
    cd tmp-latex/
else
    # draft build - fragments
    mkdir -p tmp-latex-draft/
    cd tmp-latex-draft/
    cp -rf ../tmp-latex/0* .
    cp -rf ../tmp-latex/9* .
fi


rm -r -f ../out-latex/
mkdir -p ../out-latex/

cp -f ../bibstyle.csl .
cp -f ../bibliography.bib .

mkdir -p figures/
cp -f ../figures/*.pdf figures

rm -f _main.Rmd

cp -f ../build/index_latex.Rmd index.Rmd
cp -f ../build/preamble_latex.tex preamble.tex
cp -f ../build/before_body.tex before_body.tex
cp -f ../build/after_body.tex after_body.tex
cp -f ../build/upquote.sty upquote.sty

echo "" > krantz.cls
echo "\RequirePackage{etex}" >> krantz.cls
echo "\RequirePackage{etoolbox}" >> krantz.cls
cat ../build/krantz.cls >> krantz.cls

cat 00-introduction.Rmd >> index.Rmd
rm -f 00-introduction.Rmd

date="DRAFT v0.2.1 $(date '+%Y-%m-%d %H:%M') (`git rev-parse --short HEAD`)"
sed -i -e "s/@DATE@/${date}/g" index.Rmd

if [[ -z "${LATEX_DRAFT}" ]]; then
    # full build
    Rscript -e 'bookdown.marek.mods::render_book("index.Rmd", "bookdown.marek.mods::pdf_book",
        output_dir="../out-latex")'

    cp -f ../out-latex/_main.pdf ../out-latex/lmlcr.pdf
    mv -f ../out-latex/_main.tex .
    mv -f ../out-latex/_main.pdf .
else
    # draft build
    Rscript -e '
        source("../build/process_just_tex.R")
        bookdown.marek.mods::render_book("index.Rmd", "bookdown.marek.mods::pdf_book",
            output_dir="../out-latex", clean=FALSE)'
    xelatex -file-line-error -halt-on-error -interaction=errorstopmode _main.tex #> /dev/null
fi
