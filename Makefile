# (C) 2020-2021 Marek Gagolewski, https://www.gagolewski.com

FILES_RMD = \
    00-introduction.Rmd                          \
    01-regression-simple.Rmd                     \
    02-regression-multiple.Rmd                   \
    03-classification-neighbours.Rmd             \
    04-classification-trees_and_logistic.Rmd     \
    05-classification-nnets.Rmd                  \
    06-optimisation-iterative.Rmd                \
    07-clustering.Rmd                            \
    08-optimisation-genetic.Rmd                  \
    09-recommenders.Rmd                          \
    90-convention.Rmd                            \
    91-R-setup.Rmd                               \
    92-R-vectors.Rmd                             \
    93-R-matrices.Rmd                            \
    94-R-data-frames.Rmd                         \
    99-references.Rmd


FILES_SVGZ = \
    figures/combination1.svgz                     \
    figures/combination2.svgz                     \
    figures/combination3.svgz                     \
    figures/convex_concave.svgz                   \
    figures/convex_function.svgz                  \
    figures/convex_set.svgz                       \
    figures/cover.svgz                            \
    figures/crossover.svgz                        \
    figures/neuron.svgz                           \
    figures/logistic_regression_binary.svgz       \
    figures/logistic_regression_multiclass.svgz   \
    figures/nnet.svgz                             \
    figures/perceptron.svgz


VPATH=.


.PHONY: all docs md latex gitbook figures clean purge

all: docs


docs: latex gitbook
	rm -f -r docs
	mkdir docs
	cp -f -r out-gitbook/* docs/
	cp -f -r out-latex/* docs/
	cp -f build/CNAME.tpl docs/CNAME


clean:
	rm -f -r tmp-beamer tmp-gitbook tmp-latex  \
	         out-beamer out-gitbook out-latex
purge:
	rm -f -r tmp-beamer tmp-gitbook tmp-latex tmp-md \
	         out-beamer out-gitbook out-latex



PDF_OUTPUTS=$(patsubst %.svgz,%.pdf,$(FILES_SVGZ))
# SVG_OUTPUTS=$(patsubst %.svgz,%.svg,$(FILES_SVGZ))
PNG_OUTPUTS=$(patsubst %.svgz,%.png,$(FILES_SVGZ))

figures: $(PDF_OUTPUTS) $(PNG_OUTPUTS) #$(SVG_OUTPUTS)

#figures/%.svg: figures/%.svgz
#	inkscape "$<" --without-gui --export-plain-svg="$@"

figures/%.pdf: figures/%.svgz
	inkscape "$<" --without-gui --export-pdf="$@"

figures/%.png: figures/%.svgz
	inkscape "$<" --without-gui --export-dpi=300 --export-png="$@"

TMP_MD=$(patsubst %.Rmd,tmp-md/%.md,$(FILES_RMD))
TMP_LATEX=$(patsubst tmp-md/%.md,tmp-latex/%.Rmd,$(TMP_MD))
TMP_GITBOOK=$(patsubst tmp-md/%.md,tmp-gitbook/%.Rmd,$(TMP_MD))

md: figures $(TMP_MD)
	build/render_md.sh

latex: $(TMP_LATEX)
	build/render_latex.sh

gitbook: $(TMP_GITBOOK)
	build/render_gitbook.sh

tmp-md/%.md: %.Rmd
	build/Rmd2md.sh "$<"

tmp-latex/%.Rmd: tmp-md/%.md
	build/md2md_latex.sh "$<"

tmp-gitbook/%.Rmd: tmp-md/%.md
	build/md2md_gitbook.sh "$<"
