# Marek's patches  for bookdown::pdf_book() --- do not call tinytex::latexmk
# Don't try this at work/home/etc.

library(bookdown.marek.mods)

just_tex <- function (toc = TRUE, number_sections = TRUE, fig_caption = TRUE,
    pandoc_args = NULL, ..., base_format = rmarkdown::pdf_document,
    toc_unnumbered = TRUE, toc_appendix = FALSE, toc_bib = FALSE,
    quote_footer = NULL, highlight_bw = FALSE)
{
    config = get_base_format(base_format, list(toc = toc, number_sections = number_sections,
        fig_caption = fig_caption, pandoc_args = pandoc_args2(pandoc_args),
        ...))
    config$pandoc$ext = ".tex"
    post = config$post_processor
    config$post_processor = function(metadata, input, output,
        clean, verbose) {
        if (is.function(post))
            output = post(metadata, input, output, clean, verbose)
        f = with_ext(output, ".tex")
        x = resolve_refs_latex(read_utf8(f))
        x = resolve_ref_links_latex(x)
        x = restore_part_latex(x)
        x = restore_appendix_latex(x, toc_appendix)
        if (!toc_unnumbered)
            x = remove_toc_items(x)
        if (toc_bib)
            x = add_toc_bib(x)
        x = restore_block2(x, !number_sections)
        if (!is.null(quote_footer)) {
            if (length(quote_footer) != 2 || !is.character(quote_footer))
                warning("The 'quote_footer' argument should be a character vector of length 2")
            else x = process_quote_latex(x, quote_footer)
        }
        if (highlight_bw)
            x = highlight_grayscale_latex(x)
        post = getOption("bookdown.post.latex")
        if (is.function(post))
            x = post(x)
        write_utf8(x, f)
        #tinytex::latexmk(f, config$pandoc$latex_engine, if ("--biblatex" %in%
        #    config$pandoc$args)
        #    "biber"
        #else "bibtex")
        #output = with_ext(output, ".pdf")
        #o = opts$get("output_dir")
        #keep_tex = isTRUE(config$pandoc$keep_tex)
        #if (!keep_tex)
        #    file.remove(f)
        #if (is.null(o))
        #    return(output)
        #output2 = file.path(o, output)
        #file.rename(output, output2)
        #if (keep_tex)
        #    file.rename(f, file.path(o, f))
        #output2

        f
    }
    pre = config$pre_processor
    config$pre_processor = function(...) {
        c(if (is.function(pre)) pre(...), "--variable", "tables=yes",
            "--standalone", if (rmarkdown::pandoc_available("2.7.1")) "-Mhas-frontmatter=false")
    }
    config$bookdown_output_format = "latex"
    config = set_opts_knit(config)
    config
}


environment(just_tex) <- environment(bookdown.marek.mods:::pdf_book)
unlockBinding("pdf_book", getNamespace("bookdown.marek.mods"))
assign("pdf_book", just_tex, getNamespace("bookdown.marek.mods"))
