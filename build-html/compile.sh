#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

echo "Compiling ${1} → ${1/%Rmd/html}..."
set -e

rm -f "${1/%Rmd/html}"

echo "\`\`\`{r,echo=FALSE}" > "tmp-html-${1/%.Rmd/}.Rmd"
cat knit2html-options.R >> "tmp-html-${1/%.Rmd/}.Rmd"
echo "\`\`\`" >> "tmp-html-${1/%.Rmd/}.Rmd"
echo "" >> "tmp-html-${1/%.Rmd/}.Rmd"
cat "${1}" >> "tmp-html-${1/%.Rmd/}.Rmd"



Rscript -e "\
    library('knitr');                              \
    opts_knit\$set(progress=FALSE, verbose=FALSE); \
    opts_chunk\$set(                               \
        cache.path='tmp-html-${1/%.Rmd/}/cache/',    \
        fig.path='tmp-html-${1/%.Rmd/}/figures/'     \
    );                                             \
    knit('tmp-html-${1/%.Rmd/}.Rmd', 'tmp-html-${1/%Rmd/md}')
"

/opt/anaconda3/bin/pandoc +RTS -K512m -RTS \
    "tmp-html-${1/%Rmd/md}" \
    --output "${1/%Rmd/html}" \
    --from markdown+autolink_bare_uris+tex_math_single_backslash+tex_math_dollars+smart-implicit_figures \
    --to html5 \
    --template knit2html-template.html \
    --highlight-style tango \
    --variable 'theme:flatly' \
    --variable 'mathjax-url:https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML' \
    --default-image-extension .svg \
    --email-obfuscation none \
    --number-sections \
    --self-contained \
    --standalone \
    --section-divs \
    --table-of-contents \
    --toc-depth 2 \
    --mathjax

rm -f "tmp-html-${1/%.Rmd/}.Rmd"
rm -f "tmp-html-${1/%Rmd/md}"

echo "Finished compiling ${1} → ${1/%Rmd/html}. OK."
