#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "input file does not exist or no input provided"
    exit 1
fi

keepsources=true
tmpdir="tmp-beamer/${1/%.Rmd/}"
outdir="out-beamer"
knitrfile="./tmp-beamer-${1}"
tmpfile="${tmpdir}/${1}"
outfile="${outdir}/${1/%.Rmd/.pdf}"

echo "Compiling ${1} → ${outfile}..."

title=`grep -m 1 -oP '(?<=^# ).*$' "${1}"`
date="$(date '+%Y-%m-%d %H:%M:%S') (`git rev-parse --short HEAD`)"
echo "Title='${title}'"

rm -f "${knitrfile}"
rm -f "${outfile}"
rm -f "${tmpfile}"
rm -f "${tmpfile/%.Rmd/.md}"
rm -f "${tmpfile/%.Rmd/.pdf}"
rm -f "${tmpfile/%.Rmd/.tex}"
rm -f "${tmpfile/%.Rmd/.log}"

mkdir -p "${outdir}"
mkdir -p "${tmpdir}"

echo "\`\`\`{r,echo=FALSE}" > "${knitrfile}"
cat build-beamer/options.R >> "${knitrfile}"
cat common.R >> "${knitrfile}"
echo "\`\`\`" >> "${knitrfile}"
echo "" >> "${knitrfile}"
cat "${1}" >> "${knitrfile}"



Rscript -e "\
    library('knitr');                              \
    opts_knit\$set(progress=FALSE, verbose=TRUE); \
    opts_chunk\$set(                               \
        cache.path='${tmpdir}/cache/',    \
        fig.path='${tmpdir}/figures/'     \
    );                                             \
    knit('${knitrfile}', '${tmpfile/%.Rmd/.md}')
"

mv "${knitrfile}" "${tmpfile}"


pandoc +RTS -K512m -RTS \
    "${tmpfile/%.Rmd/.md}" \
    --output "${tmpfile/%.Rmd/.tex}" \
    --from markdown+autolink_bare_uris+tex_math_single_backslash+smart-implicit_figures+link_attributes \
    --to beamer \
    --slide-level 4 \
    --highlight-style tango \
    --pdf-engine pdflatex \
    --self-contained \
    --include-in-header build-beamer/header.tex \
    --top-level-division=chapter \
    --bibliography=bibliography.bib \
    --csl=bibstyle.csl \
    -V title="${title}" \
    -V subtitle="SIT114" \
    -V author="Marek Gagolewski" \
    -V date="${date}" \
    --default-image-extension .pdf


pdflatex -interaction=batchmode -output-directory="${tmpdir}" "${tmpfile/%.Rmd/.tex}" || \
        echo "!!!!!! ERROR COMPILING FILE !!!!!!" && \
        cat "${tmpfile/%.Rmd/.log}" | grep -A 10 -e "^!" && \
        rm -f "${tmpfile/%.Rmd/.tex}" && \
        exit 1

pdflatex -interaction=batchmode -output-directory="${tmpdir}" "${tmpfile/%.Rmd/.tex}"

mv "${tmpfile/%.Rmd/.pdf}" "${outfile}"

if [ "$keepsources" = false ]; then
    rm -f "${tmpfile}"
    rm -f "${tmpfile/%.Rmd/.md}"
    rm -f "${tmpfile/%.Rmd/.tex}"
fi

rm -f "${tmpfile/%.Rmd/.aux}" "${tmpfile/%.Rmd/.log}" "${tmpfile/%.Rmd/.nav}" \
      "${tmpfile/%.Rmd/.out}" "${tmpfile/%.Rmd/.snm}" "${tmpfile/%.Rmd/.toc}" \
      "${tmpfile/%.Rmd/.vrb}"

echo "Finished compiling ${1} → ${outfile}. OK."
