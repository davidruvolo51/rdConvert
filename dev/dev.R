#'////////////////////////////////////////////////////////////////////////////
#' FILE: dev.R
#' AUTHOR: David Ruvolo
#' CREATED: 2020-10-16
#' MODIFIED: 2020-10-16
#' PURPOSE: pkg management
#' STATUS: in.progress
#' PACKAGES: usethis
#' COMMENTS: NA
#'////////////////////////////////////////////////////////////////////////////

#' init
usethis::create_package(".")


#' pkgs
usethis::use_package("R6")
usethis::use_package("Rd2md")
usethis::use_package("Rd2roxygen")
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
#' devtools::load_all()
#' system("rm -rf dev/test-site/")
#' myPkg <- convert$new(destDir = "dev/test-site/src/pages")
#' myPkg$set_entries()
#' myPkg$files
#' myPkg$convert_rds()
#' myPkg$add_yaml()

#'//////////////////////////////////////

#' ~ 999 ~
#' Misc Config

pkgbump::set_pkgbump(files = c("DESCRIPTION", "package.json"))
pkgbump::pkgbump(version = "0.0.1")

usethis::use_build_ignore(
    files = c(
        "dev",
        ".pkgbump.json",
        "package.json",
        "rdConvert.code-workspace",
        "README.md"
    )
)
