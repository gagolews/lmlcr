options(encoding="UTF-8")
set.seed(666)
options(width=64)
options(digits=7)


reticulate::use_python("/opt/anaconda3/bin/python")


################################################################################

library("knitr")
knit_hooks$set(plot=knitr:::hook_plot_md_pandoc)


..output_language <- if (is.null(opts_chunk$get("output_language"))) "???" else
        opts_chunk$get("output_language")

solution_begin <- function() {
    if (..output_language=="html") {
        cat('<details>')
        cat('<summary style="color: blue">Click here for a solution</summary>\n')
    } else if (..output_language=="tex") {
        cat("\\color{gray}\\sf\\textbf{Solution}.\n")
    } else {
        ;
    }
}

solution_end <- function() {
    if (..output_language=="html") {
        cat('</details>\n')
    } else if (..output_language=="tex") {
        cat("\\normalfont\\normalsize\\normalcolor\n")
    } else {
        ;
    }

}

################################################################################





################################################################################
# Marek's R graphics package style hacks                                       #
# aka "you don't need ggplot2 to look cool"                                    #
#                                                                              #
# Copyright (C) 2020, Marek Gagolewski <https://www.gagolewski.com>            #
#                                                                              #
# Don't try this at home, kids!!!                                              #
################################################################################


setHook("before.plot.new", function() {
    if (all(par("mar") == c(5.1, 4.1, 4.1, 2.1))) {
        par(mar=c(2.5,2.5,1,0.5))
    }
    if (..output_language!="tex") {
        par(family="Ubuntu Condensed")
    }
    par(tcl=-0.25)
    par(mgp=c(1.25, 0.5, 0))
    par(cex.main=1)
    par(font.main=2)
    par(cex.axis=0.9)
    par(cex.lab=1)
    par(font.lab=3)
}, "replace")

plot.window_new <- function (xlim, ylim, log = "", asp = NA, ...)
{
    .External.graphics(C_plot_window, xlim, ylim, log, asp, ...)
    rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col="#00000010")
    abline(v=axTicks(1), col="white", lwd=1.5, lty=1)
    abline(h=axTicks(2), col="white", lwd=1.5, lty=1)
    box()
    invisible()

}
environment(plot.window_new) <- environment(plot.window)
unlockBinding("plot.window", getNamespace("graphics"))
assign("plot.window", plot.window_new, getNamespace("graphics"))

axis_new <- function (side, at = NULL, labels = TRUE, tick = TRUE, line = -0.25,
          pos = NA, outer = FALSE, font = NA, lty = "solid", lwd = 0,
          lwd.ticks = 1, col = NULL, col.ticks = NULL, hadj = NA,
          padj = NA, gap.axis = NA, ...)
{
    if (is.null(col) && !missing(...) && !is.null(fg <- list(...)$fg))
        col <- fg
    invisible(.External.graphics(C_axis, side, at, as.graphicsAnnot(labels),
                                 tick, line, pos, outer, font, lty, lwd, lwd.ticks, col,
                                 col.ticks, hadj, padj, gap.axis, ...))
}
environment(axis_new) <- environment(axis)
unlockBinding("axis", getNamespace("graphics"))
assign("axis", axis_new, getNamespace("graphics"))

################################################################################
# Marek's R graphics package style hacks                                  EOF. #
################################################################################



