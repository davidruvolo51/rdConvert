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
        #' @field pkg_name project name
        pkg_name = NA,

        #' @field entry_dir path to Rd files
        entry_dir = "man",

        #' @field dest_dir output directory
        dest_dir = NA,

        #' @field entries list of entry files and output paths
        entries = NA,

        #' @field file_format save file as md or mdx
        file_format = "md",

        #' @field yml configuration file for sidebar.yml
        yml = NA,

        #' @field repo_url address to github repo
        repo_url = NA,

        #' @description Create a new converter
        #' @param pkg_name name of the project
        #' @param dest_dir output directory for markdown files
        #' @param file_format save file as md or mdx
        #' @param repo_url address to github repo
        initialize = function(
            pkg_name,
            dest_dir = "src/docs/usage",
            file_format = "md",
            repo_url = NULL
        ) {
            if (is.null(pkg_name)) {
                cli::cli_alert_danger("{.arg pkg_name} cannot be missing")
            }
            self$pkg_name <- pkg_name
            self$dest_dir <- format_path(dest_dir)

            formats <- c("md", "mdx")
            if (file_format %in% formats) {
                self$file_format <- file_format
            } else {
                cli::cli_alert_danger(
                    "{.val {file_format} is invalid. Use {.val {formats}}}"
                )
            }

            if (!is.null(repo_url)) {
                self$repo_url <- repo_url
            }
        },

        #' @description Set entry points and output file paths
        set_entries = function() {
            f <- list.files(
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

            # add data yml config
            self$entries <- f %>%
                mutate(
                    yml_label = gsub("_", " ", name) %>% tools::toTitleCase(.),
                    yml_link = paste0(
                        basename(outDir), "/",
                        gsub(".md|.mdx", "", basename(outFile))
                    )
                )


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

        #' @description format markdown files
        format_markdown = function() {
            for (d in seq_len(NROW(self$entries))) {
                tmp_name <- basename(self$entries$outFile[d])
                tmp_entry <- self$entries$entry[d]
                tmp_out <- self$entries$outFile[d]

                tryCatch({
                    md <- readLines(tmp_out, warn = FALSE) %>%
                        format_md_table() %>%
                        format_leading_whitespace(.) %>%
                        format_blank_lines(.)
                    writeLines(md, tmp_out)
                    cli::cli_alert_success("Formatted {.file {tmp_name}}")
                }, warning = function(warn) {
                    cli::cli_alert_danger(
                        "Error in {.fun format_markdown}: {warn}"
                    )
                }, error = function(err) {
                    cli::cli_alert_danger(
                        "Error in {.fun format_markdown}: {err}"
                    )
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
                    md <- readLines(tmp_out, warn = FALSE)
                    writeLines(c(yaml, md), tmp_out)
                    cli::cli_alert_success("Added yaml to {.file {tmp_name}}")
                }, warning = function(warn) {
                    cli::cli_alert_danger("Error in {.fun add_yaml}: {warn}")
                }, error = function(err) {
                    cli::cli_alert_danger("Error in {.fun add_yaml}: {err}")
                })
            }
        },

        #' @description generate sidebar yml
        #' @param home display home link in sidebar
        #' @param repo_url address to github repo
        set_sidebar_yml = function(home = TRUE, repo_url = NULL) {
            config <- c("# Sidebar navigation", "")

            # include home link using pkg_name
            if (home) {
                config <- c(
                    config,
                    paste0("- label: '", self$pkg_name, "'"),
                    "    link: '/'"
                )
            }

            # generate function links
            links <- sapply(
                seq_len(NROW(self$entries)),
                function(d) {
                    c(
                        paste0(
                            "    - label: '",
                            self$entries$yml_label[d],
                            "'"
                        ),
                        paste0(
                            "      link: '/",
                            self$entries$yml_link[d],
                            "'"
                        )
                    )
                }
            )

            config <- c(
                config,
                "- label: Reference",
                "  items:",
                as.character(links)
            )

            if (!is.null(repo_url)) {
                config <- c(
                    config,
                    "-label: Community",
                    "  items:",
                    "    - label: 'Github'",
                    paste0("      link: '", repo_url, "'")
                )
            }

            self$yml <- config
            cli::cli_alert_success("Created sidebar yml. See {.arg $yml}")
        },

        #' @description write yml config
        #' @param path path for configuration file
        save_sidebar_yml = function(path) {
            tryCatch({
                writeLines(self$yml, path)
                cli::cli_alert_success("Saved {.file config/sidebar.yml}")
            }, error = function(e) {
                cli::cli_alert_danger("Error: {e}")
            }, warning = function(w) {
                cli::cli_alert_danger("Warning: {w}")
            })
        }
    )
)