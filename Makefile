# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

RMD_SOURCES = \
    01-regression-simple.Rmd                     \
    02-regression-multiple.Rmd                   \
    03-classification-neighbours.Rmd             \
    04-classification-trees_and_logistic.Rmd
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
BOOKDOWN_LATEX_OUTDIR=out-bookdown-latex
BOOKDOWN_LATEX_TMPDIR=tmp-bookdown-latex
HTML_OUTPUTS=$(patsubst %.Rmd,$(HTML_OUTDIR)/%.html,$(RMD_SOURCES))
BEAMER_OUTPUTS=$(patsubst %.Rmd,$(BEAMER_OUTDIR)/%.pdf,$(RMD_SOURCES))
BOOKDOWN_GITBOOK_OUTPUTS=$(patsubst %.Rmd,$(BOOKDOWN_GITBOOK_TMPDIR)/%.Rmd,$(RMD_SOURCES))
BOOKDOWN_LATEX_OUTPUTS=$(patsubst %.Rmd,$(BOOKDOWN_LATEX_TMPDIR)/%.Rmd,$(RMD_SOURCES))

.PHONY: all clean purge html beamer bookdown_gitbook bookdown_latex

all: please_specify_build_target_manually
#all: html beamer

html: $(HTML_OUTPUTS)

beamer: $(BEAMER_OUTPUTS)

bookdown_gitbook: $(BOOKDOWN_GITBOOK_OUTPUTS)

bookdown_latex: $(BOOKDOWN_LATEX_OUTPUTS)

clean:
	rm -f -r tmp-bookdown-gitbook/*.Rmd \
	         out-beamer out-bookdown-gitbook out-bookdown-latex out-html

purge:
	rm -f -r tmp-beamer tmp-bookdown-gitbook tmp-bookdown-latex tmp-html \
	         out-beamer out-bookdown-gitbook out-bookdown-latex out-html

$(BEAMER_OUTDIR)/%.pdf: %.Rmd
	build-beamer/compile.sh "$<"

$(HTML_OUTDIR)/%.html: %.Rmd
	build-html/compile.sh "$<"

$(BOOKDOWN_GITBOOK_TMPDIR)/%.Rmd: %.Rmd
	build-bookdown-gitbook/compile.sh "$<"

$(BOOKDOWN_LATEX_TMPDIR)/%.Rmd: %.Rmd
	build-bookdown-latex/compile.sh "$<"
