#' Formatter
#'
#' Additional functions for formatting strings and Rd ojbects
#'
#' @param x an object
#'
#' @export
format <- function(x) {
    UseMethod("format", x)
}


#' Format Path
#'
#' remove trailing forward slash
#'
#' @param x a string containing a file path
#'
#' @export
format_path <- function(x) {
    if (substring(x, nchar(x)) == "/") {
        substring(x, 1, nchar(x) - 1)
    } else {
        x
    }
}

#' Format Rd File name
#'
#' remove file extension from .Rd file names
#'
#' @param x a file name
#'
#' @export
format_rd_path <- function(x) {
    gsub(".Rd", "", basename(x))
}


#' Format keywords
#'
#' Collapse Rd keywords array into JS array
#'
#' @param x an Rd keyword array
#'
#' @export
format_yaml_keywords <- function(x) {
    paste0("['", paste0(x, collapse = "', '"), "']")
}

#' Format YAML Text
#'
#' Render and format Rd text to markdown
#'
#' @param x an Rd string
#'
#' @export
format_yaml_text <- function(x) {
    if (!is.null(x)) {
        p <- roxygen2md::markdownify(x)
        dQuote(gsub("\n", "", p))
    } else {
        ""
    }
}