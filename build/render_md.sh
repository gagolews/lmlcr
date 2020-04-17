#!/bin/bash

# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

set -e

cd tmp-md/

cp -f ../bibstyle.csl .
cp -f ../bibliography.bib .

mkdir -p figures/
cp -f ../figures/*.pdf figures
cp -f ../figures/*.svg figures
