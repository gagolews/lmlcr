# Copyright (C) 2020, Marek Gagolewski, https://www.gagolewski.com

library("knitr")

opts_chunk$set(
    fig.height=3.5,
    fig.width=6,
    dev="CairoPDF",
    out.width="50%",
    dpi=300,
    error=FALSE,
    fig.align="center",
    fig.show="hold",
    fig.align="center",
    dev.args=list(pointsize=11),
    output_language="tex"
)
