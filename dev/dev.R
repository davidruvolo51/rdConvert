#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-10-16
#' MODIFIED: 2020-10-17
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
usethis::use_pipe()

#'//////////////////////////////////////

#' ~ 1 ~
#' Pkg Building

devtools::check_man()
devtools::check()

#' ~ 1a ~
#' Tests
#' rm(list = ls())
#' devtools::load_all()
#' system("rm -rf dev/gatsby/")
#'
#' myPkg <- convert$new(dest_dir = "dev/gatsby/src/docs/usage", pkg_name = "test")
#' myPkg$set_entries()
#' myPkg$set_destinations()
#' myPkg$convert_rds()
#' myPkg$format_markdown()
#' # myPkg$add_yaml()
#'
#' dir.create("dev/gatsby/src/config")
#' myPkg$set_sidebar_yml()
#' myPkg$save_sidebar_yml(path = "dev/gatsby/src/config/sidebar.yml")

#'//////////////////////////////////////

#' ~ 999 ~
#' Misc Config

pkgbump::set_pkgbump(files = c("DESCRIPTION", "package.json"))
pkgbump::pkgbump(version = "0.0.4")

usethis::use_build_ignore(
    files = c(
        "dev",
        ".pkgbump.json",
        "package.json",
        "rdConvert.code-workspace",
        "README.md"
    )
)
