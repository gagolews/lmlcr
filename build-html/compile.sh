#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "input file does not exist or no input provided"
    exit 1
fi

keepsources=true
tmpdir="tmp-html/${1/%.Rmd/}"
outdir="out-html"
knitrfile="./tmp-html-${1}"
tmpfile="${tmpdir}/${1}"
outfile="${outdir}/${1/%.Rmd/.html}"

echo "Compiling ${1} → ${outfile}..."

title=`grep -m 1 -oP '(?<=^# ).*$' "${1}"`
date="$(date '+%Y-%m-%d %H:%M:%S') (`git rev-parse --short HEAD`)"
echo "Title='${title}'"

rm -f "${knitrfile}"
rm -f "${outfile}"
rm -f "${tmpfile}"
rm -f "${tmpfile/%.Rmd/.md}"
rm -f "${tmpfile/%.Rmd/.html}"

mkdir -p "${outdir}"
mkdir -p "${tmpdir}"

echo "\`\`\`{r,echo=FALSE}" > "${knitrfile}"
cat build-html/options.R >> "${knitrfile}"
cat common.R >> "${knitrfile}"
echo "\`\`\`" >> "${knitrfile}"
echo "" >> "${knitrfile}"
cat "${1}" >> "${knitrfile}"
#sed -e 's@^---$@<p></p>@g' "${1}" >> "${knitrfile}"


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
    --output "${outfile}" \
    --from markdown+autolink_bare_uris+tex_math_single_backslash+tex_math_dollars+smart-implicit_figures \
    --to html5 \
    --template build-html/template.html \
    --highlight-style tango \
    --variable 'theme:flatly' \
    --variable 'mathjax-url:https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' \
    --default-image-extension .png \
    --email-obfuscation none \
    --number-sections \
    --self-contained \
    --standalone \
    --section-divs \
    --table-of-contents \
    --bibliography=bibliography.bib \
    --toc-depth 3 \
    --top-level-division=part \
    -V title="${title}" \
    -V pagetitle="${title}" \
    -V author="Marek Gagolewski" \
    -V date="${date}" \
    --mathjax

if [ "$keepsources" = false ]; then
    rm -f "${tmpfile}"
    rm -f "${tmpfile/%.Rmd/.md}"
fi

echo "Finished compiling ${1} → ${outfile}. OK."
