library("knitr")
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


reticulate::use_python("/opt/anaconda3/bin/python")

