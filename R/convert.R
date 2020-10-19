#' @title Rd to Md Workflow
#' @name convert
#'
#' @description
#'
#' `convert` is an R6 class for converting Rd files to markdown for use in
#' static site generators. This may be useful if you wish to use non-R web
#' frameworks for generating package documentation or if you want to add
#' you package man files to an existing web project in markdown format. This
#' workflow is optimized for the Gatsby JS theme `rocket-docs`, but it can be
#' used for as a generic renderer.
#'
#' To get started, create a new instance of the converter. It is also
#' recommended to convert Rd files into an existing project.
#'
#' ```r
#' pkg <- rdConvert::convert$new()
#' ```
#'
#' Next, configure the convert to fit your project. The argument `site_dir` is
#' used to define the base path for the static site. It is recommended to
#' create a nested project within your R project. `dest_dir` is the location
#' that the convert should use to save the markdown files. If you are using
#' RocketDocs, this is `src/docs/usage/` (no need to supply the site_dir here).
#'
#' ```r
#' pkg$config(
#'   project_name = "rdConvert",
#'   site_dir = "gatsby",
#'   dest_dir = "src/docs/usage/",
#'   repo_name = "rdConvert",
#'   repo_url = "https://github.com/davidruvolo51/rdConvert"
#' )
#' ```
#'
#' If `site_dir` is not present you, `config` will through a warning. If you
#' are using RocketDocs, you can set the path of the `sidebar.yml` file via the
#' `sidebar_yml_path` argument. By default the location is
#' `src/config/sidebar.yml`. You can adjust the configuration at any point.
#'
#' Next, create the entry and output points. This will collate all `man` files
#' and generate the output path using the `site_dir` and `dest_dir` arguments
#' defined in by the `$config` function. If you are using RocketDocs, the
#' sidebar data `labels` and `links` are generated automatically.
#'
#' ```r
#' pkg$set_entries()   # build
#' pkg$entries         # view
#' ```
#'
#' Once the entry and output points are created, run `$set_destinations`. This
#' function will verify that all directories in a path exist. If a location
#' does not exist, the folder will be created.
#'
#' ```r
#' pkg$set_destinations()
#' ```
#'
#' The returned md file may not always be perfect. There may be extra spaces
#' and multiple blank lines. Table layouts may not render appropriately. The
#' function `$format_markdown()` provides some surface-level formatting for
#' post-converted markdown files.
#'
#' ```r
#' pkg$format_markdown()
#' ```
#'
#' If you want to generate YAML for the files, use the `$add_yaml()` function.
#' This function isn't perfect. If you are using RocketDocs it will cause the
#' title to render twice as it was rendered via `$convert_rds`. I'm still
#' working on this feature.
#'
#' ```r
#' pkg$add_yaml()
#' ```
#'
#' If you are using RocketDocs, I've included two methods for generating the
#' `sidebar.yml`. `set_sidebar_yml` will generate the markup using the
#' `$entries` object. The yml configuration file can be saved using the
#' `$save_sidebar_yml` function.
#'
#' ```r
#' pkg$save_sidebar_yml()
#' ```
#'
#' ### Tips for Success
#'
#' This workflow isn't perfect, but it will help provide a basic workflow for
#' exporting Rd files for use in non-R web projects. Here are some tips for
#' success.
#'
#' - **Create static site project first**: It is a good idea to create the
#'     static site before you convert the Rd files. This will ensure the
#'     output paths are initiated before you build the paths.
#' - **Turn of Markdown support**: While experimenting with this workflow,
#'     I noticed that roxygen2 was rendering markdown. To display this,
#'     use `@noMd` in your R files or disable it package wide in the
#'     `DESCRIPTION >> Roxygen: list(markdown = TRUE)`.
#'
#' During active development, rebuilding Rd files and rerunning the steps
#' outlined above, can be a bit tidious. To make this process a bit easier,
#' run the method `$rebuild`. This will run `devtools::check_man` and
#' `$convert_rds` and `$format_markdown`. Set `set_entries` to `TRUE` if
#' you have the Rd files were added or removed. You can also auto add YAMLs
#' by setting `add_yaml` to TRUE.
#'
#' ```r
#' pkg$rebuild(set_entries = TRUE, add_yaml = FALSE)
#' ```
#'
#' @keywords convert rd markdown
#'
#' @import dplyr
#'
#' @author dcruvolo
#'
#' @return Convert Rd files to Markdown files
#'
#' @export
#' @noMd
convert <- R6::R6Class(
    "rd_converter",
    public = list(
        #' @field project_name project name
        project_name = NA,

        #' @field site_dir location of the of the static site directory
        site_dir = NA,

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

        #' @field repo_name name of the repo (e.g., Github, GitLab, etc.)
        repo_name = NA,

        #' @field repo_url address repo (e.g., GitHub, GitLab, etc.)
        repo_url = NA,

        #' @field sidebar_yml_path path to RocketDocs sidebar.yml
        sidebar_yml_path = "src/config/sidebar.yml",

        #' @description Configure a new converter
        #' @param project_name name of the project
        #' @param site_dir location of the static site directory
        #' @param dest_dir output directory for markdown files (excl. site dir)
        #' @param file_format save file as md or mdx
        #' @param repo_name name of the repo (e.g., Github, GitLab, etc.)
        #' @param repo_url address repo (e.g., GitHub, GitLab, etc.)
        #' @param sidebar_yml_path path to sidebar yml config (excl. site dir)
        config = function(
            project_name,
            site_dir = "gatsby",
            dest_dir = "src/docs/usage",
            file_format = "md",
            repo_name = NULL,
            repo_url = NULL,
            sidebar_yml_path = "src/config/sidebar.yml"
        ) {

            # validate input args
            if (is.null(project_name)) {
                cli::cli_alert_danger("{.arg project_name} cannot be missing")
            }
            if (!dir.exists(site_dir)) {
                cli::cli_alert_warning("{.path {site_dir}} does not exist")
            }

            # update values
            self$project_name <- project_name
            self$site_dir <- site_dir
            self$dest_dir <- format_path(dest_dir)
            self$sidebar_yml_path <- paste0(site_dir, "/", sidebar_yml_path)

            # validate file formats
            formats <- c("md", "mdx")
            if (file_format %in% formats) {
                self$file_format <- file_format
            } else {
                cli::cli_alert_danger(
                    "{.val {file_format} is invalid. Use {.val {formats}}}"
                )
            }

            if (!is.null(repo_url)) self$repo_url <- repo_url
            if (!is.null(repo_name)) self$repo_name <- repo_name
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
                    outDir = paste0(self$site_dir, "/", self$dest_dir, "/"),
                    outFile = paste0(
                        self$site_dir, "/",
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
            create_destinations(paste0(self$site_dir, "/", self$dest_dir))
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
        set_sidebar_yml = function() {
            config <- c(
                "# Sidebar navigation", "",
                # paste0("- label: '", self$project_name, "'"),
                "- label: 'Introduction'",
                "  link: '/'",
                "- label: 'Getting Started'",
                "  link: '/getting-started'"
            )

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

            # add community when vars `repo_name` and `repo_url` are defined
            if (!is.null(self$repo_name) && !is.null(self$repo_url)) {
                config <- c(
                    config,
                    "- label: Community",
                    "  items:",
                    paste0("    - label: '", self$repo_name, "'"),
                    paste0("      link: '", self$repo_url, "'")
                )
            }

            self$yml <- config
            cli::cli_alert_success("Created sidebar yml. See {.arg $yml}")
        },

        #' @description write yml config
        save_sidebar_yml = function() {
            tryCatch({
                writeLines(self$yml, self$sidebar_yml_path)
                cli::cli_alert_success("Saved {.file config/sidebar.yml}")
            }, error = function(e) {
                cli::cli_alert_danger("Error: {e}")
            }, warning = function(w) {
                cli::cli_alert_danger("Warning: {w}")
            })
        },

        #' @description rebuild R man files and convert to markdown
        #' @param entries If TRUE, entry and points will be rebuilt
        #' @param yaml If TRUE, yamls will be updated
        rebuild = function(entries = FALSE, yaml = FALSE) {
            tryCatch({
                devtools::check_man()
                if (entries) self$set_entries()
                self$convert_rds()
                self$format_markdown()
                if (yaml) self$add_yaml()
            }, error = function(err) {
                cli::cli_alert_danger("Issue in `document_and_rebuild`: {err}")
            }, warning = function(warn) {
                cli::cli_alert_danger("Issue in `document_and_rebuild`: {warn}")
            })
        }
    )
)