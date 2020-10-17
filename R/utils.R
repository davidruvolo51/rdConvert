#' Create Output Points
#'
#' Take a string containing a file path and validate the existence of all paths
#' and create directories where applicable.
#'
#' @param x a string containing a relative file path
#'
#' @export
create_destinations <- function(x) {
    cli::cli_alert_info("Validating path {.path {x}}")
    paths <- strsplit(x, "/")[[1]]
    for (n in seq_len(length(paths))) {
        p <- paste0(paths[1:n], collapse = "/")
        if (dir.exists(p)) {
            cli::cli_alert_success("{.path {p}} exists")
        }
        if (!dir.exists(p)) {
            cli::cli_alert_warning("Created {.path {p}}")
            dir.create(p)
        }
    }
}