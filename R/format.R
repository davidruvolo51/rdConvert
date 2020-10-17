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


#' Format Leading Whitespace
#'
#' In many text blocks, there a leading white space is added. Remove it!
#'
#' @param x a string from an md file
#'
#' @export
format_leading_whitespace <- function(x) {
    sapply(
        seq_len(length(x)),
        function(d) {
            trimws(x[d], "both")
        }
    )
}


#' Format sequential blank lines
#'
#' If there are two blank lines in a row, remove the second item
#'
#' @param x a character
#'
#' @export
format_blank_lines <- function(x) {
    counter <- 0
    rm_indices <- c()
    sapply(
        seq_len(length(x)),
        function(n) {
            if (x[n] == "") {
                counter <<- counter + 1
                if (counter > 1) {
                    rm_indices <<- c(rm_indices, n)
                }
            } else {
                counter <<- 0
            }
        }
    )
    x[-rm_indices]
}

#' Format Markdown Table
#'
#' Fix markdown table headers, table alignments, and argument cells.
#' Remove extra whitespacing and multiple backticks. Enclose rows in
#' with a vertical line.
#'
#' @param x a string or array containing markdown
#'
#' @export
format_md_table <- function(x) {
    sapply(
        seq_len(length(x)),
        function(d) {

            # adjust markdown table headers
            if (grepl("^Argument\\s+\\|Description$", x[d])) {
                gsub(
                    pattern = "^Argument\\s+\\|(\\s+)?Description$",
                    replacement = "| Argument | Description |",
                    x = x[d]
                )
            } else if (grepl("^[-]+(\\s+?)\\|[-]+$", x[d])) {

                # fix markdown table alignment
                gsub(
                    pattern = "^[-]+(\\s+?)\\|[-]+$",
                    replacement = "| -------- | ----------- |",
                    x = x[d]
                )
            } else if (grepl("^[`]{3}\\w+[`]{3}(\\s+?)\\|(\\s+?)\\w+", x[d])) {

                # fix table row columns
                a <- paste0("| ", x[d], " |")
                b <- gsub("[`]{3}", "`", a)
                gsub("\\s+", " ",  b)

            } else {
                x[d]
            }
        }
    )
}
