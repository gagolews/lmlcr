#!/bin/bash

# Copyright (C) 2020-2021, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "input file does not exist or no input provided"
    exit 1
fi

mkdir -p "tmp-gitbook"
outfile="${1/tmp-md/tmp-gitbook}"
outfile="${outfile/%.md/.Rmd}"

echo "Compiling ${1} → ${outfile}..."

rm -f "${outfile}"
cp "${1}" "${outfile}"

sed -i -e 's/^\-\-\-$/<div style="margin-top: 1em"><\/div>/g' "${outfile}"
sed -i -e 's/^\. \. \.$/<div style="margin-top: 1em"><\/div>/g' "${outfile}"


sed -i -r 's/^\{ BEGIN solution \}$/```{=html}\n<details class="solution"><summary style="color: blue">Click here for a solution.<\/summary>\n```/g'  "${outfile}"
sed -i -r 's/^\{ END solution \}$/```{=html}\n<\/details>\n```/g'  "${outfile}"

sed -i -r 's/^\{ BEGIN exercise \}$/```{=html}\n<div class="exercise"><strong>Exercise.<\/strong>\n```/g'  "${outfile}"
sed -i -r 's/^\{ END exercise \}$/```{=html}\n<\/div>\n```/g'  "${outfile}"

sed -i -r 's/^\{ BEGIN example \}$/```{=html}\n<div class="remark"><strong>Example.<\/strong>\n```/g'  "${outfile}"
sed -i -r 's/^\{ END example \}$/```{=html}\n<\/div>\n```/g'  "${outfile}"

sed -i -r 's/^\{ BEGIN remark \}$/```{=html}\n<div class="remark"><strong>Remark.<\/strong>\n```/g'  "${outfile}"
sed -i -r 's/^\{ END remark \}$/```{=html}\n<\/div>\n```/g'  "${outfile}"

sed -i -r 's/^\{ BEGIN definition \}$/```{=html}\n<div class="definition"><strong>Definition.<\/strong>\n```/g'  "${outfile}"
sed -i -r 's/^\{ END definition \}$/```{=html}\n<\/div>\n```/g'  "${outfile}"


sed -i -r 's/^\{ LATEX (.+) \}$//g'  "${outfile}"



dir_fig_in="${1/%.md/}-figures"
dir_fig_out="${outfile/%.Rmd/}-figures"
mkdir -p "${dir_fig_out}"
rm -f "${dir_fig_out}/*"
if [ -d "${dir_fig_in}" ]; then
    cp ${dir_fig_in}/*.png "${dir_fig_out}/"

#     cd "${dir_fig_out}"
#     for f in *.svg; do gzip "$f"; done
#     rename.ul ".svg.gz" ".svgz" *.svg.gz
#     cd ..
fi



echo "Compiling ${1} → ${outfile} succeeded."
