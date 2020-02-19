# (C) 2020 Marek Gagolewski, https://www.gagolewski.com

RMD_SOURCES = \
	00-hello.Rmd                               \
	01-overview.Rmd                            \
	02-regression-simple.Rmd                   \
	03-regression-multiple.Rmd                 \
	04-classification-neighbours.Rmd           \
	05-classification-trees_and_logistic.Rmd   \
	06-classification-nnets.Rmd                \
	07-optimisation-iterative.Rmd              \
	08-clustering.Rmd                          \
	09-optimisation-genetic.Rmd                \
	10-recommenders.Rmd                        \
	11-postscript.Rmd                          \
	99-notation.Rmd

HTML_OUTPUTS=$(RMD_SOURCES:.Rmd=.html)

BEAMER_OUTPUTS=$(RMD_SOURCES:.Rmd=.pdf)


%.html: %.Rmd
	./build_html/compile.sh "$<"

%.pdf: %.Rmd
	./build_beamer/compile.sh "$<"

all: html beamer

html: $(HTML_OUTPUTS)

beamer: $(BEAMER_OUTPUTS)

clean:
	rm -f $(RMD_SOURCES:.Rmd=.log)
	rm -f $(RMD_SOURCES:.Rmd=.md)
	rm -f $(RMD_SOURCES:.Rmd=.aux)
	rm -f $(RMD_SOURCES:.Rmd=.tpl)
	rm -f $(RMD_SOURCES:.Rmd=.toc)
	rm -f $(RMD_SOURCES:.Rmd=.vrb)
	rm -f $(RMD_SOURCES:.Rmd=.snm)
	rm -f $(RMD_SOURCES:.Rmd=.nav)
	rm -f $(RMD_SOURCES:.Rmd=.out)
