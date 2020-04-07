# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

library("knitr")
options(encoding="UTF-8")
opts_chunk$set(
    fig.height=4,
    fig.width=5,
    dev='pdf',
    out.width='80%',
    error=FALSE,
    output_language="tex"
)

knit_hooks$set(plot=knitr:::hook_plot_md_pandoc)
set.seed(666)
options(width=64)
options(digits=7)
