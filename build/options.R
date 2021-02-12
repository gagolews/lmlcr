# Copyright (C) 2021, Marek Gagolewski, https://www.gagolewski.com

library("knitr")

opts_chunk$set(
    fig.height=3.5,
    fig.width=6,
    dev=c("CairoPDF", "CairoPNG"),
    out.width=NULL,
    dpi=300,
    error=FALSE,
    fig.show="hold",
    fig.lp='fig:',
    autodep=TRUE,
    cache=TRUE,
    dev.args=list(pointsize=11)
)
