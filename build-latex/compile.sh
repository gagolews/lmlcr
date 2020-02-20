#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

echo "Compiling ${1} → ${1/%Rmd/pdf}..."
set -e

rm -f "${1/%Rmd/pdf}"
rm -f "${1/%Rmd/tex}"
rm -f "${1/%Rmd/log}"

echo "\`\`\`{r,echo=FALSE}" > "tmp-beamer-${1/%.Rmd/}.Rmd"
cat knit2beamer-options.R >> "tmp-beamer-${1/%.Rmd/}.Rmd"
echo "\`\`\`" >> "tmp-beamer-${1/%.Rmd/}.Rmd"
echo "" >> "tmp-beamer-${1/%.Rmd/}.Rmd"
cat "${1}" >> "tmp-beamer-${1/%.Rmd/}.Rmd"



Rscript -e "\
    library('knitr');                              \
    opts_knit\$set(progress=FALSE, verbose=TRUE); \
    opts_chunk\$set(                               \
        cache.path='tmp-beamer-${1/%.Rmd/}/cache/',    \
        fig.path='tmp-beamer-${1/%.Rmd/}/figures/'     \
    );                                             \
    knit('tmp-beamer-${1/%.Rmd/}.Rmd', 'tmp-beamer-${1/%Rmd/md}')
"

/opt/anaconda3/bin/pandoc +RTS -K512m -RTS \
    "tmp-beamer-${1/%Rmd/md}" \
    --output "${1/%Rmd/tex}" \
    --from markdown+autolink_bare_uris+tex_math_single_backslash+smart-implicit_figures+link_attributes \
    --to latex \
    --slide-level 3 \
    --highlight-style tango \
    --pdf-engine pdflatex \
    --self-contained \
    --default-image-extension .pdf

#    --include-in-header knit2beamer-header.tex \

pdflatex -interaction=batchmode "${1/%Rmd/tex}" || \
        echo "!!!!!! ERROR COMPILING FILE !!!!!!" && cat "${1/%Rmd/log}" | grep -A 10 -e "^!" && rm -f "${1/%Rmd/pdf}" && exit 1
#pdflatex  -interaction=nonstopmode "${1/%Rmd/tex}"
pdflatex -interaction=batchmode "${1/%Rmd/tex}"

rm -f "tmp-beamer-${1/%.Rmd/}.Rmd"
rm -f "tmp-beamer-${1/%Rmd/md}"
rm -f "${1/%Rmd/tex}"
rm -f "${1/%Rmd/aux}" "${1/%Rmd/log}" "${1/%Rmd/nav}" "${1/%Rmd/out}"\
      "${1/%Rmd/snm}" "${1/%Rmd/toc}" "${1/%Rmd/vrb}"

echo "Finished compiling ${1} → ${1/%Rmd/pdf}. OK."
