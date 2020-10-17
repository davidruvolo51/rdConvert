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
            self$destDir <- format_path(destDir)
        },

        #' @description Set entry points and output file paths
        set_entries = function() {
            self$files <- list.files(
                path = self$entry,
                full.names = TRUE
            ) %>%
                as.data.frame(.) %>%
                mutate(
                    name = format_rd_path(.),
                    outDir = paste0(
                        self$destDir, "/",
                        format_rd_path(.)
                    ),
                    outFile = paste0(
                        self$destDir, "/",
                        format_rd_path(.),
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

        #' @description set destinitions
        set_destinations = function() {
            create_destinations(self$destDir)
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
                    paste0("title: ", format_yaml_text(rd$title)),
                    paste0("subtitle: ", format_yaml_text(rd$value)),
                    paste0("date: ", dQuote(Sys.Date())),
                    paste0(
                        "keywords: ",
                        format_yaml_keywords(rd$keywords)
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
        }
    )
)