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


#' @title Format Path
#' @name format_path
#' @description
#'
#' Remove trailing forward slash in file paths.
#'
#' @param x a string containing a file path
#'
#' @examples
#'
#' format_path("path/to/doc/")
#'
#' @export
format_path <- function(x) {
    if (substring(x, nchar(x)) == "/") {
        substring(x, 1, nchar(x) - 1)
    } else {
        x
    }
}

#' @title Format Rd File name
#' @name format_rd_path
#' @description
#'
#' Remove the file extension from Rd files.
#'
#' @param x a file name
#'
#' @examples
#'
#' format_rd_path("man/myfile.Rd")
#'
#' @export
format_rd_path <- function(x) {
    gsub(".Rd", "", basename(x))
}


#' @title Format YAML keywords
#' @name format_yaml_keywords
#' @description
#'
#' Format Rd keywords (post-conversion), into a JS formatted string.
#'
#' @param x an Rd keyword array
#'
#' @examples
#' format_yaml_keywords(c("I", "think", "R", "is", "cool"))
#'
#' @export
format_yaml_keywords <- function(x) {
    paste0("['", paste0(x, collapse = "', '"), "']")
}

#' @title Format YAML Text
#' @name format_yaml_text
#' @description
#'
#' Converted Rd files may not always render YAML markdown. This function
#' rendered Rd into Markdown and ensures YAML is quoted.
#'
#' @param x an Rd string
#'
#' @examples
#' format_yaml_text("This is a \\bold{cool} string")
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


#' @title Format Leading Whitespace
#' @name format_leading_whitespace
#' @description
#'
#' In many text blocks, there a leading white space is added. This function
#' removes it!
#'
#' @param x a string from an md file
#'
#' @examples
#' format_leading_whitespace("    This is a cool string!   ")
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


#' @title Format Sequential blank lines
#' @name format_blank_lines
#' @description
#'
#' In some instances, there may be more than one blank line in between
#' paragraphs. This function ensures there is only 1 blank line.
#'
#' @param x a character
#'
#' @examples
#' format_blank_lines(c("This has", "", "", "", "multiple", "", "","", "", "blank lines"))
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

#' @title Format Markdown Table
#' @name format_md_table
#' @description
#'
#' In converted markdown files, the markup can be a bit funny and will render
#' properly. This is caused by extra spaces, no spaces between column
#' characters, and multiple backticks around arguments. This function cleans
#' markdown tables.
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
