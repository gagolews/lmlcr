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
BOOKDOWN_GITBOOK_OUTDIR=out-bookdown-gitbook
BOOKDOWN_GITBOOK_TMPDIR=tmp-bookdown-gitbook
HTML_OUTPUTS=$(patsubst %.Rmd,$(HTML_OUTDIR)/%.html,$(RMD_SOURCES))
BEAMER_OUTPUTS=$(patsubst %.Rmd,$(BEAMER_OUTDIR)/%.pdf,$(RMD_SOURCES))
BOOKDOWN_GITBOOK_OUTPUTS=$(patsubst %.Rmd,$(BOOKDOWN_GITBOOK_TMPDIR)/%.Rmd,$(RMD_SOURCES))

all: please_specify_build_target_manually
#all: html beamer

html: $(HTML_OUTPUTS)

beamer: $(BEAMER_OUTPUTS)

bookdown_gitbook: $(BOOKDOWN_GITBOOK_OUTPUTS)

$(BEAMER_OUTDIR)/%.pdf: %.Rmd
	build-beamer/compile.sh "$<"

$(HTML_OUTDIR)/%.html: %.Rmd
	build-html/compile.sh "$<"

$(BOOKDOWN_GITBOOK_TMPDIR)/%.Rmd: %.Rmd
	build-bookdown-gitbook/compile.sh "$<"
