#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "The input file does not exist or was not provided."
    exit 1
fi

tmpdir="tmp-md/${1/%.Rmd/}"
knitrfile="tmp-md-${1}"
outfile="tmp-md/${1/%.Rmd/.md}"

echo "Compiling ${1} -> ${outfile}..."

#title=`grep -m 1 -oP '(?<=^# ).*$' "${1}"`
#date="$(date '+%Y-%m-%d %H:%M:%S') (`git rev-parse --short HEAD`)"
#echo "@title@='${title}' @date@='${date}'"

rm -f "${knitrfile}"
rm -f "${outfile}"

mkdir -p "tmp-md"

echo "\`\`\`{r __init__,echo=FALSE,warning=FALSE,message=FALSE,results='hide'}" > "${knitrfile}"
cat build/options.R >> "${knitrfile}"
cat common.R >> "${knitrfile}"
echo "\`\`\`" >> "${knitrfile}"
echo "" >> "${knitrfile}"
cat "${1}" >> "${knitrfile}"


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

sed -i -e 's/tmp-md\///g' "${outfile}"



echo "Compiling ${1} -> ${outfile} succeeded."
