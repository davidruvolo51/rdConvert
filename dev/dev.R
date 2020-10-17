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
devtools::load_all()
system("rm -rf dev/test-site/")

myPkg <- convert$new(dest_dir = "dev/test-site/")
myPkg$set_entries()
myPkg$set_destinations()
myPkg$convert_rds()
myPkg$add_yaml()

#'//////////////////////////////////////

#' ~ 999 ~
#' Misc Config

pkgbump::set_pkgbump(files = c("DESCRIPTION", "package.json"))
pkgbump::pkgbump(version = "0.0.3")

usethis::use_build_ignore(
    files = c(
        "dev",
        ".pkgbump.json",
        "package.json",
        "rdConvert.code-workspace",
        "README.md"
    )
)
