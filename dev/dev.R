#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-10-16
#' MODIFIED: 2020-10-19
#' PURPOSE: pkg management
#' STATUS: working; ongoing
#' PACKAGES: usethis
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' init
usethis::create_package(".")


#' pkgs
usethis::use_package("R6")
usethis::use_package("Rd2md")
usethis::use_package("Rd2roxygen")
usethis::use_package("roxygen2md")
usethis::use_package("cli")
usethis::use_package("dplyr")
usethis::use_package("devtools")
usethis::use_pipe()

# versioning
pkgbump::set_pkgbump(files = c("DESCRIPTION", "package.json"))
pkgbump::pkgbump(version = "0.0.6")


# build ignore
usethis::use_build_ignore(
    files = c(
        "dev/",
        "docs/",
        "gatsby",
        ".pkgbump.json",
        "package.json",
        "rdConvert.code-workspace",
        "README.md"
    )
)


#'//////////////////////////////////////

#' ~ 1 ~
#' Pkg Building

devtools::check_man()
devtools::check()

#' ~ 1a ~
#' Tests
devtools::load_all()


#' create a new convert
pkg <- convert$new()


#' configure converter
pkg$config(
    site_dir = "gatsby",
    dest_dir = "src/docs/usage/",
    repo_name = "rdConvert",
    repo_url = "https://github.com/davidruvolo51/rdConvert",
    sidebar_yml_path = "src/config/sidebar.yml",
    ignore = c(
        "man/pipe.Rd",
        "man/format.Rd"
    )
)

# create entries and view
pkg$set_entries()
pkg$entries


# verify and init output paths
pkg$set_destinations()

# convert Rd files
pkg$convert_rds()


# format Rd
pkg$format_markdown()


# add yamls
#" pkg$add_yaml()


#' generate sidebar
pkg$set_sidebar_yml()
pkg$save_sidebar_yml()


#' rebuild
pkg$rebuild()