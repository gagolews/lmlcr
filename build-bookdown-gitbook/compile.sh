#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "input file does not exist or no input provided"
    exit 1
fi

tmpdir="tmp-bookdown-gitbook/${1/%.Rmd/}"
knitrfile="./tmp-bookdown-gitbook-${1}"
outfile="tmp-bookdown-gitbook/${1}"

echo "Compiling ${1} → ${outfile}..."

title=`grep -m 1 -oP '(?<=^# ).*$' "${1}"`
date="$(date '+%Y-%m-%d %H:%M:%S') (`git rev-parse --short HEAD`)"
echo "Title='${title}'"

rm -f "${knitrfile}"
rm -f "${outfile}"

mkdir -p "tmp-bookdown-gitbook"

echo "\`\`\`{r,echo=FALSE}" > "${knitrfile}"
cat build-bookdown-gitbook/options.R >> "${knitrfile}"
echo "\`\`\`" >> "${knitrfile}"
echo "" >> "${knitrfile}"
cat "${1}" >> "${knitrfile}"
#sed -e 's@^---$@<p></p>@g' "${1}" >> "${knitrfile}"


Rscript -e "\
    library('knitr');                              \
    opts_knit\$set(progress=FALSE, verbose=TRUE); \
    opts_chunk\$set(                               \
        cache.path='${tmpdir}-cache/',    \
        fig.path='${tmpdir}-figures/'     \
    );                                             \
    knit('${knitrfile}', '${outfile}')
"

rm -f "${knitrfile}"

sed -i -e 's/tmp-bookdown-gitbook\///g' "${outfile}"

echo "Finished compiling ${1} → ${outfile}. OK."
