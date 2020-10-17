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

        #' @field entry_dir path to Rd files
        entry_dir = "man",

        #' @field dest_dir output directory
        dest_dir = NA,

        #' @field entries list of entry files and output paths
        entries = NA,

        #' @field file_format save file as md or mdx
        file_format = "md",

        #' @description Create a new converter
        #' @param dest_dir output directory for markdown files
        #' @param file_format save file as md or mdx
        initialize = function(dest_dir = "src/pages", file_format = "md") {
            self$dest_dir <- format_path(dest_dir)

            formats <- c("md", "mdx")
            if (file_format %in% formats) {
                self$file_format <- file_format
            } else {
                cli::cli_alert_danger(
                    "{.val {file_format} is invalid. Use {.val {formats}}}"
                )
            }
        },

        #' @description Set entry points and output file paths
        set_entries = function() {
            self$entries <- list.files(
                path = self$entry_dir,
                full.names = TRUE
            ) %>%
                as.data.frame(.) %>%
                mutate(
                    name = format_rd_path(.),
                    outDir = paste0(self$dest_dir, "/"),
                    outFile = paste0(
                        self$dest_dir, "/",
                        format_rd_path(.), ".",
                        self$file_format
                    )
                ) %>%
                select(., name, entry = ., outDir, outFile)

            if (NROW(self$entries) > 0) {
                cli::cli_alert_success(
                    "Entry and destination points collated. See {.var $entries}"
                )
            } else {
                cli::cli_alert_danger(
                    "Failed to collate entry and output points"
                )
            }
        },

        #' @description set destinitions
        set_destinations = function() {
            create_destinations(self$dest_dir)
        },

        #' @description batch convert Rd files to markdown files with YAML
        convert_rds = function() {
            for (d in seq_len(NROW(self$entries))) {
                tmp_name <- basename(self$entries$outFile[d])
                tmp_entry <- self$entries$entry[d]
                tmp_dir <- self$entries$outDir[d]
                tmp_out <- self$entries$outFile[d]

                tryCatch({
                    Rd2md::Rd2markdown(tmp_entry, tmp_out, append = FALSE)
                    cli::cli_alert_success(
                        "Rendered {.file {tmp_name}} at {.path {tmp_dir}}"
                    )
                }, warning = function(warn) {
                    cli::cli_alert_danger("Error in {.fun convert_rds}: {warn}")
                }, error = function(err) {
                    cli::cli_alert_danger("Error in {.fun convert_rds}: {err}")
                })
            }
        },

        #' @description inject YAML from Rd files into rendered markdown files
        add_yaml = function() {
            for (d in seq_len(NROW(self$entries))) {
                tmp_name <- basename(self$entries$outFile[d])
                tmp_entry <- self$entries$entry[d]
                tmp_out <- self$entries$outFile[d]

                tryCatch({
                    rd <- Rd2roxygen::parse_file(tmp_entry)
                    yaml <- c(
                        "---",
                        paste0("title: ", format_yaml_text(rd$title)),
                        paste0("description: ", format_yaml_text(rd$value)),
                        paste0("date: ", dQuote(Sys.Date())),
                        paste0(
                            "keywords: ",
                            format_yaml_keywords(rd$keywords)
                        ),
                        "---",
                        ""
                    )

                    md <- readLines(tmp_out, warn = FALSE) %>%
                        format_md_table() %>%
                        format_leading_whitespace(.) %>%
                        format_blank_lines(.)
                    writeLines(c(yaml, md), tmp_out)

                    cli::cli_alert_success("Added yaml to {.file {tmp_name}}")

                }, warning = function(warn) {
                    cli::cli_alert_danger("Error in {.fun add_yaml}: {warn}")
                }, error = function(err) {
                    cli::cli_alert_danger("Error in {.fun add_yaml}: {err}")
                })
            }
        }
    )
)