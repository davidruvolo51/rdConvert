#' @title Rd to Md Workflow
#' @name convert
#'
#' @description
#'
#' As R6 class for converting Rd files to markdown with YAML headers. This may
#' be useful if you wish to use package documentation in static site generators
#' outside of the R ecosystem (e.g., React, Vue, Svelte, Gatsby, etc.). By
#' default, Rd files are rendered into their own directory with an independent
#' `index.md` file. The Rd name is parsed and set as the child directory name.
#'
#' For example, if you have the file `man/my_cool_function.Rd`, the output
#' path and file will be: `my_cool_function/index.md`
#'
#' The entry point will always be `man`.
#'
#' @examples
#' \dontrun{
#' myPkg <- convert$new(destDir = "./gatsby/src/pages/")
#' myPkg$set_entries()
#' myPkg$convert_rds()
#' myPkg$add_yaml()
#' }
#'
#' @keywords convert rd markdown
#'
#' @import dplyr
#'
#' @return Convert Rd files to Markdown files
#'
#' @export
convert <- R6::R6Class(
    "rd_converter",
    public = list(

        #' @field entry path to Rd files
        entry = "man",

        #' @field destDir output directory
        destDir = NA,

        #' @field files list of entry files and output paths
        files = NA,

        #' @description Create a new converter
        #' @param destDir output directory for markdown files
        initialize = function(destDir = "src/pages") {
            self$create_paths(destDir)
            self$destDir <- self$format_path(destDir)
        },

        #' @description Check file paths and create new dirs if applicable
        #' @param x a string containing a relative file path
        create_paths = function(x) {
            cli::cli_alert_info("Validating path {.val {x}}")
            paths <- strsplit(x, "/")[[1]]
            for (n in seq_len(length(paths))) {
                p <- paste0(paths[1:n], collapse = "/")
                if (dir.exists(p)) {
                    cli::cli_alert_success("Path {.val {p}} exists")
                }
                if (!dir.exists(p)) {
                    cli::cli_alert_warning(
                        "Initialized path {.val {p}} that did not exist"
                    )
                    dir.create(p)
                }
            }
        },

        #' @description Set entry points and output file paths
        set_entries = function() {
            self$files <- list.files(
                path = self$entry,
                full.names = TRUE
            ) %>%
                as.data.frame(.) %>%
                mutate(
                    name = self$format_rd_name(.),
                    outDir = paste0(
                        self$destDir, "/",
                        self$format_rd_name(.)
                    ),
                    outFile = paste0(
                        self$destDir, "/",
                        self$format_rd_name(.),
                        "/index.md"
                    )
                ) %>%
                select(., name, entry = ., outDir, outFile)

            if (!is.null(self$files)) {
                cli::cli_alert_success(
                    "Entry and destination points collated. See {.arg $files}"
                )
            } else {
                cli::cli_alert_danger(
                    "Failed to collate entry and output points"
                )
            }
        },

        #' @description batch convert Rd files to markdown files with YAML
        convert_rds = function() {
            for (d in seq_len(NROW(self$files))) {
                tmp_entry <- self$files$entry[d]
                tmp_dir <- self$files$outDir[d]
                tmp_out <- self$files$outFile[d]

                if (!dir.exists(tmp_dir)) dir.create(tmp_dir)
                file.create(tmp_out)
                cli::cli_alert_success(
                    text = "Rendered {.val index.md} at {.val {tmp_dir}}"
                )
                Rd2md::Rd2markdown(tmp_entry, tmp_out, append = FALSE)
            }
        },

        #' @description inject YAML from Rd files into rendered markdown files
        add_yaml = function() {
            for (d in seq_len(NROW(self$files))) {
                tmp_entry <- self$files$entry[d]
                tmp_out <- self$files$outFile[d]

                rd <- Rd2roxygen::parse_file(tmp_entry)
                yaml <- c(
                    "---",
                    paste0("title: ", self$format_yaml_text(rd$title)),
                    paste0("subtitle: ", self$format_yaml_text(rd$value)),
                    paste0("date: ", dQuote(Sys.Date())),
                    paste0(
                        "keywords: ",
                        self$format_yaml_keywords(rd$keywords)
                    ),
                    "---",
                    "\n"
                )

                md <- readLines(tmp_out, warn = FALSE)
                writeLines(c(yaml, md), tmp_out)

                cli::cli_alert_success(
                    text = "Added yaml to {.val index.md} at {.val {tmp_out}}"
                )
            }
        },

        #' @description remove trailing forward slash
        #' @param x a string containing a file path
        format_path = function(x) {
            if (substring(x, nchar(x)) == "/") {
                substring(x, 1, nchar(x) - 1)
            } else {
                x
            }
        },
        #' @description remove filename from .Rd files
        #' @param x a file name
        format_rd_name = function(x) {
            gsub(".Rd", "", basename(x))
        },

        #' @description Collapse Rd keywords array into JS array
        #' @param x an Rd keyword array
        format_yaml_keywords = function(x) {
            paste0("['", paste0(x, collapse = "', '"), "']")
        },

        #' @description Render and format Rd text to markdown
        #' @param x an Rd string
        format_yaml_text = function(x) {
            if (!is.null(x)) {
                p <- roxygen2md::markdownify(x)
                dQuote(gsub("\n", "", p))
            } else {
                ""
            }
        }
    )
)