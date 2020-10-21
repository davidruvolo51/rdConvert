# `convert`: Rd to Md Workflow

## Description

`convert` is an R6 class for converting Rd files to markdown for use in
static site generators. This may be useful if you wish to use non-R web
frameworks for generating package documentation or if you want to add
you package man files to an existing web project in markdown format. This
workflow is optimized for the Gatsby JS theme `rocket-docs`, but it can be
used for as a generic renderer.

To get started, create a new instance of the converter. It is also
recommended to convert Rd files into an existing project.

```r
pkg <- rdConvert::convert$new()
```

Next, configure the convert to fit your project. The argument `site_dir` is
used to define the base path for the static site. It is recommended to
create a nested project within your R project. `dest_dir` is the location
that the convert should use to save the markdown files. If you are using
RocketDocs, this is `src/docs/usage/` (no need to supply the site_dir here).

```r
pkg$config(
project_name = "rdConvert",
site_dir = "gatsby",
dest_dir = "src/docs/usage/",
repo_name = "rdConvert",
repo_url = "https://github.com/davidruvolo51/rdConvert"
)
```

If `site_dir` is not present you, `config` will through a warning. If you
are using RocketDocs, you can set the path of the `sidebar.yml` file via the
`sidebar_yml_path` argument. By default the location is
`src/config/sidebar.yml`. You can adjust the configuration at any point.

Next, create the entry and output points. This will collate all `man` files
and generate the output path using the `site_dir` and `dest_dir` arguments
defined in by the `$config` function. If you are using RocketDocs, the
sidebar data `labels` and `links` are generated automatically.

```r
pkg$set_entries()   # build
pkg$entries         # view
```

Once the entry and output points are created, run `$set_destinations`. This
function will verify that all directories in a path exist. If a location
does not exist, the folder will be created.

```r
pkg$set_destinations()
```

The returned md file may not always be perfect. There may be extra spaces
and multiple blank lines. Table layouts may not render appropriately. The
function `$format_markdown()` provides some surface-level formatting for
post-converted markdown files.

```r
pkg$format_markdown()
```

If you want to generate YAML for the files, use the `$add_yaml()` function.
This function isn't perfect. If you are using RocketDocs it will cause the
title to render twice as it was rendered via `$convert_rds`. I'm still
working on this feature.

```r
pkg$add_yaml()
```

If you are using RocketDocs, I've included two methods for generating the
`sidebar.yml`. `set_sidebar_yml` will generate the markup using the
`$entries` object. The yml configuration file can be saved using the
`$save_sidebar_yml` function.

```r
pkg$set_sidebar_yml()
pkg$save_sidebar_yml()
```

### Tips for Success

This workflow isn't perfect, but it will help provide a basic workflow for
exporting Rd files for use in non-R web projects. Here are some tips for
success.

- **Create static site project first**: It is a good idea to create the
static site before you convert the Rd files. This will ensure the
output paths are initiated before you build the paths.
- **Turn of Markdown support**: While experimenting with this workflow,
I noticed that roxygen2 was rendering markdown. To display this,
use `@noMd` in your R files or disable it package wide in the
`DESCRIPTION >> Roxygen: list(markdown = TRUE)`.

During active development, rebuilding Rd files and rerunning the steps
outlined above, can be a bit tidious. To make this process a bit easier,
run the method `$rebuild`. This will run `devtools::check_man` and
`$convert_rds` and `$format_markdown`. Set `set_entries` to `TRUE` if
you have the Rd files were added or removed. You can also auto add YAMLs
by setting `add_yaml` to TRUE.

```r
pkg$rebuild(set_entries = TRUE, add_yaml = FALSE)
```

## Value

Convert Rd files to Markdown files

## Author

dcruvolo

