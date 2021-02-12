#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

if [ ! -f "${1}" ]; then
    echo "input file does not exist or no input provided"
    exit 1
fi

mkdir -p "tmp-latex"
outfile="${1/tmp-md/tmp-latex}"
outfile="${outfile/%.md/.Rmd}"

echo "Compiling ${1} → ${outfile}..."

rm -f "${outfile}"
cp "${1}" "${outfile}"

sed -i -e 's/^\-\-\-$/\\bigskip/g' "${outfile}"
sed -i -e 's/^\. \. \.$/\\bigskip/g' "${outfile}"

sed -i -r 's/^\{ BEGIN ([a-z]+) \}$/```{=latex}\n\\begin{\1}\n```/g'  "${outfile}"
sed -i -r 's/^\{ END ([a-z]+) \}$/```{=latex}\n\\end{\1}\n```/g'  "${outfile}"


sed -i -r 's/^\{ LATEX (.+) \}$/```{=latex}\n\1\n```/g'  "${outfile}"

dir_fig_in="${1/%.md/}-figures"
dir_fig_out="${outfile/%.Rmd/}-figures"
mkdir -p "${dir_fig_out}"
rm -f "${dir_fig_out}/*"
if [ -d "${dir_fig_in}" ]; then
    cp ${dir_fig_in}/*.pdf "${dir_fig_out}/"
fi

echo "Compiling ${1} → ${outfile} succeeded."
