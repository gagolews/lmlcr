# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

RMD_SOURCES = \
    01-introduction.Rmd                          \
    02-regression-simple.Rmd                     \
    03-regression-multiple.Rmd                   \
    04-classification-neighbours.Rmd             \
    05-classification-trees_and_logistic.Rmd
#     06-classification-nnets.Rmd                \
#     07-optimisation-iterative.Rmd              \
#     08-clustering.Rmd                          \
#     09-optimisation-genetic.Rmd                \
#     10-recommenders.Rmd                        \
#     11-postscript.Rmd

VPATH=.
HTML_OUTDIR=out-html
BEAMER_OUTDIR=out-beamer
HTML_OUTPUTS=$(RMD_SOURCES:.Rmd=.html)
BEAMER_OUTPUTS=$(patsubst %.Rmd,$(BEAMER_OUTDIR)/%.pdf,$(RMD_SOURCES))

all: html beamer

html: $(HTML_OUTPUTS)

beamer: $(BEAMER_OUTPUTS)

$(BEAMER_OUTDIR)/%.pdf: %.Rmd
	build-beamer/compile.sh "$<"

$(HTML_OUTDIR)/%.html: %.Rmd
	build-html/compile.sh "$<"

